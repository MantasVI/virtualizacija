#!/bin/bash

cd /home/mavi1016/.ansible/webstack/app

#----------------------------
cat > index.php <<"PHP"
<?php
phpinfo();
?>
PHP

#---------------------------------------

cd /home/mavi1016/.ansible/webstack

cat > nginx.Dockerfile <<"DOC"
FROM ubuntu:24.04

RUN apt update && apt install -y nginx

RUN rm -rf /etc/nginx/sites-enabled/default

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY app/ /var/www/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
DOC

cat > php.Dockerfile <<"EOF"
FROM ubuntu:24.04

RUN apt update && apt install -y \
    php-fpm \
    php-mysql \
    php-cli \
    php-common

WORKDIR /var/www/html

RUN sed -i 's|listen = /run/php/php8.3-fpm.sock|listen = 9000|' /etc/php/8.3/fpm/pool.d/www.conf
RUN echo "clear_env = no" >> /etc/php/8.3/fpm/pool.d/www.conf

EXPOSE 9000

CMD ["/usr/sbin/php-fpm8.3", "-F"]
EOF

#--------------------------------------------


cat > nginx.conf <<"conf"
server {
    listen 80;
    server_name _;

    root /var/www/html;
    index index.php index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        fastcgi_pass app:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME /var/www/html$fastcgi_script_name;
    }
}
conf

cat > docker-compose.yml <<"comp"
version: "3.9"

services:
  app:
    build:
      context: .
      dockerfile: php.Dockerfile
    container_name: hospital_php
    volumes:
      - ./app:/var/www/html
    restart: always

  web:
    build:
      context: .
      dockerfile: nginx.Dockerfile
    container_name: hospital_nginx
    ports:
      - "80:80"
    depends_on:
      - app
    volumes:
      - ./app:/var/www/html
    restart: always
comp

#cd /home/mavi1016/.ansible/dbstack

#cat > docker-compose.yml <<"EOF"

#version: "3.9"

#services:
#  mariadb:
#    image: mariadb:10.11
#    container_name: hospital_db
#    environment:
#      MYSQL_ROOT_PASSWORD: rootpassword
#      MYSQL_DATABASE: hospital
#      MYSQL_USER: hospital_user
#      MYSQL_PASSWORD: hospital_pass
#    ports:
#      - "3306:3306"
#    volumes:
#      - db_data:/var/lib/mysql
#    restart: always
#
#volumes:
#  db_data:
#
#
#EOF
