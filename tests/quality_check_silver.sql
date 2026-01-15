/* =============================================================================
File Name      : quality_check_silver.sql
Branch         : quality_check_silver
Layer          : Silver
Purpose        : Data quality checks for Silver layer tables
Description    :
      This script contains data quality validation queries for all Silver tables.
      Each section is organized table-wise and checks:
      - Nulls & duplicates
      - Referential integrity
      - Standardization issues
      - Business rule violations

Expected Result:
      Most queries should return ZERO rows.
      Any returned rows indicate data quality issues.

Usage:
      Run manually for validation OR integrate into CI/CD checks.
============================================================================= */

SET NOCOUNT ON;

--------------------------------------------------------------------------------
-- 1. SILVER.CRM_CUST_INFO
--------------------------------------------------------------------------------

-- Duplicate or NULL customer IDs (expect 0 rows)
SELECT cst_id, COUNT(*) AS cnt
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Leading/trailing spaces in names (expect 0 rows)
SELECT *
FROM silver.crm_cust_info
WHERE cst_firstname <> LTRIM(RTRIM(cst_firstname))
   OR cst_lastname  <> LTRIM(RTRIM(cst_lastname));

-- Invalid marital status values
SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info
WHERE cst_marital_status NOT IN ('single', 'married', 'N/A');

-- Invalid gender values
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info
WHERE cst_gndr NOT IN ('male', 'female', 'other');

--------------------------------------------------------------------------------
-- 2. SILVER.CRM_PRD_INFO
--------------------------------------------------------------------------------

-- Duplicate or NULL product IDs (expect 0 rows)
SELECT prd_id, COUNT(*) AS cnt
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Unwanted spaces in product names
SELECT *
FROM silver.crm_prd_info
WHERE prd_nm <> LTRIM(RTRIM(prd_nm));

-- Negative or NULL product cost
SELECT *
FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0;

-- Invalid product line values
SELECT DISTINCT prd_line
FROM silver.crm_prd_info
WHERE prd_line NOT IN ('Mountain', 'Road', 'Touring', 'Other Sales', 'N/A');

-- Invalid date ranges (end date before start date)
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

--------------------------------------------------------------------------------
-- 3. SILVER.CRM_SALES_DETAILS
--------------------------------------------------------------------------------

-- Orders with invalid date logic
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;

-- Sales calculation mismatch
SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales <> sls_quantity * ABS(sls_price)
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0;

-- Product key not found in product master
SELECT DISTINCT sls_prd_key
FROM silver.crm_sales_details
WHERE sls_prd_key NOT IN (
    SELECT prd_key FROM silver.crm_prd_info
);

--------------------------------------------------------------------------------
-- 4. SILVER.ERP_CUST_AZ12
--------------------------------------------------------------------------------

-- NULL customer IDs
SELECT *
FROM silver.erp_cust_az12
WHERE cid IS NULL;

-- Future birth dates
SELECT *
FROM silver.erp_cust_az12
WHERE bdate > GETDATE();

-- Invalid gender values
SELECT DISTINCT gen
FROM silver.erp_cust_az12
WHERE gen NOT IN ('Male', 'Female', 'N/A');

--------------------------------------------------------------------------------
-- 5. SILVER.ERP_LOC_A101
--------------------------------------------------------------------------------

-- NULL or empty country values
SELECT *
FROM silver.erp_loc_a101
WHERE cntry IS NULL OR LTRIM(RTRIM(cntry)) = '';

-- Country standardization check
SELECT DISTINCT cntry
FROM silver.erp_loc_a101
ORDER BY cntry;

--------------------------------------------------------------------------------
-- END OF QUALITY CHECKS
--------------------------------------------------------------------------------
