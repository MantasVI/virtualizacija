#!/bin/bash
mkdir -p /home/mavi1016/.ansible/webstack/app
cd /home/mavi1016/.ansible/webstack/app

# ======================
# config.php – HOSPITAL DB (VILIAUS)
# ======================
<<<<<<< HEAD
cat > config.php <<"EOF"    # is a reusable database connection file.
<?php
session_start();    #session_start() – starts a session for the user, giving them a unique session ID. This session lets you store their user-specific data (like user_id) so they only see their own info.

$host = getenv('DB_HOST');        // from .env (Viliaus private IP)          getenv() – reads the database credentials from environment variables (DB_HOST, DB_NAME, DB_USER, DB_PASSWORD). This avoids hardcoding passwords in your PHP code.      
=======
cat > config.php <<"EOF"    
<?php
session_start();   

$host = getenv('DB_HOST');        // from .env (Viliaus private IP)          
>>>>>>> 2833e5e (final working code)
$db   = getenv('DB_NAME');        // hospital    
$user = getenv('DB_USER');        // hospital_user
$pass = getenv('DB_PASSWORD');    // hospital_pass

<<<<<<< HEAD
$conn = mysqli_connect($host, $user, $pass, $db);   $conn = mysqli_connect(...) – uses the above variables to connect to your MariaDB database. $conn is the connection handle used in queries.
=======
$conn = mysqli_connect($host, $user, $pass, $db);   
>>>>>>> 2833e5e (final working code)

if (!$conn) {
    die("could not connect to hospital database!");
}
?>
EOF

