#!/bin/bash

mkdir -p /home/mavi1016/.ansible/dbstack
cd /home/mavi1016/.ansible/dbstack

cat > Dockerfile <<"DOC"
# dbstack/Dockerfile – MariaDB for HOSPITAL
FROM mariadb:10.11
COPY my.cnf /etc/mysql/my.cnf
COPY init.sql /docker-entrypoint-initdb.d/
EXPOSE 3306
# Default ENTRYPOINT from image starts mysqld
DOC

cat > my.cnf <<"DAT"
[mysqld]
user=mysql
bind-address=0.0.0.0
skip-name-resolve
port=3306
socket=/run/mysqld/mysqld.sock
datadir=/var/lib/mysql
skip-networking=0
DAT

cat > init.sql <<"SQL"
-- HOSPITAL DATABASE + USERS/DOCTORS TABLES

CREATE DATABASE IF NOT EXISTS hospital;

-- main db user used by PHP in containers
CREATE USER IF NOT EXISTS 'hospital_user'@'%' IDENTIFIED BY 'hospital_pass';
GRANT ALL PRIVILEGES ON hospital.* TO 'hospital_user'@'%';

-- optional host-specific user (if they ever use hostname instead of IP)
CREATE USER IF NOT EXISTS 'hospital_user'@'arnas-webserver-vm-arba1037.cloud' IDENTIFIED BY 'hospital_pass';
GRANT ALL PRIVILEGES ON hospital.* TO 'hospital_user'@'arnas-webserver-vm-arba1037.cloud';

FLUSH PRIVILEGES;

USE hospital;

-- USERS table (for normal users)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- DOCTORS table
CREATE TABLE IF NOT EXISTS doctors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);
SQL

cat > docker-compose.yml <<"COM"
version: "3.9"
services:
  mariadb:
    build: .
    container_name: hospital_db
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: hospital
      MYSQL_USER: hospital_user
      MYSQL_PASSWORD: hospital_pass
    ports:
      - "3306:3306"
    volumes:
      - db_data:/var/lib/mysql
volumes:
  db_data:
COM

COM
--- FORCE INIT.SQL TO RUN EVERY TIME ---
docker compose down -v || true
docker compose up -d
