#set nginx
yum -y install gcc gcc-c++ make libtool zlib zlib-devel openssl openssl-devel pcre pcre-devel
wget http://nginx.org/download/nginx-1.10.1.tar.gz
tar -zxvf nginx-1.10.1.tar.gz
cd nginx-1.10.1
./configure --prefix=/usr/local/webserver/nginx --with-http_stub_status_module --with-http_ssl_module --with-pcre
make && make install
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
}' > /usr/local/webserver/nginx/conf/nginx.conf
/usr/local/webserver/nginx/sbin/nginx
ln -s /home/f/ /accept/
chmod 777 -R /accept
chmod 777 -R /home
