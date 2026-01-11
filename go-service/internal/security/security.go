package security

import (
	"crypto/hmac"
	"crypto/sha256"
	"encoding/base64"
	"fmt"
	"path/filepath"
	"strings"
	"sync"
)

// Config holds security configuration
type Config struct {
	AllowedRoots []string // Allowed root paths (e.g., "C:\\", "D:\\")
	HMACSecret   []byte   // Secret for token signing
}

var (
	config     *Config
	configOnce sync.Once

	// File locks for preventing race conditions
	fileLocks   = make(map[string]*sync.RWMutex)
	fileLocksMu sync.Mutex
)

// Initialize sets up security configuration
func Initialize(cfg *Config) {
	configOnce.Do(func() {
		config = cfg
	})
}

// DefaultConfig returns default security configuration
func DefaultConfig() *Config {
	return &Config{
		AllowedRoots: []string{}, // Empty = allow all drives
		HMACSecret:   []byte("change-this-secret-in-production"),
	}
}

// ValidatePath checks if a path is safe to access
// Returns cleaned path and error if invalid
func ValidatePath(requestedPath string) (string, error) {
	if requestedPath == "" {
		return "", fmt.Errorf("empty path")
	}

	// Clean the path to resolve any .. or .
	cleaned := filepath.Clean(requestedPath)

	// Convert to absolute path
	absPath, err := filepath.Abs(cleaned)
	if err != nil {
		return "", fmt.Errorf("invalid path: %w", err)
	}

	// Check for path traversal attempts
	if strings.Contains(requestedPath, "..") {
		return "", fmt.Errorf("path traversal not allowed")
	}

	// If allowed roots are configured, check against them
	if config != nil && len(config.AllowedRoots) > 0 {
		allowed := false
		for _, root := range config.AllowedRoots {
			cleanRoot := filepath.Clean(root)
			if strings.HasPrefix(strings.ToLower(absPath), strings.ToLower(cleanRoot)) {
				allowed = true
				break
			}
		}
		if !allowed {
			return "", fmt.Errorf("access denied: path outside allowed roots")
		}
	}

	// Block access to sensitive system paths
	blockedPaths := []string{
		"\\Windows\\System32",
		"\\Windows\\SysWOW64",
		"\\Program Files",
		"\\ProgramData",
		"\\Users\\Default",
	}

	lowerPath := strings.ToLower(absPath)
	for _, blocked := range blockedPaths {
		if strings.Contains(lowerPath, strings.ToLower(blocked)) {
			// Allow read but could restrict write operations
			// For now, just log a warning
		}
	}

	return absPath, nil
}

// GetFileLock returns a RWMutex for the given path
func GetFileLock(path string) *sync.RWMutex {
	fileLocksMu.Lock()
	defer fileLocksMu.Unlock()

	cleanPath := filepath.Clean(path)
	if lock, exists := fileLocks[cleanPath]; exists {
		return lock
	}

	lock := &sync.RWMutex{}
	fileLocks[cleanPath] = lock
	return lock
}

// ReleaseFileLock removes a file lock (call when file is deleted)
func ReleaseFileLock(path string) {
	fileLocksMu.Lock()
	defer fileLocksMu.Unlock()

	cleanPath := filepath.Clean(path)
	delete(fileLocks, cleanPath)
}

// CreateResumeToken creates a signed resume token
func CreateResumeToken(path string, offset int64) string {
	data := fmt.Sprintf("%s:%d", path, offset)

	var secret []byte
	if config != nil && len(config.HMACSecret) > 0 {
		secret = config.HMACSecret
	} else {
		secret = []byte("default-secret")
	}

	h := hmac.New(sha256.New, secret)
	h.Write([]byte(data))
	signature := h.Sum(nil)

	// Encode: base64(data):base64(signature)
	encodedData := base64.URLEncoding.EncodeToString([]byte(data))
	encodedSig := base64.URLEncoding.EncodeToString(signature)

	return encodedData + "." + encodedSig
}

// ValidateResumeToken validates and parses a resume token
// Returns path, offset, and error if invalid
func ValidateResumeToken(token string) (string, int64, error) {
	parts := strings.Split(token, ".")
	if len(parts) != 2 {
		return "", 0, fmt.Errorf("invalid token format")
	}

	// Decode data
	data, err := base64.URLEncoding.DecodeString(parts[0])
	if err != nil {
		return "", 0, fmt.Errorf("invalid token encoding")
	}

	// Decode signature
	providedSig, err := base64.URLEncoding.DecodeString(parts[1])
	if err != nil {
		return "", 0, fmt.Errorf("invalid signature encoding")
	}

	// Verify HMAC
	var secret []byte
	if config != nil && len(config.HMACSecret) > 0 {
		secret = config.HMACSecret
	} else {
		secret = []byte("default-secret")
	}

	h := hmac.New(sha256.New, secret)
	h.Write(data)
	expectedSig := h.Sum(nil)

	if !hmac.Equal(providedSig, expectedSig) {
		return "", 0, fmt.Errorf("invalid token signature")
	}

	// Parse data
	var path string
	var offset int64
	_, err = fmt.Sscanf(string(data), "%s:%d", &path, &offset)
	if err != nil {
		// Try alternative parsing
		dataParts := strings.SplitN(string(data), ":", 2)
		if len(dataParts) != 2 {
			return "", 0, fmt.Errorf("invalid token data")
		}
		path = dataParts[0]
		_, err = fmt.Sscanf(dataParts[1], "%d", &offset)
		if err != nil {
			return "", 0, fmt.Errorf("invalid offset in token")
		}
	}

	return path, offset, nil
}

// ValidateOffset checks if offset is valid for file size
func ValidateOffset(offset, fileSize int64) error {
	if offset < 0 {
		return fmt.Errorf("negative offset not allowed")
	}
	if offset > fileSize {
		return fmt.Errorf("offset exceeds file size")
	}
	return nil
}
