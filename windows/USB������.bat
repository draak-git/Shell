@echo off
 cls
 color 0c
 echo 
@echo off
 :stopusb
 cls
 echo.
 echo.
 echo.
 echo.
 echo.
 echo                                �� ��ֹ/����USB�豸��
 echo.
 echo                          ==============================
 echo                          ��ѡ��Ҫ���еĲ�����Ȼ�󰴻س�
 echo                          ==============================
 echo.
 echo                                  1.����USB�豸
 echo.
 echo                                  2.����USB�豸
 echo.
 echo                                  3.�˳�
 echo.
 echo.
 echo                                                               
 echo                                                              
 :chousb
 set choice=
 set /p choice=          ��ѡ��:
 IF NOT "%choice%"=="" SET choice=%choice:~0,1%
 if /i "%choice%"=="1" goto lockusb
 if /i "%choice%"=="2" goto unlockusb
 if /i "%choice%"=="3" goto menu
 echo ѡ����Ч,����������!
 :lockusb
 @reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\usbstor" /v Start /t reg_dword /d 4 /f
 echo USB�豸���óɹ�!!!�����ڽ��ú�����USB�豸���޷�ʹ��!!!
 pause >nul
 goto stopusb
 :unlockusb
 @reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\usbstor" /v Start /t reg_dword /d 3 /f
 echo USB�豸���óɹ�!!!һ��USB�豸������ʹ��,�����²���....
 pause >nul
 goto stopusb