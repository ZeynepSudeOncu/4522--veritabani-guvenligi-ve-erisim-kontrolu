/*
CASE 01 - ERİŞİM YÖNETİMİ
PROBLEM 01 - Kullanıcı ve Login Oluşturma

Amaç:
AdventureWorksLT2022 veritabanı üzerinde farklı görevlerdeki kullanıcılar için SQL Server login ve database user oluşturmak.

Senaryo:
Bir şirket veritabanında herkesin tüm verilere erişmesi güvenlik riski oluşturur.
Bu yüzden farklı kullanıcılar oluşturulur:

1. satis_login      -> Satış departmanı kullanıcısı
2. stok_login       -> Stok/ürün departmanı kullanıcısı
3. rapor_login      -> Sadece raporlama yapan kullanıcı
4. denetci_login    -> Denetim/audit takibi yapan kullanıcı

Kullanılan veritabanı:
AdventureWorksLT2022
*/

USE master;
GO

IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = 'satis_login')
BEGIN
    CREATE LOGIN satis_login WITH PASSWORD = 'Satis_12345!', CHECK_POLICY = ON;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = 'stok_login')
BEGIN
    CREATE LOGIN stok_login WITH PASSWORD = 'Stok_12345!', CHECK_POLICY = ON;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = 'rapor_login')
BEGIN
    CREATE LOGIN rapor_login WITH PASSWORD = 'Rapor_12345!', CHECK_POLICY = ON;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = 'denetci_login')
BEGIN
    CREATE LOGIN denetci_login WITH PASSWORD = 'Denetci_12345!', CHECK_POLICY = ON;
END
GO

USE AdventureWorksLT2022;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'satis_user')
BEGIN
    CREATE USER satis_user FOR LOGIN satis_login;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'stok_user')
BEGIN
    CREATE USER stok_user FOR LOGIN stok_login;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'rapor_user')
BEGIN
    CREATE USER rapor_user FOR LOGIN rapor_login;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'denetci_user')
BEGIN
    CREATE USER denetci_user FOR LOGIN denetci_login;
END
GO

/*
Windows Authentication örneği:
Gerçek bir domain ortamında aşağıdaki yapı kullanılabilir.
DOMAIN kısmı kurumun Active Directory domain adıyla değiştirilmelidir.

USE master;
CREATE LOGIN [DOMAIN\kullaniciadi] FROM WINDOWS;

USE AdventureWorksLT2022;
CREATE USER windows_satis_user FOR LOGIN [DOMAIN\kullaniciadi];
*/

SELECT name, type_desc, create_date
FROM sys.database_principals
WHERE name IN ('satis_user', 'stok_user', 'rapor_user', 'denetci_user');
GO
