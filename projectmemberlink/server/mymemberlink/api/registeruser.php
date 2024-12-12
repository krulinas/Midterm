<?php
// Debugging: Log the received POST data
error_log(print_r($_POST, true));

// Check if required parameters are present
if (!isset($_POST['email']) || !isset($_POST['password'])) {
    $response = array('status' => 'failed', 'data' => 'Missing required parameters');
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");

$email = $_POST['email'];
$password = sha1($_POST['password']); // Hash the password

// Check if the email already exists
$sqlCheckEmail = "SELECT `user_email` FROM `tbl_users` WHERE `user_email` = '$email'";
$resultEmail = $conn->query($sqlCheckEmail);

if ($resultEmail && $resultEmail->num_rows > 0) {
    $response = array('status' => 'failed', 'data' => 'Email already registered');
    sendJsonResponse($response);
} else {
    // Insert new user into the database
    $sqlinsert = "INSERT INTO `tbl_users`(`user_email`, `user_pass`, `user_datereg`) VALUES ('$email', '$password', NOW())";
    
    if ($conn->query($sqlinsert) === TRUE) {
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => $conn->error);
        sendJsonResponse($response);
    }
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>