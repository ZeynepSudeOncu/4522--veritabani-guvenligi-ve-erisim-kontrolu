USE AdventureWorksLT2022;
GO

CREATE OR ALTER PROCEDURE dbo.SearchCustomer_Safe
    @LastName NVARCHAR(100)
AS
BEGIN
    SELECT CustomerID, FirstName, LastName, EmailAddress
    FROM SalesLT.Customer
    WHERE LastName = @LastName;
END;
GO

/* Normal kullanım */
EXEC dbo.SearchCustomer_Safe @LastName = N'Adams';
GO

EXEC dbo.SearchCustomer_Safe @LastName = N''' OR 1=1 --';
GO


