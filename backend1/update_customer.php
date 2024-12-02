<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header('Content-Type: application/json');

// Include the database connection
include('db_connect.php');

if (!isset($conn)) {
    echo json_encode(["error" => "Database connection not established"]);
    exit();
}

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $id = $_POST['id'] ?? null;
    $full_name = $_POST['full_name'] ?? null;
    $number = $_POST['number'] ?? null;
    $email = $_POST['email'] ?? null; // Use 'email' instead of 'mail_id'
    $address = $_POST['address'] ?? null;

    if (empty($id) || empty($full_name) || empty($number) || empty($email) || empty($address)) {
        echo json_encode(["error" => "All fields are required"]);
        exit();
    }

    // Sanitize input
    $id = $conn->real_escape_string($id);
    $full_name = $conn->real_escape_string($full_name);
    $number = $conn->real_escape_string($number);
    $email = $conn->real_escape_string($email);
    $address = $conn->real_escape_string($address);

    // Correct column name for email
    $sql = "UPDATE client SET 
            full_name = '$full_name', 
            number = '$number', 
            email = '$email', 
            address = '$address'
            WHERE id = '$id'";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(["success" => true, "message" => "Customer updated successfully"]);
    } else {
        echo json_encode(["error" => "Failed to update customer: " . $conn->error]);
    }

    $conn->close();
} else {
    echo json_encode(["error" => "Invalid request method"]);
}
?>
