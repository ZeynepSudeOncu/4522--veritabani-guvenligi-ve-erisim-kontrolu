USE AdventureWorksLT2022;
GO

SELECT TOP 10
    CustomerID,
    FirstName,
    LastName,
    CONVERT(NVARCHAR(50), DecryptByKey(EncryptedPhone)) AS DecryptedPhone,
    CONVERT(NVARCHAR(100), DecryptByKey(EncryptedEmail)) AS DecryptedEmail
FROM SecurityDemo.CustomerEncrypted
ORDER BY CustomerID;
GO
