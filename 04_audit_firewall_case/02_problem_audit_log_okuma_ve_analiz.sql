USE AdventureWorksLT2022;
GO

/* Log oluşması için örnek işlemler */
SELECT TOP 5 CustomerID, FirstName, LastName
FROM SalesLT.Customer;
GO

UPDATE SalesLT.Customer
SET Phone = Phone
WHERE CustomerID = 1;
GO

/* Audit dosyalarını okuma */
SELECT TOP 100
    event_time,
    server_principal_name,
    database_name,
    schema_name,
    object_name,
    statement,
    action_id,
    succeeded,
    client_ip,
    application_name
FROM sys.fn_get_audit_file('C:\SQLAuditLogs\*', DEFAULT, DEFAULT)
WHERE database_name = 'AdventureWorksLT2022'
ORDER BY event_time DESC;
GO

/* Kullanıcı bazlı özet */
SELECT
    server_principal_name,
    action_id,
    COUNT(*) AS islem_sayisi
FROM sys.fn_get_audit_file('C:\SQLAuditLogs\*', DEFAULT, DEFAULT)
WHERE database_name = 'AdventureWorksLT2022'
GROUP BY server_principal_name, action_id
ORDER BY islem_sayisi DESC;
GO

/* Başarısız işlemleri bulma */
SELECT TOP 100
    event_time,
    server_principal_name,
    database_name,
    statement,
    action_id,
    succeeded
FROM sys.fn_get_audit_file('C:\SQLAuditLogs\*', DEFAULT, DEFAULT)
WHERE succeeded = 0
ORDER BY event_time DESC;
GO
