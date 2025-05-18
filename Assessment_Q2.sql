WITH customer_monthly_stats AS (
    SELECT 
        u.id as customer_id,
        COUNT(s.id) as total_transactions,
        -- Get the number of distinct months between first and last transaction
        COUNT(DISTINCT DATE_FORMAT(s.transaction_date, '%Y-%m')) as number_of_months,
        COUNT(s.id) / COUNT(DISTINCT DATE_FORMAT(s.transaction_date, '%Y-%m')) as avg_monthly_transactions
    FROM users_customuser u
    LEFT JOIN savings_savingsaccount s ON u.id = s.owner_id
    GROUP BY u.id
    HAVING number_of_months > 0
)
SELECT 
    CASE 
        WHEN avg_monthly_transactions >= 10 THEN 'High Frequency'
        WHEN avg_monthly_transactions >= 3 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END as frequency_category,
    COUNT(*) as customer_count,
    ROUND(AVG(avg_monthly_transactions), 2) as avg_transactions_per_month
FROM customer_monthly_stats
GROUP BY 
    CASE 
        WHEN avg_monthly_transactions >= 10 THEN 'High Frequency'
        WHEN avg_monthly_transactions >= 3 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END
ORDER BY 
    CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        WHEN 'Low Frequency' THEN 3
    END;
