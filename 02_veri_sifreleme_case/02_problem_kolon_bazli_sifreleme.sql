/*
CASE 02 - VERİ ŞİFRELEME
PROBLEM 02 - Kolon Bazlı Şifreleme

Amaç:
AdventureWorksLT2022 içindeki müşteri e-posta bilgisini örnek hassas veri kabul ederek kolon bazlı şifreleme yapmak.

Not:
SalesLT.Customer tablosunda EmailAddress alanı normalde açık metindir.
Bu script tabloya EmailAddressEncrypted adında VARBINARY(MAX) bir kolon ekler.
Sonra EmailAddress değerini simetrik anahtar ile şifreleyerek bu kolona yazar.
*/

USE AdventureWorksLT2022;
GO

/* Master key yoksa veritabanı seviyesinde oluşturulur. */
IF NOT EXISTS (SELECT 1 FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##')
BEGIN
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'DbMasterKey_AdventureWorksLT2022_12345!';
END
GO

/* Sertifika oluşturulur. */
IF NOT EXISTS (SELECT 1 FROM sys.certificates WHERE name = 'CustomerSensitiveDataCert')
BEGIN
    CREATE CERTIFICATE CustomerSensitiveDataCert
    WITH SUBJECT = 'Certificate for customer sensitive data encryption';
END
GO

/* Simetrik anahtar oluşturulur. */
IF NOT EXISTS (SELECT 1 FROM sys.symmetric_keys WHERE name = 'CustomerSensitiveDataKey')
BEGIN
    CREATE SYMMETRIC KEY CustomerSensitiveDataKey
    WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE CustomerSensitiveDataCert;
END
GO

/* Şifreli e-posta kolonu eklenir. */
IF COL_LENGTH('SalesLT.Customer', 'EmailAddressEncrypted') IS NULL
BEGIN
    ALTER TABLE SalesLT.Customer
    ADD EmailAddressEncrypted VARBINARY(MAX) NULL;
END
GO

/* Var olan EmailAddress verileri şifrelenir. */
OPEN SYMMETRIC KEY CustomerSensitiveDataKey
DECRYPTION BY CERTIFICATE CustomerSensitiveDataCert;
GO

UPDATE SalesLT.Customer
SET EmailAddressEncrypted = EncryptByKey(
    Key_GUID('CustomerSensitiveDataKey'),
    CONVERT(NVARCHAR(100), EmailAddress)
)
WHERE EmailAddress IS NOT NULL;
GO

CLOSE SYMMETRIC KEY CustomerSensitiveDataKey;
GO

/* Şifreli veri doğrudan okununca anlamsız binary veri görünür. */
SELECT TOP 10
    CustomerID,
    FirstName,
    LastName,
    EmailAddress AS Acik_Email,
    EmailAddressEncrypted AS Sifreli_Email
FROM SalesLT.Customer;
GO
