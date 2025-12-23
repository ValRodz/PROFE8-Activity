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
if (empty($data->order_id) || empty($data->status)) { http_response_code(400); echo json_encode(['success'=>false,'message'=>'Missing fields']); exit(); }

$order_id = $data->order_id;
$status = $data->status;

$allowed = ['pending','shipped','completed','cancelled'];
if (!in_array($status, $allowed)) { http_response_code(400); echo json_encode(['success'=>false,'message'=>'Invalid status']); exit(); }

$stmt = $db->prepare("UPDATE orders SET status = ? WHERE id = ?");
$stmt->bind_param('si', $status, $order_id);
if ($stmt->execute()) { echo json_encode(['success'=>true]); } else { http_response_code(500); echo json_encode(['success'=>false,'message'=>'Update failed']); }

$db->close();
?>
