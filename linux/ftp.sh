#!/bin/bash
ftp -n<<!
open 192.168.212.5
user ftp ftp
binary
cd /opt/ftp
lcd /home/
prompt
mget *
close
bye
!
