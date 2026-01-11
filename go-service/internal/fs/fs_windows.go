package fs

import (
	"os"
	"path/filepath"
	"strings"
	"syscall"
	"unsafe"

	"github.com/google/uuid"
	"github.com/h2non/filetype"
	pb "github.com/user/filenode/pkg/proto"
)

// Operations handles filesystem operations
type Operations struct {
	deviceID string
}

// NewOperations creates a new Operations instance
func NewOperations() *Operations {
	return &Operations{
		deviceID: getOrCreateDeviceID(),
	}
}

// GetDeviceID returns the unique device identifier
func GetDeviceID() string {
	return getOrCreateDeviceID()
}

func getOrCreateDeviceID() string {
	// Try to read existing device ID
	configDir, err := os.UserConfigDir()
	if err != nil {
		return uuid.New().String()
	}

	idFile := filepath.Join(configDir, "filenode", "device_id")

	// Try to read existing ID
	data, err := os.ReadFile(idFile)
	if err == nil && len(data) > 0 {
		return strings.TrimSpace(string(data))
	}

	// Generate new ID
	newID := uuid.New().String()

	// Save it
	os.MkdirAll(filepath.Dir(idFile), 0755)
	os.WriteFile(idFile, []byte(newID), 0644)

	return newID
}

// GetMimeType returns the MIME type of a file
func GetMimeType(path string) string {
	// First try by extension
	ext := strings.ToLower(filepath.Ext(path))
	if mimeType, ok := extensionMimeTypes[ext]; ok {
		return mimeType
	}

	// Try reading file header
	f, err := os.Open(path)
	if err != nil {
		return "application/octet-stream"
	}
	defer f.Close()

	// Read first 261 bytes for detection
	head := make([]byte, 261)
	n, err := f.Read(head)
	if err != nil || n == 0 {
		return "application/octet-stream"
	}

	kind, err := filetype.Match(head[:n])
	if err != nil || kind == filetype.Unknown {
		// Check if it might be text
		if isTextFile(head[:n]) {
			return "text/plain"
		}
		return "application/octet-stream"
	}

	return kind.MIME.Value
}

// isTextFile checks if content appears to be text
func isTextFile(data []byte) bool {
	for _, b := range data {
		if b == 0 {
			return false // Null byte = binary
		}
	}
	return true
}

// Common MIME types by extension
var extensionMimeTypes = map[string]string{
	".txt":  "text/plain",
	".html": "text/html",
	".htm":  "text/html",
	".css":  "text/css",
	".js":   "text/javascript",
	".json": "application/json",
	".xml":  "application/xml",
	".pdf":  "application/pdf",
	".zip":  "application/zip",
	".rar":  "application/x-rar-compressed",
	".7z":   "application/x-7z-compressed",
	".tar":  "application/x-tar",
	".gz":   "application/gzip",
	".jpg":  "image/jpeg",
	".jpeg": "image/jpeg",
	".png":  "image/png",
	".gif":  "image/gif",
	".bmp":  "image/bmp",
	".webp": "image/webp",
	".svg":  "image/svg+xml",
	".ico":  "image/x-icon",
	".mp3":  "audio/mpeg",
	".wav":  "audio/wav",
	".ogg":  "audio/ogg",
	".flac": "audio/flac",
	".mp4":  "video/mp4",
	".avi":  "video/x-msvideo",
	".mkv":  "video/x-matroska",
	".webm": "video/webm",
	".mov":  "video/quicktime",
	".doc":  "application/msword",
	".docx": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
	".xls":  "application/vnd.ms-excel",
	".xlsx": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
	".ppt":  "application/vnd.ms-powerpoint",
	".pptx": "application/vnd.openxmlformats-officedocument.presentationml.presentation",
	".go":   "text/x-go",
	".py":   "text/x-python",
	".rs":   "text/x-rust",
	".java": "text/x-java",
	".c":    "text/x-c",
	".cpp":  "text/x-c++",
	".h":    "text/x-c",
	".md":   "text/markdown",
	".yaml": "text/yaml",
	".yml":  "text/yaml",
	".toml": "text/toml",
}

// IsHidden checks if a file is hidden (Windows-specific)
func IsHidden(path string) bool {
	pointer, err := syscall.UTF16PtrFromString(path)
	if err != nil {
		return false
	}

	attrs, err := syscall.GetFileAttributes(pointer)
	if err != nil {
		return false
	}

	return attrs&syscall.FILE_ATTRIBUTE_HIDDEN != 0
}

// IsReadOnly checks if a file is read-only
func IsReadOnly(info os.FileInfo) bool {
	return info.Mode().Perm()&0200 == 0
}

