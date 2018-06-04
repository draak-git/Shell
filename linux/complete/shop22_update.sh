#!/bin/bash
#

USERS=`whoami`

if [ ! $USERS == jylnd ];then
	echo "请切换jylnd用户操作"
	exit 4
fi

cat << EOF
	u|update 	更新上板文件！
	r|recover	恢复上板文件！
	d|delete	删除更新、备份文件！
EOF

read -p "请输入相应参数：" OPTION

case $OPTION in
u|update)
	read -p "请输入今日上板次数：" NUM

	FILE=$(date +%F)_$NUM
	DIRECTORY=/upload/$(date +%F)_$NUM

	if [ -e /upload/$FILE ];then
		echo "今日已完成第$NUM次上板，请输入其他参数！"
		exit 8
	fi

	mkdir $DIRECTORY

ftp -n<<!
open 192.168.212.5
user ftp ftp
binary
cd /opt/ftp
lcd $DIRECTORY
prompt
mget *
close
bye
!

	FILE_NUM=`ls $DIRECTORY | wc -l` 

	if [ $FILE_NUM -eq 0 ];then
		rm -rf $DIRECTORY
		echo "ftp：192.168.212.5目录中未传本次更新文件！"
		exit 20
	fi

	tar zcf /home/$USERS/shop22_$FILE.tar.gz /home/$USERS/shop22 &> /dev/null

	\cp $DIRECTORY/* /home/$USERS/shop22/
	cd /home/$USERS/shop22
	rm -f ftpsyn.txt
	ls -l --time-style="+%Y-%m-%d %H:%M:%S" |awk '{print $8 "##" $6 " " $7}' |sed '1d' >ftpsyn.txt
	#UP_FILES=`ls -l $DIRECTORY | grep $USERS | wc -l`
	UP_FILE=`ls -l $DIRECTORY | wc -l`
	ls -lrt /home/$USERS/shop22 | tail -$UP_FILE
	echo "上板完成，本次更新文件$FILE_NUM个！"
	;;
	
r|recover)
	read -p "请输入今日上板次数：" NUM
	
	DIRECTORY=/home/$USERS/
	FILE=shop22_$(date +%F)_$NUM

	if [ -e /home/$USERS/$FILE.tar.gz ];then
		rm -rf /home/$USERS/shop22
		cd $DIRECTORY
		tar zxf $FILE.tar.gz
		mv /home/$USERS/home/$USERS/shop22 /home/$USERS/shop22
		rm -rf /home/$USERS/home
		echo "恢复第$NUM次上板文件成功！"
	else
		echo "未找到今日第$NUM次上板备份文件，请输入其他参数！"
		exit 6
	fi
	;;
	
d|delete)
	read -p "请输入删除文件 年：" NUM_YE
	read -p "请输入删除文件 月：" NUM_MON

	if [ ! -e /upload/$NUM_YE-$NUM_MON* ];then
		echo "没有关于$NUM_MON月的更新文件！"
		exit 33
	fi

	rm -rf /upload/$NUM_YE-$NUM_MON*
	echo "删除$NUM_MON月更新文件成功！"
	
	if [ ! -e /home/$USERS/shop22_$NUM_YE-$NUM_MON* ];then
		echo "没有关于$NUM_MON月的备份文件！"
		exit 34
	fi

	echo "删除$NUM_MON月备份文件成功！"
	rm -rf /home/$USERS/shop22_$NUM_YE-$NUM_MON*
	;;

*)
	echo "本脚本可执行{u|update,r|recover,d|delete}参数！"
esac
