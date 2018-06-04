#!/bin/bash
#echo "添加用户，可接受参数--add --del -v|--verbose -h|--help,并做出相应选择；"

DEBUG=0
ADD=0
DEL=0

for I in `seq 0 $#`;do
	if [ $# -gt 0 ];then
		case $1 in
			-v|--verbose)
				DEBUG=1
				shift
				;;
#			-h|--help)
#				echo "Usage: `basename $0` --add USER_LIST --del USER_LIST -v|--verbose -h|--help"
#				;;
			--list)
				grep "/bin/bash" /etc/passwd
				;;
			--add)
				ADD=1
				ADDUSER=$2
				shift 2
				;;
			--del)
				DEL=1
				DELUSER=$2
				shift 2
				;;
			*)
				echo "Usage: `basename $0` --add USER_LIST --del USER_LIST -v|--verbose -h|--help"
				exit 4
				;;
		esac
	fi
done

if [ $ADD -eq 1 ];then
	for USERS in `echo $ADDUSER | sed 's/,/ /g'`;do
		if id $USERS &> /dev/null;then
			[ $DEBUG -eq 1 ] && echo "$USERS已经存在"
		else
			useradd $USERS &> /dev/null
			echo $USERS | passwd --stdin $USERS &> /dev/null
			[ $DEBUG -eq 1 ] && echo “$USERS添加成功”
		fi
	done
fi

if [ $DEL -eq 1 ];then
	for USERS in `echo $DELUSER | sed 's/,/ /g'`;do
		if id $USERS &> /dev/null;then
			userdel -r $USERS
			[ $DEBUG -eq 1 ] && echo "$USERS删除成功"
		else
			[ $DEBUG -eq 1 ] && echo "$USERS没有这个用户"
		fi
	done
fi
