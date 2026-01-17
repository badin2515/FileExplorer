//! FileExplorer Commands Module
//! 
//! This module contains all Tauri commands organized by domain.
//! 
//! ## Architecture Principles:
//! 
//! 1. **filesystem** - ตัดสินใจเรื่อง "ไฟล์ไหน"
//!    - path validation
//!    - directory creation
//!    - file policies (permissions, etc.)
//! 
//! 2. **transfer** - แค่รู้เรื่อง "stream/offset"
//!    - รายงานสถานะ (progress, error)
//!    - ไม่ตัดสินใจ retry (core ตัดสินใจ)
//!    - ไม่รู้ path details (filesystem ตัดสินใจ)
//! 
//! 3. **device** - identity + discovery เท่านั้น
//!    - device identification
//!    - mDNS discovery
//!    - pairing flow
//! 
//! 4. **connection** - connection state management
//!    - session tokens
//!    - heartbeat
//!    - reconnection
//! 
//! 5. **core** - policy decisions
//!    - retry logic
//!    - error handling policies
//!    - operation coordination

pub mod filesystem;
pub mod transfer;
pub mod device;
pub mod connection;

pub use filesystem::*;
pub use transfer::*;
pub use device::*;
pub use connection::*;
