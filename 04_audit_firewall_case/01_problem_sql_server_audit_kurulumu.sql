
SELECT 
    IS_SRVROLEMEMBER('sysadmin') AS IsSysAdmin,
    HAS_PERMS_BY_NAME(NULL, NULL, 'ALTER ANY SERVER AUDIT') AS HasAlterAnyServerAudit;
GO

USE master;
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_file_audits WHERE name = 'AdventureWorksLT2022_ServerAudit')
BEGIN
    CREATE SERVER AUDIT AdventureWorksLT2022_ServerAudit
    TO FILE (
        FILEPATH = 'C:\SQLAuditLogs\',
        MAXSIZE = 100 MB,
        MAX_ROLLOVER_FILES = 10,
        RESERVE_DISK_SPACE = OFF
    )
    WITH (
        QUEUE_DELAY = 1000,
        ON_FAILURE = CONTINUE
    );
END
GO

ALTER SERVER AUDIT AdventureWorksLT2022_ServerAudit
WITH (STATE = ON);
GO

USE AdventureWorksLT2022;
GO

IF EXISTS (SELECT 1 FROM sys.database_audit_specifications WHERE name = 'AdventureWorksLT2022_DatabaseAuditSpec')
BEGIN
    ALTER DATABASE AUDIT SPECIFICATION AdventureWorksLT2022_DatabaseAuditSpec
    WITH (STATE = OFF);
    DROP DATABASE AUDIT SPECIFICATION AdventureWorksLT2022_DatabaseAuditSpec;
END
GO

CREATE DATABASE AUDIT SPECIFICATION AdventureWorksLT2022_DatabaseAuditSpec
FOR SERVER AUDIT AdventureWorksLT2022_ServerAudit
ADD (SELECT ON SCHEMA::SalesLT BY public),
ADD (INSERT ON SCHEMA::SalesLT BY public),
ADD (UPDATE ON SCHEMA::SalesLT BY public),
ADD (DELETE ON SCHEMA::SalesLT BY public),
ADD (DATABASE_PERMISSION_CHANGE_GROUP),
ADD (DATABASE_PRINCIPAL_CHANGE_GROUP),
ADD (SCHEMA_OBJECT_PERMISSION_CHANGE_GROUP);
GO

ALTER DATABASE AUDIT SPECIFICATION AdventureWorksLT2022_DatabaseAuditSpec
WITH (STATE = ON);
GO

SELECT
    name,
    is_state_enabled,
    create_date,
    modify_date
FROM sys.database_audit_specifications
WHERE name = 'AdventureWorksLT2022_DatabaseAuditSpec';
GO





