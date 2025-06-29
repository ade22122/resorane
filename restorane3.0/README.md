# 🍽️ Система управления рестораном

![Баннер ресторана](https://mir-s3-cdn-cf.behance.net/project_modules/1400/c164d332346489.567bd13c083bf.jpg) 

## 🌟 Возможности системы

### 🧑‍🍳 Интерфейс официанта
- **Создание заказов** с несколькими блюдами
- **Контроль запасов в реальном времени** - отображение доступного количества
- **Управление столиками** - привязка заказов к конкретным столам
- **Отслеживание статуса** заказа (новый, в процессе, завершен)

### 👨‍💼 Административная панель
- **Полный контроль инвентаря** - установка максимального и текущего количества
- **Управление меню** - добавление/удаление блюд, изменение цен
- **Управление персоналом** - настройка прав доступа
- **Аналитика продаж** - история заказов и отчеты по выручке

### 👥 Функции для клиентов
- **Регистрация пользователей** с разными ролями (гость, официант, администратор)
- **Система бронирования** - резервирование столиков
- **История заказов** - просмотр предыдущих заказов

## 🛠️ Технологический стек

### Backend
- **Python** с фреймворком **FastAPI**
- База данных **PostgreSQL**
- Шаблонизатор **Jinja2**
- ORM **SQLAlchemy**

### Frontend
- **Bootstrap 5** для адаптивного дизайна
- **Vanilla JavaScript** для интерактивных элементов
- **CSS3** с современными анимациями

## 🚀 Начало работы

### Требования
- Python 3.8+
- PostgreSQL 12+
- pipenv (рекомендуется)

### Установка
```bash
# Клонируйте репозиторий
git clone https://github.com/yourusername/restaurant-system.git
cd restaurant-system

# Установите зависимости
pipenv install
pipenv shell

# Настройте переменные окружения
cp .env.example .env
# Отредактируйте .env с вашими данными для подключения к БД

# Примените миграции
alembic upgrade head

# Запустите сервер разработки
uvicorn app.main:app --reload
```

## 📊 Схема базы данных



Основные таблицы:
- `users` - Учетные записи пользователей
- `menu_items` - Блюда и напитки ресторана
- `dish_inventory` - Текущие остатки блюд
- `restaurant_tables` - Доступные столики
- `orders` - Заказы клиентов
- `order_items` - Состав заказов

## ⚙️ API Endpoints

| Эндпоинт | Метод | Описание |
|----------|--------|-------------|
| `/waiter` | GET | Интерфейс создания заказов |
| `/waiter` | POST | Отправка нового заказа |
| `/admin/inventory` | GET | Управление инвентарем |
| `/api/menu` | GET | Получение меню (JSON) |





## 🤝 Участие в разработке

1. Форкните проект
2. Создайте ветку для вашей функции (`git checkout -b feature/AmazingFeature`)
3. Зафиксируйте изменения (`git commit -m 'Добавлена новая функция'`)
4. Отправьте изменения (`git push origin feature/AmazingFeature`)
5. Откройте Pull Request

## 📜 Лицензия

Распространяется под лицензией MIT. Подробнее см. в файле `LICENSE`.

## 📧 Контакты

Разработчик - [Паша](mailto:hfctjbuy@gmail.com)

