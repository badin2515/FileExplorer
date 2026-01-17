//! Backend Runtime
//!
//! Central control structure for managing application state and lifecycle.
//!
//! ## Responsibilities:
//! - Track active transfers (for pause/resume/cancel)
//! - Handle graceful shutdown
//! - Coordinate between modules
//!
//! ## Lifecycle Flow:
//! ```text
//! Running  ──[shutdown()]──►  Stopping  ──[all done]──►  Stopped
//!    │                           │
//!    │ accept new transfers      │ reject new transfers
//!    │ process normally          │ cancel or let finish
//! ```

use std::collections::HashMap;
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::{Arc, RwLock};
use tokio::sync::broadcast;

/// Unique identifier for a transfer operation
pub type TransferId = String;

/// Commands that can be sent to the runtime
#[derive(Debug, Clone)]
pub enum RuntimeCommand {
    /// Initiate graceful shutdown
    Shutdown,
    /// Cancel a specific transfer
    CancelTransfer(TransferId),
    /// Cancel all transfers
    CancelAllTransfers,
}

/// Transfer handle containing control channels
#[derive(Debug)]
pub struct TransferHandle {
    pub id: TransferId,
    pub status: TransferStatus,
    pub bytes_transferred: u64,
    pub total_bytes: Option<u64>,
    pub cancel_signal: broadcast::Sender<()>,
}

/// Status of a transfer operation
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum TransferStatus {
    Pending,
    InProgress,
    Paused,
    Completed,
    Failed,
    Cancelled,
}

/// Runtime state
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum RuntimeState {
    Running,
    Stopping,
    Stopped,
}

/// Backend runtime state
/// 
/// This is the central "control center" for the backend.
/// It tracks all active operations and provides lifecycle management.
pub struct BackendRuntime {
    /// Current runtime state
    is_stopping: AtomicBool,
    
    /// Active transfers indexed by transfer ID
    active_transfers: RwLock<HashMap<TransferId, TransferHandle>>,
    
    /// Shutdown signal broadcaster
    shutdown_signal: broadcast::Sender<()>,
    
    /// Command channel sender
    command_tx: broadcast::Sender<RuntimeCommand>,
}

impl BackendRuntime {
    /// Create a new backend runtime
    pub fn new() -> Self {
        let (shutdown_tx, _) = broadcast::channel(1);
        let (command_tx, _) = broadcast::channel(16);
        Self {
            is_stopping: AtomicBool::new(false),
            active_transfers: RwLock::new(HashMap::new()),
            shutdown_signal: shutdown_tx,
            command_tx,
        }
    }
    
    // ═══════════════════════════════════════
    // State Queries
    // ═══════════════════════════════════════
    
    /// Check if runtime is stopping or stopped
    pub fn is_stopping(&self) -> bool {
        self.is_stopping.load(Ordering::SeqCst)
    }
    
    /// Get current runtime state
    pub fn state(&self) -> RuntimeState {
        if self.is_stopping.load(Ordering::SeqCst) {
            let active = self.active_transfers.read().unwrap()
                .values()
                .any(|h| matches!(h.status, TransferStatus::Pending | TransferStatus::InProgress | TransferStatus::Paused));
            if active {
                RuntimeState::Stopping
            } else {
                RuntimeState::Stopped
            }
        } else {
            RuntimeState::Running
        }
    }
    
    // ═══════════════════════════════════════
    // Command Channel
    // ═══════════════════════════════════════
    
    /// Subscribe to runtime commands
    pub fn subscribe_commands(&self) -> broadcast::Receiver<RuntimeCommand> {
        self.command_tx.subscribe()
    }
    
    /// Send a command to the runtime
    pub fn send_command(&self, cmd: RuntimeCommand) {
        match &cmd {
            RuntimeCommand::Shutdown => self.shutdown(),
            RuntimeCommand::CancelTransfer(id) => { self.cancel_transfer(id); },
            RuntimeCommand::CancelAllTransfers => self.cancel_all_transfers(),
        }
        let _ = self.command_tx.send(cmd);
    }
    
    // ═══════════════════════════════════════
    // Transfer Management
    // ═══════════════════════════════════════
    
    /// Register a new transfer and get a cancel receiver
    /// Returns None if runtime is stopping (reject new transfers)
    pub fn register_transfer(&self, id: TransferId, total_bytes: Option<u64>) -> Option<broadcast::Receiver<()>> {
        // Reject new transfers if stopping
        if self.is_stopping() {
            log::warn!("Rejected transfer {} - runtime is stopping", id);
            return None;
        }
        
        let (cancel_tx, cancel_rx) = broadcast::channel(1);
        
        let handle = TransferHandle {
            id: id.clone(),
            status: TransferStatus::Pending,
            bytes_transferred: 0,
            total_bytes,
            cancel_signal: cancel_tx,
        };
        
        self.active_transfers.write().unwrap().insert(id, handle);
        Some(cancel_rx)
    }
    
    /// Update transfer progress
    pub fn update_progress(&self, id: &TransferId, bytes: u64) {
        if let Some(handle) = self.active_transfers.write().unwrap().get_mut(id) {
            handle.bytes_transferred = bytes;
            if handle.status == TransferStatus::Pending {
                handle.status = TransferStatus::InProgress;
            }
        }
    }
    
    /// Mark transfer as completed
    pub fn complete_transfer(&self, id: &TransferId) {
        if let Some(handle) = self.active_transfers.write().unwrap().get_mut(id) {
            handle.status = TransferStatus::Completed;
        }
    }
    
    /// Mark transfer as failed
    pub fn fail_transfer(&self, id: &TransferId) {
        if let Some(handle) = self.active_transfers.write().unwrap().get_mut(id) {
            handle.status = TransferStatus::Failed;
        }
    }
    
