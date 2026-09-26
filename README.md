# 🇧🇷 Olist Brazilian E-Commerce Executive Analytics Suite

[![Streamlit App](https://static.streamlit.io/badges/streamlit_badge_black_white.svg)](https://share.streamlit.io/)
[![Python](https://img.shields.io/badge/Python-3.10%2B-blue.svg)](https://www.python.org/)
[![Power BI](https://img.shields.io/badge/Power_BI-Desktop-F2C811.svg)](https://powerbi.microsoft.com/)
[![SQL](https://img.shields.io/badge/SQL-Advanced_Analytics-orange.svg)](https://www.mysql.com/)

---

## 📌 Executive Summary
An enterprise-grade marketplace analytics suite modeling Brazil's largest online marketplace (**Olist**), consolidating over **100,000 orders** across 8 relational tables into a unified Star Schema data architecture. 

The suite analyzes platform unit economics, multi-state fulfillment latency, seller revenue concentration, review sentiment, and payment installment behavior across all 27 Brazilian states.

---

## 📊 Core Business KPIs

| Metric | Measured Value | Business Definition |
| :--- | :--- | :--- |
| **Gross Merchandise Value (GMV)** | **R$ 15.44M** | Cumulative value of all marketplace transactions |
| **Total Order Volume** | **98,666** | Total customer orders fulfilled across the network |
| **Customer Cohort** | **99,441** | Unique verified purchasers across Brazilian states |
| **Average Order Value (AOV)** | **R$ 156.50** | Mean basket monetary spend per completed transaction |
| **Platform CSAT** | **4.09 / 5.0 ⭐** | Aggregated review score across all verified orders |
| **Mean Transit Latency** | **~12.5 Days** | End-to-end duration from order placement to doorstep |

---

## 🏗️ Architecture & Repository Structure

- **Star Schema Relational Model**: Standardized 8 relational entities: `Orders`, `Order_Items`, `Payments`, `Reviews`, `Products`, `Sellers`, `Customers`, and `Geolocation`.
- **Large Model Assets**: Enterprise Power BI Star Schema model (`.pbix`, ~37 MB) hosted under [GitHub Release v1.0.0](../../releases/tag/v1.0.0).
- **Relational SQL Suite (`sql_analytics.sql`)**:
  - Executive GMV, Freight Economics, and AOV calculations.
  - SLA breach analysis and regional logistics transit days by state.
  - Pareto 80/20 seller revenue concentration and rating correlation.
  - Payment gateway share and installment distribution.
- **Interactive Telemetry Dashboard (`app.py`)**: Real-time Streamlit web application with Plotly visualizations, dark executive styling, and dynamic state/payment filtering.

---

## 🛠️ Technology Stack
- **Dashboard & Modeling**: Power BI (DAX Measures, Star Schema, Semantic Model), Streamlit, Plotly
- **Data Engineering & ETL**: Python (Pandas, NumPy)
- **Warehouse Analytics**: SQL (CTEs, Window Functions, DATEDIFF, Conditional Aggregations)

---

## 🚀 How to Run Locally

### 1. Clone the repository:
git clone https://github.com/AyushKumar-12345/olist-ecommerce-analytics.git
cd olist-ecommerce-analytics

### 2. Install dependencies:
pip install -r requirements.txt

### 3. Launch the interactive dashboard:
streamlit run app.py

---

## 👤 Author
**Ayush Kumar**  
Data Analytics & Engineering
