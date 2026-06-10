USE AdventureWorksLT2022;
GO

OPEN SYMMETRIC KEY CustomerData_SymmetricKey
DECRYPTION BY CERTIFICATE CustomerData_Cert;
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

CLOSE SYMMETRIC KEY CustomerData_SymmetricKey;
GO
