
# 📊 CRM SQL Analysis Project

## 🧩 Overview
This project uses SQL to analyze CRM data related to customers, sales reps, interactions, and opportunities. The objective is to draw actionable business insights such as rep performance, conversion rates, and customer engagement metrics.

---

## 🗃️ Datasets Used
- **customers.csv** – Customer details (ID, name, country, signup date, status)
- **sales_reps.csv** – Sales representatives with performance scores
- **interactions.csv** – Logs of calls, emails, and meetings with customers
- **opportunities.csv** – Sales pipeline and deal lifecycle information

---

## 🧠 Business Questions & SQL Queries

### 1. Top Reps by Closed Deals in the Last 90 Days
```sql
SELECT
    sales_reps.name,
    COUNT(opportunities.opportunity_id) AS closed_deals
FROM
    opportunities
JOIN
    sales_reps ON opportunities.rep_id = sales_reps.rep_id
WHERE
    opportunities.status = 'Closed Won'
    AND opportunities.closed_date >= CURDATE() - INTERVAL 90 DAY
GROUP BY
    sales_reps.name
ORDER BY
    closed_deals DESC;
```

---

### 2. Average Deal Value per Rep
```sql
SELECT 
    sales_reps.name AS rep_id,
    ROUND(AVG(value), 2) AS avg_deal_value
FROM
    opportunities
JOIN
    sales_reps ON opportunities.rep_id = sales_reps.rep_id
WHERE
    status = 'Closed Won'
GROUP BY sales_reps.name
ORDER BY avg_deal_value DESC;
```

---

### 3. Conversion Rate by Country
```sql
SELECT
    customers.country,
    COUNT(CASE WHEN opportunities.status = 'Closed Won' THEN 1 END) / COUNT(*) AS conversion_rate
FROM
    opportunities
JOIN
    customers ON opportunities.customer_id = customers.customer_id
GROUP BY
    customers.country
ORDER BY
    conversion_rate DESC;
```

---

### 4. Average Days to Close a Deal
```sql
SELECT ROUND(AVG(DATEDIFF(created_date, closed_date)), 1) AS avg_days_to_close
FROM opportunities
WHERE closed_date IS NOT NULL;
```

---

### 5. Most Common Interaction Types Before a Deal Closed
```sql
SELECT
    interactions.interaction_type,
    COUNT(*) AS total
FROM
    interactions
JOIN
    opportunities ON interactions.customer_id = opportunities.customer_id
WHERE
    opportunities.status = 'Closed Won'
GROUP BY
    interactions.interaction_type
ORDER BY
    total DESC;
```

---

### 6. Customers With No Interactions in the Last 90 Days
```sql
SELECT
    customers.customer_id,
    customers.name
FROM
    customers
LEFT JOIN (
    SELECT
        interactions.customer_id,
        MAX(interactions.interaction_date) AS last_contact
    FROM
        interactions
    GROUP BY
        interactions.customer_id
) AS last_contact_info ON customers.customer_id = last_contact_info.customer_id
WHERE
    last_contact_info.last_contact < CURDATE() - INTERVAL 90 DAY;
```

---

## 🛠️ SQL Concepts Applied
- Aggregations: `COUNT`, `AVG`, `ROUND`
- Joins: `INNER JOIN`, `LEFT JOIN`
- Date calculations: `DATEDIFF`, `CURDATE()`, `INTERVAL`
- Conditional logic: `CASE WHEN`
- Subqueries and aliases

---

## 📌 Insights Summary
- Certain reps consistently close high numbers of deals in recent months.
- Some countries have significantly better conversion rates, hinting at market potential.
- Email and demo interactions are most likely to precede a closed deal.
- A subset of customers hasn’t been contacted in over 90 days and may be at risk of churn.

---

**Author**: Shoaib Shaikh  
**Tools**: MySQL Workbench  
**Next Steps**: Add Power BI visuals and documentation
