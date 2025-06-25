from fastapi import APIRouter, Request
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.templating import Jinja2Templates
from .database import get_connection

router = APIRouter()
templates = Jinja2Templates(directory="app/templates")

@router.get("/cart", response_class=HTMLResponse)
def show_cart(request: Request):
    user_id = request.cookies.get("user_id")
    if not user_id:
        return RedirectResponse("/login", status_code=303)

    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute("""
            SELECT mi.name, mi.price
            FROM cart c
            JOIN menu_items mi ON c.menu_item_id = mi.id
            WHERE c.user_id = %s
        """, (user_id,))
        items = cur.fetchall()
        total = sum(item[1] for item in items)

    return templates.TemplateResponse("cart.html", {"request": request, "items": items, "total": total})
