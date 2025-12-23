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
$buyer_id = isset($_GET['buyer_id']) ? $_GET['buyer_id'] : null;

if ($buyer_id) {
    $query = "SELECT * FROM orders WHERE buyer_id = ? ORDER BY created_at DESC";
    $stmt = $db->prepare($query);
    $stmt->bind_param('i', $buyer_id);
    $stmt->execute();
    $res = $stmt->get_result();
    $orders = [];
    while ($r = $res->fetch_assoc()) { $orders[] = $r; }
    echo json_encode(['success'=>true,'orders'=>$orders]);
    exit();
}

// For sellers: fetch orders that include seller's products
if ($seller_id) {
    $query = "SELECT o.* FROM orders o JOIN order_items oi ON oi.order_id = o.id JOIN products p ON p.id = oi.product_id WHERE p.seller_id = ? GROUP BY o.id ORDER BY o.created_at DESC";
    $stmt = $db->prepare($query);
    $stmt->bind_param('i', $seller_id);
    $stmt->execute();
    $res = $stmt->get_result();
    $orders = [];
    while ($r = $res->fetch_assoc()) { $orders[] = $r; }
    echo json_encode(['success'=>true,'orders'=>$orders]);
    exit();
}

// fallback: return recent orders
$query = "SELECT * FROM orders ORDER BY created_at DESC LIMIT 50";
$res = $db->query($query);
$orders = [];
while ($r = $res->fetch_assoc()) { $orders[] = $r; }
echo json_encode(['success'=>true,'orders'=>$orders]);

$db->close();
?>
