//! Events Module
//!
//! Event definitions for inter-module communication.
//!
//! ## Design Philosophy:
//! - Modules emit events (they don't call each other directly)
//! - Core listens and decides what to do
//! - Loose coupling between modules
//!
//! ## Event Flow:
//! ```text
//! filesystem → emit FileChanged      ──┐
//! connection → emit ConnectionLost   ──┼── core listens & decides
//! transfer   → emit ProgressUpdated  ──┘
//! ```

use serde::{Deserialize, Serialize};

// ============================================
// Filesystem Events
// ============================================

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(tag = "type", rename_all = "SCREAMING_SNAKE_CASE")]
pub enum FilesystemEvent {
    /// File or folder was created
    FileCreated {
        path: String,
        is_directory: bool,
    },
    
    /// File or folder was deleted
    FileDeleted {
        path: String,
    },
    
    /// File or folder was renamed/moved
    FileRenamed {
        old_path: String,
        new_path: String,
    },
    
    /// File content was modified
    FileModified {
        path: String,
        new_size: u64,
    },
    
    /// Directory content changed (files added/removed)
    DirectoryChanged {
        path: String,
    },
}

// ============================================
// Connection Events
// ============================================

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(tag = "type", rename_all = "SCREAMING_SNAKE_CASE")]
pub enum ConnectionEvent {
    /// Device discovered on network
    DeviceDiscovered {
        device_id: String,
        device_name: String,
        ip_address: String,
    },
    
    /// Device went offline
    DeviceLost {
        device_id: String,
    },
    
    /// Connection established successfully
    Connected {
        device_id: String,
        session_id: String,
    },
    
    /// Connection was lost unexpectedly
    ConnectionLost {
        device_id: String,
        reason: String,
    },
    
    /// Reconnection attempt
    Reconnecting {
        device_id: String,
        attempt: u32,
        max_attempts: u32,
    },
    
    /// Reconnection succeeded
    Reconnected {
        device_id: String,
    },
    
    /// All reconnection attempts failed
    ReconnectionFailed {
        device_id: String,
        reason: String,
    },
    
    /// Manual disconnect
    Disconnected {
        device_id: String,
    },
    
    /// Pairing request received
    PairingRequested {
        device_id: String,
        device_name: String,
        code: String,
    },
    
    /// Pairing completed
    PairingCompleted {
        device_id: String,
    },
    
    /// Pairing failed
    PairingFailed {
        device_id: String,
        reason: String,
    },
}

// ============================================
// Transfer Events
// ============================================

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(tag = "type", rename_all = "SCREAMING_SNAKE_CASE")]
pub enum TransferEvent {
    /// Transfer started
    TransferStarted {
        transfer_id: String,
        file_name: String,
        total_bytes: u64,
        direction: TransferDirection,
    },
    
    /// Progress update
    ProgressUpdated {
        transfer_id: String,
        bytes_transferred: u64,
        total_bytes: u64,
        speed_bps: f64,
        eta_seconds: Option<u32>,
    },
    
    /// Transfer paused
    TransferPaused {
        transfer_id: String,
        bytes_at_pause: u64,
    },
    
    /// Transfer resumed
    TransferResumed {
        transfer_id: String,
        from_offset: u64,
    },
    
    /// Transfer completed
    TransferCompleted {
        transfer_id: String,
        total_bytes: u64,
        duration_ms: u64,
    },
    
    /// Transfer failed
    TransferFailed {
        transfer_id: String,
        bytes_at_failure: u64,
        error_code: String,
        error_message: String,
        is_retryable: bool,
    },
    
    /// Transfer cancelled by user
    TransferCancelled {
        transfer_id: String,
    },
}

#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum TransferDirection {
    Upload,
    Download,
}

// ============================================
// App-level Events (for UI)
// ============================================

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(tag = "category", rename_all = "lowercase")]
pub enum AppEvent {
    Filesystem(FilesystemEvent),
    Connection(ConnectionEvent),
    Transfer(TransferEvent),
    
    /// Generic notification for UI
    Notification {
        level: NotificationLevel,
        title: String,
        message: String,
    },
}

#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum NotificationLevel {
    Info,
    Success,
    Warning,
    Error,
}

// ============================================
// Event Emitter Trait
// ============================================

/// Trait for components that can emit events
pub trait EventEmitter {
    fn emit(&self, event: AppEvent);
}

// ============================================
// Event Listener Trait (for Core)
// ============================================

/// Trait for the core module that listens to all events
pub trait EventListener {
    fn on_filesystem_event(&mut self, event: FilesystemEvent);
    fn on_connection_event(&mut self, event: ConnectionEvent);
    fn on_transfer_event(&mut self, event: TransferEvent);
}

// ============================================
// Event Bus (simple implementation)
// ============================================

use std::sync::mpsc::{channel, Receiver, Sender};

pub struct EventBus {
    sender: Sender<AppEvent>,
    receiver: Receiver<AppEvent>,
}

impl EventBus {
    pub fn new() -> Self {
        let (sender, receiver) = channel();
        Self { sender, receiver }
    }
    
    pub fn sender(&self) -> Sender<AppEvent> {
        self.sender.clone()
    }
    
    pub fn try_recv(&self) -> Option<AppEvent> {
        self.receiver.try_recv().ok()
    }
    
    pub fn recv(&self) -> Result<AppEvent, std::sync::mpsc::RecvError> {
        self.receiver.recv()
    }
}

impl Default for EventBus {
    fn default() -> Self {
        Self::new()
    }
}
