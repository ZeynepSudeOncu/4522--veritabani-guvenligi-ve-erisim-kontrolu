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

EXEC dbo.SearchCustomer_Safe @LastName = N'''; SELECT * FROM SalesLT.Product --';
GO

