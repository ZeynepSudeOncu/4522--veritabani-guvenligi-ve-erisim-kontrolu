USE AdventureWorksLT2022;
GO

IF EXISTS (
    SELECT 1
    FROM sys.database_principals
    WHERE name = 'mask_test_user'
)
BEGIN
    DROP USER mask_test_user;
END
GO

IF OBJECT_ID('SecurityDemo.CustomerEncrypted', 'U') IS NOT NULL
BEGIN
    DROP TABLE SecurityDemo.CustomerEncrypted;
END
GO

IF OBJECT_ID('SecurityDemo.CustomerMasked', 'U') IS NOT NULL
BEGIN
    DROP TABLE SecurityDemo.CustomerMasked;
END
GO

IF OBJECT_ID('SecurityDemo.PasswordHashDemo', 'U') IS NOT NULL
BEGIN
    DROP TABLE SecurityDemo.PasswordHashDemo;
END
GO

IF EXISTS (
    SELECT 1
    FROM sys.symmetric_keys
    WHERE name = 'CustomerData_SymmetricKey'
)
BEGIN
    DROP SYMMETRIC KEY CustomerData_SymmetricKey;
END
GO

IF EXISTS (
    SELECT 1
    FROM sys.certificates
    WHERE name = 'CustomerData_Cert'
)
BEGIN
    DROP CERTIFICATE CustomerData_Cert;
END
GO

IF EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'SecurityDemo'
)
AND NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE schema_id = SCHEMA_ID('SecurityDemo')
)
BEGIN
    DROP SCHEMA SecurityDemo;
END
GO
