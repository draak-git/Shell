@echo off
color ff
title 信息中心
echo.
echo                     ╭──────────────────╮
echo         ╭─────┤    信  息  中  心  专  用  程  序  ├─────╮
echo         │          ╰──────────────────╯          │
echo         │                                                            │
echo         │       本程序能为您自动设置IP网关DNS以及相应的功能设置      │
echo         │                                                            │
echo         │     测试环境WINDOWS XP操作系统,如果设置后无效请重启机器!   │
echo         │                                                            │
echo         ╰──────────────────────────────╯
echo.
echo   01.禁用本机USB设备                  -01.恢复USB设备
echo   02.禁用CMD（命令提示符）            -02.恢复CMD（命令提示符）
echo   03.禁用TCP/IP                       -03.恢复TCP/IP
echo   04.贵视大厦UPS监控
echo   05.更改本地host(shop22)并启动tcp/ip netbios服务
echo   06.ceshi
echo   07.计算机重启
echo   08.退出
echo.   
echo.
SET /P aa=  请输入数字选择:
echo.

if %aa%==01 goto :usbjy
if %aa%==-01 goto :usbqy
if %aa%==02 goto :cmdjy
if %aa%==-02 goto :cmdqy
if %aa%==03 goto :tcpjy
if %aa%==-03 goto :tcpqy
if %aa%==04 goto :gsjk
if %aa%==05 goto :hostshop22andtcp/ip netbios
if %aa%==06 goto :ceshi
if %aa%==07 goto :restart
if %aa%==08 exit

exit

::改为4禁用
:usbjy
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\USBSTOR" /f /v "Start" /t REG_DWORD /d 4
rundll32 user32.dll,UpdatePerUserSystemParameters
pause&exit

::改为3启用
:usbqy
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\USBSTOR" /f /v "Start" /t REG_DWORD /d 3
rundll32 user32.dll,UpdatePerUserSystemParameters
pause&exit

::禁用CMD
:cmdjy
@echo Windows Registry Editor Version 5.00 >>C:\WINDOWS\CMD禁用.reg
@echo [HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\System] >>C:\WINDOWS\CMD禁用.reg
@echo "DisableCMD"=dword:00000001 >>C:\WINDOWS\CMD禁用.reg
regedit -s C:\WINDOWS\CMD禁用.reg
rundll32 user32.dll,UpdatePerUserSystemParameters
pause&exit

::启用CMD
:cmdqy
@echo Windows Registry Editor Version 5.00 >>C:\WINDOWS\CMD启用.reg
@echo [HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\System] >>C:\WINDOWS\CMD启用.reg
@echo "DisableCMD"=dword:00000000 >>C:\WINDOWS\CMD启用.reg
regedit -s C:\WINDOWS\CMD启用.reg
rundll32 user32.dll,UpdatePerUserSystemParameters
pause&exit

::禁用TCP/IP
:tcpjy
@echo Windows Registry Editor Version 5.00 >>C:\WINDOWS\TCPIP禁用.reg
@echo [HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Network Connections] >>C:\WINDOWS\TCPIP禁用.reg
@echo "NC_AllowAdvancedTCPIPConfig"=dword:00000000 >>C:\WINDOWS\TCPIP禁用.reg
@echo "NC_LanChangeProperties"=dword:00000000 >>C:\WINDOWS\TCPIP禁用.reg
@echo "NC_EnableAdminProhibits"=dword:00000001 >>C:\WINDOWS\TCPIP禁用.reg
regedit -s C:\WINDOWS\TCPIP禁用.reg
rundll32 user32.dll,UpdatePerUserSystemParameters
pause&exit

::禁用TCP/IP
:tcpqy
@echo Windows Registry Editor Version 5.00 >>C:\WINDOWS\TCPIP启用.reg
@echo [HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Network Connections] >>C:\WINDOWS\TCPIP启用.reg
@echo "NC_AllowAdvancedTCPIPConfig"=dword:00000000 >>C:\WINDOWS\TCPIP启用.reg
@echo "NC_LanChangeProperties"=dword:00000001 >>C:\WINDOWS\TCPIP启用.reg
@echo "NC_EnableAdminProhibits"=dword:00000000 >>C:\WINDOWS\TCPIP启用.reg
regedit -s C:\WINDOWS\TCPIP启用.reg
rundll32 user32.dll,UpdatePerUserSystemParameters
pause&exit

::贵视监控
:gsjk
explorer "http://192.168.241.220"
explorer "http://192.168.241.221"
explorer "http://192.168.156.249"
pause&exit

::hostshop22andtcp/ip netbios
:hostshop22andtcp/ip netbios
echo 192.168.255.17	lnd.jiayougo.com >>C:\WINDOWS\system32\drivers\etc\hosts
echo 192.168.255.198	newlnd.jiayougo.com >>C:\WINDOWS\system32\drivers\etc\hosts
sc config LmHosts start= auto
sc start LmHosts
cmd /c netsh interface ip set dns name="本地连接" source=static addr=192.168.255.1
cmd /c netsh interface ip add dns name="本地连接" addr=192.168.255.2
cd c:\
md Shop22
cd c:\Documents and Settings\All Users\桌面
md shop22-Z
xcopy /s /y G:\Shop22 c:\Shop22
start G:\win32_11gR1_client\client\setup.exe
pause&exit

::hostshop22andtcp/ip netbios
:ceshi
cd c:\
md Shop22
cd c:\Documents and Settings\All Users\桌面
md shop22-Z
xcopy /s /y G:\Shop22 c:\Shop22
xcopy /e /y G:\Shop22\桌面-SHOP22 C:\Documents and Settings\All Users\桌面 
start G:\win32_11gR1_client\client\setup.exe
pause>nul

 
pause&exit

::重启计算机
:restart
shutdown -r
rundll32 user32.dll,UpdatePerUserSystemParameters
pause&exit

::ip地址更新
:1
echo.
cls
Echo *******************************************************************************
Echo           正在修改IP地址和DNS服务器地址,请耐心等待…………
Echo *******************************************************************************
cmd /c netsh interface ip set address name="本地连接" source=static addr=192.168.251.1 mask=255.255.255.0 gateway=192.168.251.254 gwmetric=1
cmd /c netsh interface ip set dns name="本地连接" source=static addr=192.168.255.1
cmd /c netsh interface ip add dns name="本地连接" addr=192.168.255.2
ipconfig /renew
ipconfig /all
Echo *******************************************************************************
Echo          OK!! "本地连接" 设置已成功刷新!
Echo          OK!! 已修改成功! 请按任意键返回…………          
Echo *******************************************************************************
pause >nul
goto :start


#配置服务的启动方式：auto自动、demand手动、disabled禁用。
#sc config themes start= auto
#启动服务
#sc start themes
#注意！等号后面要有一个空格！ 





