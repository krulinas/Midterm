<?php
// Debugging: Log the received POST data
error_log(print_r($_POST, true));
error_log(file_get_contents('php://input'));

// Validate POST parameters
if (!isset($_POST['title']) || !isset($_POST['details'])) {
    $response = array('status' => 'failed', 'data' => 'Missing required parameters');
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");

// Sanitize inputs
$title = addslashes($_POST['title']);
$details = addslashes($_POST['details']);

// Insert the news into the database
$sqlinsertnews = "INSERT INTO `tbl_news`(`news_title`, `news_details`) VALUES ('$title','$details')";

if ($conn->query($sqlinsertnews) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
} else {
    $response = array('status' => 'failed', 'data' => $conn->error);
}
sendJsonResponse($response);

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>