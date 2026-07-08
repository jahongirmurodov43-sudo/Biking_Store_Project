# 🚲 Bike Store Data Warehouse — Medallion Architecture (SQL Server / T-SQL)

An end-to-end analytical data warehouse for a fictional multi-store bicycle retailer,
built on Microsoft SQL Server using the **Medallion architecture** (Bronze → Silver → Gold).
The project ingests raw CSV exports, cleans and models them into a governed layer, and
exposes business-ready views, KPIs, and stored procedures for reporting.

---

## 📌 Overview

The warehouse turns nine raw source tables into a queryable analytics layer that answers
questions a real bike retailer would ask: Which stores and staff drive the most revenue?
What are the top-selling products? Which items need restocking? How is sales performance
trending year over year?

Data spans **three years of orders (2016–2018)** across multiple stores, staff, customers,
products, brands, and categories.

**Stack:** SQL Server · T-SQL · `BULK INSERT` · Views · Stored Procedures

---

## 🏗️ Architecture

The pipeline follows a three-layer Medallion pattern, with a dedicated schema per layer
plus an `Audit` schema reserved for ETL run/logging metadata.

```
CSV files ──► Bronze (raw)  ──►  Silver (cleaned + modeled)  ──►  Gold (business-ready)
                 │                      │                              │
          exact source copy      typed, keyed, FK-enforced      views · KPIs · procs
```

| Layer  | Schema   | Purpose |
|--------|----------|---------|
| Bronze | `Bronze` | Raw landing zone. Tables mirror the CSVs 1:1 with permissive types. Loaded via `BULK INSERT`. |
| Silver | `Silver` | Cleaned and modeled. Enforces primary keys and foreign keys, casts columns to proper types (e.g. dates), normalizes `'NULL'` string literals to real `NULL`s, and stamps each row with `dwh_create_date`. |
| Gold   | `Gold`   | Consumption layer. Reporting views, KPI views, and parameterized stored procedures built on Silver. |
| Audit  | `Audit`  | Reserved for ETL logging metadata (see Roadmap). |

### Entity relationships

See **`Database_relationships.png`** for the full source schema (Sales domain: customers,
orders, order_items, staffs, stores · Production domain: products, categories, brands, stocks).

---

## 📂 Repository structure

```
Biking_Store_Project/
│
├── data/                                # Raw source CSVs
│   ├── brands.csv
│   ├── categories.csv
│   ├── customers.csv
│   ├── order_items.csv
│   ├── orders.csv
│   ├── products.csv
│   ├── staffs.csv
│   ├── stocks.csv
│   └── stores.csv
│
├── 01_CREATING_DATABASE_AND_SCHEMAS.sql  # Creates DB + Bronze/Silver/Gold/Audit schemas
├── 02_DDL_BRONZE_LAYER.sql               # Bronze table definitions
├── 03_PROC_LOAD_BRONZE.sql               # Bronze.load_bronze (BULK INSERT loader)
├── 04_DDL_SILVER_LAYER.sql               # Silver table definitions (PKs, FKs, types)
├── 05_PROC_LOAD_SILVER.sql               # Silver.load_silver (transformation loader)
├── 06_DDL_GOLD_LAYER_VIEWS.sql           # Reporting views
├── 07_DDL_GOLD_LAYER_KPIS.sql            # KPI views
├── 08_DDL_GOLD_LAYER_PROC.sql            # Parameterized stored procedures
│
├── Database_relationships.png            # ER diagram
└── README.md
```

> The numeric prefixes above reflect the intended execution order. Rename your files to
> match, or just run them in the order listed in **Setup**.

---

## ⚙️ Setup & execution

**Prerequisites:** SQL Server (2019+ or Azure SQL) and SSMS or `sqlcmd`. The SQL Server
service account must have read access to the folder containing the CSVs.

1. **Update the file paths.** `Bronze.load_bronze` uses `BULK INSERT` with absolute paths.
   Open `03_PROC_LOAD_BRONZE.sql` and replace the hardcoded folder
   (`D:\python\Biking Store Project\...`) with the location of your `data/` folder.

2. **Run the scripts in order:**

   ```sql
   -- 1. Database + schemas (drops and recreates the DB if it exists)
   :r 01_CREATING_DATABASE_AND_SCHEMAS.sql

   -- 2. Bronze
   :r 02_DDL_BRONZE_LAYER.sql
   :r 03_PROC_LOAD_BRONZE.sql
   EXEC Bronze.load_bronze;

   -- 3. Silver
   :r 04_DDL_SILVER_LAYER.sql
   :r 05_PROC_LOAD_SILVER.sql
   EXEC Silver.load_silver;

   -- 4. Gold
   :r 06_DDL_GOLD_LAYER_VIEWS.sql
   :r 07_DDL_GOLD_LAYER_KPIS.sql
   :r 08_DDL_GOLD_LAYER_PROC.sql
   ```

3. **Verify:**

   ```sql
   SELECT * FROM Gold.vw_StoreSalesSummary;
   EXEC Gold.sp_CompareSalesYearOverYear;
   ```