// GetFileTimes returns creation and access times (Windows-specific)
func GetFileTimes(path string) (createdAt, accessedAt int64) {
	pointer, err := syscall.UTF16PtrFromString(path)
	if err != nil {
		return 0, 0
	}

	handle, err := syscall.CreateFile(
		pointer,
		syscall.GENERIC_READ,
		syscall.FILE_SHARE_READ|syscall.FILE_SHARE_WRITE,
		nil,
		syscall.OPEN_EXISTING,
		syscall.FILE_FLAG_BACKUP_SEMANTICS,
		0,
	)
	if err != nil {
		return 0, 0
	}
	defer syscall.CloseHandle(handle)

	kernel32 := syscall.NewLazyDLL("kernel32.dll")
	getFileTime := kernel32.NewProc("GetFileTime")

	var cTime, aTime, wTime syscall.Filetime
	ret, _, _ := getFileTime.Call(
		uintptr(handle),
		uintptr(unsafe.Pointer(&cTime)),
		uintptr(unsafe.Pointer(&aTime)),
		uintptr(unsafe.Pointer(&wTime)),
	)
	if ret == 0 {
		return 0, 0
	}

	return filetimeToUnixMilli(cTime), filetimeToUnixMilli(aTime)
}

func filetimeToUnixMilli(ft syscall.Filetime) int64 {
	// Windows FILETIME is 100-nanosecond intervals since January 1, 1601
	// Unix epoch is January 1, 1970
	const epochDiff = 116444736000000000 // 100-ns intervals between 1601 and 1970
	intervals := int64(ft.HighDateTime)<<32 + int64(ft.LowDateTime)
	return (intervals - epochDiff) / 10000 // Convert to milliseconds
}

// GetDrives returns list of available drives (Windows-specific)
func GetDrives() ([]*pb.DriveInfo, error) {
	kernel32 := syscall.NewLazyDLL("kernel32.dll")
	getLogicalDrives := kernel32.NewProc("GetLogicalDrives")
	getDriveTypeW := kernel32.NewProc("GetDriveTypeW")
	getDiskFreeSpaceExW := kernel32.NewProc("GetDiskFreeSpaceExW")
	getVolumeInformationW := kernel32.NewProc("GetVolumeInformationW")

	bitmask, _, _ := getLogicalDrives.Call()

	var drives []*pb.DriveInfo

	for i := 0; i < 26; i++ {
		if bitmask&(1<<uint(i)) == 0 {
			continue
		}

		letter := string(rune('A' + i))
		path := letter + ":\\"
		pathPtr, _ := syscall.UTF16PtrFromString(path)

		// Get drive type
		driveType, _, _ := getDriveTypeW.Call(uintptr(unsafe.Pointer(pathPtr)))

		// Skip if not ready (e.g., empty CD drive)
		if driveType == 0 || driveType == 1 { // DRIVE_UNKNOWN or DRIVE_NO_ROOT_DIR
			continue
		}

		isRemovable := driveType == 2 // DRIVE_REMOVABLE

		// Get free space
		var freeBytesAvailable, totalBytes, totalFreeBytes uint64
		getDiskFreeSpaceExW.Call(
			uintptr(unsafe.Pointer(pathPtr)),
			uintptr(unsafe.Pointer(&freeBytesAvailable)),
			uintptr(unsafe.Pointer(&totalBytes)),
			uintptr(unsafe.Pointer(&totalFreeBytes)),
		)

		// Get volume label
		labelBuf := make([]uint16, 256)
		getVolumeInformationW.Call(
			uintptr(unsafe.Pointer(pathPtr)),
			uintptr(unsafe.Pointer(&labelBuf[0])),
			256,
			0, 0, 0, 0, 0,
		)
		label := syscall.UTF16ToString(labelBuf)
		if label == "" {
			label = "Local Disk"
		}

		drives = append(drives, &pb.DriveInfo{
			Name:        letter + ":",
			Path:        path,
			Label:       label,
			TotalSpace:  int64(totalBytes),
			FreeSpace:   int64(freeBytesAvailable),
			IsRemovable: isRemovable,
		})
	}

	return drives, nil
}

// MoveToTrash moves a file to the Windows Recycle Bin
func MoveToTrash(path string) error {
	shell32 := syscall.NewLazyDLL("shell32.dll")
	shFileOperationW := shell32.NewProc("SHFileOperationW")

	// SHFILEOPSTRUCT
	type SHFILEOPSTRUCT struct {
		hwnd                  uintptr
		wFunc                 uint32
		pFrom                 *uint16
		pTo                   *uint16
		fFlags                uint16
		fAnyOperationsAborted int32
		hNameMappings         uintptr
		lpszProgressTitle     *uint16
	}

	const (
		FO_DELETE          = 0x0003
		FOF_ALLOWUNDO      = 0x0040
		FOF_NOCONFIRMATION = 0x0010
		FOF_SILENT         = 0x0004
	)

	// Path must be double-null terminated
	pathBuf, _ := syscall.UTF16FromString(path + "\x00")

	op := SHFILEOPSTRUCT{
		wFunc:  FO_DELETE,
		pFrom:  &pathBuf[0],
		fFlags: FOF_ALLOWUNDO | FOF_NOCONFIRMATION | FOF_SILENT,
	}

	ret, _, _ := shFileOperationW.Call(uintptr(unsafe.Pointer(&op)))
	if ret != 0 {
		return os.Remove(path) // Fallback to permanent delete
	}

	return nil
}
