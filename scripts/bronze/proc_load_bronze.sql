/*
============================================================================
Stored Procedure: Load Bronze Layer (Source → Bronze)
Script Purpose:
    This stored procedure loads data into the bronze schema from external CSV files.

    It performs the following actions:
	•	Truncates the bronze tables before loading new data.
	•	Uses the BULK INSERT command to load data from CSV files into the bronze tables.

Parameters:
	•	None.
	This stored procedure does not accept any parameters and does not return any values.
Using Example:
    EXEC bronze.load_bronze;
============================================================================
*/

CREATE OR ALTER PROCEDURE BRONZE.load_bronze
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @start_time       DATETIME,
        @end_time         DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time   DATETIME;

    BEGIN TRY

        SET @batch_start_time = GETDATE();

        PRINT '=============================================================';
        PRINT 'loading bronze layer';
        PRINT '=============================================================';

        PRINT '--------------------------------------------------------------';
        PRINT 'loading crm tables';
        PRINT '--------------------------------------------------------------';

        /* ================= CRM CUSTOMER ================= */
        SET @start_time = GETDATE();

        PRINT '>> truncating table: bronze.crm_cust_info';
        TRUNCATE TABLE BRONZE.crm_cust_info;

        PRINT '>> inserting data into: bronze.crm_cust_info';
        BULK INSERT BRONZE.crm_cust_info
        FROM 'C:\Users\Akki\Downloads\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK,
            CODEPAGE = '65001'
        );

        SET @end_time = GETDATE();
        PRINT '>> load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10))
            + ' seconds';
        PRINT '----------------------------------------------------------------------------------';

        /* ================= CRM PRODUCT ================= */
        SET @start_time = GETDATE();

        PRINT '>> truncating table: bronze.crm_prd_info';
        TRUNCATE TABLE BRONZE.crm_prd_info;

        PRINT '>> inserting data into: bronze.crm_prd_info';
        BULK INSERT BRONZE.crm_prd_info
        FROM 'C:\Users\Akki\Downloads\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK,
            CODEPAGE = '65001'
        );

        SET @end_time = GETDATE();
        PRINT '>> load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10))
            + ' seconds';
        PRINT '----------------------------------------------------------------------------------';

        /* ================= CRM SALES ================= */
        SET @start_time = GETDATE();

        PRINT '>> truncating table: bronze.crm_sales_details';
        TRUNCATE TABLE BRONZE.crm_sales_details;

        PRINT '>> inserting data into: bronze.crm_sales_details';
        BULK INSERT BRONZE.crm_sales_details
        FROM 'C:\Users\Akki\Downloads\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK,
            CODEPAGE = '65001'
        );

        SET @end_time = GETDATE();
        PRINT '>> load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10))
            + ' seconds';
        PRINT '----------------------------------------------------------------------------------';

        PRINT '--------------------------------------------------------------';
        PRINT 'loading erp tables';
        PRINT '--------------------------------------------------------------';

        /* ================= ERP LOCATION ================= */
        SET @start_time = GETDATE();

        PRINT '>> truncating table: bronze.erp_loc_a101';
        TRUNCATE TABLE BRONZE.erp_loc_a101;

        PRINT '>> inserting data into: bronze.erp_loc_a101';
        BULK INSERT BRONZE.erp_loc_a101
        FROM 'C:\Users\Akki\Downloads\sql-data-warehouse-project-main\datasets\source_erp\loc_a101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK,
            CODEPAGE = '65001'
        );

        SET @end_time = GETDATE();
        PRINT '>> load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10))
            + ' seconds';
        PRINT '----------------------------------------------------------------------------------';

        /* ================= ERP CUSTOMER ================= */
        SET @start_time = GETDATE();

        PRINT '>> truncating table: bronze.erp_cust_az12';
        TRUNCATE TABLE BRONZE.erp_cust_az12;

        PRINT '>> inserting data into: bronze.erp_cust_az12';
        BULK INSERT BRONZE.erp_cust_az12
        FROM 'C:\Users\Akki\Downloads\sql-data-warehouse-project-main\datasets\source_erp\cust_az12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK,
            CODEPAGE = '65001'
        );

        SET @end_time = GETDATE();
        PRINT '>> load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10))
            + ' seconds';
        PRINT '----------------------------------------------------------------------------------';

        /* ================= ERP PRODUCT CATEGORY ================= */
        SET @start_time = GETDATE();

        PRINT '>> truncating table: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE BRONZE.erp_px_cat_g1v2;

        PRINT '>> inserting data into: bronze.erp_px_cat_g1v2';
        BULK INSERT BRONZE.erp_px_cat_g1v2
        FROM 'C:\Users\Akki\Downloads\sql-data-warehouse-project-main\datasets\source_erp\px_cat_g1v2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK,
            CODEPAGE = '65001'
        );

        SET @end_time = GETDATE();
        SET @batch_end_time = GETDATE();

        PRINT '=============================================================';
        PRINT 'bronze layer load completed successfully';
        PRINT 'total batch duration: '
            + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR(10))
            + ' seconds';
        PRINT '=============================================================';

    END TRY
    BEGIN CATCH
        PRINT '======================================================================';
        PRINT 'ERROR occurred during bronze layer load';
        PRINT 'Error Message : ' + ERROR_MESSAGE();
        PRINT 'Error Number  : ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT 'Error State   : ' + CAST(ERROR_STATE() AS NVARCHAR(10));
        PRINT '======================================================================';
    END CATCH
END;
GO
