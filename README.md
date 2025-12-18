This project is an end-to-end PostgreSQL analytics case study on online retail transaction data. It focuses on transforming raw e-commerce sales records into actionable insights around revenue growth, customer behavior, product performance, and return-related risk.

Project Objective

To demonstrate how advanced SQL can be used to support real e-commerce business decisions by analyzing:

Revenue drivers and sales trends

Customer retention and return behavior

Product pricing inefficiencies and loss risks

Cross-sell and bundling opportunities

Data Preparation (SQL)

Created raw transactional tables and ingested CSV data

Converted string-based dates into proper TIMESTAMP format

Removed incomplete transactions (missing customer IDs)

Correctly handled returns using negative quantities

All data cleaning and transformation was performed directly in SQL.

Key Analysis Performed
Sales & Growth Analysis

Top revenue-generating products and countries

Monthly and yearly revenue trends

Peak ordering hour analysis

Customer Behavior Analysis

90-day repeat purchase rate using customer-level time logic

Identification of customers with only return transactions

Product Risk & Pricing Insights

High-volume products with low revenue (potential under-pricing)

Products sold below average revenue benchmarks

Product-level return rate analysis with meaningful thresholds

Product Bundling

Identified products frequently bought together using self-joins on invoice data

Insights for bundle creation and cross-selling strategies

Dashboards

Sales Growth Overview: Revenue drivers, repeat purchases, country performance, peak hours, and bundling patterns

Customer Risk & Product Loss: High return products, loss leaders, return-only customers, and pricing risks

Each dashboard directly reflects the underlying SQL logic.
