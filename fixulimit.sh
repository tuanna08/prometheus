#!/bin/bash

timedatectl set-timezone Asia/Ho_Chi_Minh
echo "DefaultLimitNOFILE=999999" >> /etc/systemd/user.conf

echo "DefaultLimitNOFILE=999999" >> /etc/systemd/system.conf 
echo  "fs.file-max = 999999" >> /etc/sysctl.conf
sudo sysctl -p

# /etc/security/limits.conf
echo "*         hard    nofile	999999" >> /etc/security/limits.conf
echo "*         soft    nofile	999999" >> /etc/security/limits.conf
#echo "*         hard    nproc   999999" >> /etc/security/limits.conf
#echo "*         soft    nproc	999999" >> /etc/security/limits.conf
echo "root	soft	nofile  999999" >> /etc/security/limits.conf
echo "root	hard	nofile	999999" >> /etc/security/limits.conf

echo "session required pam_limits.so">> /etc/pam.d/common-session

reboot
