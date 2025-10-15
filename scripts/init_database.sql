/*
========================================================================================
Purpose:
--------
  This script creates a new database `data_warehouse` after checking if it already exists.
  If it exists it is dropped and recreated. 
  Additionally there are 3 schemas being created: 
    *) Gold
    *) SIlver
    *) Bronze
==========================================================================================
Warning:
--------
  Running this script will drop the entire database data_warehouse if it already exists.
  All data in the database will be permanently deleted 
  and hence ensure you have proper backup before running this script
==========================================================================================
*/

Use Master;
Go
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'data_warehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

create database data_warehouse;
go

use data_warehouse;
go

create schema bronze;
go
create schema silver;
-- go is a seperator in sql
go
create schema gold;
go


