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
if (empty($data->id)) { http_response_code(400); echo json_encode(['success'=>false,'message'=>'Missing id']); exit(); }

$id = $data->id;
$query = "DELETE FROM products WHERE id = ?";
$stmt = $db->prepare($query);
$stmt->bind_param('i', $id);
if ($stmt->execute()) { echo json_encode(['success'=>true]); } else { http_response_code(500); echo json_encode(['success'=>false,'message'=>'Delete failed']); }

$db->close();
?>
