-- Q1 Count transactions by status

SELECT row_labels AS status, 
    SUM(count_of_high_ri) + SUM(count_of_high_va) AS total_transactions 
FROM cleaned_transactions
GROUP BY row_labels;

-- Q2 Calculate total captured GMV by merchant

SELECT row_labels AS merchant_id, 
    SUM(CAST(sum_of_amount_us AS DECIMAL)) AS total_captured_gmv
FROM cleaned_transactions
GROUP BY merchant_id;

-- Q3 Show top 10 merchants by captured GMV

SELECT row_labels AS merchant_id, 
    SUM(CAST(sum_of_amount_us AS DECIMAL)) AS total_gmv
FROM cleaned_transactions
GROUP BY merchant_id
ORDER BY total_gmv DESC
LIMIT 10;

-- Q4 Show daily GMV and successful transaction count

SELECT row_labels AS transaction_date, 
    SUM(CAST(sum_of_amount_us AS DECIMAL)) AS daily_gmv,
    COUNT(*) AS successful_transaction_count
FROM cleaned_transactions
GROUP BY row_labels;

-- Q5 Find merchants with chargeback ratio above 1%

SELECT row_labels AS merchant_id,
    (SUM(count_of_high_ri) * 1.0 / COUNT(*)) AS chargeback_ratio
FROM cleaned_transactions
GROUP BY merchant_id
HAVING chargeback_ratio > 0.01;

-- Q6 High-risk regions (Avg score > 50 and > 20 transactions)

SELECT row_labels AS region,
    AVG(average_of_risk_) AS avg_risk_score,
    SUM(count_of_high_ri + count_of_high_va) AS total_tx_count
FROM cleaned_transactions
GROUP BY row_labels
HAVING avg_risk_score > 50 
   AND total_tx_count > 20;

-- Q7 Users with 3+ failed or chargeback transactions on the same day

SELECT row_labels AS user_id, 
    count_of_high_ri AS failed_or_cb_count
FROM cleaned_transactions
WHERE count_of_high_ri >= 3;

-- Q8 Chargeback breakdown by merchant

SELECT row_labels AS merchant_id,
    SUM(count_of_high_ri) AS total_chargebacks,
    COUNT(DISTINCT row_labels) AS unique_users, -- Adjusted based on schema visibility
    SUM(CAST(sum_of_amount_us AS DECIMAL)) AS total_chargeback_amount
FROM cleaned_transactions
GROUP BY merchant_id;