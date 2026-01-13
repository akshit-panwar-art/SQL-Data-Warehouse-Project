/*
======================================================================
DDL Script: Creates tables in the 'silver' schema, dropping existing tables
if they already exits.
Run this script to re-define the DDL structure of 'bronze' tables
======================================================================
*/

IF OBJECT_ID('silver.crm_cust_info') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
GO

CREATE TABLE silver.crm_cust_info (
    cst_id             INT           NOT NULL,
    cst_key            NVARCHAR(50)   NOT NULL,
    cst_firstname      NVARCHAR(50),
    cst_lastname       NVARCHAR(50),
    cst_marital_status NVARCHAR(20),
    cst_gndr           NVARCHAR(20),
    cst_create_date    DATE,
    dwh_create_date    DATETIME2      DEFAULT GETDATE(),

    CONSTRAINT pk_silver_crm_cust PRIMARY KEY (cst_id)
);
GO


-- ============================================================
-- CRM PRODUCT
-- ============================================================
IF OBJECT_ID('silver.crm_prd_info') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
GO

CREATE TABLE silver.crm_prd_info (
    prd_id          INT           NOT NULL,
    prd_key         NVARCHAR(50)   NOT NULL,
    cat_id          NVARCHAR(10),
    prd_nm          NVARCHAR(100),
    prd_line        NVARCHAR(50),
    prd_start_dt    DATE,
    prd_end_dt      DATE,
    dwh_create_date DATETIME2      DEFAULT GETDATE(),

    CONSTRAINT pk_silver_crm_prd PRIMARY KEY (prd_id)
);
GO


-- ============================================================
-- CRM SALES
-- ============================================================
IF OBJECT_ID('silver.crm_sales_details') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details (
    sls_ord_num      NVARCHAR(50)  NOT NULL,
    sls_prd_key      NVARCHAR(50)  NOT NULL,
    sls_cust_id      INT           NOT NULL,
    sls_order_dt     DATE,
    sls_ship_dt      DATE,
    sls_due_dt       DATE,
    sls_sales        INT,
    sls_quantity     INT,
    sls_price        INT,
    dwh_create_date  DATETIME2     DEFAULT GETDATE()
);
GO


-- ============================================================
-- ERP CUSTOMER
-- ============================================================
IF OBJECT_ID('silver.erp_cust_az12') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;
GO

CREATE TABLE silver.erp_cust_az12 (
    cid              NVARCHAR(50) NOT NULL,
    bdate            DATE,
    gen              NVARCHAR(20),
    dwh_create_date  DATETIME2    DEFAULT GETDATE(),

    CONSTRAINT pk_silver_erp_cust PRIMARY KEY (cid)
);
GO


-- ============================================================
-- ERP LOCATION
-- ============================================================
IF OBJECT_ID('silver.erp_loc_a101') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;
GO

CREATE TABLE silver.erp_loc_a101 (
    cid              NVARCHAR(50) NOT NULL,
    cntry            NVARCHAR(50),
    dwh_create_date  DATETIME2    DEFAULT GETDATE(),

    CONSTRAINT pk_silver_erp_loc PRIMARY KEY (cid)
);
GO
