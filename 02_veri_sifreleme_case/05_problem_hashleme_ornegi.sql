USE AdventureWorksLT2022;
GO

IF OBJECT_ID('SecurityDemo.PasswordHashDemo', 'U') IS NOT NULL
BEGIN
    DROP TABLE SecurityDemo.PasswordHashDemo;
END
GO

CREATE TABLE SecurityDemo.PasswordHashDemo
(
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    UserName NVARCHAR(50) NOT NULL,
    PasswordHash VARBINARY(64) NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

INSERT INTO SecurityDemo.PasswordHashDemo (UserName, PasswordHash)
VALUES
('satis_user_demo', HASHBYTES('SHA2_256', CONVERT(NVARCHAR(200), 'SatisDemo_2026!'))),
('stok_user_demo', HASHBYTES('SHA2_256', CONVERT(NVARCHAR(200), 'StokDemo_2026!'))),
('rapor_user_demo', HASHBYTES('SHA2_256', CONVERT(NVARCHAR(200), 'RaporDemo_2026!')));
GO


SELECT
    UserID,
    UserName,
    PasswordHash,
    CreatedAt
FROM SecurityDemo.PasswordHashDemo;
GO


DECLARE @EnteredPassword NVARCHAR(200) = 'SatisDemo_2026!';

SELECT
    UserName,
    CASE
        WHEN PasswordHash = HASHBYTES('SHA2_256', CONVERT(NVARCHAR(200), @EnteredPassword))
        THEN 'Parola doğru'
        ELSE 'Parola yanlış'
    END AS PasswordCheckResult
FROM SecurityDemo.PasswordHashDemo
WHERE UserName = 'satis_user_demo';
GO
