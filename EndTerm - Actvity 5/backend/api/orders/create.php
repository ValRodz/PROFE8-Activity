<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(200); exit(); }

require_once '../../config/database.php';
$database = new Database();
$db = $database->getConnection();

$data = json_decode(file_get_contents('php://input'));
if (empty($data->buyer_id) || empty($data->items) || !is_array($data->items)) {
    http_response_code(400); echo json_encode(['success'=>false,'message'=>'Invalid payload']); exit();
}

$buyer_id = $data->buyer_id;
$items = $data->items; // array of {product_id, quantity}

$total = 0.0;
foreach ($items as $it) { $total += ($it->price ?? 0) * ($it->quantity ?? 1); }

$db->begin_transaction();
try {
    $stmt = $db->prepare("INSERT INTO orders (buyer_id, total) VALUES (?, ?)");
    $stmt->bind_param('id', $buyer_id, $total);
    $stmt->execute();
    $order_id = $db->insert_id;

    $stmt_item = $db->prepare("INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)");
    foreach ($items as $it) {
        $pid = $it->product_id; $qty = $it->quantity; $price = $it->price;
        $stmt_item->bind_param('iiid', $order_id, $pid, $qty, $price);
        $stmt_item->execute();
        // reduce stock
        $upd = $db->prepare("UPDATE products SET stock = stock - ? WHERE id = ?");
        $upd->bind_param('ii', $qty, $pid);
        $upd->execute();
    }

    $db->commit();
    echo json_encode(['success'=>true,'order_id'=>$order_id]);
} catch (Exception $e) {
    $db->rollback();
    http_response_code(500); echo json_encode(['success'=>false,'message'=>'Order failed','error'=>$e->getMessage()]);
}

$db->close();
?>
