CREATE TABLE dbo.Persons(
	ID BIGINT IDENTITY(1,1) NOT NULL,
	FirstName NVARCHAR(50) NOT NULL,
	Car NVARCHAR(50) NOT NULL,
	ValidFrom DATETIME2 GENERATED ALWAYS AS ROW START,
	ValidTill DATETIME2 GENERATED ALWAYS AS ROW END,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTill),
	CONSTRAINT PK_Persons PRIMARY KEY CLUSTERED (Id ASC)
)
WITH
(
	SYSTEM_VERSIONING = ON
	(
		HISTORY_TABLE = dbo.PersonsHistory,
		HISTORY_RETENTION_PERIOD = 1 YEARS
	)
 )
GO

INSERT INTO dbo.Persons(FirstName,Car) VALUES ('David', 'Bentley')
INSERT INTO dbo.Persons(FirstName,Car) VALUES ('Kevin', 'Ferrari')
INSERT INTO dbo.Persons(FirstName,Car) VALUES ('John', 'Porsche')
GO

/************************************************************/

/* you can use WAITFOR DELAY '00:01:00' to add an insert delay of approx. 1 minute */

UPDATE dbo.Persons SET Car = 'Bugatti' WHERE FirstName = 'David'
GO

UPDATE dbo.Persons SET Car = 'BMW' WHERE FirstName = 'David'
GO

UPDATE dbo.Persons SET Car = 'Buick' WHERE FirstName = 'David'
GO

UPDATE dbo.Persons SET Car = 'Honda' WHERE FirstName = 'David'
GO

UPDATE dbo.Persons SET Car = 'Hyundai' WHERE FirstName = 'David'
GO

UPDATE dbo.Persons SET Car = 'Mazda' WHERE FirstName = 'David'
GO

UPDATE dbo.Persons SET Car = 'Toyota' WHERE FirstName = 'David'
GO

/************************************************************/

DELETE FROM dbo.Persons WHERE FirstName = 'David'
GO

/************************************************************/

ALTER TABLE dbo.Persons
ADD
	LastName NVARCHAR(50) NULL
GO

ALTER TABLE dbo.Persons
SET (
	SYSTEM_VERSIONING = OFF
)
GO

UPDATE dbo.Persons SET LastName = '-unknown-'
UPDATE dbo.PersonsHistory SET LastName = '-unknown-'
GO

ALTER TABLE dbo.Persons
SET (
	SYSTEM_VERSIONING = ON
	(
		HISTORY_TABLE = dbo.PersonsHistory,
		HISTORY_RETENTION_PERIOD = 1 YEARS
	)
)
GO

ALTER TABLE dbo.Persons
ALTER COLUMN
	LastName NVARCHAR(50) NOT NULL
GO

/************************************************************/

ALTER TABLE dbo.Products
ADD
	ValidFrom DATETIME2 GENERATED ALWAYS AS ROW START DEFAULT GETUTCDATE(),
	ValidTill DATETIME2 GENERATED ALWAYS AS ROW END DEFAULT CAST('12/31/9999 23:59:59.9999999' AS DATETIME2),
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTill)
GO

ALTER TABLE dbo.Products
SET (
	SYSTEM_VERSIONING = ON
	(
		HISTORY_TABLE = dbo.ProductsHistory,
		HISTORY_RETENTION_PERIOD = 5 YEARS
	)
)
GO

/************************************************************/

SELECT * FROM dbo.Persons
	FOR SYSTEM_TIME
	ALL
WHERE FirstName = 'David'

SELECT * FROM dbo.Persons
	FOR SYSTEM_TIME
	BETWEEN '2018-06-14 09:27:00.0000000' AND '2018-06-14 09:30:05.1918383'
WHERE FirstName = 'David'
