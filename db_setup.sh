#!/bin/bash
a
mkdir -p /home/mavi1016/.ansible/dbstack
cd /home/mavi1016/.ansible/dbstack

#PRADEKIT NUO my.cnf ir init.sql POTO I DOCKERFILE ZIUREKIT

cat > Dockerfile <<"DOC"
# dbstack/Dockerfile – MariaDB for HOSPITAL
FROM mariadb:10.11
COPY my.cnf /etc/mysql/my.cnf    musu my.cnf (KONFIGURACIJOS FAILUS KURIS NUSTATO KAIP MARIADB VEIKS)
COPY init.sql /docker-entrypoint-initdb.d/   (tiesiog instrukcijos MariaDB, ką sukurti startuojant konteinerį.)
EXPOSE 3306
# Default ENTRYPOINT from image starts mysqld
DOC

cat > my.cnf <<"DAT"
[mysqld]          #Tells MariaDB that the lines underneath apply to the server daemon (mysqld).                        #KITAIP SAKANT my.cnf YRA KONFIGURACIJOS FAILAS!!!!
user=mysql         #MariaDB daemon will run as the mysql system user inside the container.
bind-address=0.0.0.0         #Accept connections from any network interface.
skip-name-resolve         #MariaDB does NOT try to resolve hostnames → it uses ONLY IP addresses.
port=3306             #Listen for TCP connections on port 3306.
socket=/run/mysqld/mysqld.sock         #It's just the local communication channel.
datadir=/var/lib/mysql   #“Store all database files (tables, indexes, logs) in /var/lib/mysql.”
skip-networking=0     #Enable TCP networking so containers and hosts can connect.
DAT

cat > init.sql <<"SQL"
-- HOSPITAL DATABASE + USERS/DOCTORS TABLES

CREATE DATABASE IF NOT EXISTS hospital;

-- main db user used by PHP in containers
CREATE USER IF NOT EXISTS 'hospital_user'@'%' IDENTIFIED BY 'hospital_pass';        #MariaDB vartotojas, kurį PHP naudos prisijungti prie DB
GRANT ALL PRIVILEGES ON hospital.* TO 'hospital_user'@'%'                        

FLUSH PRIVILEGES;        #atnaujink privilegijas

USE hospital;            #naudok dbr sita database

-- USERS table (for normal users / patients)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- DOCTORS table (simple; you can later add columns if you want)
CREATE TABLE IF NOT EXISTS doctors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- PATIENT CARD table (extra info for logged-in user)
CREATE TABLE IF NOT EXISTS patient_card (
    patient_id INT PRIMARY KEY,
    age INT,
    blood_type VARCHAR(10),
    allergies TEXT,
    notes TEXT,
    FOREIGN KEY (patient_id) REFERENCES users(id)
);

-- APPOINTMENTS: patient registers/checks-out with doctor
CREATE TABLE IF NOT EXISTS appointments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES users(id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(id)
);
SQL

cat > docker-compose.yml <<"COM"
version: "3.9"
services:    #kokius konteinerius paleisti? 
  mariadb:
    build: .    #kur statyti dockerfile? sitoje direktorijoje kurioje esame.
    container_name: hospital_db
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword            #VISI SITIE DUOMENYS BUS NAUDOJAMI CONFIG.PHP TENAIS MES SUKURSIM IS SITU mysql_root_pass ,database,user ir password VARIABLE KURIS TAPS prisijungimo prie DB objektu, kurį gali naudoti visur PHP kode: skaityti, rašyti, registruoti pacientus, gydytojus, appointments, ir t.t.
      MYSQL_DATABASE: hospital                        #Viskas veikia kaip tiltas tarp PHP aplikacijos ir MariaDB konteinerio.
      MYSQL_USER: hospital_user
      MYSQL_PASSWORD: hospital_pass
    ports:
      - "3306:3306"                #leidzia belekam jungtis and sito porto
    volumes:
      - db_data:/var/lib/mysql        #issaugo visa init.sql data i db_data
volumes:
  db_data:    #laiko visus duomenis cia jeigu conteineris issijungtu kad jie neissitrintu
COM

COM
--- FORCE INIT.SQL TO RUN EVERY TIME ---
docker compose down -v || true            #pilnai viska whipina 
docker compose up -d        #isnaujo viskas paleidziama ir susukuria tuscais naujas database
