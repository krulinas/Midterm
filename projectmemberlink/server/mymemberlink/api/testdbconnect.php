<?php
include_once("dbconnect.php");

if ($conn->connect_error) {
    echo "Connection failed: " . $conn->connect_error;
} else {
    echo "Database connection successful!";
}
?>