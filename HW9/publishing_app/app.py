# app.py
# 📚 Видавництво — аналітика продажів (Streamlit)

import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt
from sqlalchemy import create_engine


# ====================== CONFIG ======================
st.set_page_config(page_title="Publishing Analytics", layout="wide")
st.title("📚 Видавництво — аналітика продажів")


# ====================== INIT SESSION STATE ======================
if "books" not in st.session_state:
    st.session_state.books = None
if "orders" not in st.session_state:
    st.session_state.orders = None
if "orderitem" not in st.session_state:
    st.session_state.orderitem = None


# ====================== DB CONNECTION ======================
st.sidebar.header("Підключення до MySQL")

host = st.sidebar.text_input("Host", "localhost")
port = st.sidebar.text_input("Port", "3306")
user = st.sidebar.text_input("User", "root")
password = st.sidebar.text_input("Password", type="password")
database = st.sidebar.text_input("Database", "publishing")

connect_btn = st.sidebar.button("🔌 Підключитись")


def build_conn_str(h, p, u, pw, db):
    return f"mysql+pymysql://{u}:{pw}@{h}:{p}/{db}?charset=utf8mb4"


@st.cache_data(show_spinner=False)
def load_tables(conn_str):
    eng = create_engine(conn_str)

    books = pd.read_sql("SELECT * FROM Books", eng)
    orders = pd.read_sql("SELECT * FROM Orders", eng, parse_dates=["OrderDate"])
    orderitem = pd.read_sql("SELECT * FROM OrderItem", eng)

    return books, orders, orderitem


def build_df(books, orders, orderitem):
    df = (
        orderitem
        .merge(orders, on="OrderID", how="left")
        .merge(books, on="BookID", how="left")
    )

    df["Revenue"] = df["Quantity"] * df["UnitPrice"]
    df["OrderDate"] = pd.to_datetime(df["OrderDate"], errors="coerce")

    return df


def apply_date_filter(df, date_from, date_to):
    df = df.copy()

    if date_from:
        df = df[df["OrderDate"].dt.date >= date_from]

    if date_to:
        df = df[df["OrderDate"].dt.date <= date_to]

    return df


# ====================== LOAD DATA ======================
if connect_btn:
    try:
        conn_str = build_conn_str(host, port, user, password, database)
        books, orders, orderitem = load_tables(conn_str)

        st.session_state.books = books
        st.session_state.orders = orders
        st.session_state.orderitem = orderitem

        st.success("Підключення успішне ✅")

    except Exception as e:
        st.error(f"Помилка підключення: {e}")


# ====================== GUARD (CRITICAL FIX) ======================
if (
    st.session_state.books is None
    or st.session_state.orders is None
    or st.session_state.orderitem is None
):
    st.info("👉 Спочатку натисни 'Підключитись'")
    st.stop()


# ====================== BUILD DATAFRAME ======================
df = build_df(
    st.session_state.books,
    st.session_state.orders,
    st.session_state.orderitem
)


# ====================== FILTER ======================
st.markdown("---")

c1, c2 = st.columns(2)

with c1:
    date_from = st.date_input("Дата від", value=None)

with c2:
    date_to = st.date_input("Дата до", value=None)

df_f = apply_date_filter(df, date_from, date_to)


# safe caption
if len(df_f) > 0:
    st.caption(
        f"📊 Рядків: {len(df_f)} | "
        f"{df_f['OrderDate'].min().date()} → {df_f['OrderDate'].max().date()}"
    )
else:
    st.caption("📊 Немає даних після фільтра")


# ====================== TABS ======================
tab1, tab2 = st.tabs(["📌 KPI", "📊 Візуалізації"])


# ====================== KPI ======================
with tab1:
    st.subheader("KPI")

    total_orders = df_f["OrderID"].nunique()
    total_units = df_f["Quantity"].sum()
    total_revenue = df_f["Revenue"].sum()

    avg_order_value = (
        df_f.groupby("OrderID")["Revenue"].sum().mean()
        if total_orders > 0 else 0
    )

    c1, c2, c3, c4 = st.columns(4)

    c1.metric("Замовлення", total_orders)
    c2.metric("Одиниці", total_units)
    c3.metric("Виручка", f"{total_revenue:,.2f}")
    c4.metric("Середній чек", f"{avg_order_value:,.2f}")


# ====================== VISUALS ======================
with tab2:
    st.subheader("Графіки")

    chart = st.selectbox(
        "Оберіть графік",
        ["Топ жанри", "Динаміка місяців", "Парето 80/20"]
    )

    if st.button("📊 Побудувати"):

        # -------- TOP GENRES --------
        if chart == "Топ жанри":
            data = df_f.groupby("Genre")["Revenue"].sum().sort_values()

            fig, ax = plt.subplots()
            ax.barh(data.index, data.values)
            ax.set_xlabel("Revenue")
            ax.grid(axis="x", linestyle="--", alpha=0.5)

            st.pyplot(fig)

        # -------- MONTHLY --------
        elif chart == "Динаміка місяців":
            temp = df_f.copy()
            temp["Month"] = temp["OrderDate"].dt.to_period("M").astype(str)

            data = temp.groupby("Month")["Revenue"].sum()

            fig, ax = plt.subplots()
            ax.plot(data.index, data.values, marker="o")
            ax.tick_params(axis="x", rotation=45)
            ax.grid(True, linestyle="--", alpha=0.5)

            st.pyplot(fig)

        # -------- PARETO --------
        elif chart == "Парето 80/20":
            data = df_f.groupby("Title")["Revenue"].sum().sort_values(ascending=False)

            cum = data.cumsum() / data.sum() * 100

            fig, ax1 = plt.subplots()

            ax1.bar(data.index, data.values)
            ax1.tick_params(axis="x", rotation=45)

            ax2 = ax1.twinx()
            ax2.plot(data.index, cum.values, marker="o")
            ax2.axhline(80, linestyle="--")

            st.pyplot(fig)