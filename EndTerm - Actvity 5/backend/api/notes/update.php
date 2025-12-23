<?php
// Set CORS headers
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json');

// Handle preflight requests
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

require_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

$data = json_decode(file_get_contents("php://input"));

if (!empty($data->id)) {
    
    $id = $data->id;
    $title = isset($data->title) ? $data->title : null;
    $content = isset($data->content) ? $data->content : null;
    $category = isset($data->category) ? $data->category : null;
    
    $updates = array();
    $types = "";
    $params = array();
    
    if ($title !== null) {
        $updates[] = "title = ?";
        $types .= "s";
        $params[] = $title;
    }
    if ($content !== null) {
        $updates[] = "content = ?";
        $types .= "s";
        $params[] = $content;
    }
    if ($category !== null) {
        $updates[] = "category = ?";
        $types .= "s";
        $params[] = $category;
    }
    
    if (count($updates) > 0) {
        $query = "UPDATE notes SET " . implode(", ", $updates) . " WHERE id = ?";
        $types .= "i";
        $params[] = $id;
        
        $stmt = $db->prepare($query);
        $stmt->bind_param($types, ...$params);
        
        if ($stmt->execute()) {
            http_response_code(200);
            echo json_encode(array(
                "success" => true,
                "message" => "Note updated successfully"
            ));
        } else {
            http_response_code(500);
            echo json_encode(array(
                "success" => false,
                "message" => "Unable to update note"
            ));
        }
    } else {
        http_response_code(400);
        echo json_encode(array(
            "success" => false,
            "message" => "No fields to update"
        ));
    }
    
} else {
    http_response_code(400);
    echo json_encode(array(
        "success" => false,
        "message" => "Note ID required"
    ));
}

$db->close();
?>
