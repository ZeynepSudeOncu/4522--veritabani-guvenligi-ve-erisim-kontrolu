/*
CASE 01 - ERİŞİM YÖNETİMİ
PROBLEM 03 - Yetki Testleri

Amaç:
Oluşturulan kullanıcıların sadece izin verilen işlemleri yapabildiğini test etmek.

Bu dosyada EXECUTE AS USER komutu ile farklı kullanıcıların yerine geçilerek test yapılır.
*/

USE AdventureWorksLT2022;
GO

/* TEST 1: Satış kullanıcısı müşteri listesini görebilmeli. */
EXECUTE AS USER = 'satis_user';
SELECT TOP 5 CustomerID, FirstName, LastName, Phone, EmailAddress
FROM SalesLT.Customer;
REVERT;
GO

/* TEST 2: Satış kullanıcısı ürün fiyatı güncelleyememeli. Beklenen sonuç: Permission denied. */
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

/* TEST 3: Stok kullanıcısı ürünleri görebilmeli. */
EXECUTE AS USER = 'stok_user';
SELECT TOP 5 ProductID, Name, ListPrice
FROM SalesLT.Product;
REVERT;
GO

/* TEST 4: Stok kullanıcısı müşteri bilgilerini görememeli. Beklenen sonuç: Permission denied. */
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

/* TEST 5: Rapor kullanıcısı SELECT yapabilir ama UPDATE yapamaz. */
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

/* TEST 6: Denetçi kullanıcı rol ve izinleri görebilmeli. */
EXECUTE AS USER = 'denetci_user';
SELECT TOP 20
    USER_NAME(grantee_principal_id) AS Kullanici_Veya_Rol,
    permission_name,
    state_desc,
    class_desc
FROM sys.database_permissions;
REVERT;
GO
