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

// Support two registration flows:
// 1) Firebase-driven: client creates Firebase user, then calls this endpoint with firebase_uid and profile data (password optional)
// 2) Traditional: username/email/password/full_name provided

if (!empty($data->firebase_uid)) {
    $firebase_uid = $data->firebase_uid;
    $username = isset($data->username) ? $data->username : null;
    $email = isset($data->email) ? $data->email : null;
    $full_name = isset($data->full_name) ? $data->full_name : null;
    $role_id = isset($data->role_id) ? intval($data->role_id) : 1;

    // Check if firebase_uid or username/email exists
    $check_query = "SELECT id FROM users WHERE firebase_uid = ? OR username = ? OR email = ?";
    $check_stmt = $db->prepare($check_query);
    $check_stmt->bind_param("sss", $firebase_uid, $username, $email);
    $check_stmt->execute();
    $result = $check_stmt->get_result();

    if ($result->num_rows > 0) {
        http_response_code(409);
        echo json_encode(array("success" => false, "message" => "User already exists"));
    } else {
        $query = "INSERT INTO users (firebase_uid, username, email, full_name, role_id) VALUES (?, ?, ?, ?, ?)";
        $stmt = $db->prepare($query);
        $stmt->bind_param("ssssi", $firebase_uid, $username, $email, $full_name, $role_id);
        if ($stmt->execute()) {
            http_response_code(201);
            echo json_encode(array("success" => true, "message" => "User registered","user_id" => $db->insert_id));
        } else {
            http_response_code(500);
            echo json_encode(array("success" => false, "message" => "Unable to register user"));
        }
    }

} elseif (!empty($data->username) && !empty($data->email) && !empty($data->password) && !empty($data->full_name)) {
    $username = $data->username;
    $email = $data->email;
    $password = password_hash($data->password, PASSWORD_DEFAULT);
    $full_name = $data->full_name;
    $role_id = isset($data->role_id) ? intval($data->role_id) : 1;

    // Check if username or email already exists
    $check_query = "SELECT id FROM users WHERE username = ? OR email = ?";
    $check_stmt = $db->prepare($check_query);
    $check_stmt->bind_param("ss", $username, $email);
    $check_stmt->execute();
    $result = $check_stmt->get_result();

    if ($result->num_rows > 0) {
        http_response_code(409);
        echo json_encode(array(
            "success" => false,
            "message" => "Username or email already exists"
        ));
    } else {
        $query = "INSERT INTO users (username, email, password, full_name, role_id) VALUES (?, ?, ?, ?, ?)";
        $stmt = $db->prepare($query);
        $stmt->bind_param("ssssi", $username, $email, $password, $full_name, $role_id);

        if ($stmt->execute()) {
            http_response_code(201);
            echo json_encode(array(
                "success" => true,
                "message" => "User registered successfully",
                "user_id" => $db->insert_id
            ));
        } else {
            http_response_code(500);
            echo json_encode(array(
                "success" => false,
                "message" => "Unable to register user"
            ));
        }
    }

} else {
    http_response_code(400);
    echo json_encode(array(
        "success" => false,
        "message" => "Incomplete data. Provide firebase_uid or username,email,password,full_name"
    ));
}

$db->close();
?>
