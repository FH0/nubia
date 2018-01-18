#!/bin/bash
apt-get update
apt-get install wget unzip nginx vsftpd sysv-rc-conf -y
mkdir /root/.ssh
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+W9dthEI7Z113Sd9Vr3ZMhSSRIr80wX05OV/T8oVWIILAPT7COvaU4KTCx+j4heQunzlvQ1egvmP4WPRU1fJDI00LBdzdUyKrX/Uo/NebHyr1Snz8aDFq/6+uyl4a/xnE/nRCvnSUsATuKDOAlOlII9voCmo20Fi8HNPUl0vUbXpbison3Tjinn7Qc+J2+Sh49lmDT3tjDrRc+PdAVLfAMynw9HgIareZvdfrekZ3HDy2MS10I5SlkmIkevL12pek3BrOxLITwQ5T0COTvrlEqmzGVqocUP7sKFQM5wZ70r0h7DhyCb2/1uKXyee+lgWcFr9VOna3HPVFGq/vChId u0_a86@localhost' > /root/.ssh/authorized_keys
chmod 700 /root/.ssh/authorized_keys

#set nginx
mkdir /accept
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
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
cp /etc/vsftpd.conf /etc/vsftpd.conf.bak
echo 'listen=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
chroot_local_user=YES
chroot_local_user=YES
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd.chroot_list
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key' > /etc/vsftpd.conf
echo f > /etc/vsftpd.chroot_list
useradd -d /home/f -s /sbin/nologin f
passwd f << EOF
zxc
zxc
EOF
chown -R f.f /home/f
sed -i '/nologin/d' /etc/shells
echo /sbin/nologin >> /etc/shells
ln -s /home/f/ /accept/
chmod -R 777 /accept
chmod -R 777 /home
service vsftpd restart

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
