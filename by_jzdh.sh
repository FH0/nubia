#linux first setting
wget https://raw.githubusercontent.com/FH0/nubia/master/first_set.sh
bash first_set.sh

#set nginx
wget https://raw.githubusercontent.com/FH0/nubia/master/nginx.sh;bash nginx.sh

#set vsftpd
yum install -y vsftpd
echo 'anonymous_enable=YES
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
listen=YES

pam_service_name=vsftpd
tcp_wrappers=YES
chroot_local_user=yes' > /etc/vsftpd/vsftpd.conf
service vsftpd restart
ln -s /home/f/ /accept/
chmod -R 777 /accept
chmod -R 777 /home
adduser f
passwd f << EOF
zxc
zxc

EOF
usermod -s /sbin/nologin ftpuser
usermod -d /mnt ftpuser

#set ssr
wget https://raw.githubusercontent.com/FH0/nubia/master/ssr.sh
bash ssr.sh
wget https://raw.githubusercontent.com/FH0/nubia/master/cxll.sh
bash cxll.sh
