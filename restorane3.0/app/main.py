
from fastapi import FastAPI, Request
from fastapi.responses import RedirectResponse, HTMLResponse
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles
from fastapi.responses import Response  # для set_cookie
from fastapi import Form
from app.database import get_connection
from . import auth, reservation, cart
from . import database
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from starlette.templating import Jinja2Templates
from starlette.middleware.sessions import SessionMiddleware
from app import reservation  
from app import waiter_routes
from app import admin_routes
from fastapi.responses import RedirectResponse
from datetime import datetime
app = FastAPI()

# Подключение сессий
app.add_middleware(SessionMiddleware, secret_key="1212312324515131212093")

app.mount("/static", StaticFiles(directory="app/static"), name="static")


app.include_router(waiter_routes.router)



app.include_router(admin_routes.router)



# Подключение роутеров
app.include_router(reservation.router)

# Шаблоны
templates = Jinja2Templates(directory="app/templates")


templates = Jinja2Templates(directory="app/templates")




import json

@app.get("/", response_class=HTMLResponse)
def index(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})






@app.get("/menu", response_class=HTMLResponse)
def menu_page(request: Request):
    return templates.TemplateResponse("home.html", {"request": request})

@app.get("/profile", response_class=HTMLResponse)
def profile_page(request: Request):
    user_id = request.session.get("user_id")
    if not user_id:
        return RedirectResponse("/login", status_code=303)

    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute("SELECT username FROM users WHERE id = %s", (user_id,))
        user = cur.fetchone()
        username = user[0] if user else "неизвестен"

        cur.execute("""
            SELECT r.id, r.reservation_time, r.end_time, r.status, t.table_number
            FROM reservations r
            JOIN restaurant_tables t ON r.table_id = t.id
            WHERE r.user_id = %s
            ORDER BY r.reservation_time DESC
        """, (user_id,))
        
        reservations = [
            {
                "id": r[0],
                "start_time": r[1],
                "end_time": r[2],
                "status": r[3],
                "table_number": r[4],
                "duration": (r[2] - r[1]).total_seconds() / 3600,
                "can_cancel": r[3] == 'active' and r[1] > datetime.now()  # Можно отменить только активные и будущие брони
            }
            for r in cur.fetchall()
        ]

    return templates.TemplateResponse("profile.html", {
        "request": request,
        "user_id": user_id,
        "username": username,
        "reservations": reservations
    })

@app.post("/cancel_reservation")
def cancel_reservation(request: Request, reservation_id: int = Form(...)):
    user_id = request.session.get("user_id")
    if not user_id:
        return RedirectResponse("/login", status_code=303)

    with get_connection() as conn:
        cur = conn.cursor()
        
        # Проверяем, что бронь принадлежит пользователю и активна
        cur.execute("""
            SELECT id FROM reservations 
            WHERE id = %s AND user_id = %s AND status = 'active'
        """, (reservation_id, user_id))
        
        if not cur.fetchone():
            return RedirectResponse("/profile?error=not_found", status_code=303)
        
        # Обновляем статус брони
        cur.execute("""
            UPDATE reservations 
            SET status = 'cancelled', cancelled_at = NOW()
            WHERE id = %s
        """, (reservation_id,))
        conn.commit()

    return RedirectResponse("/profile?success=cancelled", status_code=303)

@app.get("/register", response_class=HTMLResponse)
def register_form(request: Request):
    return templates.TemplateResponse("register.html", {"request": request})

@app.post("/register")
def register_user(request: Request, username: str = Form(...), password: str = Form(...)):
    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute("SELECT * FROM users WHERE username = %s", (username,))
        if cur.fetchone():
            return templates.TemplateResponse("register.html", {
                "request": request,
                "error": "Пользователь уже существует"
            })
        cur.execute(
            "INSERT INTO users (username, password_hash, role) VALUES (%s, %s, %s)",
            (username, password, "guest")
        )
        conn.commit()
    return RedirectResponse("/login", status_code=303)

# ======= Вход =======
@app.get("/login", response_class=HTMLResponse)
def login_form(request: Request):
    return templates.TemplateResponse("login.html", {"request": request})

@app.post("/login")
def login_user(request: Request, username: str = Form(...), password: str = Form(...)):
    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute("SELECT id, role FROM users WHERE username = %s AND password_hash = %s", (username, password))
        result = cur.fetchone()
        if result:
            user_id, role = result
            request.session["user_id"] = user_id
            request.session["role"] = role
            redirect_url = "/admin" if role == "admin" else "/home"
            return RedirectResponse(redirect_url, status_code=303)
    return templates.TemplateResponse("login.html", {"request": request, "error": "Неверные данные"})
@app.get("/logout")
def logout(request: Request):
    request.session.clear()
    return RedirectResponse("/login", status_code=303)

@app.get("/home", response_class=HTMLResponse)
def home_page(request: Request):
    user_id = request.session.get("user_id")  # ← вот что не хватало

    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute("SELECT id, name, description, price, image FROM menu_items WHERE is_available = true")
        rows = cur.fetchall()

        username = None
        if user_id:
            cur.execute("SELECT username FROM users WHERE id = %s", (user_id,))
            result = cur.fetchone()
            if result:
                username = result[0]

        dishes = [
            {
                "id": r[0],
                "name": r[1],
                "description": r[2],
                "price": r[3],
                "image": r[4]
            }
            for r in rows
        ]

    cart = json.loads(request.cookies.get("cart", "[]"))
    cart_count = len(cart)

    return templates.TemplateResponse("home.html", {
        "request": request,
        "dishes": dishes,
        "cart_count": cart_count,
        "user": username or "Гость"
    })



@app.get("/cart", response_class=HTMLResponse)
def cart_page(request: Request):
    # Если у тебя пока нет логики корзины — просто заглушка
    items = [("Борщ", 250), ("Пицца", 450)]
    total = sum(price for _, price in items)
    return templates.TemplateResponse("cart.html", {
        "request": request,
        "items": items,
        "total": total
    })

#uvicorn app.main:app --reload