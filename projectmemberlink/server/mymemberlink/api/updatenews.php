<?php
// Debugging: Log incoming POST data
error_log(print_r($_POST, true));
error_log(file_get_contents('php://input'));

// Validate POST parameters
if (!isset($_POST['newsid']) || !isset($_POST['title']) || !isset($_POST['details'])) {
    $response = array('status' => 'failed', 'data' => 'Missing required parameters');
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");

// Sanitize and retrieve input
$newsid = $conn->real_escape_string($_POST['newsid']);
$title = addslashes($_POST['title']);
$details = addslashes($_POST['details']);

// Update the news in the database
$sqlupdatenews = "UPDATE `tbl_news` SET `news_title`='$title', `news_details`='$details' WHERE `news_id` = '$newsid'";

if ($conn->query($sqlupdatenews) === TRUE) {
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