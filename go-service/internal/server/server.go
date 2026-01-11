package server

import (
	"context"
	"fmt"
	"io"
	"log"
	"os"
	"path/filepath"
	"sort"
	"strings"

	"github.com/user/filenode/internal/fs"
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
	return &FileNodeServer{
		fsOps: fs.NewOperations(),
	}
}

// ListDir streams directory contents
func (s *FileNodeServer) ListDir(req *pb.ListDirRequest, stream pb.FileNode_ListDirServer) error {
	path := req.Path
	if path == "" {
		return status.Error(codes.InvalidArgument, "path is required")
	}

	// Normalize path
	path = filepath.Clean(path)

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
		if err := stream.Send(entry); err != nil {
			return err
		}
	}

	log.Printf("ListDir: %s - returned %d entries", path, len(fileEntries))
	return nil
}

// Stat returns file/directory information
func (s *FileNodeServer) Stat(ctx context.Context, req *pb.StatRequest) (*pb.FileInfo, error) {
	path := req.Path
	if path == "" {
		return nil, status.Error(codes.InvalidArgument, "path is required")
	}

	path = filepath.Clean(path)

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
	path := filepath.Clean(req.Path)
	
	var err error
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
	path := filepath.Clean(req.Path)
	
	// Check if file exists
	if _, err := os.Stat(path); err == nil {
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
		if _, err := f.Write(req.Content); err != nil {
			return &pb.OperationResult{
				Success:   false,
				Message:   err.Error(),
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
	for _, path := range req.Paths {
		path = filepath.Clean(path)
		
		var err error
		if req.Permanent {
			// Permanent delete
			info, statErr := os.Stat(path)
			if statErr != nil {
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
	oldPath := filepath.Clean(req.Path)
	newPath := filepath.Join(filepath.Dir(oldPath), req.NewName)
	
	// Check if target exists
	if _, err := os.Stat(newPath); err == nil {
		return &pb.OperationResult{
			Success:   false,
			Message:   "Target already exists",
			ErrorCode: "ALREADY_EXISTS",
		}, nil
	}
	
	if err := os.Rename(oldPath, newPath); err != nil {
		return &pb.OperationResult{
			Success:   false,
			Message:   err.Error(),
			ErrorCode: "RENAME_FAILED",
		}, nil
	}
	
	log.Printf("Rename: %s -> %s", oldPath, newPath)
	return &pb.OperationResult{
		Success: true,
		Message: "Renamed successfully",
	}, nil
}

// StreamFile streams file content to client
func (s *FileNodeServer) StreamFile(req *pb.StreamFileRequest, stream pb.FileNode_StreamFileServer) error {
	path := filepath.Clean(req.Path)
	
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
	
	// Seek to offset if specified
	if req.Offset > 0 {
		if _, err := f.Seek(req.Offset, io.SeekStart); err != nil {
			return status.Error(codes.Internal, err.Error())
		}
	}
	
	// Determine chunk size
	chunkSize := int(req.ChunkSize)
	if chunkSize <= 0 {
		chunkSize = 256 * 1024 // Default 256KB
	}
	
	// Determine bytes to read
	bytesToRead := totalSize - req.Offset
	if req.Length > 0 && req.Length < bytesToRead {
		bytesToRead = req.Length
	}
	
	buffer := make([]byte, chunkSize)
	offset := req.Offset
	bytesRead := int64(0)
	
	log.Printf("StreamFile: %s (offset=%d, length=%d)", path, req.Offset, bytesToRead)
	
	for bytesRead < bytesToRead {
		// Adjust buffer size for last chunk
		remaining := bytesToRead - bytesRead
		if remaining < int64(chunkSize) {
			buffer = make([]byte, remaining)
		}
		
		n, err := f.Read(buffer)
		if err != nil {
			if err == io.EOF {
				break
			}
			return status.Error(codes.Internal, err.Error())
		}
		
		if n == 0 {
			break
		}
		
		bytesRead += int64(n)
		isLast := bytesRead >= bytesToRead
		
		chunk := &pb.FileChunk{
			Data:        buffer[:n],
			Offset:      offset,
			TotalSize:   totalSize,
			IsLast:      isLast,
			ResumeToken: fmt.Sprintf("%s:%d", path, offset+int64(n)),
		}
		
		if err := stream.Send(chunk); err != nil {
			return err
		}
		
		offset += int64(n)
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
