#!/bin/bash
file=`find / -type f -name "sshd_config"`
dir=`dirname $file`
sshfile=/etc/ssh/sshd_config
[ -f sshfile ]
cp $sshfile $sshfile-`date +%F`.bak
yy=`cat $sshfile |grep PermitRootLogin|awk 'NR==1{print}'|awk -F " " '{print $2}'`
if [ $yy == 'no' ]
  then
    sed -i s#"$yy"#"yes"#g $sshfile
    echo "UseDNS no" >> $sshfile
    echo "GSSAPIAuthentication no" >> $sshfile
    /etc/init.d/sshd restart
else 
    echo "UseDNS no" >> $sshfile
    echo "GSSAPIAuthentication no" >> $sshfile
    /etc/init.d/sshd restart
fi
