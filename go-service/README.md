# FileNode - File Explorer Backend

Go-based backend service for FileNode file explorer.

## Prerequisites

- Go 1.22+
- Protocol Buffers compiler (`protoc`)

## Setup

### 1. Install protoc tools

```powershell
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
```

### 2. Generate proto files

```powershell
cd proto
.\generate_go.bat
```

### 3. Download dependencies

```powershell
cd go-service
go mod tidy
```

### 4. Build and run

```powershell
cd go-service
go build -o filenode.exe ./cmd/filenode-windows
.\filenode.exe
```

## gRPC Service

The server listens on `127.0.0.1:50051` (localhost only).

### Endpoints

- `ListDir` - Stream directory contents
- `Stat` - Get file/directory info
- `GetDrives` - List available drives
- `CreateDir` - Create directory
- `CreateFile` - Create file
- `Delete` - Delete files/directories
- `Rename` - Rename file/directory
- `StreamFile` - Download file (streaming)

## Testing

Use `grpcurl` to test the API:

```powershell
# List drives
grpcurl -plaintext localhost:50051 filenode.FileNode/GetDrives

# List directory
grpcurl -plaintext -d '{"path": "C:\\Users"}' localhost:50051 filenode.FileNode/ListDir

# Get file info
grpcurl -plaintext -d '{"path": "C:\\Users\\Bordin\\Desktop"}' localhost:50051 filenode.FileNode/Stat
```
