<?php

header("Access-Control-Allow-Origin: *"); // Allow all origins
header("Access-Control-Allow-Methods: POST, OPTIONS"); // Allow POST and OPTIONS methods
header("Access-Control-Allow-Headers: Content-Type"); // Allow Content-Type header
header('Content-Type: application/json'); // Set content type to JSON

// Handle the OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Database connection (adjust as necessary for your environment)
$host = 'localhost';
$dbname = 'wereads';
$username = 'root'; // Your database username
$password = ''; // Your database password

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['error' => 'Database connection failed: ' . $e->getMessage()]);
    exit();
}

// Process the form data (POST method expected)
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Collect data
    $data = $_POST;

    // Validate the data (basic example)
    $required_fields = ['full_name', 'number', 'email', 'address'];

    foreach ($required_fields as $field) {
        if (empty($data[$field])) {
            echo json_encode(['error' => "$field is required"]);
            exit();
        }
    }

    // Sanitize the inputs to prevent SQL injection
    $full_name = htmlspecialchars(trim($data['full_name']));
    $number = htmlspecialchars(trim($data['number']));
    $email = htmlspecialchars(trim($data['email']));
    $address = htmlspecialchars(trim($data['address']));

    // Insert data into the database
    try {
        $sql = "INSERT INTO client (full_name, number, email, address) 
                VALUES (:full_name, :number, :email, :address)";

        $stmt = $pdo->prepare($sql);
        $stmt->execute([
            ':full_name' => $full_name,
            ':number' => $number,
            ':email' => $email,
            ':address' => $address,
        ]);

        echo json_encode(['message' => 'Data submitted successfully']);
    } catch (PDOException $e) {
        echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['error' => 'Invalid request method']);
}
?>
