@echo off
color ff
title ��Ϣ����
echo.
echo                     �q�������������������������������������r
echo         �q������������    ��  Ϣ  ��  ��  ר  ��  ��  ��  �������������r
echo         ��          �t�������������������������������������s          ��
echo         ��                                                            ��
echo         ��       ��������Ϊ���Զ�����IP����DNS�Լ���Ӧ�Ĺ�������      ��
echo         ��                                                            ��
echo         ��     ���Ի���WINDOWS XP����ϵͳ,������ú���Ч����������!   ��
echo         ��                                                            ��
echo         �t�������������������������������������������������������������s
echo.
echo   01.���ñ���USB�豸                  -01.�ָ�USB�豸
echo   02.����CMD��������ʾ����            -02.�ָ�CMD��������ʾ����
echo   03.����TCP/IP                       -03.�ָ�TCP/IP
echo   04.���Ӵ���UPS���
echo   05.���ı���host(shop22)������tcp/ip netbios����
echo   06.ceshi
echo   07.���������
echo   08.�˳�
echo.   
echo.
SET /P aa=  ����������ѡ��:
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

::��Ϊ4����
:usbjy
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\USBSTOR" /f /v "Start" /t REG_DWORD /d 4
rundll32 user32.dll,UpdatePerUserSystemParameters
pause&exit

::��Ϊ3����
:usbqy
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\USBSTOR" /f /v "Start" /t REG_DWORD /d 3
rundll32 user32.dll,UpdatePerUserSystemParameters
pause&exit

::����CMD
:cmdjy
@echo Windows Registry Editor Version 5.00 >>C:\WINDOWS\CMD����.reg
@echo [HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\System] >>C:\WINDOWS\CMD����.reg
@echo "DisableCMD"=dword:00000001 >>C:\WINDOWS\CMD����.reg
regedit -s C:\WINDOWS\CMD����.reg
rundll32 user32.dll,UpdatePerUserSystemParameters
pause&exit

::����CMD
:cmdqy
@echo Windows Registry Editor Version 5.00 >>C:\WINDOWS\CMD����.reg
@echo [HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\System] >>C:\WINDOWS\CMD����.reg
@echo "DisableCMD"=dword:00000000 >>C:\WINDOWS\CMD����.reg
regedit -s C:\WINDOWS\CMD����.reg
rundll32 user32.dll,UpdatePerUserSystemParameters
pause&exit

::����TCP/IP
:tcpjy
@echo Windows Registry Editor Version 5.00 >>C:\WINDOWS\TCPIP����.reg
@echo [HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Network Connections] >>C:\WINDOWS\TCPIP����.reg
@echo "NC_AllowAdvancedTCPIPConfig"=dword:00000000 >>C:\WINDOWS\TCPIP����.reg
@echo "NC_LanChangeProperties"=dword:00000000 >>C:\WINDOWS\TCPIP����.reg
@echo "NC_EnableAdminProhibits"=dword:00000001 >>C:\WINDOWS\TCPIP����.reg
regedit -s C:\WINDOWS\TCPIP����.reg
rundll32 user32.dll,UpdatePerUserSystemParameters
pause&exit

::����TCP/IP
:tcpqy
@echo Windows Registry Editor Version 5.00 >>C:\WINDOWS\TCPIP����.reg
@echo [HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Network Connections] >>C:\WINDOWS\TCPIP����.reg
@echo "NC_AllowAdvancedTCPIPConfig"=dword:00000000 >>C:\WINDOWS\TCPIP����.reg
@echo "NC_LanChangeProperties"=dword:00000001 >>C:\WINDOWS\TCPIP����.reg
@echo "NC_EnableAdminProhibits"=dword:00000000 >>C:\WINDOWS\TCPIP����.reg
regedit -s C:\WINDOWS\TCPIP����.reg
rundll32 user32.dll,UpdatePerUserSystemParameters
pause&exit

::���Ӽ��
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
cmd /c netsh interface ip set dns name="��������" source=static addr=192.168.255.1
cmd /c netsh interface ip add dns name="��������" addr=192.168.255.2
cd c:\
md Shop22
cd c:\Documents and Settings\All Users\����
md shop22-Z
xcopy /s /y G:\Shop22 c:\Shop22
start G:\win32_11gR1_client\client\setup.exe
pause&exit

::hostshop22andtcp/ip netbios
:ceshi
cd c:\
md Shop22
cd c:\Documents and Settings\All Users\����
md shop22-Z
xcopy /s /y G:\Shop22 c:\Shop22
xcopy /e /y G:\Shop22\����-SHOP22 C:\Documents and Settings\All Users\���� 
start G:\win32_11gR1_client\client\setup.exe
pause>nul

 
pause&exit

::���������
:restart
shutdown -r
rundll32 user32.dll,UpdatePerUserSystemParameters
pause&exit

::ip��ַ����
:1
echo.
cls
Echo *******************************************************************************
Echo           �����޸�IP��ַ��DNS��������ַ,�����ĵȴ���������
Echo *******************************************************************************
cmd /c netsh interface ip set address name="��������" source=static addr=192.168.251.1 mask=255.255.255.0 gateway=192.168.251.254 gwmetric=1
cmd /c netsh interface ip set dns name="��������" source=static addr=192.168.255.1
cmd /c netsh interface ip add dns name="��������" addr=192.168.255.2
ipconfig /renew
ipconfig /all
Echo *******************************************************************************
Echo          OK!! "��������" �����ѳɹ�ˢ��!
Echo          OK!! ���޸ĳɹ�! �밴��������ء�������          
Echo *******************************************************************************
pause >nul
goto :start


#���÷����������ʽ��auto�Զ���demand�ֶ���disabled���á�
#sc config themes start= auto
#��������
#sc start themes
#ע�⣡�Ⱥź���Ҫ��һ���ո� 





