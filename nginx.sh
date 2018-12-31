#!/bin/bash

apt-get install nginx -y > /dev/null 2>&1
rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm > /dev/null 2>&1
yum install nginx -y > /dev/null 2>&1

rm -rf /nginx_share > /dev/null 2>&1
mkdir /nginx_share 
chmod 0777 /nginx_share

echo -e 'user  nginx;\nworker_processes  1;\npid        /var/run/nginx.pid;\n \nevents {\n    worker_connections  1024;\n}\n \nhttp {\n    server {\n        listen  8888;\n        server_name  localhost;\n        charset utf-8;\n        root /nginx_share;\n        location / {\n            autoindex on;\n            autoindex_exact_size on;\n            autoindex_localtime on;\n        }\n    }\n}' > /etc/nginx/nginx.conf

systemctl restart nginx.service
systemctl enable nginx.service
