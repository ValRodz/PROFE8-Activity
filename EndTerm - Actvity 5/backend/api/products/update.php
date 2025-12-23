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
if (empty($data->id)) { http_response_code(400); echo json_encode(['success'=>false,'message'=>'Missing product id']); exit(); }

$id = $data->id;
$fields = [];
$types = '';
$values = [];

foreach (['name','description','price','image_url','stock'] as $f) {
    if (isset($data->{$f})) { $fields[] = "$f = ?"; $values[] = $data->{$f}; }
}

if (empty($fields)) { echo json_encode(['success'=>false,'message'=>'Nothing to update']); exit(); }

$query = "UPDATE products SET " . implode(', ', $fields) . " WHERE id = ?";
$stmt = $db->prepare($query);

// build dynamic bind_param
$types = str_repeat('s', count($values)) . 'i';
$bind_values = array_merge($values, [$id]);
$stmt->bind_param($types, ...$bind_values);

if ($stmt->execute()) { echo json_encode(['success'=>true]); } else { http_response_code(500); echo json_encode(['success'=>false,'message'=>'Update failed']); }

$db->close();
?>
