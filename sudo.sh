#!/bin/bash
PASSWD="Linux#2020!!"
user=operation
echo "######################"
echo "add user and password"
echo "######################"
id $user &>/dev/null
if [ $? -eq 0 ];then
   echo "This user is already exist"
else
    useradd $user
    echo "$PASSWD"|passwd --stdin $user &>/dev/null
    if [ $? -eq 0 ];then
       echo "$user , Create success"
    else
       echo "$user , Create failure"
    fi
fi
echo "######################"
echo "add sudo privilege"
echo "######################"
os=`rpm -q centos-release|cut -d- -f3`
if [ $os -eq 6 ];then
    cd /etc/
    /bin/cp sudoers sudoers.bak
    echo "User_Alias USERALIAS=operation" >> /etc/sudoers
	echo "USERALIAS ALL=(ALL) NOPASSWD: ALL,CMDALIAS" >> /etc/sudoers
    echo 'Cmnd_Alias CMDALIAS=!/bin/vi *sudoer*,!/usr/bin/vim *sudoer*,!/usr/sbin/visudo,!/usr/bin/vim *sudoer*,!/usr/bin/passwd root,!/bin/rm -fr /,!/bin/rm -fr /*,!/bin/su' >> /etc/sudoers

else

   cd /etc/
   /bin/cp sudoers sudoers.bak
    echo "User_Alias USERALIAS=operation" >> /etc/sudoers
	echo "USERALIAS ALL=(ALL) NOPASSWD: ALL,CMDALIAS" >> /etc/sudoers
    echo 'Cmnd_Alias CMDALIAS=!/usr/bin/vi *sudoer*,!/usr/bin/vi *sudoer*,!/usr/sbin/visudo,!/usr/bin/vim *sudoer*,!/usr/bin/passwd root,!/bin/rm -rf /,!/bin/rm -rf /*,!/usr/bin/su' >> /etc/sudoers
fi
echo "congfig Sudoers is done"
