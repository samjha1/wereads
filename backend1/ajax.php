<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Database credentials
$host = 'localhost';
$dbname = 'wereads';
$username = 'root'; // Your database username
$password = ''; // Your database password

// Start session
session_start();

// Establish database connection
$conn = new mysqli($host, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode([
        "status" => "error",
        "message" => "Database connection failed: " . $conn->connect_error
    ]));
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = $_POST['email'];
    $password = $_POST['password'];

    // Prepare the SQL statement
    $stmt = $conn->prepare("SELECT * FROM users WHERE email = ? AND password = ?");
    if (!$stmt) {
        echo json_encode([
            "status" => "error",
            "message" => "Failed to prepare statement: " . $conn->error
        ]);
        exit;
    }

    // Bind parameters
    $stmt->bind_param("ss", $email, $password);

    // Execute the statement
    $stmt->execute();

    // Get the result
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();

        // Set session variables for the logged-in user
        $_SESSION['login_id'] = $user['id'];
        $_SESSION['login_name'] = $user['email'];
        $_SESSION['login_role'] = $user['role'];

        // Return success with the user's role
        echo json_encode([
            "status" => "success",
            "role" => $user['role']
        ]);
    } else {
        // Invalid login
        echo json_encode([
            "status" => "error",
            "message" => "Invalid email or password"
        ]);
    }

    // Close statement and connection
    $stmt->close();
    $conn->close();
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Invalid request method"
    ]);
}
?>
