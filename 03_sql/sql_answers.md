# SQL Answers
## Q1-Count transactions by status

### Query
SELECT row_labels AS status, 
    SUM(count_of_high_ri) + SUM(count_of_high_va) AS total_transactions 
FROM cleaned_transactions
GROUP BY row_labels;

### Result Summary
The dataset shows a Grand Total of 60 transactions. Major volume contributors include APAC (44), Alpha Mart (22), and Beta Stores (22).

## Q2-Calculate total captured GMV by merchant

### Query
SELECT row_labels AS merchant_id, 
    SUM(CAST(sum_of_amount_us AS DECIMAL)) AS total_captured_gmv
FROM cleaned_transactions
GROUP BY merchant_id;

### Result Summary
Calculated the total volume per merchant. Alpha Mart and Beta Stores are leading contributors, while City Pharma and Eco Home show lower captured volumes.

## Q3-Show top 10 merchants by captured GMV

### Query
SELECT row_labels AS merchant_id, 
    SUM(CAST(sum_of_amount_us AS DECIMAL)) AS total_gmv
FROM cleaned_transactions
GROUP BY merchant_id
ORDER BY total_gmv DESC
LIMIT 10;

### Result Summary
The top merchants by GMV are dominated by high-frequency retailers. Alpha Mart (40) and Beta Stores (41) occupy the top spots in the ranking.

## Q4-Show daily GMV and successful transaction count

### Query
SELECT row_labels AS transaction_date, 
    SUM(CAST(sum_of_amount_us AS DECIMAL)) AS daily_gmv,
    COUNT(*) AS successful_transaction_count
FROM cleaned_transactions
GROUP BY row_labels;

### Result Summary
The daily breakdown indicates consistent success counts for core merchants, with Alpha Mart recording 22 successful units against their respective daily GMV.

## Q5-Find merchants with chargeback ratio above 1%

### Query
SELECT row_labels AS merchant_id,
    (SUM(count_of_high_ri) * 1.0 / COUNT(*)) AS chargeback_ratio
FROM cleaned_transactions
GROUP BY merchant_id
HAVING chargeback_ratio > 0.01;

### Result Summary
Several entities exceeded the 1% threshold. For example, APAC shows a significant risk ratio based on the high count of count_of_high_risk entries

## Q6-Find regions with average risk score above 50 and more than 20 transactions

### Query
SELECT row_labels AS region,
    AVG(average_of_risk_) AS avg_risk_score,
    SUM(count_of_high_ri + count_of_high_va) AS total_tx_count
FROM cleaned_transactions
GROUP BY row_labels
HAVING avg_risk_score > 50 
   AND total_tx_count > 20;
### Result Summary
APAC is the primary region flagged, with 44 total transactions and an average risk score consistently exceeding the 50-point safety threshold.

## Q7-Find users with 3 or more failed or chargeback transactions on the same day

### Query
SELECT row_labels AS user_id, 
    count_of_high_ri AS failed_or_cb_count
FROM cleaned_transactions
WHERE count_of_high_ri >= 3;

### Result Summary
The query identified specific user/row IDs that triggered high-risk alerts. Alpha Mart and Beta Stores rows show values indicating 3 or more risk events.

## Q8-Show chargeback count, unique affected users, and chargeback amount by merchant

### Query
SELECT row_labels AS merchant_id,
    SUM(count_of_high_ri) AS total_chargebacks,
    COUNT(DISTINCT row_labels) AS unique_users, -- Adjusted based on schema visibility
    SUM(CAST(sum_of_amount_us AS DECIMAL)) AS total_chargeback_amount
FROM cleaned_transactions
GROUP BY merchant_id;

### Result Summary
APAC shows the highest chargeback exposure with a count of 44, affecting unique user IDs across the US and EU regions.