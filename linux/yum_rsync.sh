#!/bin/bash

# base value

# 要同步的源
#YUM_SITE="rsync://mirror.centos.org/"
#YUM_SITE="rsync://mirrors.kernel.org/"
YUM_SITE="rsync://rsync.mirrors.ustc.edu.cn/"
# 本地存放目录
LOCAL_PATH="/data/nginx/"

# 需要同步的版本，我只需要5和6版本还有7的,总共在120G左右
#echo "rsync源为：ustc.edu.cn"
LOCAL_VER="centos/6/centosplus/x86_64/ centos/6/cloud/x86_64/ centos/6/contrib/x86_64/ centos/6/cr/x86_64/ centos/6/extras/x86_64/ centos/6/fasttrack/x86_64/ centos/6/isos/ centos/6/os/x86_64/ centos/6/sclo/x86_64/ centos/6/storage/x86_64/ centos/6/updates/x86_64/ centos/6/virt/x86_64/ centos/7/ centos/build/ epel/6/SRPMS/ epel/6/x86_64/ epel/6Server/SRPMS/ epel/6Server/x86_64/ epel/7/SRPMS/ epel/7/x86_64/ epel/7Server/SRPMS/ epel/7Server/x86_64/ epel/testing/6/SRPMS/ epel/testing/6/x86_64/ epel/testing/7/SRPMS/ epel/testing/7/x86_64/"
#LOCAL_VER_RPM="centos/RPM-GPG-KEY-CentOS-6 centos/RPM-GPG-KEY-CentOS-7 centos/RPM-GPG-KEY-CentOS-Debug-6 centos/RPM-GPG-KEY-CentOS-Debug-7 centos/RPM-GPG-KEY-CentOS-Security-6 centos/RPM-GPG-KEY-CentOS-Testing-6 centos/RPM-GPG-KEY-CentOS-Testing-7 centos/RPM-GPG-KEY-beta epel/RPM-GPG-KEY-EPEL-6 epel/RPM-GPG-KEY-EPEL-7 epel/RPM-GPG-KEY-EPEL-6Server epel/RPM-GPG-KEY-EPEL-7Server epel/epel-release-latest-6.noarch.rpm epel/epel-release-latest-7.noarch.rpm"
#echo "rsync源为：kernel.org"
#LOCAL_VER="centos/6/centosplus/x86_64/ centos/6/cloud/x86_64/ centos/6/contrib/x86_64/ centos/6/cr/x86_64/ centos/6/extras/x86_64/ centos/6/fasttrack/x86_64/ centos/6/isos/ centos/6/os/x86_64/ centos/6/sclo/x86_64/ centos/6/storage/x86_64/ centos/6/updates/x86_64/ centos/6/virt/x86_64/ centos/7/ centos/build/ fedora-epel/6/SRPMS/ fedora-epel/6/x86_64/ fedora-epel/6Server/SRPMS/ fedora-epel/6Server/x86_64/ fedora-epel/7/SRPMS/ fedora-epel/7/x86_64/ fedora-epel/7Server/SRPMS/ fedora-epel/7Server/x86_64/ fedora-epel/testing/6/SRPMS/ fedora-epel/testing/6/x86_64/ fedora-epel/testing/7/SRPMS/ fedora-epel/testing/7/x86_64/"
#LOCAL_VER_RPM="centos/RPM-GPG-KEY-CentOS-6 centos/RPM-GPG-KEY-CentOS-7 centos/RPM-GPG-KEY-CentOS-Debug-6 centos/RPM-GPG-KEY-CentOS-Debug-7 centos/RPM-GPG-KEY-CentOS-Security-6 centos/RPM-GPG-KEY-CentOS-Testing-6 centos/RPM-GPG-KEY-CentOS-Testing-7 centos/RPM-GPG-KEY-beta fedora-epel/RPM-GPG-KEY-EPEL-6 fedora-epel/RPM-GPG-KEY-EPEL-7 fedora-epel/RPM-GPG-KEY-EPEL-6Server fedora-epel/RPM-GPG-KEY-EPEL-7Server fedora-epel/epel-release-latest-6.noarch.rpm fedora-epel/epel-release-latest-7.noarch.rpm"

# 同步时要限制的带宽
BW_limit=16384

# 记录本脚本进程号
LOCK_FILE="/var/log/yum_server.pid"

# 同步日志文件
LogFile=/var/log/rsync/yum_`date +"%Y-%m-%d"`.log

# 如用系统默认rsync工具为空即可。
# 如用自己安装的rsync工具直接填写完整路径
RSYNC_PATH=""
 
# check update yum server  pid
MY_PID=$$
if [ -f $LOCK_FILE ]; then
	get_pid=`/bin/cat $LOCK_FILE`
	get_system_pid=`/bin/ps -ef|grep -v grep|grep $get_pid|wc -l`
	if [ $get_system_pid -eq 0 ] ; then
		echo $MY_PID>$LOCK_FILE
	else
		echo "Have update yum server now!"
        exit 38
	fi
else
	echo $MY_PID>$LOCK_FILE
fi
 
# check rsync tool
if [ -z $RSYNC_PATH ]; then
	RSYNC_PATH=`/usr/bin/whereis rsync|awk ' ''{print $2}'`
	if [ -z $RSYNC_PATH ]; then
		echo 'Not find rsync tool.'
        	echo 'use comm: yum install -y rsync'
    	fi
fi
 
# sync yum source
echo "rsync start at $(date +"%Y-%m-%d %H:%M:%S")" >$LogFile
echo "--------------------------------------------------" >>$LogFile
for VER in $LOCAL_VER;do
	# Check whether there are local directory
	if [ ! -d "$LOCAL_PATH$VER" ] ; then
	        echo "Create dir $LOCAL_PATH$VER"
        	`/bin/mkdir -p $LOCAL_PATH$VER`
	fi
    	# sync yum source
	echo "Start sync $LOCAL_PATH$VER"  >>$LogFile
	echo "--------------------------------------------------" >>$LogFile
	$RSYNC_PATH -avrtH --delete --bwlimit=$BW_limit  $YUM_SITE$VER $LOCAL_PATH$VER  >>$LogFile
done

for VER_RPM in $LOCAL_VER_RPM;do
        # sync yum source rpm
	echo "Start sync $LOCAL_PATH$VER_RPM"  >>$LogFile
	echo "--------------------------------------------------" >>$LogFile
	$RSYNC_PATH -avrtH --delete --bwlimit=$BW_limit  $YUM_SITE$VER_RPM $LOCAL_PATH$VER_RPM  >>$LogFile
done

echo "rsync end at $(date +"%Y-%m-%d %H:%M:%S")" >>$LogFile
echo "--------------------------------------------------" >>$LogFile

# clean lock file
`/bin/rm -rf $LOCK_FILE`

##同步数据192.168.212.252:/data/
rsync -avrth --delete /data/nginx/ 192.168.212.252:/data/nginx/
rsync -avr /data/backup/ 192.168.212.252:/data/backup/
rsync -avrth --delete /data/scripts/ 192.168.212.252:/data/scripts/
rsync -avrth --delete /data/share/ 192.168.212.252:/data/share/
rsync -avrth --delete /data/course/ 192.168.212.252:/data/course/
chmod -R 755 /data/nginx/public
chown root:root /data/nginx/public -R
find / -name "nohup.out" | xargs rm
 
echo 'sync end.time is $(date)'
exit 81
