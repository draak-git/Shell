#!/bin/bash
FILE=/root/arp/oa_login.txt

if [ ! -e $FILE ];then
	echo "No such file"
	exit 2
fi

if [ $# -lt 1 ];then
	echo "请添加一个姓名/IP地址为参数"
	exit 0	
fi

if grep  "\<$1\>" $FILE &> /dev/null;then
	grep "\<$1\>" $FILE
	NAME=`grep "\<$1\>" $FILE | wc -l`
	echo "参数$1一共$NAME条信息"
elif grep  "\<$1" $FILE &> /dev/null;then
        grep "\<$1" $FILE
        NAME=`grep "\<$1" $FILE | wc -l`
        echo "参数$1一共$NAME条信息"
else
	echo "没有相应姓名/IP地址信息"
fi
