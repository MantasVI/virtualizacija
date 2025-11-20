#!/bin/bash

mkdir -p /home/mavi1016/.ansible/dbstack
cd /home/mavi1016/.ansible/dbstack

cat > Dockerfile <<"DOC"
# dbstack/Dockerfile – use official MariaDB image
FROM mariadb:10.11  # changed: official image will run init scripts automatically:contentReference[oaicite:2]{index=2}
COPY my.cnf /etc/mysql/my.cnf
COPY init.sql /docker-entrypoint-initdb.d/
EXPOSE 3306
# (No CMD needed; default ENTRYPOINT starts mysqld)
DOC

cat > my.cnf <<"DAT"
[mysqld]
user=mysql
bind-address=0.0.0.0       # allow remote connections (not just localhost):contentReference[oaicite:3]{index=3}
skip-name-resolve          # added: prevent DNS reverse-lookup of client host
port=3306
socket=/run/mysqld/mysqld.sock
datadir=/var/lib/mysql
skip-networking=0
DAT

cat > init.sql <<"SQL"
CREATE DATABASE IF NOT EXISTS hospital;

CREATE USER IF NOT EXISTS 'hospital_user'@'%' IDENTIFIED BY 'hospital_pass';
GRANT ALL PRIVILEGES ON hospital.* TO 'hospital_user'@'%';

CREATE USER IF NOT EXISTS 'hospital_user'@'arnas-webserver-vm-arba1037.cloud' IDENTIFIED BY 'hospital_pass';  # added host-specific user
GRANT ALL PRIVILEGES ON hospital.* TO 'hospital_user'@'arnas-webserver-vm-arba1037.cloud';            # grant for that hostname

FLUSH PRIVILEGES;
USE hospital;

CREATE TABLE IF NOT EXISTS patients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255),
    email VARCHAR(255),
    password VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS doctors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    speciality VARCHAR(255),
    schedule VARCHAR(255),
    password VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS appointments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_time DATETIME,
    FOREIGN KEY (patient_id) REFERENCES patients(id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(id)
);
SQL

cat > docker-compose.yml <<"COM"
services:
  mariadb:
    build: .
    image: mariadb:10.11   # use the official image
    container_name: hospital_db
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: hospital      # new: create 'hospital' database
      MYSQL_USER: hospital_user     # new: create 'hospital_user'
      MYSQL_PASSWORD: hospital_pass # new: set 'hospital_user' password
    ports:
      - "3306:3306"
    volumes:
      - db_data:/var/lib/mysql
volumes:
  db_data:
COM

