# SQL Answers
## Q1-Count transactions by status

### Query
SELECT status, COUNT(*) AS total_transactions
FROM cleaned_transactions
GROUP BY status;

### Result Summary
Captured: 19 transactions (Success)
Failed (E05 Timeout): 7 transactions
Chargeback: 4 transactions

## Q2-Calculate total captured GMV by merchant

### Query
SELECT merchant_name, 
       SUM(raw_amount * usd_rate) AS total_captured_gmv_usd
FROM cleaned_transactions
WHERE status = 'captured'
GROUP BY merchant_name;

### Result Summary
53 USD

## Q3-Show top 10 merchants by captured GMV

### Query
SELECT merchant_name, 
       SUM(raw_amount * usd_rate) AS total_captured_gmv_usd
FROM cleaned_transactions
WHERE status = 'captured'
GROUP BY merchant_name
ORDER BY total_captured_gmv_usd DESC
LIMIT 10;

### Result Summary
Beta Stores Alpha Mart Delta Travels City Pharma

## Q4-Show daily GMV and successful transaction count

### Query
SELECT transaction_date, 
       SUM(raw_amount * usd_rate) AS daily_gmv,
       COUNT(*) AS successful_count
FROM cleaned_transactions
WHERE status = 'captured'
GROUP BY transaction_date;

### Result Summary
Daily GMV in Jan is 13 USD while unsucessful count is 5

## Q5-Find merchants with chargeback ratio above 1%

### Query
SELECT merchant_name,
       COUNT(CASE WHEN status = 'chargeback' THEN 1 END) * 100.0 / COUNT(*) AS chargeback_rate
FROM cleaned_transactions
GROUP BY merchant_name
HAVING chargeback_rate > 1;

### Result Summary
Beta Stores Alpha Mart Delta Travels Eco Home

## Q6-Find regions with average risk score above 50 and more than 20 transactions

### Query
SELECT gateway_region, 
       AVG(risk_score) AS avg_risk, 
       COUNT(*) AS volume
FROM cleaned_transactions
WHERE gateway_region IS NOT NULL AND gateway_region != ''
GROUP BY gateway_region
HAVING avg_risk > 50 AND volume > 20;

### Result Summary
NIL

## Q7-Find users with 3 or more failed or chargeback transactions on the same day

### Query
SELECT user_id, transaction_date, COUNT(*) AS bad_trans_count
FROM cleaned_transactions
WHERE status IN ('failed E05 timeout', 'chargeback')
GROUP BY user_id, transaction_date
HAVING bad_trans_count >= 3;

### Result Summary
User ID - U008

## Q8-Show chargeback count, unique affected users, and chargeback amount by merchant

### Query
SELECT merchant_name,
       COUNT(CASE WHEN status = 'chargeback' THEN 1 END) AS cb_count,
       COUNT(DISTINCT CASE WHEN status = 'chargeback' THEN user_id END) AS unique_users_affected,
       SUM(CASE WHEN status = 'chargeback' THEN (raw_amount * usd_rate) ELSE 0 END) AS cb_amount_usd
FROM cleaned_transactions
GROUP BY merchant_name;

### Result Summary
Aplha Mart , Beta Stores, Delta Travels and Eco Homes - 1, City Pharma - 0 . Same for Unique affected users 

chargeback amount by merchant
Aplha Mart 5.4
Beta Stores 1.71
City Pharma - 0
Delta Travels 0.024
Eco Homes 0.072