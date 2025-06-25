from fastapi import APIRouter, Request, Form
from fastapi.responses import HTMLResponse, RedirectResponse, StreamingResponse
from fastapi.templating import Jinja2Templates
from app.database import get_connection
from datetime import datetime
import csv
import io

router = APIRouter()
templates = Jinja2Templates(directory="app/templates")

@router.get("/admin", response_class=HTMLResponse)
def admin_dashboard(request: Request):
    if request.session.get("role") != "admin":
        return RedirectResponse("/login", status_code=303)

    start_date = request.query_params.get("start")
    end_date = request.query_params.get("end")

    with get_connection() as conn:
        cur = conn.cursor()

        cur.execute("SELECT id, username, role FROM users")
        users = [dict(id=r[0], username=r[1], role=r[2]) for r in cur.fetchall()]

        cur.execute("""
            SELECT r.id, u.username, r.table_id, r.reservation_time, r.status
            FROM reservations r
            JOIN users u ON r.user_id = u.id
            ORDER BY r.reservation_time DESC
        """)
        reservations = [
            dict(id=r[0], username=r[1], table_id=r[2], time=r[3], status=r[4])
            for r in cur.fetchall()
        ]

        cur.execute("SELECT id, table_number, seats FROM restaurant_tables")
        tables = [dict(id=r[0], number=r[1], seats=r[2]) for r in cur.fetchall()]

        # Статистика заказов по дням
        query = """
            SELECT DATE(created_at), COUNT(*), SUM(total_price)
            FROM orders
        """
        params = []
        if start_date and end_date:
            query += " WHERE created_at::date BETWEEN %s AND %s"
            params = [start_date, end_date]
        query += " GROUP BY DATE(created_at) ORDER BY DATE(created_at) DESC"

        cur.execute(query, params)
        order_stats = [
            {"date": row[0].strftime("%Y-%m-%d"), "total_orders": row[1], "total_revenue": float(row[2] or 0)}
            for row in cur.fetchall()
        ]

    return templates.TemplateResponse("admin_dashboard.html", {
        "request": request,
        "users": users,
        "reservations": reservations,
        "tables": tables,
        "order_stats": order_stats
    })


@router.post("/admin/delete_reservation")
def delete_reservation(request: Request, reservation_id: int = Form(...)):
    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute("DELETE FROM reservations WHERE id = %s", (reservation_id,))
        conn.commit()
    return RedirectResponse("/admin", status_code=303)


@router.post("/admin/create_reservation")
def add_reservation(
    request: Request,
    user_id: int = Form(...),
    table_id: int = Form(...),
    reservation_time: str = Form(...)
):
    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute("""
            INSERT INTO reservations (user_id, table_id, reservation_time, status, created_at)
            VALUES (%s, %s, %s, %s, %s)
        """, (user_id, table_id, reservation_time, "active", datetime.now()))
        conn.commit()
    return RedirectResponse("/admin", status_code=303)


@router.get("/admin/export_csv")
def export_csv():
    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute("""
            SELECT DATE(created_at), COUNT(*), SUM(total_price)
            FROM orders
            GROUP BY DATE(created_at)
            ORDER BY DATE(created_at) DESC
        """)
        data = cur.fetchall()

    output = io.StringIO()
    writer = csv.writer(output)
    writer.writerow(["Дата", "Количество заказов", "Сумма"])
    for row in data:
        writer.writerow([row[0].strftime("%Y-%m-%d"), row[1], row[2]])

    output.seek(0)
    return StreamingResponse(output, media_type="text/csv", headers={
        "Content-Disposition": "attachment; filename=order_statistics.csv"
    })
