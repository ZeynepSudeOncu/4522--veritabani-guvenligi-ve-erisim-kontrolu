USE AdventureWorksLT2022;
GO


EXECUTE AS USER = 'satis_user';
SELECT TOP 5 CustomerID, FirstName, LastName, Phone, EmailAddress
FROM SalesLT.Customer;
REVERT;
GO

EXECUTE AS USER = 'satis_user';
BEGIN TRY
    UPDATE SalesLT.Product
    SET ListPrice = ListPrice
    WHERE ProductID = 680;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS Beklenen_Hata_Mesaji;
END CATCH
REVERT;
GO


EXECUTE AS USER = 'stok_user';
SELECT TOP 5 ProductID, Name, ListPrice
FROM SalesLT.Product;
REVERT;
GO

EXECUTE AS USER = 'stok_user';
BEGIN TRY
    SELECT TOP 5 CustomerID, FirstName, LastName
    FROM SalesLT.Customer;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS Beklenen_Hata_Mesaji;
END CATCH
REVERT;
GO


EXECUTE AS USER = 'rapor_user';
SELECT TOP 5 SalesOrderID, OrderDate, TotalDue
FROM SalesLT.SalesOrderHeader;

BEGIN TRY
    UPDATE SalesLT.Customer
    SET Phone = Phone
    WHERE CustomerID = 1;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS Beklenen_Hata_Mesaji;
END CATCH
REVERT;
GO


EXECUTE AS USER = 'denetci_user';
SELECT TOP 20
    USER_NAME(grantee_principal_id) AS Kullanici_Veya_Rol,
    permission_name,
    state_desc,
    class_desc
FROM sys.database_permissions;
REVERT;
GO
