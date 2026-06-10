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


EXEC dbo.SearchCustomer_Unsafe @LastName = N''' OR 1=1 --';
GO


