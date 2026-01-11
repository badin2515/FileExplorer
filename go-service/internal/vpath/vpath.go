package vpath

import (
	"fmt"
	"path/filepath"
	"strings"
	"sync"
)

// VirtualPathMapper handles translation between virtual and real paths
// Client sees: /root/folder/file.txt
// Server uses: D:\FileExplorerRoot\folder\file.txt
type VirtualPathMapper struct {
	mu         sync.RWMutex
	mounts     map[string]string // virtualPrefix -> realPath
	reverseLUT map[string]string // realPath -> virtualPrefix (for reverse lookup)
}

var (
	defaultMapper *VirtualPathMapper
	mapperOnce    sync.Once
)

// GetMapper returns the singleton path mapper
func GetMapper() *VirtualPathMapper {
	mapperOnce.Do(func() {
		defaultMapper = NewVirtualPathMapper()
	})
	return defaultMapper
}

// NewVirtualPathMapper creates a new path mapper
func NewVirtualPathMapper() *VirtualPathMapper {
	return &VirtualPathMapper{
		mounts:     make(map[string]string),
		reverseLUT: make(map[string]string),
	}
}

// Mount adds a virtual path mapping
// Example: Mount("/drive_c", "C:\\") maps /drive_c/Users to C:\Users
func (m *VirtualPathMapper) Mount(virtualPrefix, realPath string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	// Normalize paths
	virtualPrefix = normalizePath(virtualPrefix)
	realPath = filepath.Clean(realPath)

	if virtualPrefix == "" {
		return fmt.Errorf("virtual prefix cannot be empty")
	}

	if realPath == "" {
		return fmt.Errorf("real path cannot be empty")
	}

	m.mounts[virtualPrefix] = realPath
	m.reverseLUT[strings.ToLower(realPath)] = virtualPrefix

	return nil
}

// Unmount removes a virtual path mapping
func (m *VirtualPathMapper) Unmount(virtualPrefix string) {
	m.mu.Lock()
	defer m.mu.Unlock()

	virtualPrefix = normalizePath(virtualPrefix)
	if realPath, ok := m.mounts[virtualPrefix]; ok {
		delete(m.reverseLUT, strings.ToLower(realPath))
	}
	delete(m.mounts, virtualPrefix)
}

// ToReal converts a virtual path to a real OS path
// /drive_c/Users/Test -> C:\Users\Test
func (m *VirtualPathMapper) ToReal(virtualPath string) (string, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	virtualPath = normalizePath(virtualPath)

	if virtualPath == "" || virtualPath == "/" {
		return "", fmt.Errorf("root listing not allowed, specify a mount point")
	}

	// Find matching mount
	for prefix, realBase := range m.mounts {
		if strings.HasPrefix(virtualPath, prefix) {
			remainder := strings.TrimPrefix(virtualPath, prefix)
			remainder = strings.TrimPrefix(remainder, "/")

			if remainder == "" {
				return realBase, nil
			}

			// Convert forward slashes to OS path separator
			remainder = strings.ReplaceAll(remainder, "/", string(filepath.Separator))
			return filepath.Join(realBase, remainder), nil
		}
	}

	return "", fmt.Errorf("no mount found for path: %s", virtualPath)
}

// ToVirtual converts a real OS path to a virtual path
// C:\Users\Test -> /drive_c/Users/Test
func (m *VirtualPathMapper) ToVirtual(realPath string) (string, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	realPath = filepath.Clean(realPath)
	realPathLower := strings.ToLower(realPath)

	// Find matching mount
	for realBase, virtualPrefix := range m.reverseLUT {
		if strings.HasPrefix(realPathLower, realBase) {
			remainder := realPath[len(realBase):]
			remainder = strings.TrimPrefix(remainder, string(filepath.Separator))

			if remainder == "" {
				return virtualPrefix, nil
			}

			// Convert OS separators to forward slashes
			remainder = strings.ReplaceAll(remainder, string(filepath.Separator), "/")
			return virtualPrefix + "/" + remainder, nil
		}
	}

	return "", fmt.Errorf("no mount found for path: %s", realPath)
}

// ListMounts returns all current mounts
func (m *VirtualPathMapper) ListMounts() map[string]string {
	m.mu.RLock()
	defer m.mu.RUnlock()

	result := make(map[string]string, len(m.mounts))
	for k, v := range m.mounts {
		result[k] = v
	}
	return result
}

// SetupDefaultMounts creates default mounts for Windows drives
func (m *VirtualPathMapper) SetupDefaultMounts(drives []string) {
	for _, drive := range drives {
		// Convert "C:" to "/drive_c"
		if len(drive) >= 2 && drive[1] == ':' {
			letter := strings.ToLower(string(drive[0]))
			virtualPrefix := "/drive_" + letter
			realPath := drive
			if !strings.HasSuffix(realPath, "\\") {
				realPath += "\\"
			}
			m.Mount(virtualPrefix, realPath)
		}
	}
}

// normalizePath ensures path starts with / and uses forward slashes
func normalizePath(path string) string {
	path = strings.ReplaceAll(path, "\\", "/")
	path = strings.TrimSuffix(path, "/")
	if !strings.HasPrefix(path, "/") {
		path = "/" + path
	}
	return path
}
