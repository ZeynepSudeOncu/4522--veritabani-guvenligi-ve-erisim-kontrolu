USE AdventureWorksLT2022;
GO

IF OBJECT_ID('SecurityDemo.CustomerMasked', 'U') IS NOT NULL
BEGIN
    DROP TABLE SecurityDemo.CustomerMasked;
END
GO

CREATE TABLE SecurityDemo.CustomerMasked
(
    CustomerID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Phone NVARCHAR(50) MASKED WITH (FUNCTION = 'partial(0,"XXXX",4)'),
    EmailAddress NVARCHAR(100) MASKED WITH (FUNCTION = 'email()')
);
GO

INSERT INTO SecurityDemo.CustomerMasked
(
    CustomerID,
    FirstName,
    LastName,
    Phone,
    EmailAddress
)
SELECT TOP 10
    CustomerID,
    FirstName,
    LastName,
    Phone,
    EmailAddress
FROM SalesLT.Customer
ORDER BY CustomerID;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_principals
    WHERE name = 'mask_test_user'
)
BEGIN
    CREATE USER mask_test_user WITHOUT LOGIN;
END
GO

GRANT SELECT ON SecurityDemo.CustomerMasked TO mask_test_user;
GO

EXECUTE AS USER = 'mask_test_user';
SELECT TOP 10
    CustomerID,
    FirstName,
    LastName,
    Phone,
    EmailAddress
FROM SecurityDemo.CustomerMasked
ORDER BY CustomerID;
REVERT;
GO

SELECT TOP 10
    CustomerID,
    FirstName,
    LastName,
    Phone,
    EmailAddress
FROM SecurityDemo.CustomerMasked
ORDER BY CustomerID;
GO
