<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(200); exit(); }

require_once '../../config/database.php';
$database = new Database();
$db = $database->getConnection();

$seller_id = isset($_GET['seller_id']) ? $_GET['seller_id'] : null;
$product_id = isset($_GET['product_id']) ? $_GET['product_id'] : null;

if ($product_id) {
    $query = "SELECT * FROM products WHERE id = ?";
    $stmt = $db->prepare($query);
    $stmt->bind_param('i', $product_id);
    $stmt->execute();
    $res = $stmt->get_result();
    $row = $res->fetch_assoc();
    echo json_encode(['success'=>true,'product'=>$row]);
    exit();
}

if ($seller_id) {
    $query = "SELECT * FROM products WHERE seller_id = ? ORDER BY created_at DESC";
    $stmt = $db->prepare($query);
    $stmt->bind_param('i', $seller_id);
} else {
    $query = "SELECT * FROM products ORDER BY created_at DESC";
    $stmt = $db->prepare($query);
}

$stmt->execute();
$res = $stmt->get_result();
$products = [];
while ($row = $res->fetch_assoc()) {
    $products[] = $row;
}
echo json_encode(['success'=>true,'products'=>$products]);

$db->close();
?>
