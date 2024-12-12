<?php

include_once("dbconnect.php");

// Get the current page number and page size from the request
$pageno = isset($_GET['pageno']) ? (int)$_GET['pageno'] : 1;
$page_size = 2; // Number of products per page
$offset = ($pageno - 1) * $page_size;

// Get the total number of results
$sqlcount = "SELECT COUNT(*) AS total FROM tbl_products";
$countresult = $conn->query($sqlcount);
$total = $countresult->fetch_assoc()['total'];
$numofpage = ceil($total / $page_size); // Calculate the number of pages

// Fetch the products for the current page
$sqlloadproducts = "SELECT * FROM tbl_products ORDER BY product_title ASC LIMIT $offset, $page_size";
$result = $conn->query($sqlloadproducts);

if ($result->num_rows > 0) {
    $productarray['products'] = array();
    while ($row = $result->fetch_assoc()) {
        $product = array();
        $product['product_id'] = $row['product_id'];
        $product['product_title'] = $row['product_title'];
        $product['product_description'] = $row['product_description'];
        $product['product_image'] = $row['product_image'];
        $product['product_quantity'] = $row['product_quantity'];
        $product['product_price'] = $row['product_price'];
        $product['product_type'] = $row['product_type'];
        array_push($productarray['products'], $product);
    }
    $response = array(
        'status' => 'success',
        'data' => $productarray,
        'numofpage' => $numofpage, // Total number of pages
        'numberofresult' => $total // Total number of results
    );
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>