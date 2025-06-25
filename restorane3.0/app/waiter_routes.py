from fastapi import APIRouter, Request, Form
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.templating import Jinja2Templates
from datetime import datetime
from .database import get_connection

router = APIRouter()
templates = Jinja2Templates(directory="app/templates")

# Главная страница официанта
from fastapi import APIRouter, Request, Form
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.templating import Jinja2Templates
from app.database import get_connection
from datetime import datetime

router = APIRouter()
templates = Jinja2Templates(directory="app/templates")


@router.get("/waiter", response_class=HTMLResponse)
def waiter_form(request: Request):
    with get_connection() as conn:
        cur = conn.cursor()

        # Получаем список клиентов
        cur.execute("SELECT id, username FROM users WHERE role = 'guest'")
        clients = cur.fetchall()

        # Получаем список столов
        cur.execute("SELECT id, table_number FROM restaurant_tables")
        tables = cur.fetchall()

        # Получаем список блюд
        cur.execute("SELECT id, name FROM menu_items WHERE is_available = true")
        dishes = cur.fetchall()

    return templates.TemplateResponse("waiter_form.html", {
        "request": request,
        "clients": clients,
        "tables": tables,
        "dishes": dishes
    })

@router.post("/waiter")
async def submit_order(
    request: Request,
    user_id: int = Form(...),
    table_id: int = Form(...),
):
    form_data = await request.form()
    dish_quantities = {
        int(key.split("_")[1]): int(value)
        for key, value in form_data.items()
        if key.startswith("dish_") and value.isdigit() and int(value) > 0
    }

    if not dish_quantities:
        return templates.TemplateResponse("waiter_form.html", {
            "request": request,
            "error": "Не выбрано ни одного блюда!"
        })

    with get_connection() as conn:
        cur = conn.cursor()

        # Получаем цену каждого блюда
        total_price = 0
        for dish_id, qty in dish_quantities.items():
            cur.execute("SELECT price FROM menu_items WHERE id = %s", (dish_id,))
            result = cur.fetchone()
            if result:
                price = result[0]
                total_price += price * qty

        # Вставляем заказ
        waiter_id = 1  # заменить на реального официанта
        cur.execute("""
            INSERT INTO orders (user_id, waiter_id, table_id, status, created_at, total_price)
            VALUES (%s, %s, %s, %s, %s, %s)
            RETURNING id
        """, (user_id, waiter_id, table_id, 'невыполнен', datetime.now(), total_price))
        order_id = cur.fetchone()[0]

        # Вставка позиций заказа
        for dish_id, quantity in dish_quantities.items():
            cur.execute("""
                INSERT INTO order_items (order_id, menu_item_id, quantity)
                VALUES (%s, %s, %s)
            """, (order_id, dish_id, quantity))

        conn.commit()

    return RedirectResponse("/waiter", status_code=303)



# Создание нового заказа
@router.post("/waiter/create_order")
def create_order(
    request: Request,
    table_id: int = Form(...),
    waiter_id: int = Form(...),
    item_ids: list[int] = Form(...),
    quantities: list[int] = Form(...)
):
    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute(
            "INSERT INTO orders (waiter_id, table_id, status, created_at) VALUES (%s, %s, %s, %s) RETURNING id",
            (waiter_id, table_id, "open", datetime.now())
        )
        order_id = cur.fetchone()[0]

        for menu_item_id, qty in zip(item_ids, quantities):
            cur.execute(
                "INSERT INTO order_items (order_id, menu_item_id, quantity) VALUES (%s, %s, %s)",
                (order_id, menu_item_id, qty)
            )

        conn.commit()

    return RedirectResponse("/waiter", status_code=303)

# Просмотр всех заказов
@router.get("/waiter/orders", response_class=HTMLResponse)
def view_orders(request: Request):
    with get_connection() as conn:
        cur = conn.cursor()
        
        # Получаем основную информацию о заказах
        cur.execute("""
            SELECT o.id, u.username, t.table_number, o.status, 
                   o.created_at, o.total_price, o.waiter_id, o.table_id
            FROM orders o
            JOIN users u ON o.user_id = u.id
            JOIN restaurant_tables t ON o.table_id = t.id
            ORDER BY o.created_at DESC
        """)
        orders_data = cur.fetchall()

        orders = []
        for order in orders_data:
            # Получаем позиции заказа из таблицы order_items
            cur.execute("""
                SELECT mi.name, oi.quantity, mi.price
                FROM order_items oi
                JOIN menu_items mi ON oi.menu_item_id = mi.id
                WHERE oi.order_id = %s
            """, (order[0],))
            items = cur.fetchall()
            
            orders.append({
                "id": order[0],
                "client_name": order[1],
                "table_number": order[2],
                "status": order[3],
                "created_at": order[4],
                "total_price": order[5],
                "waiter_id": order[6],
                "table_id": order[7],
                "order_items": [{
                    "name": item[0],
                    "quantity": item[1],
                    "price": float(item[2])
                } for item in items]
            })

    return templates.TemplateResponse("waiter_orders.html", {"request": request, "orders": orders})

@router.post("/waiter/complete_order")
def complete_order(request: Request, order_id: int = Form(...)):
    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute("UPDATE orders SET status = 'completed' WHERE id = %s", (order_id,))
        conn.commit()
    return RedirectResponse("/waiter/orders", status_code=303)

