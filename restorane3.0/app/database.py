import psycopg2

def get_connection():
    return psycopg2.connect(
        dbname="restorane",
        user="postgres",
        password="9999",
        host="localhost",
        port="5433"
    )




def get_tables():
    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute("SELECT id, table_number, seats, is_available FROM restaurant_tables")
        rows = cur.fetchall()
        return [{"id": r[0], "table_number": r[1], "seats": r[2], "is_available": r[3]} for r in rows]

def get_reservations_for_user(user_id: int):
    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute("""
            SELECT r.id, r.user_id, r.reservation_time, r.status, t.table_number, t.seats
            FROM reservations r
            JOIN restaurant_tables t ON r.table_id = t.id
            WHERE r.user_id = %s
            ORDER BY r.reservation_time DESC
        """, (user_id,))
        rows = cur.fetchall()
        return [
            {
                "id": row[0],
                "user_id": row[1],
                "reservation_time": row[2],
                "status": row[3],
                "table_number": row[4],
                "seats": row[5]
            }
            for row in rows
        ]

