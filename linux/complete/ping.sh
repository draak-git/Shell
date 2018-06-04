#!/bin/bash

read -p "输入网段：" NETWORK
for I in {1..254};do
	if ping -c 1 -W 1 $NETWORK.$I &> /dev/null;then
		echo -e "\033[32m$NETWORK.$I\033[0m is up."
	else
		echo -e "\033[31m$NETWORK.$I\033[0m is down."
	fi
done
