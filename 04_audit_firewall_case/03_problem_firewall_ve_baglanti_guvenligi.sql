SELECT
    session_id,
    login_name,
    host_name,
    program_name,
    client_interface_name,
    login_time
FROM sys.dm_exec_sessions
WHERE is_user_process = 1;
GO

/* Aktif bağlantıların IP bilgilerini görüntüleme */
SELECT
    s.session_id,
    s.login_name,
    s.host_name,
    c.client_net_address,
    c.local_net_address,
    c.local_tcp_port,
    s.program_name
FROM sys.dm_exec_sessions s
JOIN sys.dm_exec_connections c ON s.session_id = c.session_id
WHERE s.is_user_process = 1;
GO

