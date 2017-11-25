apt update -y
pkg install wget unzip -y
/data/data/com.termux/files/usr/bin/wget https://raw.githubusercontent.com/FH0/nubia/master/sussr.zip
su

cd
cp /data/data/com.termux/files/home/sussr.zip /data/data
cd /data/data
unzip sussr.zip
chmod 0777 sussr
cd sussr/
sh start.sh
echo ssr='su

sh /data/data/com.wg.ssr/files/sussr/start.sh' >> /data/data/com.termux/files/usr/etc/profile
