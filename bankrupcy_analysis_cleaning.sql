-- SQL Cleaning & Feature Engineering for Bankruptcy Analysis Project
-- Dataset: Panel data on U.S. public companies, 1999–2018

-- ---------------------------------------------------------------------
-- STEP 1: Create a cleaned table for failed companies only
-- ---------------------------------------------------------------------
CREATE TABLE bankrupt_firms AS
SELECT
    company_id,
    year,
    X1 AS current_assets,
    X14 AS current_liabilities,
    X4 AS ebitda,
    X8 AS market_value,
    X9 AS net_sales,
    X11 AS total_longterm_debt,

    -- Log-transformed values (for OLS + visualization)
    LOG(X1 + 1) AS log_current_assets,
    LOG(X14 + 1) AS log_current_liabilities,

    -- Feature engineering for polynomial regression
    X14 * X14 AS current_liabilities_squared,
    LOG(X14 + 1) * X8 AS liab_market_interaction

FROM bankruptcy_data
WHERE status_label = 0
  AND X1 IS NOT NULL
  AND X14 IS NOT NULL;

-- ---------------------------------------------------------------------
-- STEP 2: Remove records with invalid values (QA step)
-- ---------------------------------------------------------------------
DELETE FROM bankrupt_firms
WHERE current_assets < 0 OR current_liabilities < 0;

-- ---------------------------------------------------------------------
-- STEP 3: Add normalized ratio: liabilities per sales
-- ---------------------------------------------------------------------
ALTER TABLE bankrupt_firms ADD COLUMN liabilities_per_sales REAL;

UPDATE bankrupt_firms
SET liabilities_per_sales = CASE
    WHEN net_sales > 0 THEN current_liabilities / net_sales
    ELSE NULL
END;

-- ---------------------------------------------------------------------
-- STEP 4: Add binary year flag (optional: for fixed effects model)
-- ---------------------------------------------------------------------
ALTER TABLE bankrupt_firms ADD COLUMN is_2003 INTEGER;

UPDATE bankrupt_firms
SET is_2003 = CASE WHEN year = 2003 THEN 1 ELSE 0 END;

-- ---------------------------------------------------------------------
-- STEP 5: Create EBITDA quartiles for visualizations
-- ---------------------------------------------------------------------
ALTER TABLE bankrupt_firms ADD COLUMN ebitda_quartile INTEGER;
UPDATE bankrupt_firms
SET ebitda_quartile = (
   SELECT NTILE(4) OVER (ORDER BY ebitda)
 );