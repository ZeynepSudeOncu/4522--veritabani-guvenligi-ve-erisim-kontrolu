/*
CASE 03 - SQL INJECTION
PROBLEM 03 - SQL Injection Test Senaryoları

Amaç:
Güvensiz ve güvenli stored procedure davranışlarını karşılaştırmak.
*/

USE AdventureWorksLT2022;
GO

/* TEST 1: Normal arama - güvensiz procedure */
EXEC dbo.SearchCustomer_Unsafe @LastName = N'Adams';
GO

/* TEST 2: Injection denemesi - güvensiz procedure */
EXEC dbo.SearchCustomer_Unsafe @LastName = N''' OR 1=1 --';
GO

/* TEST 3: Normal arama - güvenli procedure */
EXEC dbo.SearchCustomer_Safe @LastName = N'Adams';
GO

/* TEST 4: Injection denemesi - güvenli procedure */
EXEC dbo.SearchCustomer_Safe @LastName = N''' OR 1=1 --';
GO

/* TEST 5: Çoklu ifade denemesi - güvenli procedure içinde çalışmaz, veri gibi davranır. */
EXEC dbo.SearchCustomer_Safe @LastName = N'''; SELECT * FROM SalesLT.Product --';
GO

/*
Beklenen Sonuç Tablosu:

1. SearchCustomer_Unsafe + normal değer:
   Sadece ilgili soyadına sahip müşteriler gelir.

2. SearchCustomer_Unsafe + ' OR 1=1 --:
   Tüm müşteriler gelebilir. Bu güvenlik açığıdır.

3. SearchCustomer_Safe + normal değer:
   Sadece ilgili soyadına sahip müşteriler gelir.

4. SearchCustomer_Safe + ' OR 1=1 --:
   Büyük ihtimalle kayıt gelmez. Çünkü değer SQL kodu olarak değil, metin olarak değerlendirilir.

5. SearchCustomer_Safe + başka SELECT denemesi:
   İkinci komut çalışmaz.
*/
