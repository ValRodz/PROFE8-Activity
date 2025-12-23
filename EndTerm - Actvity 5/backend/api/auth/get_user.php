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
if (empty($data->firebase_uid)) { http_response_code(400); echo json_encode(['success'=>false,'message'=>'Missing firebase_uid']); exit(); }

$firebase_uid = $data->firebase_uid;
$query = "SELECT id, firebase_uid, username, email, full_name, role_id, created_at FROM users WHERE firebase_uid = ?";
$stmt = $db->prepare($query);
$stmt->bind_param('s', $firebase_uid);
$stmt->execute();
$res = $stmt->get_result();
if ($res->num_rows > 0) {
    $row = $res->fetch_assoc();
    echo json_encode(['success'=>true,'user'=>$row]);
} else {
    http_response_code(404);
    echo json_encode(['success'=>false,'message'=>'User not found']);
}

$db->close();
?>
