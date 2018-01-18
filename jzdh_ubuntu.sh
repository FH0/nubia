#!/bin/bash
apt-get update
apt-get install wget unzip nginx vsftpd sysv-rc-conf -y
mkdir /root/.ssh
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+W9dthEI7Z113Sd9Vr3ZMhSSRIr80wX05OV/T8oVWIILAPT7COvaU4KTCx+j4heQunzlvQ1egvmP4WPRU1fJDI00LBdzdUyKrX/Uo/NebHyr1Snz8aDFq/6+uyl4a/xnE/nRCvnSUsATuKDOAlOlII9voCmo20Fi8HNPUl0vUbXpbison3Tjinn7Qc+J2+Sh49lmDT3tjDrRc+PdAVLfAMynw9HgIareZvdfrekZ3HDy2MS10I5SlkmIkevL12pek3BrOxLITwQ5T0COTvrlEqmzGVqocUP7sKFQM5wZ70r0h7DhyCb2/1uKXyee+lgWcFr9VOna3HPVFGq/vChId u0_a86@localhost' > /root/.ssh/authorized_keys
chmod 700 /root/.ssh/authorized_keys

#set nginx
mkdir /accept
echo 'worker_processes  1;
events {
    worker_connections  1024;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
        server {
        listen       8082;        
        server_name  localhost;   
        root    /accept;  
        autoindex on;             
        autoindex_exact_size off;
        }
}' > /etc/nginx/nginx.conf

#set vsftpd
mkdir /home/f
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
chroot_local_user=yes
local_root=/home/f' > /etc/vsftpd.conf
ln -s /home/f/ /accept/
chmod -R 777 /accept
chmod -R 777 /home
useradd f
passwd f << EOF
zxc
zxc
EOF
usermod -s /sbin/nologin f
usermod -d /mnt f
service vsftpd start

#set ssr
wget https://raw.githubusercontent.com/FH0/nubia/master/ssrmu.zip
unzip ssrmu.zip
bash ssrmu_80.sh
bash ssrmu_8080.sh
bash ssrmu_53.sh
bash gost.sh
cat ssrmu.sh > /bin/doub
chmod +x /bin/doub
rm -rf ssrmu*
rm -f gost.sh

#start when boot
echo '#!/bin/bash
/etc/init.d/nginx
service vsftpd start
nohup /usr/local/gost/gostproxy -C /usr/local/gost/gost.json >/dev/null 2>&1 &' > /etc/init.d/jzdh
chmod 755 /etc/init.d/jzdh
chmod +x /etc/init.d/jzdh
sysv-rc-conf jzdh on
