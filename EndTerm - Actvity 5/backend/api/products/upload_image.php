<?php
// Set CORS headers
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json');

// Handle preflight requests
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Only allow POST requests
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
    exit();
}

// Define upload directory
// For XAMPP: save to htdocs/uploads/ so files are accessible at http://localhost/uploads/
$uploadDir = __DIR__ . '/../../../uploads/';

// Create uploads directory if it doesn't exist
if (!is_dir($uploadDir)) {
    mkdir($uploadDir, 0775, true);
}

// Check if file was uploaded
if (empty($_FILES['file'])) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'No file uploaded']);
    exit();
}

// Validate file
$file = $_FILES['file'];
$allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
$maxSize = 5 * 1024 * 1024; // 5MB

// Check file type
$finfo = finfo_open(FILEINFO_MIME_TYPE);
$mimeType = finfo_file($finfo, $file['tmp_name']);
finfo_close($finfo);

if (!in_array($mimeType, $allowedTypes)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Invalid file type. Only images are allowed.']);
    exit();
}

// Check file size
if ($file['size'] > $maxSize) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'File too large. Maximum size is 5MB.']);
    exit();
}

// Generate unique filename
$originalName = basename($file['name']);
$extension = pathinfo($originalName, PATHINFO_EXTENSION);
$uniqueName = 'product_' . time() . '_' . bin2hex(random_bytes(4)) . '.' . $extension;
$targetPath = $uploadDir . $uniqueName;

// Move uploaded file
if (move_uploaded_file($file['tmp_name'], $targetPath)) {
    // Return public URL
    // For XAMPP: http://localhost/uploads/filename.jpg
    $protocol = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? 'https' : 'http';
    $host = $_SERVER['HTTP_HOST'];
    // Construct URL: backend/uploads is accessible at /uploads/ from root
    $publicUrl = "$protocol://$host/uploads/$uniqueName";
    
    http_response_code(200);
    echo json_encode([
        'success' => true,
        'url' => $publicUrl,
        'filename' => $uniqueName
    ]);
} else {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Failed to save file']);
}
?>

