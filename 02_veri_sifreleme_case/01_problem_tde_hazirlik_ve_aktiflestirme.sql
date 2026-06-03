/*
CASE 02 - VERİ ŞİFRELEME
PROBLEM 01 - TDE Hazırlık ve Aktifleştirme

Amaç:
AdventureWorksLT2022 veritabanını Transparent Data Encryption kullanarak disk seviyesinde şifrelemek.

TDE neyi korur?
- MDF veri dosyası
- LDF log dosyası
- Backup dosyaları

TDE neyi tek başına çözmez?
- Yetkili kullanıcının SELECT ile veri okumasını engellemez.
- SQL Injection saldırısını engellemez.
- Uygulama katmanındaki hatalı yetkilendirmeyi çözmez.
*/

USE master;
GO

/* Master key yoksa oluşturulur. */
IF NOT EXISTS (SELECT 1 FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##')
BEGIN
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'MasterKey_AdventureWorksLT2022_12345!';
END
GO

/* TDE için sertifika oluşturulur. */
IF NOT EXISTS (SELECT 1 FROM sys.certificates WHERE name = 'AdventureWorksLT2022_TDE_Cert')
BEGIN
    CREATE CERTIFICATE AdventureWorksLT2022_TDE_Cert
    WITH SUBJECT = 'AdventureWorksLT2022 TDE Certificate';
END
GO

/* Sertifika mutlaka yedeklenmelidir. */
BACKUP CERTIFICATE AdventureWorksLT2022_TDE_Cert
TO FILE = 'C:\SQLBackups\AdventureWorksLT2022_TDE_Cert.cer'
WITH PRIVATE KEY (
    FILE = 'C:\SQLBackups\AdventureWorksLT2022_TDE_Cert_PrivateKey.pvk',
    ENCRYPTION BY PASSWORD = 'CertBackup_12345!'
);
GO

USE AdventureWorksLT2022;
GO

/* Database Encryption Key oluşturulur. Daha önce varsa tekrar oluşturulmaz. */
IF NOT EXISTS (
    SELECT 1
    FROM sys.dm_database_encryption_keys
    WHERE database_id = DB_ID('AdventureWorksLT2022')
)
BEGIN
    CREATE DATABASE ENCRYPTION KEY
    WITH ALGORITHM = AES_256
    ENCRYPTION BY SERVER CERTIFICATE AdventureWorksLT2022_TDE_Cert;
END
GO

ALTER DATABASE AdventureWorksLT2022
SET ENCRYPTION ON;
GO

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