    /// Cancel a specific transfer
    pub fn cancel_transfer(&self, id: &TransferId) -> bool {
        if let Some(handle) = self.active_transfers.write().unwrap().get_mut(id) {
            handle.status = TransferStatus::Cancelled;
            let _ = handle.cancel_signal.send(()); // Signal cancellation
            true
        } else {
            false
        }
    }
    
    /// Cancel all active transfers
    pub fn cancel_all_transfers(&self) {
        for (id, handle) in self.active_transfers.write().unwrap().iter_mut() {
            if matches!(handle.status, TransferStatus::Pending | TransferStatus::InProgress | TransferStatus::Paused) {
                handle.status = TransferStatus::Cancelled;
                let _ = handle.cancel_signal.send(());
                log::info!("Cancelled transfer {}", id);
            }
        }
    }
    
    /// Pause a transfer
    pub fn pause_transfer(&self, id: &TransferId) -> bool {
        if let Some(handle) = self.active_transfers.write().unwrap().get_mut(id) {
            if handle.status == TransferStatus::InProgress {
                handle.status = TransferStatus::Paused;
                return true;
            }
        }
        false
    }
    
    /// Resume a transfer
    pub fn resume_transfer(&self, id: &TransferId) -> bool {
        // Don't resume if stopping
        if self.is_stopping() {
            return false;
        }
        
        if let Some(handle) = self.active_transfers.write().unwrap().get_mut(id) {
            if handle.status == TransferStatus::Paused {
                handle.status = TransferStatus::InProgress;
                return true;
            }
        }
        false
    }
    
    /// Get all active transfers (not completed/failed/cancelled)
    pub fn get_active_transfers(&self) -> Vec<(TransferId, TransferStatus, u64, Option<u64>)> {
        self.active_transfers.read().unwrap()
            .iter()
            .filter(|(_, h)| matches!(h.status, TransferStatus::Pending | TransferStatus::InProgress | TransferStatus::Paused))
            .map(|(id, h)| (id.clone(), h.status, h.bytes_transferred, h.total_bytes))
            .collect()
    }
    
    /// Remove completed/failed/cancelled transfers
    pub fn cleanup_finished(&self) {
        self.active_transfers.write().unwrap()
            .retain(|_, h| matches!(h.status, TransferStatus::Pending | TransferStatus::InProgress | TransferStatus::Paused));
    }
    
    // ═══════════════════════════════════════
    // Lifecycle Management
    // ═══════════════════════════════════════
    
    /// Subscribe to shutdown signal
    pub fn subscribe_shutdown(&self) -> broadcast::Receiver<()> {
        self.shutdown_signal.subscribe()
    }
    
    /// Initiate graceful shutdown
    /// - Marks runtime as stopping (rejects new transfers)
    /// - Cancels all active transfers
    /// - Broadcasts shutdown signal
    pub fn shutdown(&self) {
        // Mark as stopping first
        self.is_stopping.store(true, Ordering::SeqCst);
        log::info!("Backend shutdown initiated - rejecting new transfers");
        
        // Cancel all active transfers
        self.cancel_all_transfers();
        
        // Broadcast shutdown signal
        let _ = self.shutdown_signal.send(());
        log::info!("Backend shutdown signal sent");
    }
}

impl Default for BackendRuntime {
    fn default() -> Self {
        Self::new()
    }
}

/// Thread-safe runtime handle
pub type RuntimeHandle = Arc<BackendRuntime>;

/// Create a new runtime handle
pub fn create_runtime() -> RuntimeHandle {
    Arc::new(BackendRuntime::new())
}

#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn test_transfer_lifecycle() {
        let runtime = BackendRuntime::new();
        
        // Register
        let id = "test-transfer-1".to_string();
        let _cancel_rx = runtime.register_transfer(id.clone(), Some(1000));
        assert!(_cancel_rx.is_some());
        
        // Update progress
        runtime.update_progress(&id, 500);
        
        // Check active
        let active = runtime.get_active_transfers();
        assert_eq!(active.len(), 1);
        assert_eq!(active[0].2, 500); // bytes transferred
        
        // Complete
        runtime.complete_transfer(&id);
        
        // Cleanup
        runtime.cleanup_finished();
        assert_eq!(runtime.get_active_transfers().len(), 0);
    }
    
    #[test]
    fn test_cancel_transfer() {
        let runtime = BackendRuntime::new();
        let id = "test-cancel".to_string();
        let cancel_rx = runtime.register_transfer(id.clone(), None);
        assert!(cancel_rx.is_some());
        let mut cancel_rx = cancel_rx.unwrap();
        
        // Cancel
        assert!(runtime.cancel_transfer(&id));
        
        // Should receive cancel signal
        assert!(cancel_rx.try_recv().is_ok());
    }
    
    #[test]
    fn test_shutdown_rejects_new_transfers() {
        let runtime = BackendRuntime::new();
        
        // Should accept before shutdown
        let result = runtime.register_transfer("before".to_string(), None);
        assert!(result.is_some());
        
        // Shutdown
        runtime.shutdown();
        assert!(runtime.is_stopping());
        
        // Should reject after shutdown
        let result = runtime.register_transfer("after".to_string(), None);
        assert!(result.is_none());
    }
    
    #[test]
    fn test_runtime_state() {
        let runtime = BackendRuntime::new();
        assert_eq!(runtime.state(), RuntimeState::Running);
        
        // Start a transfer
        let _rx = runtime.register_transfer("test".to_string(), None);
        
        // Shutdown - should be Stopping because transfer is still active
        runtime.shutdown();
        // After cancel_all in shutdown, status becomes Cancelled, so it's Stopped
        assert_eq!(runtime.state(), RuntimeState::Stopped);
    }
}
