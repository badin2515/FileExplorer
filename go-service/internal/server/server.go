package server

import (
	"context"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"sort"
	"strings"

	"github.com/user/filenode/internal/errors"
	"github.com/user/filenode/internal/fs"
	"github.com/user/filenode/internal/observability"
	"github.com/user/filenode/internal/security"
	"github.com/user/filenode/internal/streaming"
	"github.com/user/filenode/internal/vpath"
	pb "github.com/user/filenode/pkg/proto"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// Configuration constants
const (
	// MaxEntriesPerPage limits entries per ListDir call
	MaxEntriesPerPage = 1000

	// DefaultPageSize is the default number of entries per page
	DefaultPageSize = 500

	// MaxConcurrentStreams limits the number of active file streams
	MaxConcurrentStreams = 20
)

// FileNodeServer implements the FileNode gRPC service
type FileNodeServer struct {
	pb.UnimplementedFileNodeServer
	fsOps      *fs.Operations
	pathMapper *vpath.VirtualPathMapper
	streamSem  chan struct{} // Semaphore for concurrency limiting
}

// NewFileNodeServer creates a new FileNode server instance
func NewFileNodeServer() *FileNodeServer {
	// Initialize security with default config
	security.Initialize(security.DefaultConfig())

	// Initialize observability (if not already)
	observability.InitLogger()
	observability.GetMetrics()

	// Setup virtual path mapper with default mounts
	mapper := vpath.GetMapper()

	// Auto-mount available drives
	drives, _ := fs.GetDrives()
	for _, drive := range drives {
		letter := strings.ToLower(string(drive.Name[0]))
		mapper.Mount("/drive_"+letter, drive.Path)
	}

	return &FileNodeServer{
		fsOps:      fs.NewOperations(),
		pathMapper: mapper,
		streamSem:  make(chan struct{}, MaxConcurrentStreams),
	}
}

// toRealPath converts virtual path to real OS path with validation
func (s *FileNodeServer) toRealPath(virtualPath string) (string, error) {
	if virtualPath == "" {
		return "", status.Error(codes.InvalidArgument, "path is required")
	}

	// Convert virtual to real path
	realPath, err := s.pathMapper.ToReal(virtualPath)
	if err != nil {
		observability.LogWarn("Path resolution failed", "path", virtualPath, "error", err)
		return "", status.Error(codes.InvalidArgument, err.Error())
	}

	// Validate the real path for security
	cleanPath, err := security.ValidatePath(realPath)
	if err != nil {
		observability.LogWarn("Security validation failed", "path", realPath, "error", err)
		return "", status.Error(codes.PermissionDenied, errors.ErrOutsideRoot)
	}

	return cleanPath, nil
}

// toVirtualPath converts real OS path to virtual path
func (s *FileNodeServer) toVirtualPath(realPath string) string {
	virtualPath, err := s.pathMapper.ToVirtual(realPath)
	if err != nil {
		return realPath
	}
	return virtualPath
}

// ListDir streams directory contents with pagination support
func (s *FileNodeServer) ListDir(req *pb.ListDirRequest, stream pb.FileNode_ListDirServer) error {
	realPath, err := s.toRealPath(req.Path)
	if err != nil {
		return err
	}

	ctx := stream.Context()
	select {
	case <-ctx.Done():
		return ctx.Err()
	default:
	}

	info, err := os.Stat(realPath)
	if err != nil {
		if os.IsNotExist(err) {
			return status.Error(codes.NotFound, errors.ErrNotFound)
		}
		return status.Error(codes.Internal, errors.ErrInternal)
	}

	if !info.IsDir() {
		return status.Error(codes.InvalidArgument, errors.ErrInvalidArg)
	}

	entries, err := os.ReadDir(realPath)
	if err != nil {
		return status.Error(codes.PermissionDenied, errors.ErrPermission)
	}

	pageSize := int(req.PageSize)
	if pageSize <= 0 {
		pageSize = DefaultPageSize
	}
	if pageSize > MaxEntriesPerPage {
		pageSize = MaxEntriesPerPage
	}

	startIndex := 0
	if req.PageToken != "" {
		var offset int
		if _, parseErr := parsePageToken(req.PageToken, &offset); parseErr == nil {
			startIndex = offset
		} else {
			return status.Error(codes.InvalidArgument, errors.ErrPageToken)
		}
	}

	var filteredEntries []os.DirEntry
	totalCount := 0
	for _, entry := range entries {
		if !req.ShowHidden && strings.HasPrefix(entry.Name(), ".") {
			continue
		}
		filteredEntries = append(filteredEntries, entry)
		totalCount++
		if totalCount >= MaxEntriesPerPage*2 {
			break
		}
	}

	var fileEntries []*pb.FileEntry
	dirVirtualPath := req.Path

	for i, entry := range filteredEntries {
		if i%100 == 0 {
			select {
			case <-ctx.Done():
				return ctx.Err()
			default:
			}
		}

		info, err := entry.Info()
		if err != nil {
			continue
		}

		fullRealPath := filepath.Join(realPath, entry.Name())
		fullVirtualPath := dirVirtualPath + "/" + entry.Name()

		ext := ""
		if !entry.IsDir() {
			ext = strings.TrimPrefix(filepath.Ext(entry.Name()), ".")
		}

		fileEntry := &pb.FileEntry{
			Id:          fullVirtualPath,
			Name:        entry.Name(),
			Path:        fullVirtualPath,
			DisplayPath: fullVirtualPath,
			IsDir:       entry.IsDir(),
			Size:        info.Size(),
			ModifiedAt:  info.ModTime().UnixMilli(),
			Extension:   ext,
			MimeType:    fs.GetMimeType(fullRealPath),
			IsHidden:    strings.HasPrefix(entry.Name(), ".") || fs.IsHidden(fullRealPath),
			IsReadonly:  fs.IsReadOnly(info),
		}

		fileEntries = append(fileEntries, fileEntry)
	}

	sortEntries(fileEntries, req.SortBy, req.SortOrder)

	endIndex := startIndex + pageSize
	if endIndex > len(fileEntries) {
		endIndex = len(fileEntries)
	}

	if startIndex >= len(fileEntries) {
		return nil
	}

	pagedEntries := fileEntries[startIndex:endIndex]

	for _, entry := range pagedEntries {
		select {
		case <-ctx.Done():
			return ctx.Err()
		default:
		}

		if err := stream.Send(entry); err != nil {
			return err
		}
	}

	observability.LogInfo("ListDir success", "path", req.Path, "count", len(pagedEntries))
	return nil
}

// Stat returns file/directory information
func (s *FileNodeServer) Stat(ctx context.Context, req *pb.StatRequest) (*pb.FileInfo, error) {
	realPath, err := s.toRealPath(req.Path)
	if err != nil {
		return nil, err
	}

	info, err := os.Stat(realPath)
	if err != nil {
		if os.IsNotExist(err) {
			return nil, status.Error(codes.NotFound, errors.ErrNotFound)
		}
		return nil, status.Error(codes.Internal, err.Error())
	}

	ext := ""
	if !info.IsDir() {
		ext = strings.TrimPrefix(filepath.Ext(realPath), ".")
	}

	virtualPath := req.Path

	entry := &pb.FileEntry{
		Id:          virtualPath,
		Name:        info.Name(),
		Path:        virtualPath,
		DisplayPath: virtualPath,
		IsDir:       info.IsDir(),
		Size:        info.Size(),
		ModifiedAt:  info.ModTime().UnixMilli(),
		Extension:   ext,
		MimeType:    fs.GetMimeType(realPath),
		IsHidden:    fs.IsHidden(realPath),
		IsReadonly:  fs.IsReadOnly(info),
	}

	createdAt, accessedAt := fs.GetFileTimes(realPath)

	return &pb.FileInfo{
		Entry:      entry,
		CreatedAt:  createdAt,
		AccessedAt: accessedAt,
		IsLocked:   false,
		LockedBy:   "",
		Checksum:   "",
	}, nil
}

// GetDrives returns list of available drives
func (s *FileNodeServer) GetDrives(ctx context.Context, req *pb.Empty) (*pb.DriveList, error) {
	realDrives, err := fs.GetDrives()
	if err != nil {
		return nil, status.Error(codes.Internal, errors.ErrInternal)
	}

	var virtualDrives []*pb.DriveInfo
	for _, drive := range realDrives {
		letter := strings.ToLower(string(drive.Name[0]))
		virtualPath := "/drive_" + letter

		virtualDrive := &pb.DriveInfo{
			Name:        drive.Name,
			Path:        virtualPath,
			Label:       drive.Label,
			TotalSpace:  drive.TotalSpace,
			FreeSpace:   drive.FreeSpace,
			IsRemovable: drive.IsRemovable,
		}
		virtualDrives = append(virtualDrives, virtualDrive)
	}

	return &pb.DriveList{Drives: virtualDrives}, nil
}

// GetDeviceInfo returns device information
func (s *FileNodeServer) GetDeviceInfo(ctx context.Context, req *pb.Empty) (*pb.DeviceInfo, error) {
	hostname, _ := os.Hostname()

	return &pb.DeviceInfo{
		DeviceId:     fs.GetDeviceID(),
		DeviceName:   hostname,
		Platform:     "windows",
		Version:      "1.0.0",
		TotalStorage: 0,
		FreeStorage:  0,
	}, nil
}

// CreateDir creates a new directory
func (s *FileNodeServer) CreateDir(ctx context.Context, req *pb.CreateDirRequest) (*pb.OperationResult, error) {
	realPath, err := s.toRealPath(req.Path)
	if err != nil {
		return &pb.OperationResult{
			Success:   false,
			Message:   err.Error(),
			ErrorCode: errors.ErrPermission,
		}, nil
	}

	lock := security.GetFileLock(realPath)
	lock.Lock()
	defer lock.Unlock()

	if req.Recursive {
		err = os.MkdirAll(realPath, 0755)
	} else {
		err = os.Mkdir(realPath, 0755)
	}

	if err != nil {
		return &pb.OperationResult{
			Success:   false,
			Message:   err.Error(),
			ErrorCode: "CREATE_FAILED",
		}, nil
	}

	observability.LogInfo("CreateDir success", "path", req.Path)
	return &pb.OperationResult{
		Success: true,
		Message: "Directory created",
	}, nil
}

// CreateFile creates a new file
func (s *FileNodeServer) CreateFile(ctx context.Context, req *pb.CreateFileRequest) (*pb.OperationResult, error) {
	realPath, err := s.toRealPath(req.Path)
	if err != nil {
		return &pb.OperationResult{
			Success:   false,
			Message:   err.Error(),
			ErrorCode: errors.ErrPermission,
		}, nil
	}

	lock := security.GetFileLock(realPath)
	lock.Lock()
	defer lock.Unlock()

	if _, statErr := os.Stat(realPath); statErr == nil {
		return &pb.OperationResult{
			Success:   false,
			Message:   "File already exists",
			ErrorCode: errors.ErrAlreadyExists,
		}, nil
	}

	f, err := os.Create(realPath)
	if err != nil {
		return &pb.OperationResult{
			Success:   false,
			Message:   err.Error(),
			ErrorCode: "CREATE_FAILED",
		}, nil
	}
	defer f.Close()

	if len(req.Content) > 0 {
		if _, writeErr := f.Write(req.Content); writeErr != nil {
			return &pb.OperationResult{
				Success:   false,
				Message:   writeErr.Error(),
				ErrorCode: "WRITE_FAILED",
			}, nil
		}
	}

	observability.LogInfo("CreateFile success", "path", req.Path)
	return &pb.OperationResult{
		Success: true,
		Message: "File created",
	}, nil
}

// Delete removes files or directories
func (s *FileNodeServer) Delete(ctx context.Context, req *pb.DeleteRequest) (*pb.OperationResult, error) {
	for _, virtualPath := range req.Paths {
		realPath, err := s.toRealPath(virtualPath)
		if err != nil {
			return &pb.OperationResult{
				Success:   false,
				Message:   err.Error(),
				ErrorCode: errors.ErrPermission,
			}, nil
		}

		lock := security.GetFileLock(realPath)
		lock.Lock()

		if req.Permanent {
			info, statErr := os.Stat(realPath)
			if statErr != nil {
				lock.Unlock()
				continue
			}
			if info.IsDir() {
				err = os.RemoveAll(realPath)
			} else {
				err = os.Remove(realPath)
			}
		} else {
			err = fs.MoveToTrash(realPath)
		}

		lock.Unlock()
		security.ReleaseFileLock(realPath)

		if err != nil {
			if strings.Contains(err.Error(), "process cannot access") {
				return &pb.OperationResult{
					Success:   false,
					Message:   err.Error(),
					ErrorCode: errors.ErrFileLocked,
				}, nil
			}
			return &pb.OperationResult{
				Success:   false,
				Message:   err.Error(),
				ErrorCode: "DELETE_FAILED",
			}, nil
		}
	}

	observability.LogInfo("Delete success", "count", len(req.Paths))
	return &pb.OperationResult{
		Success: true,
		Message: "Deleted successfully",
	}, nil
}

// Rename renames a file or directory
func (s *FileNodeServer) Rename(ctx context.Context, req *pb.RenameRequest) (*pb.OperationResult, error) {
	oldRealPath, err := s.toRealPath(req.Path)
	if err != nil {
		return &pb.OperationResult{
			Success:   false,
			Message:   err.Error(),
			ErrorCode: errors.ErrPermission,
		}, nil
	}

	newRealPath := filepath.Join(filepath.Dir(oldRealPath), req.NewName)

	if _, validateErr := security.ValidatePath(newRealPath); validateErr != nil {
		return &pb.OperationResult{
			Success:   false,
			Message:   validateErr.Error(),
			ErrorCode: errors.ErrPermission,
		}, nil
	}

	oldLock := security.GetFileLock(oldRealPath)
	newLock := security.GetFileLock(newRealPath)

	oldLock.Lock()
	defer oldLock.Unlock()
	newLock.Lock()
	defer newLock.Unlock()

	if _, statErr := os.Stat(newRealPath); statErr == nil {
		return &pb.OperationResult{
			Success:   false,
			Message:   "Target already exists",
			ErrorCode: errors.ErrAlreadyExists,
		}, nil
	}

	if renameErr := os.Rename(oldRealPath, newRealPath); renameErr != nil {
		if strings.Contains(renameErr.Error(), "process cannot access") {
			return &pb.OperationResult{
				Success:   false,
				Message:   renameErr.Error(),
				ErrorCode: errors.ErrFileLocked,
			}, nil
		}
		return &pb.OperationResult{
			Success:   false,
			Message:   renameErr.Error(),
			ErrorCode: "RENAME_FAILED",
		}, nil
	}

	security.ReleaseFileLock(oldRealPath)

	observability.LogInfo("Rename success", "path", req.Path, "new_name", req.NewName)
	return &pb.OperationResult{
		Success: true,
		Message: "Renamed successfully",
	}, nil
}

// StreamFile streams file content to client with preview/download support
func (s *FileNodeServer) StreamFile(req *pb.StreamFileRequest, stream pb.FileNode_StreamFileServer) error {
	// Concurrent limit check
	select {
	case s.streamSem <- struct{}{}:
		defer func() { <-s.streamSem }()
	default:
		return status.Error(codes.ResourceExhausted, "too many concurrent streams")
	}

	realPath, err := s.toRealPath(req.Path)
	if err != nil {
		return err
	}

	lock := security.GetFileLock(realPath)
	lock.RLock()
	defer lock.RUnlock()

	f, err := os.Open(realPath)
	if err != nil {
		if os.IsNotExist(err) {
			return status.Error(codes.NotFound, errors.ErrNotFound)
		}
		return status.Error(codes.PermissionDenied, errors.ErrPermission)
	}
	defer f.Close()

	info, err := f.Stat()
	if err != nil {
		return status.Error(codes.Internal, err.Error())
	}

	if info.IsDir() {
		return status.Error(codes.InvalidArgument, errors.ErrInvalidArg)
	}

	totalSize := info.Size()
	mimeType := fs.GetMimeType(realPath)
	offset := req.Offset

	streamReq, err := streaming.ParseStreamRequest(req.Path, req.Offset, req.Length, int(req.ChunkSize), mimeType)
	if err != nil {
		return status.Error(codes.InvalidArgument, errors.ErrInvalidArg)
	}

	if req.ResumeToken != "" {
		tokenPath, tokenOffset, tokenErr := security.ValidateResumeToken(req.ResumeToken)
		if tokenErr != nil {
			return status.Error(codes.InvalidArgument, errors.ErrInvalidResume)
		}
		if tokenPath != req.Path {
			return status.Error(codes.InvalidArgument, errors.ErrInvalidResume)
		}
		offset = tokenOffset
	}

	if err := security.ValidateOffset(offset, totalSize); err != nil {
		return status.Error(codes.InvalidArgument, errors.ErrOffset)
	}

	if offset > 0 {
		if _, seekErr := f.Seek(offset, io.SeekStart); seekErr != nil {
			return status.Error(codes.Internal, seekErr.Error())
		}
	}

	bytesToRead := totalSize - offset
	if streamReq.Mode == streaming.ModePreview || streamReq.Mode == streaming.ModeRange {
		if streamReq.Length > 0 && streamReq.Length < bytesToRead {
			bytesToRead = streamReq.Length
		}
	}

	buffer := make([]byte, streamReq.ChunkSize)
	currentOffset := offset
	bytesRead := int64(0)
	ctx := stream.Context()

	modeStr := "download"
	if streamReq.Mode == streaming.ModePreview {
		modeStr = "preview"
	} else if streamReq.Mode == streaming.ModeRange {
		modeStr = "range"
	}
	observability.LogInfo("StreamFile start", "mode", modeStr, "path", req.Path, "offset", offset, "bytes_to_read", bytesToRead)

	for bytesRead < bytesToRead {
		select {
		case <-ctx.Done():
			observability.LogInfo("StreamFile cancelled", "path", req.Path)
			return ctx.Err()
		default:
		}

		remaining := bytesToRead - bytesRead
		if remaining < int64(streamReq.ChunkSize) {
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

		resumeToken := security.CreateResumeToken(req.Path, currentOffset+int64(n))

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

// Helpers

func sortEntries(entries []*pb.FileEntry, sortBy pb.SortBy, order pb.SortOrder) {
	sort.Slice(entries, func(i, j int) bool {
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
		default:
			less = strings.ToLower(entries[i].Name) < strings.ToLower(entries[j].Name)
		}

		if order == pb.SortOrder_DESC {
			return !less
		}
		return less
	})
}

func parsePageToken(token string, offset *int) (bool, error) {
	if token == "" {
		*offset = 0
		return true, nil
	}

	_, err := parseIntFromString(token, offset)
	return err == nil, err
}

func parseIntFromString(s string, val *int) (bool, error) {
	n := 0
	for _, c := range s {
		if c >= '0' && c <= '9' {
			n = n*10 + int(c-'0')
		} else {
			return false, fmt.Errorf("invalid character")
		}
	}
	*val = n
	return true, nil
}
