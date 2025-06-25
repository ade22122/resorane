from fastapi import APIRouter, Request, Form
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.templating import Jinja2Templates
from datetime import datetime, timedelta
from .database import get_connection

router = APIRouter()
templates = Jinja2Templates(directory="app/templates")

@router.get("/reserve", response_class=HTMLResponse)
async def show_reserve_form(request: Request):
    tables = [{"id": i, "table_number": i, "seats": 4} for i in range(1, 11)]
    return templates.TemplateResponse("reserve.html", {
        "request": request,
        "tables": tables,
        "default_duration": 2  # Дефолтная продолжительность в часах
    })

@router.post("/reserve")
async def make_reservation(
    request: Request,
    table_id: int = Form(...),
    reservation_time: str = Form(...),
    duration: int = Form(...)
):
    user_id = request.cookies.get("user_id")
    if not user_id:
        return RedirectResponse("/login", status_code=303)

    # Преобразуем строку времени в datetime
    start_time = datetime.strptime(reservation_time, "%Y-%m-%dT%H:%M")
    end_time = start_time + timedelta(hours=duration)

    with get_connection() as conn:
        cur = conn.cursor()
        
        # Проверяем доступность столика
        cur.execute(
            """
            SELECT id FROM reservations 
            WHERE table_id = %s 
            AND reservation_time < %s 
            AND end_time > %s
            AND status = 'active'
            """,
            (table_id, end_time, start_time)
        )
        if cur.fetchone():
            return templates.TemplateResponse("reserve.html", {
                "request": request,
                "tables": [{"id": i, "table_number": i, "seats": 4} for i in range(1, 11)],
                "error": "Этот столик уже забронирован на выбранное время",
                "default_duration": duration
            })

        # Создаем бронирование
        cur.execute(
            """
            INSERT INTO reservations 
            (user_id, table_id, reservation_time, end_time, status, created_at)
            VALUES (%s, %s, %s, %s, %s, NOW())
            """,
            (user_id, table_id, start_time, end_time, "active")
        )
        conn.commit()

    return RedirectResponse("/profile", status_code=303)