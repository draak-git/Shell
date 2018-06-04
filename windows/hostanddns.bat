cmd /c netsh interface ip set dns name="本地连接" source=static addr=192.168.222.33
cmd /c netsh interface ip add dns name="本地连接" addr=202.106.0.20
ipconfig /renew
ipconfig /all
echo 192.168.255.17	lnd.jiayougo.com >>C:\WINDOWS\system32\drivers\etc\hosts
echo 192.168.255.198	newlnd.jiayougo.com >>C:\WINDOWS\system32\drivers\etc\hosts
echo 192.168.222.20	jyprod.jiayougo.com >>C:\WINDOWS\system32\drivers\etc\hosts