> `01_CREATING_DATABASE_AND_SCHEMAS.sql` **drops and recreates** the database. Don't run it
> against a database you want to keep.

---

## 🔄 ETL design notes

- **Idempotent DDL.** Every table script guards with `IF OBJECT_ID(...) IS NOT NULL DROP`,
  so scripts can be re-run safely.
- **Bronze load** truncates and reloads each table from CSV, wrapped in `TRY...CATCH` with
  per-table and total load-duration logging via `PRINT`.
- **Silver load** runs inside an explicit transaction with `SET XACT_ABORT ON`, deleting
  child tables before parents (to respect foreign keys) and rolling back on any error via
  `TRY...CATCH` + `RAISERROR`. `TRUNCATE` is intentionally avoided here because the tables
  are referenced by foreign keys.
- **Type hardening in Silver.** Date columns land as strings in Bronze and are cast to
  `DATE` in Silver; `'NULL'` text literals (e.g. in `shipped_date`, `manager_id`) are
  converted to real `NULL`s during load.

---

## 📊 Gold layer catalog

### Reporting views (`06_DDL_GOLD_LAYER_VIEWS.sql`)

| View | Description |
|------|-------------|
| `Gold.vw_StoreSalesSummary`   | Gross/net revenue, order count, and units sold per store. |
| `Gold.vw_TopSellingProducts`  | Top 10 products by quantity sold with revenue. |
| `Gold.vw_InventoryStatus`     | Current stock quantity per product across stores. |
| `Gold.vw_StaffPerformance`    | Quantity, revenue, and net revenue attributed to each staff member. |
| `Gold.vw_RegionalTrends`      | Revenue and units aggregated by store state. |
| `Gold.vw_SalesByCategory`     | Revenue and units by product category. |

### KPI views (`07_DDL_GOLD_LAYER_KPIS.sql`)

| KPI view | Measures |
|----------|----------|
| `Gold.vw_KPI_et_total_revenue`            | Total net revenue across all orders. |
| `Gold.vw_KPI_Average_Order_Value`         | Average order value. |
| `Gold.vw_KPI_Inventory_Turnover`          | Revenue relative to average inventory value.* |
| `Gold.vw_KPI_Revenue_By_Store`            | Net revenue per store. |
| `Gold.vw_KPI_Gross_Profit_By_Category`    | Revenue per category.* |
| `Gold.vw_KPI_Sales_By_Brand`              | Net revenue per brand. |
| `Gold.vw_KPI_Staff_Revenue_Contribution`  | Net revenue contribution per staff member. |

<sub>*The source data contains no cost/COGS column, so "profit" and "turnover" metrics are
currently revenue-based approximations. See Roadmap.</sub>

### Stored procedures (`08_DDL_GOLD_LAYER_PROC.sql`)

| Procedure | Parameters | Description |
|-----------|-----------|-------------|
| `Gold.sp_CalculateStoreKPI`        | `@store_id` | Gross/net revenue, order count, and units sold for one store. |
| `Gold.sp_GenerateRestockList`      | `@store_id` | Products in a store with stock below the reorder threshold (< 5). |
| `Gold.sp_CompareSalesYearOverYear` | *(none)*    | Net revenue by year with year-over-year growth %. |
| `Gold.sp_GetCustomerProfile`       | `@customer_id` | Revenue totals, order history, and most-purchased products for one customer. |

---

## 🚧 Known limitations & roadmap

Honest notes on the current state and planned improvements:

- **No cost data in source.** The dataset has list prices but no COGS, so true gross profit
  and standard inventory turnover can't be computed. Profit/turnover KPIs are revenue-based
  proxies. *Planned:* add a cost dimension to enable real margin analysis.
- **Audit schema is not yet populated.** The `Audit` schema exists but ETL runs currently
  log only to the SQL Server messages pane via `PRINT`. *Planned:* an `Audit.etl_log` table
  capturing run timestamps, row counts, durations, and caught errors.
- **Hardcoded load paths.** Bronze load paths are absolute. *Planned:* parameterize the
  source folder or move to an external data source / staging pattern.
- **Aggregation style.** Several Gold objects compute aggregates with
  `SELECT DISTINCT` + windowed `SUM() OVER (PARTITION BY ...)`. *Planned:* refactor to
  `GROUP BY` for clarity and performance.
- **Gold is view-based, not dimensional.** Gold currently serves query-friendly views
  rather than a true star schema. *Planned (optional):* materialize fact/dimension tables
  with surrogate keys if the reporting surface grows.

---

## 🗂️ Data model summary

**9 source tables**, two business domains:

- **Sales:** `customers`, `orders`, `order_items`, `staffs`, `stores`
- **Production:** `products`, `categories`, `brands`, `stocks`

Key relationships: orders → customers/stores/staffs; order_items → orders/products;
products → brands/categories; stocks → stores/products; staffs self-reference via
`manager_id`.

---

## 📝 License

Provided as a personal portfolio project for educational purposes. The BikeStores sample
dataset is a widely used public teaching dataset.
