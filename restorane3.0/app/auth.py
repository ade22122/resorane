from fastapi import APIRouter, Form, Request
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.templating import Jinja2Templates
from .database import get_connection

router = APIRouter()
templates = Jinja2Templates(directory="app/templates")

# ======= Регистрация =======
@router.get("/register", response_class=HTMLResponse)
def register_form(request: Request):
    return templates.TemplateResponse("register.html", {"request": request})

@router.post("/register")
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
            "INSERT INTO users (username, passwor_hash, role) VALUES (%s, %s, %s)",
            (username, password, "guest")
        )
        conn.commit()
    return RedirectResponse("/login", status_code=303)

# ======= Вход =======
@router.get("/login", response_class=HTMLResponse)
def login_form(request: Request):
    return templates.TemplateResponse("login.html", {"request": request})

@router.post("/login")
def login_user(request: Request, username: str = Form(...), password: str = Form(...)):
    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute("SELECT id, role FROM users WHERE username = %s AND passwor_hash = %s", (username, password))
        result = cur.fetchone()
        if result:
            user_id, role = result
            request.session["user_id"] = user_id
            request.session["role"] = role
            redirect_url = "/admin" if role == "admin" else "/home"
            return RedirectResponse(redirect_url, status_code=303)
    return templates.TemplateResponse("login.html", {"request": request, "error": "Неверные данные"})

# ======= Выход =======
@router.get("/logout")
def logout(request: Request):
    request.session.clear()
    return RedirectResponse("/home", status_code=303)


#uvicorn app.main:app --reload