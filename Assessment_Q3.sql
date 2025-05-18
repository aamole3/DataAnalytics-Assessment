WITH last_transactions AS (
    SELECT 
        p.id as plan_id,
        p.owner_id,
        CASE 
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_fixed_investment = 1 THEN 'Investment'
            ELSE 'Other'
        END as type,
        MAX(s.transaction_date) as last_transaction_date,
        DATEDIFF(CURRENT_DATE(), MAX(s.transaction_date)) as inactivity_days
    FROM plans_plan p
    LEFT JOIN savings_savingsaccount s ON p.id = s.plan_id
    WHERE 
        p.is_deleted = 0  -- Not deleted plans
    GROUP BY 
        p.id,
        p.owner_id,
        CASE 
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_fixed_investment = 1 THEN 'Investment'
            ELSE 'Other'
        END
)
SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    inactivity_days
FROM last_transactions
WHERE 
    inactivity_days >= 365  -- More than 1 year of inactivity
    OR last_transaction_date IS NULL  -- Include plans with no transactions at all
ORDER BY inactivity_days DESC;
