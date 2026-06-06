# =========================================================================
# Практична робота 9. Обробка та візуалізація даних засобами Python
# =========================================================================

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sqlalchemy import create_engine, text

# -------------------------------------------------------------------------
# Задача 1 та 2. Підключення, імпорт таблиць та збереження у CSV
# -------------------------------------------------------------------------
# Заміни ТВІЙ_ПАРОЛЬ на свій актуальний пароль від MySQL
engine = create_engine("mysql+pymysql://root:ТВІЙ_ПАРОЛЬ@localhost:3306/publishing?charset=utf8mb4")

with engine.connect() as conn:
    res = conn.execute(text("SELECT NOW()"))
    print("Підключення успішне! Поточна дата MySQL:", res.scalar())

books = pd.read_sql("SELECT * FROM Books", engine)
orders = pd.read_sql("SELECT * FROM Orders", engine)
orderitem = pd.read_sql("SELECT * FROM OrderItem", engine)

print(f"Завантажено: Книги={books.shape}, Замовлення={orders.shape}, Позиції={orderitem.shape}")

# Об'єднання таблиць
df = (orderitem
      .merge(orders, on='OrderID', how='left')
      .merge(books, on='BookID', how='left'))

df['Revenue'] = df['Quantity'] * df['UnitPrice']
df["OrderDate"] = pd.to_datetime(df["OrderDate"])

df.to_csv('sales_data.csv', index=False, encoding='utf-8')
print("Файл збережено: sales_data.csv")


# -------------------------------------------------------------------------
# Задача 3. Побудова графіка: дохід по книгах
# -------------------------------------------------------------------------
top_books = (df.groupby("Title")["Revenue"]
               .sum()
               .sort_values(ascending=False)
               .reset_index())

plt.figure(figsize=(8,5))
plt.bar(top_books["Title"], top_books["Revenue"], color="skyblue")
plt.title("Дохід по книгах", fontsize=14)
plt.xlabel("Назва книги")
plt.ylabel("Дохід (CHF)")
plt.xticks(rotation=30, ha='right')
plt.tight_layout()
plt.show()


# -------------------------------------------------------------------------
# Задача 4. Побудова графіка динаміки продажів
# -------------------------------------------------------------------------
sales_by_date = (df.groupby("OrderDate")["Revenue"]
                   .sum()
                   .reset_index()
                   .sort_values("OrderDate"))

plt.figure(figsize=(8,5))
plt.plot(sales_by_date["OrderDate"], sales_by_date["Revenue"], marker="o", color="teal", linewidth=2)
plt.title("Динаміка продажів за датами", fontsize=14)
plt.xlabel("Дата замовлення")
plt.ylabel("Виручка (CHF)")
plt.grid(True, linestyle="--", alpha=0.6)
plt.tight_layout()
plt.savefig('revenue_by_month.png', dpi=200)
plt.show()


# -------------------------------------------------------------------------
# Задача 5. Ключові показники (KPI)
# -------------------------------------------------------------------------
kpi = {
    "total_orders": df["OrderID"].nunique(),
    "total_units": int(df["Quantity"].sum()),
    "total_revenue": float(df["Revenue"].sum()),
    "avg_order_value": float(df.groupby("OrderID")["Revenue"].sum().mean())
}

kpi_series = pd.Series(kpi, name="Value")
kpi_series.to_csv("kpi.csv")
print("\nKPI (ключові показники):")
print(kpi_series)


# -------------------------------------------------------------------------
# Задача 6. Топ-жанри за виручкою (стовпчикова діаграма)
# -------------------------------------------------------------------------
genre_revenue = (df.groupby("Genre")["Revenue"]
                   .sum()
                   .sort_values(ascending=False)
                   .reset_index())

plt.figure(figsize=(8,5))
plt.barh(genre_revenue["Genre"], genre_revenue["Revenue"], color="cornflowerblue")
plt.title("Топ-жанри за виручкою", fontsize=14)
plt.xlabel("Виручка (CHF)")
plt.ylabel("Жанр")
plt.gca().invert_yaxis()
plt.grid(axis='x', linestyle="--", alpha=0.6)
plt.tight_layout()
plt.show()

genre_revenue.to_csv("genre_revenue.csv", index=False)


# -------------------------------------------------------------------------
# Задача 7. Топ-книги (Pareto 80/20)
# -------------------------------------------------------------------------
book_revenue = (df.groupby("Title")["Revenue"]
                  .sum()
                  .sort_values(ascending=False)
                  .reset_index())

book_revenue["CumulativeRevenue"] = book_revenue["Revenue"].cumsum()
book_revenue["CumulativePercent"] = 100 * book_revenue["CumulativeRevenue"] / book_revenue["Revenue"].sum()

fig, ax1 = plt.subplots(figsize=(8,5))
ax1.bar(book_revenue["Title"], book_revenue["Revenue"], color="skyblue")
ax1.set_xlabel("Назва книги")
ax1.set_ylabel("Виручка (CHF)", color="navy")

ax2 = ax1.twinx()
ax2.plot(book_revenue["Title"], book_revenue["CumulativePercent"], color="orange", marker="o")
ax2.set_ylabel("Накопичувальний відсоток доходу (%)", color="darkorange")
ax2.axhline(80, color="red", linestyle="--", linewidth=1.5, label="80% межа")

plt.title("Аналіз топ-книг (Pareto 80/20)", fontsize=14)
ax1.tick_params(axis='x', rotation=30, labelsize=9)
ax1.grid(axis='y', linestyle="--", alpha=0.6)
plt.tight_layout()
plt.show()

book_revenue.to_csv("book_pareto.csv", index=False)


# -------------------------------------------------------------------------
# Задача 8 (Частина 1). Heatmap жанр × рік видання
# -------------------------------------------------------------------------
pivot = (df.groupby(["Genre", "PublishYear"])["Revenue"]
           .sum()
           .unstack(fill_value=0))

plt.figure(figsize=(8,5))
sns.heatmap(pivot, annot=True, fmt=".0f", cmap="YlGnBu")
plt.title("Жанр × Рік видання (виручка)", fontsize=14)
plt.xlabel("Рік видання")
plt.ylabel("Жанр")
plt.tight_layout()
plt.show()

pivot.to_csv("genre_year_heatmap.csv")