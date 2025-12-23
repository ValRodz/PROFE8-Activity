<?php
// Set CORS headers
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(200); exit(); }

require_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

$data = json_decode(file_get_contents('php://input'));

if (empty($data->seller_id) || empty($data->name) || !isset($data->price)) {
    http_response_code(400);
    echo json_encode(['success'=>false,'message'=>'Missing required fields']);
    exit();
}

$seller_id = $data->seller_id;
$name = $data->name;
$description = isset($data->description) ? $data->description : '';
$price = $data->price;
$image_url = isset($data->image_url) ? $data->image_url : null;
$stock = isset($data->stock) ? $data->stock : 0;

$query = "INSERT INTO products (seller_id, name, description, price, image_url, stock) VALUES (?, ?, ?, ?, ?, ?)";
$stmt = $db->prepare($query);
$stmt->bind_param('issdsi', $seller_id, $name, $description, $price, $image_url, $stock);

if ($stmt->execute()) {
    http_response_code(201);
    echo json_encode(['success'=>true,'product_id'=>$db->insert_id]);
} else {
    http_response_code(500);
    echo json_encode(['success'=>false,'message'=>'Failed to create product']);
}

$db->close();

?>
