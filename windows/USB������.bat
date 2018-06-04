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
 echo                                ◆ 禁止/启用USB设备◆
 echo.
 echo                          ==============================
 echo                          请选择要进行的操作，然后按回车
 echo                          ==============================
 echo.
 echo                                  1.禁用USB设备
 echo.
 echo                                  2.启用USB设备
 echo.
 echo                                  3.退出
 echo.
 echo.
 echo                                                               
 echo                                                              
 :chousb
 set choice=
 set /p choice=          请选择:
 IF NOT "%choice%"=="" SET choice=%choice:~0,1%
 if /i "%choice%"=="1" goto lockusb
 if /i "%choice%"=="2" goto unlockusb
 if /i "%choice%"=="3" goto menu
 echo 选择无效,请重新输入!
 :lockusb
 @reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\usbstor" /v Start /t reg_dword /d 4 /f
 echo USB设备禁用成功!!!所有在禁用后插入的USB设备将无法使用!!!
 pause >nul
 goto stopusb
 :unlockusb
 @reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\usbstor" /v Start /t reg_dword /d 3 /f
 echo USB设备启用成功!!!一切USB设备将可以使用,请重新插入....
 pause >nul
 goto stopusb