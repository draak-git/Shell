#!/bin/bash
# 测试网络丢包率和平均延时，注意变量clr和cdt的赋值，不同版本的mtr对应的字段位置不同
# 脚本在CentOS 6.2 Linux 2.6.32-220.el6.x86_64 mtr v0.75 上测试通过
urllist="
114.114.114.114
223.5.5.5
202.106.0.20
"
urlarr=($urllist)
date

for ((i=0; i<${#urlarr[@]}; i++))
do
echo -n ${urlarr[$i]}',,'
done
echo
for ((j=0; i< 10000; j++))
do
for ((i=0; i<${#urlarr[@]}; i++))
do
mtr -r -n ${urlarr[$i]} | sed's/%//g'| awk'BEGIN{
lossrate=0;
delaytime=0;
}{
if(NR!=1 && $1!="???"){
clr=$3;
cdt=$6;
(clr<100.0&&lossrate<clr)?(lossrate=clr):true;
delaytime<cdt?(delaytime=cdt):true;
}
}END{
printf("%s,%s,",lossrate,delaytime);
}'
done
echo
done
