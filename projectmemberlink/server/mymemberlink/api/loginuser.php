<?php
// Debugging: Log POST data and raw input
error_log(print_r($_POST, true));
error_log(file_get_contents('php://input'));

// Check if required parameters are present
if (!isset($_POST['email']) || !isset($_POST['password'])) {
    $response = array('status' => 'failed', 'data' => 'Missing required parameters');
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");

// Sanitize and retrieve inputs
$email = $conn->real_escape_string($_POST['email']);
$password = sha1($conn->real_escape_string($_POST['password'])); // Hash password

// Query to check login
$sqllogin = "SELECT `user_email`, `user_pass` FROM `tbl_users` WHERE `user_email` = '$email' AND `user_pass` = '$password'";
$result = $conn->query($sqllogin);

if ($result && $result->num_rows > 0) {
    $response = array('status' => 'success', 'data' => null);
} else {
    $response = array('status' => 'failed', 'data' => 'Invalid email or password');
}
sendJsonResponse($response);

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>