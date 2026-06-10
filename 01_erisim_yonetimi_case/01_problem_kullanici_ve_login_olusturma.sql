
USE master;
GO

IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = 'satis_login')
BEGIN
    CREATE LOGIN satis_login WITH PASSWORD = 'Satis_Departmani_12345!', CHECK_POLICY = ON;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = 'stok_login')
BEGIN
    CREATE LOGIN stok_login WITH PASSWORD = 'Stok_Departmani_12345!', CHECK_POLICY = ON;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = 'rapor_login')
BEGIN
    CREATE LOGIN rapor_login WITH PASSWORD = 'Rapor_Kullanicisi_12345!', CHECK_POLICY = ON;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = 'denetci_login')
BEGIN
    CREATE LOGIN denetci_login WITH PASSWORD = 'Denetci_Kullanicisi_12345!', CHECK_POLICY = ON;
END
GO

USE AdventureWorksLT2022;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'satis_user')
BEGIN
    CREATE USER satis_user FOR LOGIN satis_login;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'stok_user')
BEGIN
    CREATE USER stok_user FOR LOGIN stok_login;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'rapor_user')
BEGIN
    CREATE USER rapor_user FOR LOGIN rapor_login;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'denetci_user')
BEGIN
    CREATE USER denetci_user FOR LOGIN denetci_login;
END
GO


SELECT name, type_desc, create_date
FROM sys.database_principals
WHERE name IN ('satis_user', 'stok_user', 'rapor_user', 'denetci_user');
GO
