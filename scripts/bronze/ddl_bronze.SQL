/*
===========================================================================
DDL Script: Create Bronze Tables
===========================================================================
Script Purpose:
  This script create table in the 'bronze' schema, dropping existing tables
  if they already exist.
  Run this script to re-define the DDL structure of 'bronze' tables
===========================================================================
*/


IF DB_ID('DataWarehouse') IS NULL
BEGIN
    CREATE DATABASE DataWarehouse;
END
GO

USE DataWarehouse;
GO
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'BRONZE')
    EXEC('CREATE SCHEMA BRONZE');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'SILVER')
    EXEC('CREATE SCHEMA SILVER');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'GOLD')
    EXEC('CREATE SCHEMA GOLD');
GO
DROP TABLE IF EXISTS BRONZE.crm_cust_info;
GO

CREATE TABLE BRONZE.crm_cust_info (
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(50),
    cst_lastname NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr NVARCHAR(50),
    cst_create_date DATE
);
GO

DROP TABLE IF EXISTS BRONZE.crm_prd_info;
GO

CREATE TABLE BRONZE.crm_prd_info (
    prd_id INT,
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(50),
    prd_cost INT,
    prd_line NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt DATETIME
);
GO

DROP TABLE IF EXISTS BRONZE.crm_sales_details;
GO

CREATE TABLE BRONZE.crm_sales_details (
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);
GO

DROP TABLE IF EXISTS BRONZE.erp_loc_a101;
GO

CREATE TABLE BRONZE.erp_loc_a101 (
    cid NVARCHAR(50),
    cntry NVARCHAR(50)
);
GO

DROP TABLE IF EXISTS BRONZE.erp_cust_az12;
GO

CREATE TABLE BRONZE.erp_cust_az12 (
    cid NVARCHAR(50),
    bdate DATE,
    gen NVARCHAR(50)
);
GO

DROP TABLE IF EXISTS BRONZE.erp_px_cat_g1v2;
GO

CREATE TABLE BRONZE.erp_px_cat_g1v2 (
    id NVARCHAR(50),
    cat NVARCHAR(50),
    subcat NVARCHAR(50),
    maintenance NVARCHAR(50)
);
GO

