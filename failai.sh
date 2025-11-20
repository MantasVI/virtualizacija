#!/bin/bash

mkdir -p /home/mavi1016/.ansible/webstack/app
cd /home/mavi1016/.ansible/webstack/app

# PHP TEST FILE

cat > index.php <<"EOF"
<?php
session_start();  // Start session

// If already logged in, redirect to home
if (isset($_SESSION['patient_id'])) {
    header("Location: home.php");
    exit;
}

// Database connection
$servername = getenv('DB_HOST');
$username   = getenv('DB_USER');
$password   = getenv('DB_PASSWORD');
$dbname     = getenv('DB_NAME');
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$error = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = trim($_POST['email'] ?? '');
    $password = $_POST['password'] ?? '';
    if (empty($email) || empty($password)) {
        $error = "Email and password are required";
    } else {
        $stmt = $conn->prepare("SELECT id, email, password FROM patients WHERE email = ?");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $result = $stmt->get_result();
        if ($row = $result->fetch_assoc()) {
            if (password_verify($password, $row['password'])) {
                $_SESSION['patient_id']    = $row['id'];
                $_SESSION['patient_email'] = $row['email'];
                header("Location: home.php");
                exit;
            }
        }
        $error = "Invalid email or password";
    }
    if ($error) {
        header("Location: index.php?error=" . urlencode($error));
        exit;
    }
}
?>
<!DOCTYPE html>
<html>
<head><title>Login</title></head>
<body>
<h2>Login</h2>
<?php if (isset($_GET['error'])): ?>
  <p style="color:red;"><?php echo htmlspecialchars($_GET['error']); ?></p>
<?php endif; ?>
<form method="post" action="index.php">
    <label>Email:</label><br>
    <input type="email" name="email" required><br><br>
    <label>Password:</label><br>
    <input type="password" name="password" required><br><br>
    <button type="submit">Login</button>
</form>
</body>
</html>
EOF

# Create home page
cat > home.php <<"EOF"
<?php
session_start();
if (!isset($_SESSION['patient_id'])) {
    header("Location: index.php");
    exit;
}
?>
<!DOCTYPE html>
<html>
<head><title>Home</title></head>
<body>
<h2>Welcome, <?php echo htmlspecialchars($_SESSION['patient_email']); ?>!</h2>
<p>You are now logged in.</p>
<p><a href="logout.php">Logout</a></p>
</body>
</html>
EOF

# Create logout script
cat > logout.php <<"EOF"
<?php
session_start();
session_unset();
session_destroy();
header("Location: index.php");
exit;
EOF



#cat > index.php <<"EOF"
#<?php
#$host = getenv('DB_HOST');
#$db = getenv('DB_NAME');
#$user = getenv('DB_USER');
#$pass = getenv('DB_PASSWORD');

#$mysqli = new mysqli($host, $user, $pass, $db);

#if ($mysqli->connect_error) {
#    die("MySQL connection failed: " . $mysqli->connect_error);
#}

#echo "<h1>✅ PHP is working</h1>";
#echo "<p>Connected to <strong>$db</strong> on <strong>$host</strong> as <strong>$user</strong>.</p>";

#$result = $mysqli->query("SHOW TABLES");
#if ($result) {
#    echo "<h2>📋 Tables in '$db':</h2><ul>";
#    while ($row = $result->fetch_array()) {
#        echo "<li>{$row[0]}</li>";
#    }
#    echo "</ul>";
#} else {
#    echo "<p>No tables or failed to list them.</p>";
#}
#
#$mysqli->close();
#?>
#EOF

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
