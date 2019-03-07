#!/bin/bash


DIR="/usr/local/src"
IP="ip a | grep em1 | grep inet | awk '{print $2}' |sed 's/\/.*//'"

yum install -y lrzsz wget
rm -rf /etc/yum.repos.d/*
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
yum clean all && yum groupinstall -y "Development tools" "Server Platform Development" && yum install -y openssl-devel perl perl-Net-Telnet perl-Net-DNS perl-LDAP perl-libwww-perl perl-IO-Socket-SSL perl-Socket6 perl-Time-HiRes perl-ExtUtils-MakeMaker rrdtool rrdtool-perl curl httpd httpd-devel gcc make wget libxml2-devel libpng-devel glib pango pango-devel freetype freetype-devel fontconfig cairo cairo-devel libart_lgpl libart_lgpl-devel popt popt-devel libidn libidn-devel fping wqy-zenhei-fonts.noarch
yum groupinstall -y "Chinese Support"
echo "LANG="zh_CN.UTF-8""  > /etc/sysconfig/i18n
LANG="zh_CN.UTF-8"
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
setenforce 0
/etc/init.d/iptables stop
/etc/init.d/ip6tables stop
chkconfig iptables off
chkconfig ip6tables off
cd ${DIR}
wget https://oss.oetiker.ch/smokeping/pub/smokeping-2.6.9.tar.gz
wget http://120.52.51.19/deb.debian.org/debian/pool/main/e/echoping/echoping_6.0.2.orig.tar.gz
tar xf echoping_6.0.2.orig.tar.gz
tar xf smokeping-2.6.9.tar.gz
cd ${DIR}/echoping-6.0.2
./configure && make && make install
cd ${DIR}/smokeping-2.6.9
./setup/build-perl-modules.sh /usr/local/smokeping/thirdparty && ./configure --prefix=/usr/local/smokeping && /usr/bin/gmake install
mkdir /usr/local/smokeping/{cache,data,var}
touch /var/log/smokeping.log
chown apache:apache /var/log/smokeping.log
chown apache:apache /usr/local/smokeping/{cache,data,var}
chmod 600 /usr/local/smokeping/etc/smokeping_secrets.dist
mv /usr/local/smokeping/htdocs/smokeping.fcgi.dist /usr/local/smokeping/htdocs/smokeping.fcgi
\cp -a ${DIR}/config /usr/local/smokeping/etc/config
\cp -a ${DIR}/Graphs.pm /usr/local/smokeping/lib/Smokeping/Graphs.pm
sed -i ‘s@cgiurl = http://127.0.0.1/smokeping.cgi@cgiurl = http://${IP}/smokeping.cgi@g’ /usr/local/smokeping/etc/config
mv httpd-smokping.conf /etc/httpd/conf.d/
sed -i 's#ServerAdmin root@localhost#ServerAdmin smokeping@jiayougo.com#g' /etc/httpd/conf/httpd.conf
sed -i 's#Listen 80#Listen 9999#g' /etc/httpd/conf/httpd.conf
sed -i 's@#ServerName www.example.com:80@ServerName ${IP}:80@g' /etc/httpd/conf/httpd.conf
/etc/init.d/httpd start
/usr/local/smokeping/bin/smokeping
#echo 'export PATH=/usr/local/smokeping/bin/:$PATH' >> /etc/profile.d/smokeping.sh
#. /etc/profile.d/smokeping.sh
#chkconfig httpd on
#echo "/usr/local/smokeping/bin/smokeping --logfile=/var/log/smokeping.log 2>&1 &" >> /etc/rc.local
