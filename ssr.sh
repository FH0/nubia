#set shadowsocksR
yum install wget -y
nohup command & wget https://raw.githubusercontent.com/FH0/nubia/master/ssr.zip && unzip ssr.zip && cd SSR* && bash install.sh
nohup command & cd /usr/local/shadowsocksr
nohup command & python mujson_mgr.py -a -u 1 -p 80 -k 239 -m chacha20 -O auth_sha1_v4 -o http_simple -t 700
nohup command & python mujson_mgr.py -a -u 2 -p 8080 -k 239 -m chacha20 -O auth_sha1_v4 -o http_simple -t 70
nohup command & python mujson_mgr.py -a -u 3 -p 53 -k 239 -m chacha20 -O auth_sha1_v4 -o http_simple -t 70
nohup command & bash /usr/local/shadowsocksr/logrun.sh
