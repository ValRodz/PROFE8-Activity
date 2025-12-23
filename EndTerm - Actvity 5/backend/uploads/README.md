# Uploads Directory

This directory stores product images uploaded by sellers.

## Setup Instructions

1. Make sure this directory has write permissions (775 or 777)
2. The directory is automatically created by the upload script if it doesn't exist
3. Images are served at: `http://localhost/uploads/filename.jpg`

## Security Notes

- Only image files (jpg, jpeg, png, gif, webp) are allowed
- Maximum file size: 5MB
- Files are automatically renamed to prevent conflicts
- Consider adding authentication checks in production









