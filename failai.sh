#!/bin/bash

mkdir -p /home/mavi1016/.ansible/webstack/app
cd /home/mavi1016/.ansible/webstack/app

# PHP TEST FILE
cat > index.php <<"EOF"
<?php
$host = getenv('DB_HOST');
$db = getenv('DB_NAME');
$user = getenv('DB_USER');
$pass = getenv('DB_PASSWORD');

$mysqli = new mysqli($host, $user, $pass, $db);

if ($mysqli->connect_error) {
    die("MySQL connection failed: " . $mysqli->connect_error);
}

echo "<h1>✅ PHP is working</h1>";
echo "<p>Connected to <strong>$db</strong> on <strong>$host</strong> as <strong>$user</strong>.</p>";

$result = $mysqli->query("SHOW TABLES");
if ($result) {
    echo "<h2>📋 Tables in '$db':</h2><ul>";
    while ($row = $result->fetch_array()) {
        echo "<li>{$row[0]}</li>";
    }
    echo "</ul>";
} else {
    echo "<p>No tables or failed to list them.</p>";
}

$mysqli->close();
?>
EOF

cd /home/mavi1016/.ansible/webstack

# NGINX DOCKERFILE
cat > nginx.Dockerfile <<"DOC"
FROM ubuntu:24.04

RUN apt update && apt install -y nginx

RUN rm -rf /etc/nginx/sites-enabled/default

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY app/ /var/www/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
DOC

# PHP DOCKERFILE
cat > php.Dockerfile <<"EOF"
FROM ubuntu:24.04
RUN apt update && apt install -y \
    php-fpm \
    php-mysql \
    php-cli \
    php-common \
    mariadb-client        # added: install MariaDB client for CLI (e.g. mysql command)
WORKDIR /var/www/html
RUN sed -i 's|listen = /run/php/php8.3-fpm.sock|listen = 9000|' /etc/php/8.3/fpm/pool.d/www.conf
RUN echo "clear_env = no" >> /etc/php/8.3/fpm/pool.d/www.conf
EXPOSE 9000
CMD ["/usr/sbin/php-fpm8.3", "-F"]
EOF

# NGINX CONFIG
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

# DOCKER-COMPOSE (no Ansible variables)
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
    environment:
      DB_HOST: "${DB_HOST}"
      DB_PORT: "${DB_PORT}"
      DB_NAME: "${DB_NAME}"
      DB_USER: "${DB_USER}"
      DB_PASSWORD: "${DB_PASSWORD}"
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
