#  Online Retail Sales

This project is an end-to-end SQL-based analysis of an e-commerce retail dataset aimed at uncovering **sales performance, customer behavior, product risks, and revenue leakage**. The objective was to transform raw transactional data into meaningful insights that support data-driven business decisions using a real-world **raw dataset** sourced from Kaggle.

---

##  Objectives
- Analyze sales and revenue performance across products, countries, and time  
- Measure customer retention through repeat purchase behavior  
- Identify product-level risks such as high return rates and underpriced items  
- Detect customers contributing to revenue loss through excessive returns  
- Generate actionable insights for pricing, promotions, bundling, and customer strategy  

---

##  Key Tasks & Methodology

### Data Understanding & Table Creation
- Created a structured PostgreSQL table to store raw invoice-level transaction data  
- Loaded data directly from CSV into the database for complete SQL-driven analysis  

### Data Cleaning & Preprocessing
- Converted invoice dates from text format to proper **TIMESTAMP** values  
- Removed records with missing customer IDs to maintain analytical accuracy  
- Correctly handled **returns using negative quantities**, preserving real-world retail logic  

### Query Design & SQL Techniques
- Used **CTEs** for multi-step customer retention and return-rate calculations  
- Applied **window functions** for ranking, comparisons, and threshold-based analysis  
- Used **self-joins** on invoice numbers to identify frequently bought product combinations  
- Implemented **conditional aggregation** to separate sales and returns  
- Performed **time-based analysis** using date extraction and interval logic  

### Analysis Logic
- Compared quantity sold vs revenue generated to detect pricing inefficiencies  
- Segmented customers based on purchase and return behavior  
- Applied minimum thresholds (units sold, return percentages) to ensure meaningful insights  

---

##  Key Analysis Performed
- Product-level revenue and quantity performance analysis  
- Country-wise and monthly sales trend analysis  
- 90-day repeat purchase rate calculation  
- Identification of customers with only return transactions  
- Product return frequency and return-rate analysis  
- Detection of high-volume, low-revenue (loss-leader) products  
- Product bundling and cross-sell analysis using invoice-level co-occurrence  

---

##  Dashboards

###  Sales Growth Overview Dashboard
This dashboard focuses on **revenue drivers and growth patterns**, helping understand what is performing well and why.

![Sales Growth Dashboard](images/sales_growth_dashboard.png)

🔗 **View Interactive Dashboard:**  
https://mavenshowcase.com/project/54434

**Key highlights:**
- Top revenue-generating products  
- Highest earning countries  
- 90-day repeat purchase rate  
- Peak ordering hour analysis  
- Frequently bought product combinations  

---

###  Customer Risk & Product Loss Analysis Dashboard
This dashboard highlights **risk areas and revenue leakage**, helping identify where corrective actions are needed.

![Risk Analysis Dashboard](images/Risk%20analysis%20dash.png)

🔗 **View Interactive Dashboard:**  
https://mavenshowcase.com/project/54436

**Key highlights:**
- High-return products and return-rate percentages  
- Customers with only return transactions  
- High-volume but low-revenue products  
- Below-average revenue product identification  

Each dashboard directly maps back to SQL logic, ensuring traceability from query to insight.

---

##  Insights & Findings
- A small group of products and countries contributes the majority of revenue  
- Over **50% of customers made repeat purchases within 90 days**, indicating strong retention  
- Several products sell in high volumes but generate low revenue, suggesting pricing issues  
- A subset of customers made only returns, indicating potential risk or poor customer experience  
- Certain product combinations are frequently purchased together, presenting bundling opportunities  

---

##  Business Impact / Value
- Enables **pricing optimization** by identifying underpriced or loss-leading products  
- Supports **targeted promotions** during peak ordering hours  
- Improves **inventory and quality decisions** by highlighting high-return products  
- Helps identify **customer risk segments** based on return behavior  
- Provides actionable insights for **cross-selling and bundle creation**  

---

##  Skills Demonstrated
- Advanced SQL (CTEs, window functions, self-joins, conditional aggregation)  
- Data cleaning and transformation using SQL  
- Time-based customer behavior and retention analysis  
- Business-oriented analytical thinking  
- Translating raw SQL results into dashboard-ready insights  

---

##  Tools Used
- **PostgreSQL** – Data cleaning, transformation, and analysis  
- **Power BI** – Interactive dashboards and visual storytelling  

---

##  Dataset
Online Retail transactional data sourced from Kaggle  
🔗 **Raw dataset:** https://www.kaggle.com/datasets/psparks/instacart-market-basket-analysis
