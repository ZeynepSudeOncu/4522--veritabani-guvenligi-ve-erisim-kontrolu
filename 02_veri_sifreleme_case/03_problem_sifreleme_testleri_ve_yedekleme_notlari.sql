/*
CASE 02 - VERİ ŞİFRELEME
PROBLEM 03 - Şifreleme Testleri ve Yedekleme Notları

Amaç:
TDE ve kolon bazlı şifrelemenin çalıştığını test etmek.
*/

USE AdventureWorksLT2022;
GO

/* TEST 1: TDE durumunu kontrol etme */
SELECT
    DB_NAME(database_id) AS database_name,
    encryption_state,
    CASE encryption_state
        WHEN 0 THEN 'No database encryption key present, no encryption'
        WHEN 1 THEN 'Unencrypted'
        WHEN 2 THEN 'Encryption in progress'
        WHEN 3 THEN 'Encrypted'
        WHEN 4 THEN 'Key change in progress'
        WHEN 5 THEN 'Decryption in progress'
        WHEN 6 THEN 'Protection change in progress'
    END AS encryption_state_description,
    percent_complete
FROM sys.dm_database_encryption_keys
WHERE database_id = DB_ID('AdventureWorksLT2022');
GO

/* TEST 2: Şifreli e-posta alanını çözerek okuma */
OPEN SYMMETRIC KEY CustomerSensitiveDataKey
DECRYPTION BY CERTIFICATE CustomerSensitiveDataCert;
GO

SELECT TOP 10
    CustomerID,
    FirstName,
    LastName,
    EmailAddressEncrypted,
    CONVERT(NVARCHAR(100), DecryptByKey(EmailAddressEncrypted)) AS Cozulmus_Email
FROM SalesLT.Customer;
GO

CLOSE SYMMETRIC KEY CustomerSensitiveDataKey;
GO

/* TEST 3: Anahtar açılmadan DecryptByKey kullanılırsa sonuç NULL olur. */
SELECT TOP 10
    CustomerID,
    CONVERT(NVARCHAR(100), DecryptByKey(EmailAddressEncrypted)) AS Anahtar_Acilmadan_Okuma
FROM SalesLT.Customer;
GO

/*
Yedekleme Notları:

1. TDE kullanılıyorsa sertifika ve private key mutlaka yedeklenmelidir.
2. Sertifika kaybolursa şifrelenmiş backup başka sunucuda açılamayabilir.
3. Sertifika yedeği güvenli bir yerde tutulmalıdır.
4. Şifreler proje dokümanına açık şekilde yazılmamalıdır.
5. Gerçek sistemlerde sertifika yedeği ayrı bir güvenli kasada veya kurumsal secret manager içinde saklanmalıdır.
*/
