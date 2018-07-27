#!/bin/bash
#This script used for create lvm for servers
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#Filename:parted.sh                     
#Description:parted for disk to chengdu
#Author:xiejun    
#Email:1544709094@qq.com
#Revision:1.0
#Date:2018-6-28
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
mkdir /etc/yum.repos.d/backup
mv /etc/yum.repos.d/Cen* /etc/yum.repos.d/backup
wget http://10.123.14.31/yum-to-chengdu.sh && sh yum-to-chengdu.sh && rm -f yum-to-chengdu.sh
yum clean all
yum makecache
yum install xfsprogs 
###yum install xfsprogs kmod-xfs xfsdump xfsprogs-devel
modprobe xfs
###格式化磁盘为MBR
parted -s /dev/sdb mklabel msdos

pvcreate /dev/sdb
vgcreate vg1 /dev/sdb

for i in {a,c,d,e,f,g,h,i,j,k,l}           ####排除系统那个磁盘###
        do 
                fdisk -l |grep /dev/sd$i
                if [ $? == 0 ]
                then
                        parted -s /dev/sd$i mklabel msdos
                        pvcreate /dev/sd$i
                        vgextend vg1 /dev/sd$i
                fi
done

vgreduce --removemissing vg1

TYPE=`vgdisplay vg1|grep 'VG Size' |awk '{print $4}'`
if [ $TYPE = TiB ]
then
        SIZE=`vgdisplay vg1|grep 'VG Size' |awk '{print $3}' |awk -F "." '{print $1}'`T
else
        SIZE=`vgdisplay vg1|grep 'VG Size' |awk '{print $3}' |awk -F "." '{print $1}'`G
fi

lvcreate -L $SIZE -n lvmdisk1 vg1
mkfs.xfs /dev/mapper/vg1-lvmdisk1
rm -f /data && mkdir /data
mount /dev/mapper/vg1-lvmdisk1 /data

cat /etc/fstab |grep vg1
if [ $? = 1 ]
then
        echo "/dev/mapper/vg1-lvmdisk1 /data                       xfs    defaults        0 0" >> /etc/fstab
fi

