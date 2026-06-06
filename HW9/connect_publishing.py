from sqlalchemy import create_engine, text
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# ==========================================
# 1. Підключення до MySQL
# ==========================================

engine = create_engine(
    "mysql+pymysql://root:finklif@localhost:3306/mydb?charset=utf8mb4"
)

with engine.connect() as conn:
    current_time = conn.execute(text("SELECT NOW()")).scalar()

    print("✅ Підключення успішне!")
    print("Поточний час MySQL:", current_time)

# ==========================================
# 2. Завантаження таблиць
# ==========================================

books = pd.read_sql("SELECT * FROM Books", engine)
orders = pd.read_sql("SELECT * FROM Orders", engine)
orderitem = pd.read_sql("SELECT * FROM OrderItem", engine)

print(
    f"Завантажено:"
    f"\nBooks={books.shape}"
    f"\nOrders={orders.shape}"
    f"\nOrderItem={orderitem.shape}"
)

print("\nКолонки Books:")
print(list(books.columns))

# ==========================================
# 3. Об'єднання таблиць
# ==========================================

df = (
    orderitem
    .merge(orders, on="OrderID", how="left")
    .merge(books, on="BookID", how="left")
)

df["Revenue"] = df["Quantity"] * df["UnitPrice"]

print("\nПерші рядки:")
print(df.head())

# ==========================================
# 4. Перевірка колонок
# ==========================================

required_columns = ["Genre", "PublishYear"]

for col in required_columns:
    if col not in df.columns:
        raise ValueError(
            f"Колонка '{col}' відсутня. "
            f"Доступні колонки:\n{list(df.columns)}"
        )

# ==========================================
# 5. Pivot Table
# ==========================================

pivot = (
    df.groupby(["Genre", "PublishYear"])["Revenue"]
      .sum()
      .unstack(fill_value=0)
)

print("\nPivot Table:")
print(pivot)

# ==========================================
# 6. Heatmap
# ==========================================

plt.figure(figsize=(12, 8))

sns.heatmap(
    pivot,
    annot=True,
    fmt=".0f",
    cmap="YlGnBu"
)

plt.title(
    "Жанр × Рік видання (виручка)",
    fontsize=16
)

plt.xlabel("Рік видання")
plt.ylabel("Жанр")

plt.tight_layout()

plt.savefig(
    "genre_year_heatmap.png",
    dpi=300,
    bbox_inches="tight"
)

print("✅ Графік збережено: genre_year_heatmap.png")

plt.show()

# ==========================================
# 7. Збереження CSV
# ==========================================

pivot.to_csv(
    "genre_year_heatmap.csv",
    encoding="utf-8-sig"
)

print("✅ CSV збережено: genre_year_heatmap.csv")