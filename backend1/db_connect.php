<?php
$servername = "localhost";  // Database server
$username = "root";         // Database username
$password = "";             // Database password (empty by default in XAMPP)
$dbname = "wereads";      // Database name

// Create a connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check the connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>
