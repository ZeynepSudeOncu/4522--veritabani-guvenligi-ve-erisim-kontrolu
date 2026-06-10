USE AdventureWorksLT2022;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'SecurityDemo'
)
BEGIN
    EXEC('CREATE SCHEMA SecurityDemo');
END
GO

IF OBJECT_ID('SecurityDemo.CustomerEncrypted', 'U') IS NOT NULL
BEGIN
    DROP TABLE SecurityDemo.CustomerEncrypted;
END
GO


CREATE TABLE SecurityDemo.CustomerEncrypted
(
    CustomerID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    EncryptedPhone VARBINARY(MAX),
    EncryptedEmail VARBINARY(MAX)
);
GO


IF NOT EXISTS (
    SELECT 1
    FROM sys.symmetric_keys
    WHERE name = '##MS_DatabaseMasterKey##'
)
BEGIN
    CREATE MASTER KEY
    ENCRYPTION BY PASSWORD = 'ColumnEncryption_MasterKey_2026!';
END
GO


IF NOT EXISTS (
    SELECT 1
    FROM sys.certificates
    WHERE name = 'CustomerData_Cert'
)
BEGIN
    CREATE CERTIFICATE CustomerData_Cert
    WITH SUBJECT = 'Customer Sensitive Data Certificate';
END
GO


IF NOT EXISTS (
    SELECT 1
    FROM sys.symmetric_keys
    WHERE name = 'CustomerData_SymmetricKey'
)
BEGIN
    CREATE SYMMETRIC KEY CustomerData_SymmetricKey
    WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE CustomerData_Cert;
END
GO

OPEN SYMMETRIC KEY CustomerData_SymmetricKey
DECRYPTION BY CERTIFICATE CustomerData_Cert;
GO
INSERT INTO SecurityDemo.CustomerEncrypted
(
    CustomerID,
    FirstName,
    LastName,
    EncryptedPhone,
    EncryptedEmail
)
SELECT TOP 10
    CustomerID,
    FirstName,
    LastName,
    EncryptByKey(
        Key_GUID('CustomerData_SymmetricKey'),
        CONVERT(NVARCHAR(50), ISNULL(Phone, ''))
    ) AS EncryptedPhone,
    EncryptByKey(
        Key_GUID('CustomerData_SymmetricKey'),
        CONVERT(NVARCHAR(100), ISNULL(EmailAddress, ''))
    ) AS EncryptedEmail
FROM SalesLT.Customer
ORDER BY CustomerID;
GO

CLOSE SYMMETRIC KEY CustomerData_SymmetricKey;
GO


SELECT TOP 10
    CustomerID,
    FirstName,
    LastName,
    EncryptedPhone,
    EncryptedEmail
FROM SecurityDemo.CustomerEncrypted
ORDER BY CustomerID;
GO
