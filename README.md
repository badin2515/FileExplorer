# FileNode - File Explorer LAN System

ระบบ File Explorer ที่เชื่อมต่อผ่าน LAN ระหว่าง Windows และ Android

## Project Structure

```
FileExplorer/
├── proto/                      # Protocol Buffer definitions
│   ├── filenode.proto
│   └── generate_go.bat
│
├── go-service/                 # Go Backend Service
│   ├── cmd/
│   │   └── filenode-windows/
│   │       └── main.go
│   ├── internal/
│   │   ├── server/
│   │   │   └── server.go
│   │   └── fs/
│   │       └── fs_windows.go
│   └── go.mod
│
└── flutter-ui/                 # Flutter UI
    ├── lib/
    │   ├── main.dart
    │   ├── core/
    │   │   └── grpc/
    │   │       └── client.dart
    │   └── features/
    │       └── explorer/
    │           ├── explorer_screen.dart
    │           ├── providers/
    │           │   └── explorer_provider.dart
    │           └── widgets/
    │               ├── sidebar.dart
    │               ├── toolbar.dart
    │               └── file_list.dart
    └── pubspec.yaml
```

## Prerequisites

### Required Tools

1. **Go 1.22+** - https://go.dev/dl/
2. **Flutter 3.16+** - https://docs.flutter.dev/get-started/install
3. **Protocol Buffers** - https://protobuf.dev/downloads/

### Installation (Windows)

#### Install Go
```powershell
# Download and install from https://go.dev/dl/
# Or use winget:
winget install GoLang.Go
```

#### Install Flutter
```powershell
# Download from https://flutter.dev
# Or use git:
git clone https://github.com/flutter/flutter.git -b stable
# Add to PATH: flutter\bin
```

#### Install Protocol Buffers
```powershell
# Download protoc from https://github.com/protocolbuffers/protobuf/releases
# Extract and add to PATH

# Install Go proto plugins
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
```

## Setup

### 1. Generate Proto Files

```powershell
cd proto
.\generate_go.bat
```

### 2. Build Go Service

```powershell
cd go-service
go mod tidy
go build -o filenode.exe ./cmd/filenode-windows
```

### 3. Setup Flutter

```powershell
cd flutter-ui
flutter pub get

# Generate proto for dart (requires dart protoc plugin)
# protoc --dart_out=grpc:lib/core/proto filenode.proto
```

## Running

### Start Go Service

```powershell
cd go-service
.\filenode.exe
# Server listening on 127.0.0.1:50051
```

### Start Flutter App

```powershell
cd flutter-ui
flutter run -d windows
```

## Architecture

```
┌─────────────────────────────────────┐
│           Flutter UI (Windows)      │
│  • File list, Preview, Progress     │
└───────────────┬─────────────────────┘
                │ gRPC (localhost:50051)
                ▼
┌─────────────────────────────────────┐
│        Go FileNode Service          │
│  • ListDir, StreamFile, etc.        │
│  • mDNS discovery, TLS              │
└───────────────┬─────────────────────┘
                │
                ▼
        Local File System
```

## API

| Method | Description |
|--------|-------------|
| `ListDir` | Stream directory contents |
| `Stat` | Get file/directory info |
| `GetDrives` | List available drives |
| `CreateDir` | Create directory |
| `CreateFile` | Create file |
| `Delete` | Delete files/directories |
| `Rename` | Rename file/directory |
| `StreamFile` | Download file (streaming) |

## Development Status

- [x] Proto definitions
- [x] Go server skeleton
- [x] ListDir, Stat, GetDrives
- [x] File operations (Create, Delete, Rename)
- [x] StreamFile (download)
- [x] Flutter UI skeleton
- [x] Explorer screen with sidebar
- [x] File list with icons
- [ ] Proto generation for Dart
- [ ] Upload streaming
- [ ] mDNS discovery
- [ ] TLS/Pairing
- [ ] Android support
