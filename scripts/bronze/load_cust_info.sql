/*
================================================================================================
Stored Procedure: Load Bronze Layer 
================================================================================================
Purpose:
    This script will load the data into the tables in the bronze schema.
    
The flow of the code:
    1. Logs the start time of the procedure.
    2. Prints headers and progress messages for better traceability.
    3. Truncates existing data from Bronze CRM tables.
    4. Bulk loads data from CSV files into CRM tables.
    5. Truncates and loads ERP tables from source files.
    6. Calculates and logs load durations for each table.
    7. Displays total execution time for the procedure.
    8. Handles errors gracefully using TRY...CATCH and logs error details.
        
================================================================================================
⚠️⚠️ WARNING
================================================================================================
    This procedure performs **TRUNCATE** and **BULK INSERT** operations on multiple tables 
    in the `bronze` schema. 

    ▪ All existing data in these tables will be permanently deleted before loading new data.
    ▪ Ensure that:
        - No active users or processes are reading from these tables.
        - Backup of bronze tables or source data is available if reprocessing is required.
        - File paths and permissions for BULK INSERT are correct.
        - CSV files are validated for format consistency before execution.
    ▪ Run this only in **non-production environments** unless you are sure it is safe.

    Proceeding without checking these may result in **data loss** or **load failure**.
================================================================================================
*/
go
CREATE or alter PROCEDURE bronze.load_cust_info as
begin
    declare @start_time datetime, @end_time datetime;
    declare @procedure_start_time datetime, @procedure_end_time datetime
    begin try
        set @procedure_start_time = getdate();
        print replicate('=',60);
        print 'Loading Bronze Layer';
        print replicate('=',60);
    
        print replicate('-',45)
        print ' Loading CRM tables';
        print replicate('-',45);

        -- bronze.crm_cust_info
        set @start_time = getdate();
        print '>> Truncating Table: bronze.crm_cust_info'
        Truncate table bronze.crm_cust_info;
        print '>> Bulk inserting into table: bronze.crm_cust_info';
        bulk insert bronze.crm_cust_info
        from 'C:\e_drive\Dsa_cpp_python\python\SQL\Data warehousing\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        with (
            firstrow = 2,
            fieldterminator =',',
            tablock 
        );
        set @end_time = getdate();
        print '>> Load Duration: '+ cast(datediff(second, @start_time,@end_time) as nvarchar);
        print '>>'+replicate('-',20);
        -- bronze.prd_info
        set @start_time = getdate();
        print '>> Truncating table: bronze.crm_prd_info';
        Truncate table bronze.crm_prd_info;

        print '>> Inserting data into table:  bronze.crm_prd_info';
        bulk insert bronze.crm_prd_info
        from 'C:\e_drive\Dsa_cpp_python\python\SQL\Data warehousing\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        with (
            firstrow = 2,
            fieldterminator =',',
            tablock 
        );
        set @end_time = getdate();
        print '>> Load Duration: '+ cast(datediff(second,@start_time,@end_time) as nvarchar);
        print '>>'+replicate('-',20);
        -- bronze.sales.details
        set @start_time = getdate();
        print '>> Truncating table: bronze.crm_sales_details';
        Truncate table bronze.crm_sales_details;
        print '>> Inserting into table: bronze.crm_sales_details';
        bulk insert bronze.crm_sales_details
        from 'C:\e_drive\Dsa_cpp_python\python\SQL\Data warehousing\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        with (
            firstrow = 2,
            fieldterminator =',',
            tablock 
        );
        set @end_time = getdate();
        print '>> Load Time: '+cast(datediff(second,@start_time,@end_time) as nvarchar);
        print '>>'+replicate('-',20);
        print replicate('-',45);
        print ' Loading ERP tables';
        print replicate('-',45);
        -- bronze.erp_loc_a101
        set @start_time = getdate();
        print '>> Truncating table: bronze.erp_loc_a101';
        truncate table [bronze].[erp_loc_a101]
        print '>> Inserting into table: bronze.erp_loc_a101';
        bulk insert [bronze].[erp_loc_a101]
        from 'C:\e_drive\Dsa_cpp_python\python\SQL\Data warehousing\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        with
        (
            firstrow = 2,
            fieldterminator = ',',
            tablock
        );
        set @end_time = getdate();
        print '>> Load Time: '+  cast(datediff(second, @start_time,@end_time) as nvarchar);
        print '>>'+replicate('-',20);
        -- [bronze].[erp_loc_az12]
        set @start_time = getdate();
        print '>> Truncating table : bronze.erp_loc_az12';
        truncate table [bronze].[erp_loc_az12];
        print '>> Inserting into table: bronze.erp_loc_az12';
        bulk insert [bronze].[erp_loc_az12]
        from 'C:\e_drive\Dsa_cpp_python\python\SQL\Data warehousing\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        with
        (
            firstrow = 2,
            fieldterminator = ',',
            tablock
        );
        set @end_time = getdate();
        print '>> Load time: '+cast(datediff(second,@start_time,@end_time) as nvarchar);
        print '>>'+replicate('-',20);

        --[bronze].[erp_px_cat_g1v2]
        set @start_time = GETDATE();
        print '>>Truncating table: bronze.erp_px_cat_g1v2';
        truncate table [bronze].[erp_px_cat_g1v2]
        print '>>Inserting into table : bronze.erp_px_cat_g1v2';
        bulk insert [bronze].[erp_px_cat_g1v2]
        from 'C:\e_drive\Dsa_cpp_python\python\SQL\Data warehousing\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        with
        (
            firstrow = 2,
            fieldterminator = ',',
            tablock
        );
        set @end_time = GETDATE();
        print '>>Load Time: '+ cast(datediff(second,@start_time,@end_time) as nvarchar);
        print '>>'+replicate('-',20);
        set @procedure_end_time = GETDATE();
        print 'Total duration of the procedure: '+cast(datediff(second,@procedure_start_time,@procedure_end_time) as nvarchar);
    end try
    begin catch
        set @procedure_start_time = GETDATE();
        print replicate('=',60);
        print ('Error Occured during loading bronze layer');
        print 'Error Message: ' + cast(Error_message() as nvarchar);
        print 'Error Number: '+ cast(error_number() as nvarchar);
        print ' Error state: '+ cast(error_state() as nvarchar);
        print replicate('=',60);
        set @procedure_end_time = GETDATE();
        print 'Total duration of the procedure: '+cast(datediff(second,@procedure_start_time,@procedure_end_time) as nvarchar);
    end catch
end
go
/*
This command is used to execute the stored procedure:
-- execute bronze.load_cust_info;
*/
