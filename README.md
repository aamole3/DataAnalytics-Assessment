# Data Analytics Assessment

This repository contains SQL queries for analyzing customer data and transaction patterns. Each query addresses specific business requirements and provides insights into customer behavior.

## Repository Structure

```
DataAnalytics-Assessment/
│
├── Assessment_Q1.sql  # High-Value Customers Analysis
├── Assessment_Q2.sql  # Customer Transaction Frequency
├── Assessment_Q3.sql  # Inactive Accounts Detection
├── Assessment_Q4.sql  # Customer Lifetime Value (CLV)
│
└── README.md         # Documentation
```

## Question Analysis

### Q1: High-Value Customers with Multiple Products

**Task:** Identify customers with both funded savings and investment plans.

**Approach:**
1. Used two-CTE structure for better organization:
   - `funded_plans`: Identified funded plans and their balances
   - `customer_plans`: Aggregated customer-level data
2. Calculated balances using COALESCE to handle NULL values
3. Used DISTINCT counting to avoid duplicate plan counts

**Challenges:**
1. Name Display Issue:
   - Problem: All customer names were NULL initially
   - Solution: Implemented COALESCE with concatenated first_name and last_name
2. Balance Calculation:
   - Problem: Initial approach only considered 'successful' transactions
   - Solution: Modified to use actual balances instead of transaction status
3. Plan Counting:
   - Problem: Potential duplicate counting of plans
   - Solution: Implemented DISTINCT counting in aggregations

### Q2: Customer Transaction Frequency Analysis

**Task:** Analyze and categorize customers based on transaction frequency.

**Approach:**
1. Created monthly transaction aggregation
2. Implemented frequency categorization logic
3. Used CTEs for clean data transformation
4. Applied appropriate date functions for monthly calculations

**Challenges:**
1. Initial Overcomplexity:
   - Problem: Over-complicated active months calculation
   - Solution: Simplified to direct monthly transaction counting
2. Data Aggregation:
   - Problem: Complex nested averaging giving incorrect results
   - Solution: Streamlined calculation approach
3. Transaction Counting:
   - Problem: Initially missed some transactions due to status filtering
   - Solution: Removed unnecessary transaction status restrictions

### Q3: Inactive Accounts Detection

**Task:** Find accounts with no transactions in the last year.

**Approach:**
1. Used LEFT JOIN to include all plans
2. Implemented DATEDIFF for inactivity calculation
3. Created CASE statements for plan type identification
4. Applied appropriate filtering for 365-day inactivity

**Challenges:**
1. Status Field Assumption:
   - Problem: Incorrectly assumed existence of is_active column
   - Solution: Revised schema understanding and adjusted query
2. Date Handling:
   - Problem: Accurate calculation of inactivity periods
   - Solution: Implemented proper DATEDIFF logic
3. Plan Status:
   - Problem: Determining current plan status
   - Solution: Focused on transaction dates rather than status flags

### Q4: Customer Lifetime Value (CLV)

**Task:** Calculate estimated CLV based on transaction history.

**Approach:**
1. Implemented CTE for customer metrics calculation
2. Created tenure calculation using TIMESTAMPDIFF
3. Applied CLV formula with appropriate aggregations
4. Used LEFT JOIN to ensure all customer inclusion

**Challenges:**
1. Transaction Inclusion:
   - Problem: Initially filtered out relevant transactions
   - Solution: Removed restrictive transaction status filtering
2. Profit Calculation:
   - Problem: Handling NULL amounts in calculations
   - Solution: Implemented COALESCE for NULL handling
3. Tenure Calculation:
   - Problem: Ensuring accurate customer tenure
   - Solution: Added proper date validation and NULL checks

## Key Learnings

1. Start with minimal filtering and add constraints as needed
2. Always handle NULL values appropriately
3. Validate intermediate results
4. Consider business context when setting thresholds
5. Use CTEs for better query organization

## Usage

Each SQL file contains:
- The main query
- Relevant comments explaining the logic
- Required table references
- Expected output format 