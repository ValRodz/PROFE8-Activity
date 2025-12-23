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

try {
    require_once '../../config/database.php';

    $database = new Database();
    $db = $database->getConnection();

    if (!$db) {
        throw new Exception("Database connection failed");
    }

    $user_id = isset($_GET['user_id']) ? $_GET['user_id'] : '';
    $note_id = isset($_GET['note_id']) ? $_GET['note_id'] : '';

    if (!empty($note_id)) {
        // Get specific note
        $query = "SELECT * FROM notes WHERE id = ?";
        $stmt = $db->prepare($query);

        if (!$stmt) {
            throw new Exception("Prepare failed: " . $db->error);
        }

        $stmt->bind_param("i", $note_id);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            $note = $result->fetch_assoc();
            http_response_code(200);
            echo json_encode(array(
                "success" => true,
                "note" => $note
            ));
        } else {
            http_response_code(404);
            echo json_encode(array(
                "success" => false,
                "message" => "Note not found"
            ));
        }
        $stmt->close();
    } elseif (!empty($user_id)) {
        // Get all notes for a user
        $query = "SELECT * FROM notes WHERE user_id = ? ORDER BY created_at DESC";
        $stmt = $db->prepare($query);

        if (!$stmt) {
            throw new Exception("Prepare failed: " . $db->error);
        }

        $stmt->bind_param("i", $user_id);
        $stmt->execute();
        $result = $stmt->get_result();

        $notes = array();
        while ($row = $result->fetch_assoc()) {
            $notes[] = $row;
        }

        http_response_code(200);
        echo json_encode(array(
            "success" => true,
            "notes" => $notes
        ));
        $stmt->close();
    } else {
        http_response_code(400);
        echo json_encode(array(
            "success" => false,
            "message" => "user_id or note_id required"
        ));
    }

    $db->close();
} catch(Exception $e) {
    http_response_code(500);
    echo json_encode(array(
        "success" => false,
        "message" => "Server error: " . $e->getMessage()
    ));
}
?>
