package errors

// Error codes for the FileNode service
const (
	// Standard errors
	ErrInternal   = "ERR_INTERNAL"
	ErrInvalidArg = "ERR_INVALID_ARGUMENT"
	ErrNotFound   = "ERR_NOT_FOUND"
	ErrPermission = "ERR_PERMISSION_DENIED"

	// File errors
	ErrOutsideRoot   = "ERR_OUTSIDE_ROOT"   // Path traversal attempt or outside allowed roots
	ErrFileLocked    = "ERR_FILE_LOCKED"    // File is in use by another operation
	ErrAlreadyExists = "ERR_ALREADY_EXISTS" // File/folder already exists

	// Streaming/Pagination errors
	ErrInvalidResume = "ERR_INVALID_RESUME_TOKEN" // Resume token invalid or mismatch
	ErrPageToken     = "ERR_INVALID_PAGE_TOKEN"   // Page token invalid
	ErrOffset        = "ERR_INVALID_OFFSET"       // Offset beyond file size or negative
)
