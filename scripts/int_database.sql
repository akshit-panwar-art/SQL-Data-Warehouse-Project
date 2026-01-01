/*
===========================================================================
Create Database and Schemas
===========================================================================
Script Purpose:
    This script creates a new database named 'DataWarehouse' after checking if it already exists.
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.

WARNING:
    Runing this script will drop the entire 'Datahouse'database if it exits.
    All data in the database will be permanently deleted, Proceed with caution 
    and ensure you have proper backups before running the script.
*/
  
CREATE DATABASE IF NOT EXISTS DataWarehouse;
USE DataWarehouse;

CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;
