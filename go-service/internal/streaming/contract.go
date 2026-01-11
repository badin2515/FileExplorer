package streaming

import (
	"fmt"
)

// Preview constants define standard preview sizes
const (
	// PreviewSizeImage is for image previews (thumbnails)
	PreviewSizeImage = 1 * 1024 * 1024 // 1MB

	// PreviewSizeVideo is for video previews (first chunk for playback start)
	PreviewSizeVideo = 2 * 1024 * 1024 // 2MB

	// PreviewSizeDocument is for document previews (PDF first pages, etc.)
	PreviewSizeDocument = 512 * 1024 // 512KB

	// PreviewSizeAudio is for audio previews (first seconds)
	PreviewSizeAudio = 1 * 1024 * 1024 // 1MB

	// DefaultPreviewSize is the fallback preview size
	DefaultPreviewSize = 1 * 1024 * 1024 // 1MB

	// MaxPreviewSize is the maximum allowed preview size
	MaxPreviewSize = 5 * 1024 * 1024 // 5MB
)

// StreamMode defines the streaming mode
type StreamMode int

const (
	// ModeDownload streams the entire file from offset 0 (or requested offset) to EOF.
	// Triggered when Length == 0.
	ModeDownload StreamMode = iota

	// ModePreview streams a limited portion of the file for preview purposes.
	// Triggered when Length > 0 and Length <= MaxPreviewSize.
	// Server guarantees to stop streaming after Length bytes.
	ModePreview

	// ModeRange streams a specific byte range.
	// Triggered when Length > MaxPreviewSize (explicit range request).
	ModeRange
)

// StreamRequest represents a validated streaming request
type StreamRequest struct {
	Mode        StreamMode
	Path        string
	Offset      int64
	Length      int64
	ChunkSize   int
	ResumeToken string
}

// ParseStreamRequest determines the streaming mode and validates the request
//
// Contract:
//
//  1. Full Download:
//     - Input: length = 0
//     - Behavior: Streams from offset to end of file.
//
//  2. Preview:
//     - Input: length > 0 && length <= MaxPreviewSize (5MB)
//     - Behavior: Streams exactly 'length' bytes (or until EOF).
//
//  3. Range Request:
//     - Input: length > MaxPreviewSize
//     - Behavior: Streams exactly 'length' bytes (explicit range).
//
//  4. Resume/Seek:
//     - Input: offset > 0
//     - Behavior: Starts reading from 'offset'. Combined with above modes.
func ParseStreamRequest(path string, offset, length int64, chunkSize int, mimeType string) (*StreamRequest, error) {
	req := &StreamRequest{
		Path:      path,
		Offset:    offset,
		ChunkSize: chunkSize,
	}

	// Validate chunk size
	if req.ChunkSize <= 0 {
		req.ChunkSize = 256 * 1024 // Default 256KB
	}
	if req.ChunkSize > 1024*1024 {
		req.ChunkSize = 1024 * 1024 // Max 1MB chunks
	}

	// Determine mode based on contract
	if length == 0 {
		req.Mode = ModeDownload
		req.Length = 0 // Will be set to file size by caller
	} else if length <= MaxPreviewSize {
		req.Mode = ModePreview
		req.Length = length
	} else {
		req.Mode = ModeRange
		req.Length = length
	}

	return req, nil
}

// GetPreviewSize returns the appropriate preview size for a given MIME type
func GetPreviewSize(mimeType string) int64 {
	switch {
	case isImageMimeType(mimeType):
		return PreviewSizeImage
	case isVideoMimeType(mimeType):
		return PreviewSizeVideo
	case isAudioMimeType(mimeType):
		return PreviewSizeAudio
	case isDocumentMimeType(mimeType):
		return PreviewSizeDocument
	default:
		return DefaultPreviewSize
	}
}

// ValidatePreviewRequest validates a preview request
func ValidatePreviewRequest(length int64, mimeType string) (int64, error) {
	if length <= 0 {
		// Use default preview size for the MIME type
		return GetPreviewSize(mimeType), nil
	}

	if length > MaxPreviewSize {
		return 0, fmt.Errorf("preview size exceeds maximum (%d bytes)", MaxPreviewSize)
	}

	return length, nil
}

// Helper functions for MIME type detection
func isImageMimeType(mimeType string) bool {
	switch mimeType {
	case "image/jpeg", "image/png", "image/gif", "image/webp", "image/bmp", "image/svg+xml":
		return true
	}
	return false
}

func isVideoMimeType(mimeType string) bool {
	switch mimeType {
	case "video/mp4", "video/webm", "video/x-matroska", "video/quicktime", "video/x-msvideo":
		return true
	}
	return false
}

func isAudioMimeType(mimeType string) bool {
	switch mimeType {
	case "audio/mpeg", "audio/wav", "audio/ogg", "audio/flac", "audio/aac":
		return true
	}
	return false
}

func isDocumentMimeType(mimeType string) bool {
	switch mimeType {
	case "application/pdf", "application/msword",
		"application/vnd.openxmlformats-officedocument.wordprocessingml.document",
		"application/vnd.ms-excel",
		"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet":
		return true
	}
	return false
}
