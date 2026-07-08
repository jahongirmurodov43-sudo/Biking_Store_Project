USE master;

GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE NAME = 'Biking_Store_Project')
BEGIN 
	ALTER DATABASE Biking_Store_Project SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE Biking_Store_Project;
END;

GO

CREATE DATABASE Biking_Store_Project;

GO

USE Biking_Store_Project

GO 

CREATE SCHEMA Bronze;

GO 

CREATE SCHEMA Silver;

GO

CREATE SCHEMA Gold;

GO

CREATE SCHEMA Audit;


