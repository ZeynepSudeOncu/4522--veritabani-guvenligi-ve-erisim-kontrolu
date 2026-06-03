/*
CASE 03 - SQL INJECTION
PROBLEM 01 - Güvensiz Sorgu Örneği

Amaç:
Dinamik SQL'in kullanıcı girdisiyle doğrudan birleştirildiğinde nasıl SQL Injection riski oluşturduğunu göstermek.

Senaryo:
Bir uygulama müşteri soyadına göre arama yapıyor.
Kullanıcıdan gelen değer doğrudan SQL metnine eklenirse saldırgan farklı SQL ifadeleri çalıştırabilir.
*/

USE AdventureWorksLT2022;
GO

CREATE OR ALTER PROCEDURE dbo.SearchCustomer_Unsafe
    @LastName NVARCHAR(100)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);

    SET @sql = N'SELECT CustomerID, FirstName, LastName, EmailAddress
                 FROM SalesLT.Customer
                 WHERE LastName = ''' + @LastName + N'''';

    PRINT @sql;
    EXEC(@sql);
END;
GO

/* Normal kullanım */
EXEC dbo.SearchCustomer_Unsafe @LastName = N'Adams';
GO

/* SQL Injection örneği: Tüm müşterileri getirmeye çalışır. */
EXEC dbo.SearchCustomer_Unsafe @LastName = N''' OR 1=1 --';
GO

/*
Beklenen yorum:
Normalde sadece LastName = Adams olan kayıtlar gelmelidir.
Ancak zararlı giriş sonucunda WHERE koşulu etkisiz hale gelir ve tüm müşteriler listelenebilir.
Bu yüzden kullanıcı girdisi SQL metnine doğrudan eklenmemelidir.
*/
