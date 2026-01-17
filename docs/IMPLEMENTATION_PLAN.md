# FileExplorer - Implementation Plan
## Cross-Platform File Management (Windows ↔ Android)

---

## 📋 Project Overview

**Goal**: Create a seamless file management experience between Windows and Android devices over local WiFi, similar to USB direct connection.

**Protocol**: gRPC with Protocol Buffers
**Transport**: HTTP/2 over TCP

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                         Local WiFi Network                          │
├──────────────────────────────┬──────────────────────────────────────┤
│      Windows Desktop App      │          Android Companion App       │
│                               │                                      │
│  ┌─────────────────────────┐  │  ┌────────────────────────────────┐ │
│  │   React UI (Vite)       │  │  │   Kotlin UI (Jetpack Compose)  │ │
│  │   - FileExplorer        │  │  │   - File Browser               │ │
│  │   - Dual Panel View     │  │  │   - Connection Status          │ │
│  └───────────┬─────────────┘  │  └───────────────┬────────────────┘ │
│              │ IPC            │                  │                   │
│  ┌───────────▼─────────────┐  │  ┌───────────────▼────────────────┐ │
│  │   Tauri Backend (Rust)  │  │  │   gRPC Server (Kotlin)         │ │
│  │   - Local File System   │  │  │   - FileSystemService          │ │
│  │   - gRPC Client         │◄─────►   - FileTransferService       │ │
│  │   - mDNS Discovery      │  │  │   - DeviceDiscoveryService     │ │
│  └─────────────────────────┘  │  └────────────────────────────────┘ │
│                               │                                      │
│  Windows File System          │          Android File System         │
└──────────────────────────────┴──────────────────────────────────────┘
```

---

## 📁 Project Structure

```
FileExplorer/
├── proto/
│   └── fileexplorer.proto          # gRPC protocol definition
│
├── windows-app/                     # Tauri + React application
│   ├── src/                         # React frontend (existing)
│   ├── src-tauri/                   # Rust backend
│   │   ├── src/
│   │   │   ├── main.rs
│   │   │   ├── grpc_client.rs       # gRPC client for Android
│   │   │   ├── local_fs.rs          # Local file system operations
│   │   │   ├── discovery.rs         # mDNS device discovery
│   │   │   └── commands.rs          # Tauri commands
│   │   ├── build.rs                 # protobuf compilation
│   │   └── Cargo.toml
│   ├── package.json
│   └── tauri.conf.json
│
├── android-app/                     # Kotlin Android application
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── java/com/fileexplorer/
│   │   │   │   ├── MainActivity.kt
│   │   │   │   ├── grpc/
│   │   │   │   │   ├── FileSystemServiceImpl.kt
│   │   │   │   │   ├── FileTransferServiceImpl.kt
│   │   │   │   │   └── DiscoveryServiceImpl.kt
│   │   │   │   ├── service/
│   │   │   │   │   └── GrpcServerService.kt
│   │   │   │   └── ui/
│   │   │   │       ├── screens/
│   │   │   │       └── components/
│   │   │   └── proto/               # Generated from .proto
│   │   └── build.gradle.kts
│   └── settings.gradle.kts
│
└── docs/
    ├── PROTOCOL.md
    ├── SETUP.md
    └── API.md
```

---

## 🔧 Tech Stack

### Windows Desktop App
| Component | Technology | Notes |
|-----------|------------|-------|
| Framework | **Tauri v2** | Lightweight, Rust backend |
| Frontend | **React + Vite** | Existing FileExplorer UI |
| gRPC Client | **tonic** | Rust gRPC library |
| Discovery | **mdns-sd** | mDNS/DNS-SD for discovery |
| Build | **prost** | Protobuf code generation |

### Android Companion App
| Component | Technology | Notes |
|-----------|------------|-------|
| Language | **Kotlin** | Modern Android development |
| UI | **Jetpack Compose** | Declarative UI |
| gRPC Server | **grpc-kotlin** | Official Kotlin gRPC |
| File Access | **Storage Access Framework** | Android file permissions |
| Background | **Foreground Service** | Keep server running |
| Discovery | **NsdManager** | Network Service Discovery |

---

## 📅 Development Phases

### Phase 1: Foundation (Week 1-2)
- [ ] Set up Tauri v2 project wrapping existing React app
- [ ] Create Android project with Kotlin + Compose
- [ ] Generate code from .proto files for both platforms
- [ ] Implement basic gRPC connection (Ping service)

### Phase 2: File System Operations (Week 3-4)
- [ ] Implement Android gRPC server
  - [ ] ListDirectory
  - [ ] GetFileInfo
  - [ ] CreateFolder
  - [ ] Delete
  - [ ] Rename
- [ ] Implement Windows gRPC client
- [ ] Connect React UI to Tauri backend

### Phase 3: File Transfer (Week 5-6)
- [ ] Implement streaming file download
- [ ] Implement streaming file upload
- [ ] Progress tracking
- [ ] Pause/Resume support
- [ ] Error handling & retry logic

### Phase 4: Device Discovery (Week 7)
- [ ] Implement mDNS broadcasting (Android)
- [ ] Implement mDNS discovery (Windows)
- [ ] Auto-connect when devices are on same network
- [ ] Pairing flow with verification code

### Phase 5: Polish & Integration (Week 8)
- [ ] Dual panel view with remote device
- [ ] Drag & drop between panels
- [ ] Copy/Move between devices
- [ ] Connection status indicator
- [ ] Error handling & reconnection

---

## 🔌 gRPC Services Summary

### FileSystemService
| Method | Description |
|--------|-------------|
| `ListDirectory` | List files in a folder |
| `GetFileInfo` | Get file details + thumbnail |
| `CreateFolder` | Create new folder |
| `Delete` | Delete files/folders |
| `Rename` | Rename/move items |
| `Copy` | Copy items |
| `Search` | Search for files (streaming) |
| `GetStorageInfo` | Get storage volumes info |

### FileTransferService
| Method | Description |
|--------|-------------|
| `DownloadFile` | Stream download from device |
| `UploadFile` | Stream upload to device |
| `GetTransferProgress` | Track transfer status |
| `CancelTransfer` | Cancel ongoing transfer |
| `PauseTransfer` | Pause transfer |
| `ResumeTransfer` | Resume from offset |

### DeviceDiscoveryService
| Method | Description |
|--------|-------------|
| `GetDeviceInfo` | Get device name, storage, etc. |
| `Ping` | Check if device is alive |
| `RequestPairing` | Initiate pairing |
| `RespondToPairing` | Accept/reject pairing |

---

## 🚀 Getting Started

### Prerequisites
- **Rust** (latest stable)
- **Node.js** (18+)
- **Android Studio** (latest)
- **Protocol Buffer Compiler** (protoc)

### Step 1: Generate protobuf code
```bash
# Windows (Rust)
cd windows-app/src-tauri
cargo build  # build.rs will generate code

# Android (Kotlin)
./gradlew generateProto
```

### Step 2: Run Windows app
```bash
cd windows-app
npm install
npm run tauri dev
```

### Step 3: Run Android app
```bash
cd android-app
./gradlew installDebug
```

---

## 📝 Notes

### Security Considerations
- All communication is local network only
- Pairing requires physical confirmation
- Session tokens expire after 24 hours
- No data leaves the local network

### Performance Targets
- File listing: < 100ms for 1000 files
- File transfer: > 50 MB/s over WiFi
- Discovery: < 3 seconds to find device

### Limitations
- Android requires app to be running (foreground service)
- Some system folders may not be accessible on Android
- Large file transfers may drain battery
