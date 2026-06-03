/*
CASE 04 - AUDIT VE FIREWALL
PROBLEM 03 - Firewall ve Bağlantı Güvenliği

Amaç:
SQL Server'a erişimin sadece gerekli istemcilerden yapılmasını sağlamak.

Bu dosya doğrudan SQL içinde firewall kuralı oluşturmaz; çünkü firewall kuralları işletim sistemi veya ağ cihazı üzerinden yönetilir.
Ancak projede uygulanacak güvenlik adımlarını ve kontrol komutlarını içerir.
*/

/*
1. SQL Server varsayılan portu:
TCP 1433

2. Güvenlik yaklaşımı:
- SQL Server doğrudan internete açılmamalıdır.
- Sadece uygulama sunucusunun IP adresine izin verilmelidir.
- Yönetici bağlantıları VPN üzerinden yapılmalıdır.
- Gereksiz SQL Browser servisi kapatılabilir.
- Güçlü parola politikası kullanılmalıdır.
- Failed login denemeleri audit ile izlenmelidir.
*/

/* SQL Server bağlantı bilgilerini kontrol etme */
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

/*
Windows Firewall örnek PowerShell komutu:

New-NetFirewallRule `
    -DisplayName "Allow SQL Server From App Server" `
    -Direction Inbound `
    -Protocol TCP `
    -LocalPort 1433 `
    -RemoteAddress 192.168.1.50 `
    -Action Allow

Tüm dış erişimi engellemek için:

New-NetFirewallRule `
    -DisplayName "Block SQL Server Public Access" `
    -Direction Inbound `
    -Protocol TCP `
    -LocalPort 1433 `
    -RemoteAddress Any `
    -Action Block

Not:
Önce allow kuralı ve network policy sırası dikkatli tasarlanmalıdır.
Yanlış firewall kuralı SQL Server bağlantınızı tamamen kesebilir.
*/
