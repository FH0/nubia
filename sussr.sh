pkg install unzip -y
/data/data/com.termux/files/usr/bin/wget https://raw.githubusercontent.com/FH0/nubia/master/sussr.zip
cp /data/data/com.termux/files/home/sussr.zip /data/data
cd /data/data
unzip sussr.zip
cd sussr/
chmod 777 *
sh /data/data/sussr/start.sh
echo 'alias ssr="sh /data/data/com.wg.ssr/files/sussr/start.sh"' >> /data/data/com.termux/files/usr/etc/profile
