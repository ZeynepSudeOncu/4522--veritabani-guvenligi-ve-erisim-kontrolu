/*
CASE 03 - SQL INJECTION
PROBLEM 02 - Parametrik Sorgu ve Stored Procedure

Amaç:
SQL Injection riskini azaltmak için parametreli sorgu kullanımını göstermek.
*/

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

/* SQL Injection denemesi burada veri olarak değerlendirilir, komut olarak çalışmaz. */
EXEC dbo.SearchCustomer_Safe @LastName = N''' OR 1=1 --';
GO

/*
C# tarafında güvenli kullanım örneği:

string sql = "SELECT CustomerID, FirstName, LastName FROM SalesLT.Customer WHERE LastName = @LastName";
SqlCommand cmd = new SqlCommand(sql, connection);
cmd.Parameters.AddWithValue("@LastName", lastNameTextBox.Text);

Bu kullanımda kullanıcı girdisi SQL komutu olarak değil, parametre değeri olarak gönderilir.
*/
