#set shadowsocksR
yum install wget nano make tar screen unzip -y
wget https://raw.githubusercontent.com/FH0/nubia/master/ssr.zip && unzip ssr.zip && cd SSR* && bash install.sh
cd /usr/local/shadowsocksr
python mujson_mgr.py -a -u 1 -p 80 -k 239 -m chacha20 -O auth_sha1_v4 -o http_simple -t 700
python mujson_mgr.py -a -u 2 -p 8080 -k 239 -m chacha20 -O auth_sha1_v4 -o http_simple -t 70
python mujson_mgr.py -a -u 3 -p 53 -k 239 -m chacha20 -O auth_sha1_v4 -o http_simple -t 70
bash /usr/local/shadowsocksr/logrun.sh
echo 'alias cx="python /usr/local/SSR-Bash-Python/show_flow.py"' >> /etc/profile