# ======================
# index.php – USER home (must be logged in as user)
# ======================
cat > index.php <<"EOF"
<?php
require 'config.php';   
<<<<<<< HEAD
if (!empty($_SESSION["id"])) {    #Patikrina sesiją: if (!empty($_SESSION["id"])) → ar vartotojas yra prisijungęs.
    $id = $_SESSION["id"];                #Gautų duomenų paieška: Jei prisijungęs, iš duomenų bazės paima visą eilutę iš users lentelės pagal $id.
    $result = mysqli_query($conn, "SELECT * FROM users WHERE id = $id");
    $row = mysqli_fetch_assoc($result);    #Asociatyvus masyvas: mysqli_fetch_assoc($result) paverčia eilutę į asociatyvų masyvą, kad galėtum naudoti $row["user"], $row["password"] ir t.t.
} else {
    header("Location: login.php");    #nera id reiskia logginink
=======
if (!empty($_SESSION["id"])) {   
    $id = $_SESSION["id"];               
    $result = mysqli_query($conn, "SELECT * FROM users WHERE id = $id");
    $row = mysqli_fetch_assoc($result);    
} else {
    header("Location: login.php");    
>>>>>>> 2833e5e (final working code)
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
<<<<<<< HEAD
    <h1>Welcome <?php echo htmlspecialchars($row["user"]); ?></h1>        #turi id imeta tave i userio page

=======
    <h1>Welcome <?php echo htmlspecialchars($row["user"]); ?></h1>        
>>>>>>> 2833e5e (final working code)
    <p>
        <a href="logout.php">LOGOUT</a>
    </p>

    <hr>

    <h3>Patient functions</h3>
    <ul>
        <li><a href="patient_card.php">Patient card</a></li>
        <li><a href="doctor_list.php">List of doctors</a></li>
        <li><a href="doctor_search.php">Search for doctors</a></li>
        <li><a href="book_appointment.php">Register with a doctor</a></li>
        <li><a href="my_appointments.php">My appointments (check-out)</a></li>
    </ul>

    <h3>Doctor area</h3>
    <ul>
        <li><a href="doctor_login.php">Doctor login</a></li>
        <li><a href="doctor_registration.php">Doctor registration</a></li>
    </ul>
</body>
</html>
EOF

# ======================
# login.php – USER login (uses hospital.users)
# ======================
cat > login.php <<"EOF"
<?php
require 'config.php';

<<<<<<< HEAD
if (isset($_POST["username"])) {        #ar uzpildytas ir username ir password ? 
    $username = $_POST["username"];
    $password = $_POST["password"];

    $result = mysqli_query($conn, "SELECT * FROM users WHERE user = '$username'");    #patikrina ar yra toksai username database?
    $row    = mysqli_fetch_assoc($result);    #padaro assocaitive array    row['user'] row['id'] row['password'] 

    if (mysqli_num_rows($result) > 0) {         # ar egzistuoja database? jei taip tikrina ar ivestas passwordas atitinka database passworda jei atitinka ($_session[id] = userio id stores the user’s unique ID in the session so other pages know which user is logged in.) ir nukreipia i  index.php kuris yra tsg user page
        // PLAIN TEXT PASSWORD CHECK – EXACTLY LIKE YOUR ORIGINAL
=======
if (isset($_POST["username"])) {       
    $username = $_POST["username"];
    $password = $_POST["password"];

    $result = mysqli_query($conn, "SELECT * FROM users WHERE user = '$username'");   
    $row    = mysqli_fetch_assoc($result);    

    if (mysqli_num_rows($result) > 0) {         
>>>>>>> 2833e5e (final working code)
        if ($password == $row["password"]) {
            $_SESSION["login"] = true;
            $_SESSION["id"]  = $row["id"]; 
            header("Location: index.php");
            exit;
        } else {
<<<<<<< HEAD
            echo "wrong password"; # jei slaptazodis nesutampa 
        }
    } else {
        echo "not registered"; # jeigu mysqli_num_rows($result) = 0 aka vps nera tokio userio database
=======
            echo "wrong password"; 
        }
    } else {
        echo "not registered"; 
>>>>>>> 2833e5e (final working code)
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Login page</title>
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
<<<<<<< HEAD
$_SESSION = [];    #Empties the session array ($_SESSION = []) → no stored data left.
session_unset();   #frees session memory
session_destroy();  #deletes session 
header("Location: login.php"); #relocates the user to the login page
=======
$_SESSION = [];    
session_unset();   
session_destroy();   
header("Location: login.php"); 
>>>>>>> 2833e5e (final working code)
exit;
?>
EOF

# ======================
# registration.php – USER registration (hospital.users)
# ======================
cat > registration.php <<"EOF"
<?php
<<<<<<< HEAD
require 'config.php'; #loads the database connection

if (!empty($_SESSION["id"])) {        #ar sessijos id tuscias? jei ne tai reiskias useris prisijunges ir ji grazinam i user page 
=======
require 'config.php'; 

if (!empty($_SESSION["id"])) {         
>>>>>>> 2833e5e (final working code)
    header("Location: index.php");
    exit;
}

if (isset($_POST["submit"])) {
<<<<<<< HEAD
    $username  = $_POST["username"]; #ka irase i username lentele
    $password  = $_POST["password"];  #ka irase i password lentele

    $duplicate = mysqli_query($conn, "SELECT * FROM users WHERE user = '$username'");  #ar egzistuoja toks username database?
    if (mysqli_num_rows($duplicate) > 0) { #jei egzistuoja
        echo "username taken";
    } else { #jei ne 
        if (!empty($username) && !empty($password)) { #ar ir passwordas ir username ivestas?
            // PLAIN TEXT – EXACTLY LIKE YOUR ORIGINAL
            $query = "INSERT INTO users (user, password) VALUES ('$username', '$password')";
            mysqli_query($conn, $query); #issiunciu sukurta insert query i database.
=======
    $username  = $_POST["username"]; 
    $password  = $_POST["password"];  

    $duplicate = mysqli_query($conn, "SELECT * FROM users WHERE user = '$username'");  
    if (mysqli_num_rows($duplicate) > 0) { 
        echo "username taken";
    } else { 
        if (!empty($username) && !empty($password)) { 
            
            $query = "INSERT INTO users (user, password) VALUES ('$username', '$password')";
            mysqli_query($conn, $query); 
>>>>>>> 2833e5e (final working code)
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
<<<<<<< HEAD
        <input type="text" name="username"><br>  #$username = # $_POST[username] is cia kyla
        password:<br>
        <input type="password" name="password"><br>    #$password = # $_POST[password] is cia kyla
        <input type="submit" name="submit" value="register"><br>     #isset(submit) is cia
=======
        <input type="text" name="username"><br> 
        password:<br>
        <input type="password" name="password"><br>    
        <input type="submit" name="submit" value="register"><br>     
>>>>>>> 2833e5e (final working code)
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
<<<<<<< HEAD
require 'config.php'; #reikalingas database 

if (isset($_POST["username"])) {  #cia legit same shit kaip submit 
    $username = $_POST["username"];    #ivesti duomenys username
    $password = $_POST["password"];    #ivesti duomenys password

    $result = mysqli_query($conn, "SELECT * FROM doctors WHERE user = '$username'");  istraukia is database info apie username 
    $row    = mysqli_fetch_assoc($result); #istraukia values apie ta username $row["id"], $row["user"], $row["password"]

    if (mysqli_num_rows($result) > 0) {    #ar yra toks useris database? jei yra tada tikrina ar passwordas atitinka database passworda
        // PLAIN TEXT
        if ($password == $row["password"]) {
            $_SESSION["doctor_login"] = true; #CIA KRC TSG TIKRINS AND KIEKVIENO DOCTOR PAGE AR PRISIJUNGES 
            $_SESSION["doctor_id"]    = $row["id"];  #leidzia identifikuoti koks doctor prisijunges nes kiekvienas useris ir doctor turi skirtinga id
            $_SESSION["doctor_user"]  = $row["user"]; #cia tai tsg displaying varda daktaro kinda useless
            header("Location: doctor_index.php"); #nusiuncia daktara i doctor page
=======
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
>>>>>>> 2833e5e (final working code)
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
<<<<<<< HEAD
cat > doctor_registration.php <<"EOF"  # 1 : 1 kaip useriams registracija
=======
cat > doctor_registration.php <<"EOF"  
>>>>>>> 2833e5e (final working code)
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
# doctor_index.php – doctor home + appointments
# ======================
cat > doctor_index.php <<"EOF"
<?php
require 'config.php';
<<<<<<< HEAD
if (empty($_SESSION["doctor_id"])) {  # ar gydytojas prisijunges ? jei ne tai nukreipia ji i doctor logina
    header("Location: doctor_login.php");
    exit;
}
$doctor_id   = $_SESSION["doctor_id"]; # issaugo daktaro sesijos id
$doctor_name = isset($_SESSION["doctor_user"]) ? $_SESSION["doctor_user"] : "Doctor"; #parodo daktaro varda 

// fetch appointments for this doctor
$app_sql = "                                    # cai tsg is user lenteles istraukia varda data laika kada turi appointmenta [mantas 25-01-01 18.30]
=======
if (empty($_SESSION["doctor_id"])) {  
    header("Location: doctor_login.php");
    exit;
}
$doctor_id   = $_SESSION["doctor_id"];
$doctor_name = isset($_SESSION["doctor_user"]) ? $_SESSION["doctor_user"] : "Doctor"; 
// fetch appointments for this doctor
$app_sql = "                                    
>>>>>>> 2833e5e (final working code)
    SELECT a.id, a.date, a.time, u.user AS patient_user 
    FROM appointments a
    JOIN users u ON a.patient_id = u.id
    WHERE a.doctor_id = $doctor_id
    ORDER BY a.date, a.time
";
<<<<<<< HEAD
$app_res = mysqli_query($conn, $app_sql); # ta querry issiuncia i database $conn
=======
$app_res = mysqli_query($conn, $app_sql); 
>>>>>>> 2833e5e (final working code)
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

    <h3>My appointments</h3>
<<<<<<< HEAD
    <?php if ($app_res && mysqli_num_rows($app_res) > 0): ?>  # AR YRA BENT 1 SUSITIKIMAS RODYTU SU KUO KITAIP NO APPINTMENTS
=======
    <?php if ($app_res && mysqli_num_rows($app_res) > 0): ?>  
>>>>>>> 2833e5e (final working code)
        <table border="1" cellpadding="5">
            <tr>
                <th>Date</th>
                <th>Time</th>
                <th>Patient</th>
            </tr>
            <?php while ($r = mysqli_fetch_assoc($app_res)): ?>
                <tr>
<<<<<<< HEAD
                    <td><?php echo htmlspecialchars($r['date']); ?></td>    #atprintima 1 userio data laika ir jo varda
=======
                    <td><?php echo htmlspecialchars($r['date']); ?></td>    
>>>>>>> 2833e5e (final working code)
                    <td><?php echo htmlspecialchars($r['time']); ?></td>
                    <td><?php echo htmlspecialchars($r['patient_user']); ?></td>
                </tr>
            <?php endwhile; ?>
        </table>
    <?php else: ?>
        <p>No appointments yet.</p>
    <?php endif; ?>

    <hr>
    <h3>Schedule</h3>
    <p><a href="doctor_schedule.php">View weekly schedule</a></p>

    <p>
        <a href="doctor_list.php">All doctors</a> |
        <a href="doctor_search.php">Search doctors</a> |
        <a href="index.php">Patient area</a>
    </p>
</body>
</html>
EOF

# ======================
# doctor_list.php – list doctors
# ======================
<<<<<<< HEAD
cat > doctor_list.php <<"EOF"  # legit kai apsilankai atprintina visus daktarus. thats it.  
=======
cat > doctor_list.php <<"EOF"   
>>>>>>> 2833e5e (final working code)
<?php
require 'config.php';

$result = mysqli_query($conn, "SELECT * FROM doctors");
?>
<!DOCTYPE html>
<html>
<head>
    <title>Doctor List</title>
</head>
<body>
<h2>All Doctors</h2>

<p>
    <a href="index.php">User home</a> |
    <a href="doctor_index.php">Doctor home</a>
</p>

<table border="1" cellpadding="5">
    <tr>
        <th>ID</th>
        <th>Username</th>
    </tr>

<?php while ($row = mysqli_fetch_assoc($result)): ?>
    <tr>
        <td><?php echo $row['id']; ?></td>
        <td><?php echo htmlspecialchars($row['user']); ?></td>
    </tr>
<?php endwhile; ?>

</table>

</body>
</html>
EOF

# ======================
# doctor_search.php – basic search (by username for now)
# ======================
cat > doctor_search.php <<"EOF"
<?php
require 'config.php';

<<<<<<< HEAD
$q = trim($_GET['q'] ?? ""); #CIA YRA KA TU IRASAI IESKAI PVZ DAKTARO TAI VISAS TSA INPUT ISSAUGOMAS $q VARIABLE

if ($q === "") {     #ar ka ivedei tuscia? jei tuscia nieko nerodo
=======
$q = trim($_GET['q'] ?? ""); 

if ($q === "") {     
>>>>>>> 2833e5e (final working code)
    $result = false;
} else {
    $sql = "SELECT * FROM doctors WHERE user LIKE '%$qEsc%'"; # cia krc is database ismeta visus doctors JEI kas panasus i ka ivedei ( '%$qEsc%' ) 
    $result = mysqli_query($conn, $sql);
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Search Doctors</title>
</head>
<body>
<h2>Search Doctors</h2>

<form method="get" action="">
    <input type="text" name="q" placeholder="doctor username" value="<?php echo htmlspecialchars($q); ?>">
    <button type="submit">Search</button>
</form>

<p>
    <a href="index.php">User home</a> |
    <a href="doctor_index.php">Doctor home</a>
</p>

<<<<<<< HEAD
<?php if ($q !== ""): ?>    #tikrinam ar ka irasei nera tuscia jei nera
    <h3>Results:</h3>
    <?php if ($result && mysqli_num_rows($result) > 0): ?>    tikrinam ar ka ivedei yra database 
=======
<?php if ($q !== ""): ?>    
    <h3>Results:</h3>
    <?php if ($result && mysqli_num_rows($result) > 0): ?>    
>>>>>>> 2833e5e (final working code)
        <table border="1" cellpadding="5">
            <tr>
                <th>ID</th>
                <th>Username</th>
            </tr>
<<<<<<< HEAD
            <?php while ($row = mysqli_fetch_assoc($result)): ?> isprintina daktaro id ir username
=======
            <?php while ($row = mysqli_fetch_assoc($result)): ?> 
>>>>>>> 2833e5e (final working code)
            <tr>
                <td><?php echo $row['id']; ?></td>
                <td><?php echo htmlspecialchars($row['user']); ?></td> 
            </tr>
            <?php endwhile; ?>
        </table>
    <?php else: ?>
        <p>No doctors found.</p> #jei nera databeise 
    <?php endif; ?>
<?php endif; ?>

</body>
</html>
EOF

# ======================
# doctor_schedule.php – simple weekly schedule (calendar-like table)
# ======================
cat > doctor_schedule.php <<"EOF"  
<?php
require 'config.php';

<<<<<<< HEAD
if (empty($_SESSION["doctor_id"])) {         #ar yra prisijunges daktaras jei ne i login page jei taip tai tsg isprintina jo work hours 
=======
if (empty($_SESSION["doctor_id"])) {         
>>>>>>> 2833e5e (final working code)
    header("Location: doctor_login.php");
    exit;
}
$doctor = $_SESSION["doctor_user"];
?>
<!DOCTYPE html>
<html>
<head>
    <title>Doctor Schedule</title>
</head>
<body>
<h2>Doctor Schedule – <?php echo htmlspecialchars($doctor); ?></h2>

<p>
    <a href="doctor_index.php">Doctor home</a> |
    <a href="index.php">User home</a>
</p>

<table border="1" cellpadding="5">
    <tr><th>Day</th><th>Work Hours</th></tr>
    <tr><td>Monday</td><td>09:00–17:00</td></tr>
    <tr><td>Tuesday</td><td>09:00–17:00</td></tr>
    <tr><td>Wednesday</td><td>09:00–17:00</td></tr>
    <tr><td>Thursday</td><td>09:00–17:00</td></tr>
    <tr><td>Friday</td><td>09:00–17:00</td></tr>
    <tr><td>Saturday</td><td>OFF</td></tr>
    <tr><td>Sunday</td><td>OFF</td></tr>
</table>

</body>
</html>
EOF

# ======================
# patient_card.php – edit + view patient medical card
# ======================
cat > patient_card.php <<"EOF"
<?php
<<<<<<< HEAD
require 'config.php';    # prisijungiam database ir leidzia naudoti $_SESSION visur

if (empty($_SESSION["id"])) {    # jei useris neprisijungęs, nukreipia į login puslapį.
=======
require 'config.php';    

if (empty($_SESSION["id"])) {    
>>>>>>> 2833e5e (final working code)
    header("Location: login.php");
    exit;
}

<<<<<<< HEAD
$patient_id = $_SESSION["id"];    #išsaugome paciento ID, kad žinotume, kieno kortelė.

// handle save
if ($_SERVER['REQUEST_METHOD'] === 'POST') {    #tikrina, ar buvo paspaustas “Save” mygtukas.
    $age = $_POST['age'] !== '' ? (int)$_POST['age'] : null;    #ar ivestas buvo ivesta kazkas jei ne lieka tuscia jei taip tai sukuriamas patient card su sitais values kuriuos ivedem

=======
$patient_id = $_SESSION["id"];    

// handle save
if ($_SERVER['REQUEST_METHOD'] === 'POST') {    
    $age = $_POST['age'] !== '' ? (int)$_POST['age'] : null;    
>>>>>>> 2833e5e (final working code)
    // enforce age between 1 and 99
    if ($age !== null && ($age < 1)) {
        $age = null;
    }

    $blood_type = $_POST['blood_type'] ?? '';
    $allergies  = $_POST['allergies'] ?? '';
    $notes      = $_POST['notes'] ?? '';

  
<<<<<<< HEAD
    $check = mysqli_query($conn, "SELECT patient_id FROM patient_card WHERE patient_id = $patient_id");  #ar turi patient card useris?
    if ($check && mysqli_num_rows($check) > 0) {   #patikrina ar dabartinis pacientas turi susikures pateint card jei turi tai mes ji tik paupdeitinam jie neturi sukuriam 
        // update
        $sql = "UPDATE patient_card SET age = $age, blood_type = '$blood_type', allergies = '$allergies', notes = '$notes' WHERE patient_id = $patient_id";
        mysqli_query($conn, $sql); #issiunciam i database
=======
    $check = mysqli_query($conn, "SELECT patient_id FROM patient_card WHERE patient_id = $patient_id");  
    if ($check && mysqli_num_rows($check) > 0) {    
        // update
        $sql = "UPDATE patient_card SET age = $age, blood_type = '$blood_type', allergies = '$allergies', notes = '$notes' WHERE patient_id = $patient_id";
        mysqli_query($conn, $sql); 
>>>>>>> 2833e5e (final working code)
    } else {
        // insert
        $sql = "INSERT INTO patient_card (patient_id, age, blood_type, allergies, notes)
                VALUES ($patient_id, $age, '$blood_type', '$allergies', '$notes')";
<<<<<<< HEAD
        mysqli_query($conn, $sql);  #issiunciam i database
=======
        mysqli_query($conn, $sql);  
>>>>>>> 2833e5e (final working code)
    }
}

// load card
<<<<<<< HEAD
$card_res = mysqli_query($conn, "SELECT * FROM patient_card WHERE patient_id = $patient_id"); #parodom patient card
$card = $card_res && mysqli_num_rows($card_res) > 0 ? mysqli_fetch_assoc($card_res) : null; jei yra bent 1 toks pacientas tai parodom  jo patient card info 
=======
$card_res = mysqli_query($conn, "SELECT * FROM patient_card WHERE patient_id = $patient_id"); 
$card = $card_res && mysqli_num_rows($card_res) > 0 ? mysqli_fetch_assoc($card_res) : null; 
>>>>>>> 2833e5e (final working code)
?>
<!DOCTYPE html>
<html>
<head>
    <title>Patient Card</title>
</head>
<body>
<h2>Patient Card</h2>

<p><a href="index.php">Back to user home</a></p>

<form method="post" action="">
    <table border="0" cellpadding="5">
        <tr>
            <td>Age:</td>
            <td><input type="number" name="age" value="<?php echo htmlspecialchars($card['age'] ?? ''); ?>"></td>
        </tr>
        <tr>
            <td>Blood type:</td>
            <td><input type="text" name="blood_type" value="<?php echo htmlspecialchars($card['blood_type'] ?? ''); ?>"></td>
        </tr>
        <tr>
            <td>Allergies:</td>
            <td><textarea name="allergies" rows="3" cols="30"><?php echo htmlspecialchars($card['allergies'] ?? ''); ?></textarea></td>
        </tr>
        <tr>
            <td>Notes:</td>
            <td><textarea name="notes" rows="3" cols="30"><?php echo htmlspecialchars($card['notes'] ?? ''); ?></textarea></td>
        </tr>
    </table>
    <br>
    <button type="submit">Save card</button>
</form>

</body>
</html>

EOF

# ======================
# book_appointment.php – PATIENT: register with doctor
# ======================
cat > book_appointment.php <<"EOF"
<?php
require 'config.php';

if (empty($_SESSION["id"])) {         # ar yra useris prisijunges? 
    header("Location: login.php");
    exit;
}

$patient_id = $_SESSION["id"];        # issaugom paciento id nes pagal tai zinosim kam appointmentas
$message = "";

<<<<<<< HEAD
// gauti gydytojų sąrašą
$doctors_res = mysqli_query($conn, "SELECT id, user FROM doctors ORDER BY user");    # gauname gydytoju sarasa

// jei forma buvo pateikta
if ($_SERVER['REQUEST_METHOD'] === 'POST') {    # jei doctor_id, date ir time buvo uzpildyti ir mygtukas pateikti paspaustas
    $doctor_id = (int)$_POST['doctor_id'];
    $date      = $_POST['date'];
    $time      = $_POST['time'];
=======
$doctors_res = mysqli_query($conn, "SELECT id, user FROM doctors ORDER BY user");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $doctor_id = (int)($_POST['doctor_id'] ?? 0);
    $date      = $_POST['date'] ?? '';
    $time      = $_POST['time'] ?? '';
>>>>>>> 2833e5e (final working code)

    // ar visi laukeliai įvesti
    if ($doctor_id <= 0 || $date === '' || $time === '') {
        $message = "Užpildyk visus laukus.";
    } else {
<<<<<<< HEAD
        // patikrinti ar daktaras turi appointment tuo metu
        $check = mysqli_query(
            $conn,
            "SELECT id FROM appointments 
             WHERE doctor_id = $doctor_id AND date = '$date' AND time = '$time'"
        );

        if (mysqli_num_rows($check) > 0) {
            $message = "Gydytojas tuo metu jau užimtas.";
=======
        $sql = "INSERT INTO appointments (patient_id, doctor_id, date, time)
                VALUES ($patient_id, $doctor_id, '$date', '$time')";
        if (mysqli_query($conn, $sql)) {
            $message = "Appointment booked.";
>>>>>>> 2833e5e (final working code)
        } else {
            // įrašyti naują appointment
            mysqli_query(
                $conn,
                "INSERT INTO appointments (patient_id, doctor_id, date, time) 
                 VALUES ($patient_id, $doctor_id, '$date', '$time')"
            );
            $message = "Vizitas sėkmingai užregistruotas.";
        }
    }
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Book Appointment</title>
</head>
<body>
<h2>Book Appointment with Doctor</h2>

<p><a href="index.php">Back to user home</a></p>

<?php if ($message): ?>
    <p><?php echo htmlspecialchars($message); ?></p>
<?php endif; ?>

<form method="post" action="">
    <label>Doctor:</label><br>
    <select name="doctor_id" required>
        <option value="">-- choose doctor --</option>
        <?php
<<<<<<< HEAD
       
=======
        $doctors_res = mysqli_query($conn, "SELECT id, user FROM doctors ORDER BY user");
>>>>>>> 2833e5e (final working code)
        while ($d = mysqli_fetch_assoc($doctors_res)):
        ?>
            <option value="<?php echo $d['id']; ?>">
                <?php echo htmlspecialchars($d['user']); ?>
            </option>
        <?php endwhile; ?>
    </select><br><br>

    <label>Date:</label><br>
    <input type="date" name="date" required><br><br>

    <label>Time:</label><br>
    <input type="time" name="time" required><br><br>

    <button type="submit">Book</button>
</form>

</body>
</html>
EOF
# ======================
# my_appointments.php – PATIENT: view + check-out (cancel)
# ======================
cat > my_appointments.php <<"EOF"
<?php
require 'config.php'; #prisijungiam prie duombases

if (empty($_SESSION["id"])) {  #ar prisijunges vartotojas
    header("Location: login.php");
    exit;
}

$patient_id = $_SESSION["id"];  # issaugom paciento id kad parodyt vizita 

// fetch appointments   #parodo visus paciento visitus 
$sql = "
    SELECT a.id, a.date, a.time, d.user AS doctor_user
    FROM appointments a
    JOIN doctors d ON a.doctor_id = d.id
    WHERE a.patient_id = $patient_id
    ORDER BY a.date, a.time
";
$res = mysqli_query($conn, $sql);
?>
<!DOCTYPE html>
<html>
<head>
    <title>My Appointments</title>
</head>
<body>
<h2>My Appointments</h2>

<p>
    <a href="index.php">Back to user home</a>
</p>

<?php if ($res && mysqli_num_rows($res) > 0): ?>        #jei egzistuoja bent 1 vizitas rodo lentele su vizitais
    <table border="1" cellpadding="5">
        <tr>
            <th>Doctor</th>
            <th>Date</th>
            <th>Time</th>
            <th>Action (check-out)</th>        
        </tr>
        <?php while ($row = mysqli_fetch_assoc($res)): ?>    
        <tr>
            <td><?php echo htmlspecialchars($row['doctor_user']); ?></td>
            <td><?php echo htmlspecialchars($row['date']); ?></td>
            <td><?php echo htmlspecialchars($row['time']); ?></td>
            <td>
                <form method="post" action="cancel_appointment.php" style="display:inline;"> #cia taipat yra mygtukas cancel atsaukti bet jis issiunciamas i kita faila?
                    <input type="hidden" name="id" value="<?php echo $row['id']; ?>">
                    <button type="submit">Cancel</button>
                </form>
            </td>
        </tr>
        <?php endwhile; ?>
    </table>
<?php else: ?>
    <p>No appointments found.</p>
<?php endif; ?>

</body>
</html>
EOF

# ======================
# cancel_appointment.php – PATIENT: cancel (check-out)
# ======================
cat > cancel_appointment.php <<"EOF"  #IS PRAEITO FAILO PASPAUDUS CANCEL AND APPOINTMENTO CIA BASICALLY FUNKCIONALUMAS TO CANCEL BUTTON
<?php
require 'config.php';

if (empty($_SESSION["id"])) {
    header("Location: login.php");
    exit;
}

$patient_id = $_SESSION["id"];

<<<<<<< HEAD
if ($_SERVER['REQUEST_METHOD'] === 'POST') {    #ar paspaude cancel buttona
    $id = (int)($_POST['id'] ?? 0);    #laiko vizito id jei jo nera 0

    if ($id > 0) {    #jei yra visito nr istrinamas jis is appointment database ir mus grazina i my_appointmentus
=======
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $id = (int)($_POST['id'] ?? 0);

    if ($id > 0) {
>>>>>>> 2833e5e (final working code)
        // paprastas delete, be sql injection apsaugos
        mysqli_query($conn, "DELETE FROM appointments 
                             WHERE id = $id AND patient_id = $patient_id");
    }
}

header("Location: my_appointments.php");
exit;
EOF

# ======================
# Docker + Nginx/PHP 
# ======================
cd /home/mavi1016/.ansible/webstack

# NGINX DOCKERFILE
cat > nginx.Dockerfile <<"DOC"
FROM ubuntu:24.04

RUN apt update && apt install -y nginx

RUN rm -rf /etc/nginx/sites-enabled/default    #istrinam default configuracija

COPY nginx.conf /etc/nginx/conf.d/default.conf #nukopijuojame musu sukurta konfiguracija i ta direktorija 
COPY app/ /var/www/html/    nukopijuojame visus app/ failus i /var/www/html 

EXPOSE 80   #paviesintas 80 portui

CMD ["nginx", "-g", "daemon off;"] #paleidzia nginx serveri ir (-g daemon off) kad nebutu ant background paleidziamas o ant foregroundo
roundo paleidziamas o kaip main
DOC

# PHP DOCKERFILE
cat > php.Dockerfile <<"EOF"
FROM ubuntu:24.04
RUN apt update && apt install -y \  #instaliuoja ka reikia 
    php-fpm \
    php-mysql \
    php-cli \
    php-common \
    mariadb-client
WORKDIR /var/www/html    #nustato kur bus vykdomi failai 
RUN sed -i 's|listen = /run/php/php8.3-fpm.sock|listen = 9000|' /etc/php/8.3/fpm/pool.d/www.conf #Pakeičia PHP-FPM, kad nebūtų Unix soketo, o klausytų TCP porto 9000.
RUN echo "clear_env = no" >> /etc/php/8.3/fpm/pool.d/www.conf #PHP-FPM saugumo nustatymas, kad Docker aplinka pasiektų PHP skriptus.
EXPOSE 9000  #paskleidzia visiems 9000 porta
CMD ["/usr/sbin/php-fpm8.3", "-F"] #paleidžia PHP-FPM tame konteineryje, kad jis neužsidarytų ir veiktų visą laiką, kol konteineris gyvas. (-F reiskia veik foregrounde)
EOF

# NGINX CONFIG
cat > nginx.conf <<"conf"
server {
    listen 80; #klausyk porto 80
    server_name _;    #bet koks domain tinka

    root /var/www/html;                    #Nurodo katalogą konteineryje, iš kurio Nginx turi ieškoti failų.
                                                #Pvz., jei naršyklėje nueini į http://localhost/index.php, Nginx ieškos /var/www/html/index.php.
    
     index index.php index.html;               #Nurodo, kokį failą numatytai atidaryti, jei vartotojas nueina į katalogą be konkretaus failo.
                                                #Pvz., naršyklė prašo / → Nginx pirmiausia ieško index.php, jei jo nėra – index.html.

    location / {
        try_files $uri $uri/ =404;         #Jei failas ar katalogas neegzistuoja → vartotojui parodoma klaida 404.
    }


#Šis blokas nukreipia visas PHP užklausas į PHP-FPM konteinerį.
#Nginx nevykdo PHP pats – jis perduoda PHP-FPM per TCP portą (9000).
#PHP-FPM vykdo skriptą ir grąžina rezultatą atgal Nginx, kuris pateikia naršyklei.

    location ~ \.php$ {
        fastcgi_pass app:9000;                                
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME /var/www/html$fastcgi_script_name;
    }
}
conf

# DOCKER-COMPOSE 
cat > docker-compose.yml <<"comp"
version: "3.9"

services:
  app:
    build:
      context: .
      dockerfile: php.Dockerfile
    container_name: hospital_php
    volumes:
      - ./app:/var/www/html    #visi failai /app perduodami i /var/www/html
    environment:        # tai kintamieji (variables) konteinerio aplinkoje, kuriuos PHP-FPM naudoja prisijungimui prie duomenų bazės.
      DB_HOST: "${DB_HOST}"  #PHP skriptas jas gali pasiekti per getenv() arba $_ENV
      DB_PORT: "${DB_PORT}"
      DB_NAME: "${DB_NAME}"
      DB_USER: "${DB_USER}"
      DB_PASSWORD: "${DB_PASSWORD}"
    restart: always # jei uzluzta visados perkrauna

  web:
    build:
      context: .
      dockerfile: nginx.Dockerfile
    container_name: hospital_nginx
    ports:
      - "80:80" #Nginx konteineris aptarnauja HTTP užklausas (port 80),
    depends_on:
      - app #Nurodo, kad Nginx konteineris bus paleistas tik po PHP-FPM konteinerio (app).
    volumes:
      - ./app:/var/www/html #Tavo lokalus katalogas ./app konteineryje atrodo kaip /var/www/html, Bet PHP ir Nginx konteineriai mato tuos failus ir gali juos naudoti.
    restart: always
comp
