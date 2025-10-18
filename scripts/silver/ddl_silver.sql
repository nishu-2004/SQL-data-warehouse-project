/*
=================================================================================================
PURPOSE:
    It creates the tables in the 'silver' schema 
    It is similar to that of the ddl_bronze.sql schema but creates the timestamp column of when it was updated.
-------------------------------------------------------------------------------------------------
WARNING:
    **USE WITH CAUTION** 
    It will drop the table if it already exists.
-------------------------------------------------------------------------------------------------
FLow:
    1) Checks if the table exist
    2) If it exists then drops it 
    3) If it doesnt, then it creates the table
=================================================================================================
*/

IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
GO

CREATE TABLE silver.crm_cust_info (
    cst_id              INT,
    cst_key             NVARCHAR(50),
    cst_firstname       NVARCHAR(50),
    cst_lastname        NVARCHAR(50),
    cst_marital_status  NVARCHAR(50),
    cst_gndr            NVARCHAR(50),
    cst_create_date     DATE,
    dwh_create_date  datetime2 default getdate()
);
GO

IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
GO

CREATE TABLE silver.crm_prd_info (
    prd_id       INT,
    prd_key      NVARCHAR(50),
    prd_nm       NVARCHAR(50),
    prd_cost     INT,
    prd_line     NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt   DATETIME,
    dwh_create_date  datetime2 default getdate()
);
GO

IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details (
    sls_ord_num  NVARCHAR(50),
    sls_prd_key  NVARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT,
    dwh_create_date  datetime2 default getdate()
);
GO


-- erp source
go
if object_id('silver.erp_loc_az12','U') is not NULL
    drop table silver.erp_loc_az12;
go

create table silver.erp_loc_az12 (
    cid nvarchar(50),
    bdate date,
    gen nvarchar(50),
    dwh_create_date  datetime2 default getdate()
);
go
IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;
GO

CREATE TABLE silver.erp_loc_a101 (
    cid    NVARCHAR(50),
    cntry  NVARCHAR(50),
    dwh_create_date  datetime2 default getdate()
);
GO

if object_id ('silver.erp_px_cat_g1v2','U') is not null
    drop table silver.erp_px_cat_g1v2;
go

create table silver.erp_px_cat_g1v2 (
    id nvarchar(50),
    cat nvarchar(50),
    subcat nvarchar(50),
    maintenance nvarchar(50),
    dwh_create_date  datetime2 default getdate()
);
go
