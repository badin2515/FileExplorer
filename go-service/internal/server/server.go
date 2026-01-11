package server

import (
	"context"
	"io"
	"log"
	"os"
	"path/filepath"
	"sort"
	"strings"

	"github.com/user/filenode/internal/fs"
	"github.com/user/filenode/internal/security"
	pb "github.com/user/filenode/pkg/proto"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// FileNodeServer implements the FileNode gRPC service
type FileNodeServer struct {
	pb.UnimplementedFileNodeServer
	fsOps *fs.Operations
}

// NewFileNodeServer creates a new FileNode server instance
func NewFileNodeServer() *FileNodeServer {
	// Initialize security with default config
	security.Initialize(security.DefaultConfig())

	return &FileNodeServer{
		fsOps: fs.NewOperations(),
	}
}

// validatePath validates and cleans a path, returning error if invalid
func validatePath(path string) (string, error) {
	if path == "" {
		return "", status.Error(codes.InvalidArgument, "path is required")
	}

	cleanPath, err := security.ValidatePath(path)
	if err != nil {
		return "", status.Error(codes.PermissionDenied, err.Error())
	}

	return cleanPath, nil
}

// ListDir streams directory contents
func (s *FileNodeServer) ListDir(req *pb.ListDirRequest, stream pb.FileNode_ListDirServer) error {
	path, err := validatePath(req.Path)
	if err != nil {
		return err
	}

	// Check context cancellation
	ctx := stream.Context()
	select {
	case <-ctx.Done():
		return ctx.Err()
	default:
	}

	// Check if path exists
	info, err := os.Stat(path)
	if err != nil {
		if os.IsNotExist(err) {
			return status.Error(codes.NotFound, "path not found")
		}
		return status.Error(codes.Internal, err.Error())
	}

	if !info.IsDir() {
		return status.Error(codes.InvalidArgument, "path is not a directory")
	}

	// Read directory
	entries, err := os.ReadDir(path)
	if err != nil {
		return status.Error(codes.PermissionDenied, err.Error())
	}

	// Convert to FileEntry slice for sorting
	var fileEntries []*pb.FileEntry
	for _, entry := range entries {
		// Check context cancellation periodically
		select {
		case <-ctx.Done():
			return ctx.Err()
		default:
		}

		// Skip hidden files if not requested
		if !req.ShowHidden && strings.HasPrefix(entry.Name(), ".") {
			continue
		}

		info, err := entry.Info()
		if err != nil {
			continue // Skip files we can't stat
		}

		fullPath := filepath.Join(path, entry.Name())
		ext := ""
		if !entry.IsDir() {
			ext = strings.TrimPrefix(filepath.Ext(entry.Name()), ".")
		}

		fileEntry := &pb.FileEntry{
			Id:          fullPath, // Use path as ID for Windows
			Name:        entry.Name(),
			Path:        fullPath,
			DisplayPath: fullPath,
			IsDir:       entry.IsDir(),
			Size:        info.Size(),
			ModifiedAt:  info.ModTime().UnixMilli(),
			Extension:   ext,
			MimeType:    fs.GetMimeType(fullPath),
			IsHidden:    strings.HasPrefix(entry.Name(), ".") || fs.IsHidden(fullPath),
			IsReadonly:  fs.IsReadOnly(info),
		}

		fileEntries = append(fileEntries, fileEntry)
	}

	// Sort entries
	sortEntries(fileEntries, req.SortBy, req.SortOrder)

	// Stream entries
	for _, entry := range fileEntries {
		select {
		case <-ctx.Done():
			return ctx.Err()
		default:
		}

		if err := stream.Send(entry); err != nil {
			return err
		}
	}

	log.Printf("ListDir: %s - returned %d entries", path, len(fileEntries))
	return nil
}

// Stat returns file/directory information
func (s *FileNodeServer) Stat(ctx context.Context, req *pb.StatRequest) (*pb.FileInfo, error) {
	path, err := validatePath(req.Path)
	if err != nil {
		return nil, err
	}

	info, err := os.Stat(path)
	if err != nil {
		if os.IsNotExist(err) {
			return nil, status.Error(codes.NotFound, "path not found")
		}
		return nil, status.Error(codes.Internal, err.Error())
	}

	ext := ""
	if !info.IsDir() {
		ext = strings.TrimPrefix(filepath.Ext(path), ".")
	}

	entry := &pb.FileEntry{
		Id:          path,
		Name:        info.Name(),
		Path:        path,
		DisplayPath: path,
		IsDir:       info.IsDir(),
		Size:        info.Size(),
		ModifiedAt:  info.ModTime().UnixMilli(),
		Extension:   ext,
		MimeType:    fs.GetMimeType(path),
		IsHidden:    fs.IsHidden(path),
		IsReadonly:  fs.IsReadOnly(info),
	}

	// Get additional info (platform-specific)
	createdAt, accessedAt := fs.GetFileTimes(path)

	return &pb.FileInfo{
		Entry:      entry,
		CreatedAt:  createdAt,
		AccessedAt: accessedAt,
		IsLocked:   false,
		LockedBy:   "",
		Checksum:   "", // Computed on demand
	}, nil
}

// GetDrives returns list of available drives
func (s *FileNodeServer) GetDrives(ctx context.Context, req *pb.Empty) (*pb.DriveList, error) {
	drives, err := fs.GetDrives()
	if err != nil {
		return nil, status.Error(codes.Internal, err.Error())
	}

	log.Printf("GetDrives: returned %d drives", len(drives))
	return &pb.DriveList{Drives: drives}, nil
}

// GetDeviceInfo returns device information
func (s *FileNodeServer) GetDeviceInfo(ctx context.Context, req *pb.Empty) (*pb.DeviceInfo, error) {
	hostname, _ := os.Hostname()

	return &pb.DeviceInfo{
		DeviceId:     fs.GetDeviceID(),
		DeviceName:   hostname,
		Platform:     "windows",
		Version:      "1.0.0",
		TotalStorage: 0, // TODO: Calculate
		FreeStorage:  0,
	}, nil
}

// CreateDir creates a new directory
func (s *FileNodeServer) CreateDir(ctx context.Context, req *pb.CreateDirRequest) (*pb.OperationResult, error) {
	path, err := validatePath(req.Path)
	if err != nil {
		return &pb.OperationResult{
			Success:   false,
			Message:   err.Error(),
			ErrorCode: "PERMISSION_DENIED",
		}, nil
	}

	// Get file lock
	lock := security.GetFileLock(path)
	lock.Lock()
	defer lock.Unlock()

	if req.Recursive {
		err = os.MkdirAll(path, 0755)
	} else {
		err = os.Mkdir(path, 0755)
	}

	if err != nil {
		return &pb.OperationResult{
			Success:   false,
			Message:   err.Error(),
			ErrorCode: "CREATE_FAILED",
		}, nil
	}

	log.Printf("CreateDir: %s", path)
	return &pb.OperationResult{
		Success: true,
		Message: "Directory created",
	}, nil
}

// CreateFile creates a new file
func (s *FileNodeServer) CreateFile(ctx context.Context, req *pb.CreateFileRequest) (*pb.OperationResult, error) {
	path, err := validatePath(req.Path)
	if err != nil {
		return &pb.OperationResult{
			Success:   false,
			Message:   err.Error(),
			ErrorCode: "PERMISSION_DENIED",
		}, nil
	}

	// Get file lock
	lock := security.GetFileLock(path)
	lock.Lock()
	defer lock.Unlock()

	// Check if file exists
	if _, statErr := os.Stat(path); statErr == nil {
		return &pb.OperationResult{
			Success:   false,
			Message:   "File already exists",
			ErrorCode: "ALREADY_EXISTS",
		}, nil
	}

	// Create file
	f, err := os.Create(path)
	if err != nil {
		return &pb.OperationResult{
			Success:   false,
			Message:   err.Error(),
			ErrorCode: "CREATE_FAILED",
		}, nil
	}
	defer f.Close()

	// Write content if provided
	if len(req.Content) > 0 {
		if _, writeErr := f.Write(req.Content); writeErr != nil {
			return &pb.OperationResult{
				Success:   false,
				Message:   writeErr.Error(),
				ErrorCode: "WRITE_FAILED",
			}, nil
		}
	}

	log.Printf("CreateFile: %s", path)
	return &pb.OperationResult{
		Success: true,
		Message: "File created",
	}, nil
}

// Delete removes files or directories
func (s *FileNodeServer) Delete(ctx context.Context, req *pb.DeleteRequest) (*pb.OperationResult, error) {
	for _, reqPath := range req.Paths {
		path, err := validatePath(reqPath)
		if err != nil {
			return &pb.OperationResult{
				Success:   false,
				Message:   err.Error(),
				ErrorCode: "PERMISSION_DENIED",
			}, nil
		}

		// Get file lock
		lock := security.GetFileLock(path)
		lock.Lock()

		if req.Permanent {
			// Permanent delete
			info, statErr := os.Stat(path)
			if statErr != nil {
				lock.Unlock()
				continue
			}
			if info.IsDir() {
				err = os.RemoveAll(path)
			} else {
				err = os.Remove(path)
			}
		} else {
			// Move to recycle bin (Windows-specific)
			err = fs.MoveToTrash(path)
		}

		lock.Unlock()
		security.ReleaseFileLock(path) // Clean up lock after delete

		if err != nil {
			return &pb.OperationResult{
				Success:   false,
				Message:   err.Error(),
				ErrorCode: "DELETE_FAILED",
			}, nil
		}

		log.Printf("Delete: %s (permanent=%v)", path, req.Permanent)
	}

	return &pb.OperationResult{
		Success: true,
		Message: "Deleted successfully",
	}, nil
}

// Rename renames a file or directory
func (s *FileNodeServer) Rename(ctx context.Context, req *pb.RenameRequest) (*pb.OperationResult, error) {
	oldPath, err := validatePath(req.Path)
	if err != nil {
		return &pb.OperationResult{
			Success:   false,
			Message:   err.Error(),
			ErrorCode: "PERMISSION_DENIED",
		}, nil
	}

	newPath := filepath.Join(filepath.Dir(oldPath), req.NewName)

	// Validate new path too
	if _, validateErr := validatePath(newPath); validateErr != nil {
		return &pb.OperationResult{
			Success:   false,
			Message:   validateErr.Error(),
			ErrorCode: "PERMISSION_DENIED",
		}, nil
	}

	// Get locks for both paths
	oldLock := security.GetFileLock(oldPath)
	newLock := security.GetFileLock(newPath)

	oldLock.Lock()
	defer oldLock.Unlock()
	newLock.Lock()
	defer newLock.Unlock()

	// Check if target exists
	if _, statErr := os.Stat(newPath); statErr == nil {
		return &pb.OperationResult{
			Success:   false,
			Message:   "Target already exists",
			ErrorCode: "ALREADY_EXISTS",
		}, nil
	}

	if renameErr := os.Rename(oldPath, newPath); renameErr != nil {
		return &pb.OperationResult{
			Success:   false,
			Message:   renameErr.Error(),
			ErrorCode: "RENAME_FAILED",
		}, nil
	}

	// Release old lock
	security.ReleaseFileLock(oldPath)

	log.Printf("Rename: %s -> %s", oldPath, newPath)
	return &pb.OperationResult{
		Success: true,
		Message: "Renamed successfully",
	}, nil
}

// StreamFile streams file content to client
func (s *FileNodeServer) StreamFile(req *pb.StreamFileRequest, stream pb.FileNode_StreamFileServer) error {
	path, err := validatePath(req.Path)
	if err != nil {
		return err
	}

	// Get read lock (allows concurrent reads)
	lock := security.GetFileLock(path)
	lock.RLock()
	defer lock.RUnlock()

	// Open file
	f, err := os.Open(path)
	if err != nil {
		if os.IsNotExist(err) {
			return status.Error(codes.NotFound, "file not found")
		}
		return status.Error(codes.PermissionDenied, err.Error())
	}
	defer f.Close()

	// Get file info
	info, err := f.Stat()
	if err != nil {
		return status.Error(codes.Internal, err.Error())
	}

	if info.IsDir() {
		return status.Error(codes.InvalidArgument, "cannot stream a directory")
	}

	totalSize := info.Size()
	offset := req.Offset

	// If resume token provided, validate and parse it
	if req.ResumeToken != "" {
		tokenPath, tokenOffset, tokenErr := security.ValidateResumeToken(req.ResumeToken)
		if tokenErr != nil {
			return status.Error(codes.InvalidArgument, "invalid resume token")
		}

		// Verify token matches requested path
		if tokenPath != path {
			return status.Error(codes.InvalidArgument, "resume token path mismatch")
		}

		offset = tokenOffset
	}

	// Validate offset
	if err := security.ValidateOffset(offset, totalSize); err != nil {
		return status.Error(codes.InvalidArgument, err.Error())
	}

	// Seek to offset
	if offset > 0 {
		if _, seekErr := f.Seek(offset, io.SeekStart); seekErr != nil {
			return status.Error(codes.Internal, seekErr.Error())
		}
	}

	// Determine chunk size
	chunkSize := int(req.ChunkSize)
	if chunkSize <= 0 {
		chunkSize = 256 * 1024 // Default 256KB
	}

	// Determine bytes to read
	bytesToRead := totalSize - offset
	if req.Length > 0 && req.Length < bytesToRead {
		bytesToRead = req.Length
	}

	buffer := make([]byte, chunkSize)
	currentOffset := offset
	bytesRead := int64(0)
	ctx := stream.Context()

	log.Printf("StreamFile: %s (offset=%d, length=%d)", path, offset, bytesToRead)

	for bytesRead < bytesToRead {
		// Check context cancellation
		select {
		case <-ctx.Done():
			log.Printf("StreamFile: %s - cancelled by client", path)
			return ctx.Err()
		default:
		}

		// Adjust buffer size for last chunk
		remaining := bytesToRead - bytesRead
		if remaining < int64(chunkSize) {
			buffer = make([]byte, remaining)
		}

		n, readErr := f.Read(buffer)
		if readErr != nil {
			if readErr == io.EOF {
				break
			}
			return status.Error(codes.Internal, readErr.Error())
		}

		if n == 0 {
			break
		}

		bytesRead += int64(n)
		isLast := bytesRead >= bytesToRead

		// Create signed resume token
		resumeToken := security.CreateResumeToken(path, currentOffset+int64(n))

		chunk := &pb.FileChunk{
			Data:        buffer[:n],
			Offset:      currentOffset,
			TotalSize:   totalSize,
			IsLast:      isLast,
			ResumeToken: resumeToken,
		}

		if sendErr := stream.Send(chunk); sendErr != nil {
			return sendErr
		}

		currentOffset += int64(n)
	}

	return nil
}

// Helper function to sort file entries
func sortEntries(entries []*pb.FileEntry, sortBy pb.SortBy, order pb.SortOrder) {
	sort.Slice(entries, func(i, j int) bool {
		// Directories always come first
		if entries[i].IsDir != entries[j].IsDir {
			return entries[i].IsDir
		}

		var less bool
		switch sortBy {
		case pb.SortBy_SORT_SIZE:
			less = entries[i].Size < entries[j].Size
		case pb.SortBy_SORT_MODIFIED:
			less = entries[i].ModifiedAt < entries[j].ModifiedAt
		case pb.SortBy_SORT_TYPE:
			less = entries[i].Extension < entries[j].Extension
		default: // SORT_NAME
			less = strings.ToLower(entries[i].Name) < strings.ToLower(entries[j].Name)
		}

		if order == pb.SortOrder_DESC {
			return !less
		}
		return less
	})
}
