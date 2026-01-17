# FileExplorer Project Structure
## Modular Architecture

---

## 📁 Directory Structure

```
FileExplorer/
│
├── proto/                          # Protocol definitions (shared)
│   └── fileexplorer.proto
│
├── docs/                           # Documentation
│   ├── IMPLEMENTATION_PLAN.md
│   └── HTTP_FILE_TRANSFER_API.md
│
├── packages/                       # Shared packages (protocol layer)
│   │
│   ├── core/                       # Core Engine Module
│   │   ├── src/
│   │   │   ├── lib.rs
│   │   │   ├── filesystem/         # Local file operations
│   │   │   │   ├── mod.rs
│   │   │   │   ├── operations.rs
│   │   │   │   └── watcher.rs
│   │   │   ├── transfer/           # File transfer logic
│   │   │   │   ├── mod.rs
│   │   │   │   ├── download.rs
│   │   │   │   └── upload.rs
│   │   │   └── types/              # Shared types
│   │   │       ├── mod.rs
│   │   │       └── file_info.rs
│   │   └── Cargo.toml
│   │
│   └── protocol/                   # Protocol Layer (gRPC + HTTP client)
│       ├── src/
│       │   ├── lib.rs
│       │   ├── grpc/               # gRPC client
│       │   │   ├── mod.rs
│       │   │   └── client.rs
│       │   ├── http/               # HTTP client
│       │   │   ├── mod.rs
│       │   │   ├── download.rs
│       │   │   └── upload.rs
│       │   └── discovery/          # mDNS discovery
│       │       ├── mod.rs
│       │       └── mdns.rs
│       ├── build.rs                # Protobuf compilation
│       └── Cargo.toml
│
├── apps/                           # Applications
│   │
│   └── desktop/                    # Tauri Desktop App
│       ├── src/                    # React Frontend
│       │   ├── components/
│       │   │   ├── files/
│       │   │   ├── layout/
│       │   │   ├── modals/
│       │   │   └── panels/
│       │   ├── hooks/              # React hooks for Tauri
│       │   │   ├── useLocalFS.ts
│       │   │   ├── useRemoteDevice.ts
│       │   │   └── useTransfer.ts
│       │   ├── stores/             # State management
│       │   │   ├── deviceStore.ts
│       │   │   └── transferStore.ts
│       │   ├── App.jsx
│       │   └── main.jsx
│       │
│       ├── src-tauri/              # Rust Backend
│       │   ├── src/
│       │   │   ├── main.rs
│       │   │   ├── commands/       # Tauri commands (bridge to UI)
│       │   │   │   ├── mod.rs
│       │   │   │   ├── filesystem.rs
│       │   │   │   ├── device.rs
│       │   │   │   └── transfer.rs
│       │   │   └── state.rs        # App state
│       │   ├── Cargo.toml
│       │   └── tauri.conf.json
│       │
│       ├── package.json
│       └── vite.config.ts
│
└── Cargo.toml                      # Workspace root
```

---

## 🏗️ Layer Separation

```
┌─────────────────────────────────────────────────────────────────┐
│                         UI Layer                                │
│                    (React Components)                           │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │  • FileArea, Panel, Sidebar                             │   │
│   │  • Uses hooks: useLocalFS, useRemoteDevice              │   │
│   │  • NO direct access to protocol                         │   │
│   └─────────────────────────────────────────────────────────┘   │
│                              │                                   │
│                              │ Tauri IPC (invoke)               │
│                              ▼                                   │
├─────────────────────────────────────────────────────────────────┤
│                      Commands Layer                             │
│                  (Tauri Commands - Bridge)                      │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │  • filesystem::list_directory                           │   │
│   │  • device::connect, device::disconnect                  │   │
│   │  • transfer::download, transfer::upload                 │   │
│   │  • Translates UI requests to Core/Protocol calls        │   │
│   └─────────────────────────────────────────────────────────┘   │
│                              │                                   │
│                              ▼                                   │
├─────────────────────────────────────────────────────────────────┤
│                      Core Engine                                │
│                   (packages/core)                               │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │  • FileSystem operations (local)                        │   │
│   │  • Transfer management                                   │   │
│   │  • Shared types                                          │   │
│   │  • NO knowledge of UI or Protocol                       │   │
│   └─────────────────────────────────────────────────────────┘   │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                     Protocol Layer                              │
│                  (packages/protocol)                            │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │  • gRPC client (for remote FileSystem operations)       │   │
│   │  • HTTP client (for file transfer)                       │   │
│   │  • mDNS discovery                                        │   │
│   │  • NO knowledge of UI                                   │   │
│   │  • Uses Core types                                       │   │
│   └─────────────────────────────────────────────────────────┘   │
│                              │                                   │
│                              ▼                                   │
│                     [Remote Android Device]                     │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔑 Key Principles

### 1. Protocol Layer ไม่รู้จัก UI
```rust
// ❌ Wrong - Protocol knows about UI
pub fn list_directory() -> Vec<UiFileItem> { ... }

// ✅ Correct - Protocol returns core types
pub fn list_directory() -> Vec<core::FileInfo> { ... }
```

### 2. Core Engine เป็น Pure Library
```rust
// packages/core/src/lib.rs
// NO dependencies on:
// - Tauri
// - gRPC/tonic
// - HTTP/reqwest
// - UI frameworks

pub mod filesystem;
pub mod transfer;
pub mod types;
```

### 3. Commands Layer เป็น Bridge เท่านั้น
```rust
// apps/desktop/src-tauri/src/commands/filesystem.rs

#[tauri::command]
pub async fn list_directory(
    path: String,
    source: FileSource,  // Local or Remote
    state: State<'_, AppState>,
) -> Result<Vec<FileInfo>, String> {
    match source {
        FileSource::Local => {
            // Use core::filesystem
            core::filesystem::list_directory(&path)
        }
        FileSource::Remote(device_id) => {
            // Use protocol::grpc
            let device = state.get_device(&device_id)?;
            protocol::grpc::list_directory(&device, &path).await
        }
    }
}
```

### 4. Future Migration Ready
```rust
// วันหนึ่งถ้าจะ migrate data channel จาก HTTP → gRPC:
// 
// เปลี่ยนแค่ใน packages/protocol
// UI และ Core ไม่ต้องแก้เลย
```

---

## 📦 Cargo Workspace

```toml
# FileExplorer/Cargo.toml

[workspace]
members = [
    "packages/core",
    "packages/protocol",
    "apps/desktop/src-tauri",
]

[workspace.package]
version = "0.1.0"
edition = "2021"
license = "MIT"

[workspace.dependencies]
tokio = { version = "1", features = ["full"] }
serde = { version = "1", features = ["derive"] }
thiserror = "1"
tracing = "0.1"
```
