/*
====================================================================
    SCRIPT: Silver Layer Data Quality & Validation Checks
    DATABASE: data_warehouse
    PURPOSE:
        - Validate and clean CRM & ERP data post-Silver ETL.
        - Check for duplicates, nulls, unwanted spaces, invalid values.
        - Verify transformations between Bronze → Silver.
        - Ensure referential consistency between Silver tables.
====================================================================
*/

USE data_warehouse;
GO

/* ================================================================
   SECTION 1: CRM_CUSTOMER VALIDATION
=================================================================== */

-- Check for unwanted spaces in name & gender fields
SELECT cst_firstname FROM bronze.crm_cust_info WHERE cst_firstname != TRIM(cst_firstname);
SELECT cst_lastname FROM bronze.crm_cust_info WHERE cst_lastname != TRIM(cst_lastname);
SELECT cst_gndr FROM bronze.crm_cust_info WHERE cst_gndr != TRIM(cst_gndr);

-- Verify deduplication (should have only 1 record per cst_id)
SELECT cst_id, COUNT(*) AS duplicate_count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Validate distinct gender & marital status values after transformation
SELECT DISTINCT cst_gndr FROM silver.crm_cust_info;
SELECT DISTINCT cst_marital_status FROM silver.crm_cust_info;


/* ================================================================
   SECTION 2: CRM_PRODUCT VALIDATION
=================================================================== */

-- Duplicate or missing product IDs
SELECT prd_id, COUNT(*) AS duplicate_count
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Validate cleaned category and key fields
SELECT cat_id FROM silver.crm_prd_info WHERE cat_id != TRIM(cat_id);

-- Check for invalid or missing product cost
SELECT prd_cost FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Validate product line mapping consistency
SELECT DISTINCT prd_line FROM silver.crm_prd_info;

-- Quick validation of product ID consistency with sales details
SELECT prd_id
FROM bronze.crm_prd_info
WHERE SUBSTRING(prd_key, 7, LEN(prd_key)) IN (
    SELECT DISTINCT sls_prd_key FROM bronze.crm_sales_details
);


/* ================================================================
   SECTION 3: CRM_SALES VALIDATION
=================================================================== */

-- Verify date formats and null date cleaning logic
SELECT DISTINCT bdate
FROM bronze.erp_loc_az12
WHERE bdate < '1924-01-01';

-- Validate sales, quantity, and price consistency
SELECT DISTINCT
    sls_sales AS old_sls_sales,
    sls_quantity,
    sls_price AS old_sls_price,
    CASE 
        WHEN sls_sales IS NULL OR sls_sales <= 0 
             OR sls_sales != sls_quantity * ABS(sls_price)
            THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,
    CASE 
        WHEN sls_price IS NULL OR sls_price <= 0 
            THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price
    END AS sls_price
FROM silver.crm_sales_details
WHERE sls_sales != (sls_quantity * sls_price)
   OR sls_price IS NULL OR sls_price <= 0
   OR sls_quantity IS NULL OR sls_quantity <= 0
   OR sls_sales IS NULL OR sls_sales <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- Row count check
SELECT COUNT(*) AS total_sales_records FROM silver.crm_sales_details;


/* ================================================================
   SECTION 4: ERP DATA VALIDATION
=================================================================== */

-- ERP_LOC_AZ12: Gender and birth date validations
SELECT
    CASE 
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) 
        ELSE cid
    END AS cid,
    CASE WHEN bdate > GETDATE() THEN NULL ELSE bdate END AS bdate,
    CASE 
        WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
        WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
        ELSE 'n/a'
    END AS gen
FROM bronze.erp_loc_az12;

-- Gender distribution validation
SELECT DISTINCT 
    gen,
    CASE 
        WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
        WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
        ELSE 'n/a'
    END AS standardized_gen,
    COUNT(*) AS count_gen
FROM bronze.erp_loc_az12
GROUP BY gen;

-- ERP_LOC_A101: Validate country names
SELECT 
    REPLACE(cid, '-', '') AS cid,
    CASE 
        WHEN TRIM(cntry) = 'DE' THEN 'Germany'
        WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
        WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
        ELSE TRIM(cntry)
    END AS cntry_clean
FROM bronze.erp_loc_a101;

-- Validate mapping with CRM customers
SELECT REPLACE(cid, '-', '') AS cid
FROM bronze.erp_loc_a101
WHERE REPLACE(cid, '-', '') NOT IN (
    SELECT cst_key FROM silver.crm_cust_info
);

-- ERP_PX_CAT_G1V2: Product category linkage validation
SELECT DISTINCT id 
FROM bronze.erp_px_cat_g1v2
WHERE id NOT IN (
    SELECT cat_id FROM silver.crm_prd_info
);


/* ================================================================
   SECTION 5: FINAL ETL EXECUTION
=================================================================== */

PRINT REPLICATE('=', 60);
PRINT 'Executing Silver ETL Procedure...';
PRINT REPLICATE('=', 60);

EXEC silver.load_silver;
GO
