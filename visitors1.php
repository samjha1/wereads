<?php
header("Access-Control-Allow-Origin: *"); // Allow all origins
header("Access-Control-Allow-Methods: POST, OPTIONS"); // Allow POST and OPTIONS methods
header("Access-Control-Allow-Headers: Content-Type"); // Allow Content-Type header

error_reporting(E_ALL);
ini_set('display_errors', 1);

// Database connection credentials
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "wereads";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

// Handle preflight request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Retrieve POST data
    $previous_date = isset($_POST['previous_date']) ? trim($_POST['previous_date']) : '';
    $court_hall = isset($_POST['court_hall']) ? trim($_POST['court_hall']) : '';
    $perticulars = isset($_POST['perticulars']) ? trim($_POST['perticulars']) : '';
    $stages = isset($_POST['stages']) ? trim($_POST['stages']) : '';
    $next_date = isset($_POST['next_date']) ? trim($_POST['next_date']) : '';

    // Check if all fields are filled
    if (!empty($previous_date) && !empty($court_hall) && !empty($perticulars) && !empty($stages) && !empty($next_date)) {
        // Prepare the SQL query to insert data into the `diary` table
        $stmt = $conn->prepare("INSERT INTO diary (previous_date, court_hall, perticulars, stages, next_date) VALUES (?, ?, ?, ?, ?)");

        // Check if preparation was successful
        if ($stmt === false) {
            die(json_encode(["error" => "Error preparing SQL query: " . $conn->error]));
        }

        // Bind parameters
        $stmt->bind_param("sssss", $previous_date, $court_hall, $perticulars, $stages, $next_date);

        // Execute the query and check for success
        if ($stmt->execute()) {
            echo json_encode(["status" => "success", "message" => "Record inserted successfully"]);
        } else {
            echo json_encode(["error" => "Error: " . $stmt->error]);
        }

        $stmt->close();
    } else {
        echo json_encode(["error" => "All fields are required!"]);
    }
} else {
    echo json_encode(["error" => "Invalid request method!"]);
}

// Close the connection
$conn->close();
?>
