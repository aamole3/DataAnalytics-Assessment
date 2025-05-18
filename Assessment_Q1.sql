-- Now let's write our main query focusing on funded plans
WITH funded_plans AS (
    SELECT 
        p.id as plan_id,
        p.owner_id,
        p.is_regular_savings,
        p.is_fixed_investment,
        COALESCE(MAX(s.new_balance), p.amount) as current_balance
    FROM plans_plan p
    LEFT JOIN savings_savingsaccount s ON p.id = s.plan_id
    GROUP BY p.id, p.owner_id, p.is_regular_savings, p.is_fixed_investment, p.amount
    HAVING COALESCE(MAX(s.new_balance), p.amount) > 0
),
customer_plans AS (
    SELECT 
        u.id as owner_id,
        COALESCE(u.name, CONCAT(u.first_name, ' ', u.last_name)) as name,
        COUNT(DISTINCT CASE WHEN fp.is_regular_savings = 1 THEN fp.plan_id END) as savings_count,
        COUNT(DISTINCT CASE WHEN fp.is_fixed_investment = 1 THEN fp.plan_id END) as investment_count,
        SUM(fp.current_balance) as total_deposits
    FROM funded_plans fp
    INNER JOIN users_customuser u ON fp.owner_id = u.id
    GROUP BY u.id, u.name, u.first_name, u.last_name
    HAVING 
        COUNT(DISTINCT CASE WHEN fp.is_regular_savings = 1 THEN fp.plan_id END) >= 1
        AND COUNT(DISTINCT CASE WHEN fp.is_fixed_investment = 1 THEN fp.plan_id END) >= 1
)
SELECT 
    owner_id,
    name,
    savings_count,
    investment_count,
    total_deposits
FROM customer_plans
ORDER BY total_deposits DESC;
