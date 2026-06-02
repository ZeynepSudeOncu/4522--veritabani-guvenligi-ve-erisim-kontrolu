/*
CASE 01 - ERİŞİM YÖNETİMİ
PROBLEM 02 - Rol Tabanlı Yetkilendirme

Amaç:
Kullanıcılara tek tek yetki vermek yerine roller oluşturup yetkileri roller üzerinden yönetmek.

Roller:
1. SalesRole     -> Müşteri ve sipariş bilgilerini görebilir, bazı müşteri alanlarını güncelleyebilir.
2. StockRole     -> Ürün bilgilerini görebilir ve ürün listesinde güncelleme yapabilir.
3. ReportRole    -> Sadece SELECT yetkisi vardır. Kritik tablolarda değişiklik yapamaz.
4. AuditorRole   -> Audit ve güvenlik kontrol sorgularını çalıştırmak için seçili görüntüleme yetkisine sahiptir.
*/

USE AdventureWorksLT2022;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'SalesRole' AND type = 'R')
    CREATE ROLE SalesRole;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'StockRole' AND type = 'R')
    CREATE ROLE StockRole;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'ReportRole' AND type = 'R')
    CREATE ROLE ReportRole;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'AuditorRole' AND type = 'R')
    CREATE ROLE AuditorRole;
GO

/* Önce gereksiz geniş yetkiler temizlenir. */
DENY DELETE ON SCHEMA::SalesLT TO SalesRole;
DENY DELETE ON SCHEMA::SalesLT TO StockRole;
DENY INSERT ON SCHEMA::SalesLT TO ReportRole;
DENY UPDATE ON SCHEMA::SalesLT TO ReportRole;
DENY DELETE ON SCHEMA::SalesLT TO ReportRole;
GO

/* SalesRole yetkileri */
GRANT SELECT ON SalesLT.Customer TO SalesRole;
GRANT SELECT ON SalesLT.Address TO SalesRole;
GRANT SELECT ON SalesLT.CustomerAddress TO SalesRole;
GRANT SELECT ON SalesLT.SalesOrderHeader TO SalesRole;
GRANT SELECT ON SalesLT.SalesOrderDetail TO SalesRole;
GRANT UPDATE ON SalesLT.Customer(Phone, EmailAddress) TO SalesRole;
GO

/* StockRole yetkileri */
GRANT SELECT ON SalesLT.Product TO StockRole;
GRANT SELECT ON SalesLT.ProductCategory TO StockRole;
GRANT SELECT ON SalesLT.ProductModel TO StockRole;
GRANT UPDATE ON SalesLT.Product(ListPrice, SellEndDate, DiscontinuedDate) TO StockRole;
GO

/* ReportRole yetkileri */
GRANT SELECT ON SalesLT.Customer TO ReportRole;
GRANT SELECT ON SalesLT.Product TO ReportRole;
GRANT SELECT ON SalesLT.SalesOrderHeader TO ReportRole;
GRANT SELECT ON SalesLT.SalesOrderDetail TO ReportRole;
GO

/* AuditorRole için metadata görüntüleme yetkileri */
GRANT VIEW DEFINITION TO AuditorRole;
GRANT SELECT ON sys.database_permissions TO AuditorRole;
GRANT SELECT ON sys.database_principals TO AuditorRole;
GO

/* Kullanıcıları rollere ekleme */
ALTER ROLE SalesRole ADD MEMBER satis_user;
ALTER ROLE StockRole ADD MEMBER stok_user;
ALTER ROLE ReportRole ADD MEMBER rapor_user;
ALTER ROLE AuditorRole ADD MEMBER denetci_user;
GO

/* Yetki kontrol sorgusu */
SELECT
    dp1.name AS role_name,
    dp2.name AS user_name
FROM sys.database_role_members drm
JOIN sys.database_principals dp1 ON drm.role_principal_id = dp1.principal_id
JOIN sys.database_principals dp2 ON drm.member_principal_id = dp2.principal_id
WHERE dp1.name IN ('SalesRole', 'StockRole', 'ReportRole', 'AuditorRole')
ORDER BY dp1.name, dp2.name;
GO
