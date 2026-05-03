-- Q1 Count transactions by status

SELECT status, COUNT(*) AS total_transactions
FROM cleaned_transactions
GROUP BY status;

-- Q2 Calculate total captured GMV by merchant

SELECT merchant_name, 
       SUM(raw_amount * usd_rate) AS total_captured_gmv_usd
FROM cleaned_transactions
WHERE status = 'captured'
GROUP BY merchant_name;

-- Q3 Show top 10 merchants by captured GMV

SELECT merchant_name, 
       SUM(raw_amount * usd_rate) AS total_captured_gmv_usd
FROM cleaned_transactions
WHERE status = 'captured'
GROUP BY merchant_name
ORDER BY total_captured_gmv_usd DESC
LIMIT 10;

-- Q4 Show daily GMV and successful transaction count

SELECT transaction_date, 
       SUM(raw_amount * usd_rate) AS daily_gmv,
       COUNT(*) AS successful_count
FROM cleaned_transactions
WHERE status = 'captured'
GROUP BY transaction_date;

-- Q5 Find merchants with chargeback ratio above 1%

SELECT merchant_name,
       COUNT(CASE WHEN status = 'chargeback' THEN 1 END) * 100.0 / COUNT(*) AS chargeback_rate
FROM cleaned_transactions
GROUP BY merchant_name
HAVING chargeback_rate > 1;

-- Q6 High-risk regions (Avg score > 50 and > 20 transactions)

SELECT gateway_region, 
       AVG(risk_score) AS avg_risk, 
       COUNT(*) AS volume
FROM cleaned_transactions
WHERE gateway_region IS NOT NULL AND gateway_region != ''
GROUP BY gateway_region
HAVING avg_risk > 50 AND volume > 20;

-- Q7 Users with 3+ failed or chargeback transactions on the same day

SELECT user_id, transaction_date, COUNT(*) AS bad_trans_count
FROM cleaned_transactions
WHERE status IN ('failed E05 timeout', 'chargeback')
GROUP BY user_id, transaction_date
HAVING bad_trans_count >= 3;

-- Q8 Chargeback breakdown by merchant

SELECT merchant_name,
       COUNT(CASE WHEN status = 'chargeback' THEN 1 END) AS cb_count,
       COUNT(DISTINCT CASE WHEN status = 'chargeback' THEN user_id END) AS unique_users_affected,
       SUM(CASE WHEN status = 'chargeback' THEN (raw_amount * usd_rate) ELSE 0 END) AS cb_amount_usd
FROM cleaned_transactions
GROUP BY merchant_name;