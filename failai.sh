#!/bin/bash

mkdir -p /home/mavi1016/.ansible/webstack/app
cd /home/mavi1016/.ansible/webstack/app

# ======================
# config.php – HOSPITAL DB (VILIAUS)
# ======================
cat > config.php <<"EOF"
<?php
session_start();

$host = getenv('DB_HOST');        // from .env (Viliaus private IP)
$db   = getenv('DB_NAME');        // hospital
$user = getenv('DB_USER');        // hospital_user
$pass = getenv('DB_PASSWORD');    // hospital_pass

$conn = mysqli_connect($host, $user, $pass, $db);

if (!$conn) {
    die("could not connect to hospital database!");
}
?>
EOF

# ======================
# index.php – user home (must be logged in as user)
# ======================
cat > index.php <<"EOF"
<?php
require 'config.php';
if (!empty($_SESSION["id"])) {
    $id = $_SESSION["id"];
    $result = mysqli_query($conn, "SELECT * FROM users WHERE id = $id");
    $row = mysqli_fetch_assoc($result);
} else {
    header("Location: login.php");
    exit;
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Home</title>
</head>
<body>
    <h1>Welcome <?php echo htmlspecialchars($row["user"]); ?></h1>
    <p>
        <a href="logout.php">LOGOUT</a>
    </p>
    <hr>
    <p>
        <a href="doctor_login.php">Doctor login</a> |
        <a href="doctor_registration.php">Doctor registration</a>
    </p>
</body>
</html>
EOF

# ======================
# login.php – USER login (uses hospital.users)
# ======================
cat > login.php <<"EOF"
<?php
require 'config.php';

if (isset($_POST["username"])) {
    $username = $_POST["username"];
    $password = $_POST["password"];

    $result = mysqli_query($conn, "SELECT * FROM users WHERE user = '$username'");
    $row    = mysqli_fetch_assoc($result);

    if (mysqli_num_rows($result) > 0) {
        // PLAIN TEXT PASSWORD CHECK – EXACTLY LIKE YOUR ORIGINAL
        if ($password == $row["password"]) {
            $_SESSION["login"] = true;
            $_SESSION["id"]    = $row["id"];
            header("Location: index.php");
            exit;
        } else {
            echo "wrong password";
        }
    } else {
        echo "not registered";
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login page</title>
</head>
<body>
    <h2>User Login</h2>
    <form action="" method="post" autocomplete="off">
        <label for="username">username:</label>
        <input type="text" name="username" id="username" required> <br>
        <label for="password">Password</label>
        <input type="password" name="password" id="password" required><br>
        <button type="submit" name="submit">Login</button>
    </form>

    <p>
        <a href="registration.php">User registration</a>
    </p>
    <p>
        <a href="doctor_login.php">Doctor login</a> |
        <a href="doctor_registration.php">Doctor registration</a>
    </p>
</body>
</html>
EOF

# ======================
# logout.php – clears ALL session
# ======================
cat > logout.php <<"EOF"
<?php
require 'config.php';
$_SESSION = [];
session_unset();
session_destroy();
header("Location: login.php");
exit;
?>
EOF

# ======================
# registration.php – USER registration (hospital.users)
# ======================
cat > registration.php <<"EOF"
<?php
require 'config.php';

if (!empty($_SESSION["id"])) {
    header("Location: index.php");
    exit;
}

if (isset($_POST["submit"])) {
    $username  = $_POST["username"];
    $password  = $_POST["password"];

    $duplicate = mysqli_query($conn, "SELECT * FROM users WHERE user = '$username'");
    if (mysqli_num_rows($duplicate) > 0) {
        echo "username taken";
    } else {
        if (!empty($username) && !empty($password)) {
            // PLAIN TEXT – EXACTLY LIKE YOUR ORIGINAL
            $query = "INSERT INTO users (user, password) VALUES ('$username', '$password')";
            mysqli_query($conn, $query);
            echo "registration successful";
        } else {
            echo "registration failed";
        }
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User registration</title>
</head>
<body>
    <form action="<?php $_SERVER["PHP_SELF"] ?>" method="post">
        <h2>Welcome to the Linux hospital – User registration</h2>
        username:<br>
        <input type="text" name="username"><br>
        password:<br>
        <input type="password" name="password"><br>
        <input type="submit" name="submit" value="register"><br>
        <a href="login.php">User login</a><br>
        <a href="doctor_login.php">Doctor login</a> |
        <a href="doctor_registration.php">Doctor registration</a>
    </form>
</body>
</html>
EOF

# ======================
# doctor_login.php – DOCTOR login (hospital.doctors)
# ======================
cat > doctor_login.php <<"EOF"
<?php
require 'config.php';

if (isset($_POST["username"])) {
    $username = $_POST["username"];
    $password = $_POST["password"];

    $result = mysqli_query($conn, "SELECT * FROM doctors WHERE user = '$username'");
    $row    = mysqli_fetch_assoc($result);

    if (mysqli_num_rows($result) > 0) {
        // PLAIN TEXT
        if ($password == $row["password"]) {
            $_SESSION["doctor_login"] = true;
            $_SESSION["doctor_id"]    = $row["id"];
            $_SESSION["doctor_user"]  = $row["user"];
            header("Location: doctor_index.php");
            exit;
        } else {
            echo "wrong password";
        }
    } else {
        echo "not registered";
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Doctor Login</title>
</head>
<body>
    <h2>Doctor Login</h2>
    <form action="" method="post" autocomplete="off">
        <label for="username">username:</label>
        <input type="text" name="username" id="username" required> <br>
        <label for="password">Password</label>
        <input type="password" name="password" id="password" required><br>
        <button type="submit" name="submit">Login</button>
    </form>

    <p>
        <a href="doctor_registration.php">Doctor registration</a>
    </p>
    <p>
        <a href="login.php">User login</a> |
        <a href="registration.php">User registration</a>
    </p>
</body>
</html>
EOF

# ======================
# doctor_registration.php – create doctor in hospital.doctors
# ======================
cat > doctor_registration.php <<"EOF"
<?php
require 'config.php';

if (!empty($_SESSION["doctor_id"])) {
    header("Location: doctor_index.php");
    exit;
}

if (isset($_POST["submit"])) {
    $username  = $_POST["username"];
    $password  = $_POST["password"];

    $duplicate = mysqli_query($conn, "SELECT * FROM doctors WHERE user = '$username'");
    if (mysqli_num_rows($duplicate) > 0) {
        echo "username taken";
    } else {
        if (!empty($username) && !empty($password)) {
            // PLAIN TEXT
            $query = "INSERT INTO doctors (user, password) VALUES ('$username', '$password')";
            mysqli_query($conn, $query);
            echo "doctor registration successful";
        } else {
            echo "registration failed";
        }
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Doctor registration</title>
</head>
<body>
    <form action="<?php $_SERVER["PHP_SELF"] ?>" method="post">
        <h2>Linux hospital – Doctor registration</h2>
        username:<br>
        <input type="text" name="username"><br>
        password:<br>
        <input type="password" name="password"><br>
        <input type="submit" name="submit" value="register"><br>
        <a href="doctor_login.php">Doctor login</a><br>
        <a href="login.php">User login</a> |
        <a href="registration.php">User registration</a>
    </form>
</body>
</html>
EOF

# ======================
# doctor_index.php – doctor home
# ======================
cat > doctor_index.php <<"EOF"
<?php
require 'config.php';
if (empty($_SESSION["doctor_id"])) {
    header("Location: doctor_login.php");
    exit;
}
$doctor_name = isset($_SESSION["doctor_user"]) ? $_SESSION["doctor_user"] : "Doctor";
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Doctor Home</title>
</head>
<body>
    <h1>Welcome Dr. <?php echo htmlspecialchars($doctor_name); ?></h1>
    <p>
        <a href="logout.php">LOGOUT</a>
    </p>
    <hr>
    <p>
        <a href="login.php">User login</a> |
        <a href="registration.php">User registration</a>
    </p>
</body>
</html>
EOF

# ======================
# Docker + Nginx/PHP (unchanged, still works with .env from 8.dockeris.sh)
# ======================
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
    mariadb-client
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

# DOCKER-COMPOSE (env vars from .env written by 8.dockeris.sh)
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
