
# 🏢 SQL Data Warehouse Project
Welcome to my **SQL Data Warehouse  Project**! 🚀
This project showcases the complete lifecycle of building a **modern data warehouse**, performing **ETL transformations**, integrating multi-source data, and validating data quality — all using **SQL Server**.

---

## 📘 Project Overview

This project demonstrates:

* **Data Warehousing** – Centralizing multiple business datasets (CRM, ERP, and Sales) into a unified warehouse.
* **ETL Pipelines** – Implementing the **Medallion Architecture (Bronze → Silver → Gold)** for structured data transformation.
* **Data Modeling** – Designing a **Star Schema** with **fact** and **dimension** views for analytics.
* **Data Integration & Quality Checks** – Validating data consistency, removing duplicates, and ensuring referential integrity across layers.
* **Analytics & Insights** – Running SQL-based queries to derive insights into **sales performance**, **customer behavior**, and **product trends**.

---

## 🧱 Data Architecture

The project follows the **Medallion Architecture** pattern with three layers:

| Layer                      | Description                                                                                                                                                               |
| -------------------------- | -----------------------------------------------------------------------------------------------------------------------------------------                                 |
| **Bronze (Raw Layer)**     | Direct ingestion of raw CSV data into SQL Server, with schemas reflecting original file structures.                                                                       |
| **Silver (Cleaned Layer)** | Data cleaning, deduplication, data normalization as well as decision for data integration.                                                                                |
| **Gold (Business Layer)**  | Merging of different tables and Creation of **dimension** and **fact views** — `dim_customers`, `dim_products`, and `fact_sales` — optimized for analytics and reporting. |

---

## 🧩 Data Modeling

The **Gold layer** follows a **Star Schema** design (`1` fact and `2` dimensions):

* **Dimension Tables:**

  * `dim_customers` – Descriptive attributes about customers (name, gender, region, etc.)
  * `dim_products` – Product-related details (category, cost, status, etc.)

* **Fact Table:**

  * `fact_sales` – Transactional sales data linked to the above dimensions, containing measurable values like sales amount, quantity, and price.

The **ER Diagram** illustrating the schema was created using **draw.io**, and is stored in the `docs/` folder.

---

## 📂 Repository Structure

```
data-warehouse-project/
│
├── datasets/                 # Raw CSV datasets (CRM, ERP, Sales, etc.)
├── docs/                     # Documentation & ER diagrams (created in draw.io)
├── scripts/                  # SQL ETL scripts organized by layer
│   ├── bronze/               # Raw data ingestion
│   ├── silver/               # Data cleaning, integration, and standardization
│   └── gold/                 # Fact & dimension view creation
├── tests/                    # Data quality & validation scripts
├── README.md                 # Project overview (this file)
└── LICENSE                   # License info
```

---

## ⚙️ Tools & Technologies

* **Microsoft SQL Server Express** – Primary database engine.
* **SQL Server Management Studio (SSMS)** – Used for ETL scripting and view creation.
* **draw.io** – Used to design ER diagrams and visualize schema relationships.
* **Git & GitHub** – For version control and project documentation.
* *(Optional)* **Python** – For automation or CSV preprocessing in future expansions.

---

## 🎯 Key Objectives

1. **Data Engineering**

   * Build and manage ETL pipelines across Bronze, Silver, and Gold layers.
   * Integrate CRM and ERP datasets into a unified data model.

2. **Data Modeling**

   * Design a Star Schema with Fact and Dimension views.
   * Ensure optimized query performance for reporting and analytics.

3. **Data Quality & Integration**

   * Perform validation checks for duplicates, null values, referential integrity, and inconsistent categories.
   * Merge multi-source columns (e.g., gender integration between CRM and ERP tables).
   * Validate date consistency and record completeness across all layers.

4. **Analytics & Reporting**

   * Enable SQL-based reports for:

     * Sales trend analysis
     * Customer purchase behavior
     * Product category performance

---

## ✅ Data Validation Examples

Quality checks included in the `tests/` folder ensure data consistency, such as:

* **Duplicate detection** in Silver layer tables
* **Gender integration** using CRM as the master source
* **Null and referential integrity checks** in Gold layer
* **Chronological validation** (`order_date < ship_date < due_date`)
* **Count comparison** between Silver and Gold layers

---

## 🚀 Future Enhancements

* **Analytical Layer Development:**
  Build a full **analytical project** on top of the Gold layer — including SQL-based KPI dashboards, customer segmentation analysis, and performance insights.

* **Cloud Integration:**
  Migrate the warehouse to a **cloud-based platform** such as **Azure SQL Database** or **AWS Redshift** for scalability and automated ETL orchestration.

* **ETL Automation:**
  Schedule data refresh jobs using SQL Agent or Python scripts.

* **BI Visualization:**
  Connect to **Power BI** or **Tableau** for dashboard development.

* **Data Monitoring & Anomaly Detection:**
  Implement alerting mechanisms to track data drift and quality issues.

---

## ☕ Connect with Me

* **LinkedIn:** [Nishanth P Kashyap](https://www.linkedin.com/in/nishanth-kashyap-06b979259/)
* **GitHub:** [nishu-2004](https://github.com/nishu-2004)

---

## 🛡️ License

This project is licensed under the **MIT License** – you’re free to use, modify, and share with proper attribution.

