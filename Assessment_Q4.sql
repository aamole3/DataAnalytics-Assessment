-- 1. First check total users
SELECT COUNT(*) as total_users
FROM users_customuser;

-- 2. Check users with transactions
SELECT COUNT(DISTINCT owner_id) as users_with_transactions
FROM savings_savingsaccount
WHERE transaction_status = 'successful';

-- 3. Check transaction status values
SELECT DISTINCT transaction_status, COUNT(*) as count
FROM savings_savingsaccount
GROUP BY transaction_status;

-- 4. Modified main query
WITH customer_metrics AS (
    SELECT 
        u.id as customer_id,
        COALESCE(u.name, CONCAT(u.first_name, ' ', u.last_name)) as name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE()) as tenure_months,
        COUNT(s.id) as total_transactions,
        SUM(COALESCE(s.confirmed_amount, 0) * 0.001) as total_profit
    FROM users_customuser u
    LEFT JOIN savings_savingsaccount s ON u.id = s.owner_id
    WHERE u.date_joined IS NOT NULL
    GROUP BY 
        u.id,
        u.name,
        u.first_name,
        u.last_name,
        u.date_joined
    HAVING 
        tenure_months > 0 AND  -- Ensure positive tenure
        total_transactions > 0  -- Ensure some transactions
)
SELECT 
    customer_id,
    name,
    tenure_months,
    total_transactions,
    ROUND((total_transactions / tenure_months) * 12 * (total_profit / total_transactions), 2) as estimated_clv
FROM customer_metrics
ORDER BY estimated_clv DESC;
