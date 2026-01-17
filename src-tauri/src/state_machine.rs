//! State Machines Module
//!
//! Formal state machine definitions for:
//! - Connection State
//! - Transfer State
//!
//! ## Design Philosophy:
//! - State is "real" - not scattered if-else
//! - Valid transitions are enforced
//! - Invalid transitions return errors
//! - State machine ไม่ทำเอง - มันแค่บอกว่าควรทำอะไร (Output Actions)
//!
//! ## Output Actions Pattern:
//! ```ignore
//! let (new_state, actions) = state.transition(event);
//! for action in actions {
//!     match action {
//!         Action::StartTransfer { .. } => { /* executor does this */ }
//!         Action::ScheduleRetry { .. } => { /* scheduler does this */ }
//!         Action::EmitUiEvent { .. } => { /* UI emitter does this */ }
//!     }
//! }
//! ```

use serde::{Deserialize, Serialize};
use std::collections::VecDeque;

// ============================================
// Output Actions
// ============================================
//
// State machine คืน Actions - ไม่ทำเอง
// ผู้เรียกต้อง execute actions เหล่านี้

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(tag = "type", rename_all = "SCREAMING_SNAKE_CASE")]
pub enum ConnectionAction {
    /// Start connection attempt to device
    StartConnection { 
        device_id: String,
        attempt: u32,
    },
    
    /// Schedule a reconnection attempt
    ScheduleReconnect { 
        delay_ms: u64,
        attempt: u32,
    },
    
    /// Start heartbeat
    StartHeartbeat { 
        interval_ms: u64,
    },
    
    /// Stop heartbeat
    StopHeartbeat,
    
    /// Emit event to UI
    EmitUiEvent { 
        event_type: String,
        data: String,
    },
    
    /// Log for timeline
    LogTimeline { 
        message: String,
        level: LogLevel,
    },
    
    /// Notify that connection failed permanently
    NotifyConnectionFailed { 
        reason: String,
    },
    
    /// Cleanup resources
    Cleanup,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(tag = "type", rename_all = "SCREAMING_SNAKE_CASE")]
pub enum TransferAction {
    /// Start the actual transfer
    StartTransfer { 
        transfer_id: String,
        url: String,
        offset: u64,
    },
    
    /// Schedule a retry attempt
    ScheduleRetry { 
        delay_ms: u64,
        attempt: u32,
        from_offset: u64,
    },
    
    /// Pause the active transfer
    PauseTransfer { 
        transfer_id: String,
    },
    
    /// Resume from offset
    ResumeTransfer { 
        transfer_id: String,
        from_offset: u64,
    },
    
    /// Cancel and cleanup
    CancelTransfer { 
        transfer_id: String,
    },
    
    /// Update progress in UI
    UpdateProgress { 
        bytes: u64,
        total: u64,
        speed: f64,
    },
    
    /// Emit event to UI
    EmitUiEvent { 
        event_type: String,
        data: String,
    },
    
    /// Log for timeline
    LogTimeline { 
        message: String,
        level: LogLevel,
    },
    
    /// Notify completion
    NotifyComplete { 
        transfer_id: String,
    },
    
    /// Notify failure
    NotifyFailed { 
        transfer_id: String,
        error: String,
        can_retry: bool,
    },
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum LogLevel {
    Debug,
    Info,
    Warn,
    Error,
}

// ============================================
// Timeline Trace
// ============================================
//
// บันทึก event + state transition เป็น timeline
// ช่วย debug และ reproduce bug

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TimelineEntry {
    pub timestamp: i64,
    pub sequence: u64,
    pub event_type: String,
    pub from_state: String,
    pub to_state: String,
    pub actions_produced: Vec<String>,
    pub data: Option<String>,
}

#[derive(Debug, Default)]
pub struct Timeline {
    entries: VecDeque<TimelineEntry>,
    sequence: u64,
    max_entries: usize,
}

impl Timeline {
    pub fn new(max_entries: usize) -> Self {
        Self {
            entries: VecDeque::new(),
            sequence: 0,
            max_entries,
        }
    }
    
    pub fn record(&mut self, entry: TimelineEntry) {
        self.entries.push_back(entry);
        if self.entries.len() > self.max_entries {
            self.entries.pop_front();
        }
    }
    
    pub fn next_sequence(&mut self) -> u64 {
        self.sequence += 1;
        self.sequence
    }
    
    pub fn entries(&self) -> &VecDeque<TimelineEntry> {
        &self.entries
    }
    
    pub fn dump(&self) -> Vec<TimelineEntry> {
        self.entries.iter().cloned().collect()
    }
    
    pub fn dump_json(&self) -> String {
        serde_json::to_string_pretty(&self.dump()).unwrap_or_default()
    }
    
    pub fn clear(&mut self) {
        self.entries.clear();
    }
}

// ============================================
// Transition Result
// ============================================

#[derive(Debug)]
pub struct TransitionResult<S, A> {
    pub new_state: S,
    pub actions: Vec<A>,
    pub timeline_entry: TimelineEntry,
}

// ============================================
// Connection State Machine
// ============================================

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(tag = "state", rename_all = "lowercase")]
pub enum ConnectionState {
    Disconnected,
    Connecting { 
        device_id: String,
        attempt: u32,
        started_at: i64,
    },
    Connected { 
        device_id: String,
        connected_at: i64,
        last_heartbeat: i64,
    },
    Reconnecting { 
        device_id: String,
        attempt: u32,
        last_connected_at: i64,
    },
    Failed { 
        device_id: String,
        reason: String,
        failed_at: i64,
    },
}

impl Default for ConnectionState {
    fn default() -> Self {
        Self::Disconnected
    }
}

impl ConnectionState {
    pub fn kind(&self) -> ConnectionStateKind {
        match self {
            Self::Disconnected => ConnectionStateKind::Disconnected,
            Self::Connecting { .. } => ConnectionStateKind::Connecting,
            Self::Connected { .. } => ConnectionStateKind::Connected,
            Self::Reconnecting { .. } => ConnectionStateKind::Reconnecting,
            Self::Failed { .. } => ConnectionStateKind::Failed,
        }
    }
    
    /// Process event and return new state + actions
    /// State machine ไม่ทำเอง - มันแค่บอกว่าควรทำอะไร
    pub fn transition(
        &self, 
        event: ConnectionEvent,
        sequence: u64,
    ) -> Result<TransitionResult<ConnectionState, ConnectionAction>, StateError> {
        let now = current_timestamp();
        let from_state = format!("{:?}", self.kind());
        let event_type = format!("{:?}", event);
        
        let (new_state, actions) = match (self, &event) {
            // ═══════════════════════════════════════
            // From Disconnected
            // ═══════════════════════════════════════
            (ConnectionState::Disconnected, ConnectionEvent::Connect { device_id }) => {
                let new_state = ConnectionState::Connecting {
                    device_id: device_id.clone(),
                    attempt: 1,
                    started_at: now,
                };
                let actions = vec![
                    ConnectionAction::StartConnection {
                        device_id: device_id.clone(),
                        attempt: 1,
                    },
                    ConnectionAction::LogTimeline {
                        message: format!("Starting connection to {}", device_id),
                        level: LogLevel::Info,
                    },
                    ConnectionAction::EmitUiEvent {
                        event_type: "CONNECTING".to_string(),
                        data: device_id.clone(),
                    },
                ];
                (new_state, actions)
            }
            
            // ═══════════════════════════════════════
            // From Connecting
            // ═══════════════════════════════════════
            (ConnectionState::Connecting { device_id, attempt, .. }, ConnectionEvent::ConnectionEstablished) => {
                let new_state = ConnectionState::Connected {
                    device_id: device_id.clone(),
                    connected_at: now,
                    last_heartbeat: now,
                };
                let actions = vec![
                    ConnectionAction::StartHeartbeat { interval_ms: 5000 },
                    ConnectionAction::LogTimeline {
                        message: format!("Connected to {} after {} attempt(s)", device_id, attempt),
                        level: LogLevel::Info,
                    },
                    ConnectionAction::EmitUiEvent {
                        event_type: "CONNECTED".to_string(),
                        data: device_id.clone(),
                    },
                ];
                (new_state, actions)
            }
            
            (ConnectionState::Connecting { device_id, attempt, .. }, ConnectionEvent::ConnectionFailed { reason }) 
                if *attempt < 3 => 
            {
                let new_state = ConnectionState::Connecting {
                    device_id: device_id.clone(),
                    attempt: attempt + 1,
                    started_at: now,
                };
                let delay = (*attempt as u64) * 1000; // Exponential backoff
                let actions = vec![
                    ConnectionAction::ScheduleReconnect { 
                        delay_ms: delay,
                        attempt: attempt + 1,
                    },
                    ConnectionAction::LogTimeline {
                        message: format!("Connection attempt {} failed: {}. Retrying in {}ms", attempt, reason, delay),
                        level: LogLevel::Warn,
                    },
                ];
                (new_state, actions)
            }
            
            (ConnectionState::Connecting { device_id, attempt, .. }, ConnectionEvent::ConnectionFailed { reason }) => {
                let new_state = ConnectionState::Failed {
                    device_id: device_id.clone(),
                    reason: reason.clone(),
                    failed_at: now,
                };
                let actions = vec![
                    ConnectionAction::NotifyConnectionFailed {
                        reason: format!("Failed after {} attempts: {}", attempt, reason),
                    },
                    ConnectionAction::LogTimeline {
                        message: format!("Connection failed permanently: {}", reason),
                        level: LogLevel::Error,
                    },
                    ConnectionAction::EmitUiEvent {
                        event_type: "CONNECTION_FAILED".to_string(),
                        data: reason.clone(),
                    },
                    ConnectionAction::Cleanup,
                ];
                (new_state, actions)
            }
            
            (ConnectionState::Connecting { .. }, ConnectionEvent::Cancel) => {
                let actions = vec![
                    ConnectionAction::Cleanup,
                    ConnectionAction::LogTimeline {
                        message: "Connection cancelled by user".to_string(),
                        level: LogLevel::Info,
                    },
                    ConnectionAction::EmitUiEvent {
                        event_type: "DISCONNECTED".to_string(),
                        data: "cancelled".to_string(),
                    },
                ];
                (ConnectionState::Disconnected, actions)
            }
            
            // ═══════════════════════════════════════
            // From Connected
            // ═══════════════════════════════════════
            (ConnectionState::Connected { device_id, connected_at, .. }, ConnectionEvent::ConnectionLost) => {
                let new_state = ConnectionState::Reconnecting {
                    device_id: device_id.clone(),
                    attempt: 1,
                    last_connected_at: *connected_at,
                };
                let actions = vec![
                    ConnectionAction::StopHeartbeat,
                    ConnectionAction::ScheduleReconnect { delay_ms: 1000, attempt: 1 },
                    ConnectionAction::LogTimeline {
                        message: "Connection lost. Starting reconnection...".to_string(),
                        level: LogLevel::Warn,
                    },
                    ConnectionAction::EmitUiEvent {
                        event_type: "RECONNECTING".to_string(),
                        data: device_id.clone(),
                    },
                ];
                (new_state, actions)
            }
            
            (ConnectionState::Connected { connected_at, device_id, .. }, ConnectionEvent::HeartbeatReceived) => {
                let new_state = ConnectionState::Connected {
                    device_id: device_id.clone(),
                    connected_at: *connected_at,
                    last_heartbeat: now,
                };
                let actions = vec![
                    ConnectionAction::LogTimeline {
                        message: "Heartbeat received".to_string(),
                        level: LogLevel::Debug,
                    },
                ];
                (new_state, actions)
            }
            
            (ConnectionState::Connected { .. }, ConnectionEvent::Disconnect) => {
                let actions = vec![
                    ConnectionAction::StopHeartbeat,
                    ConnectionAction::Cleanup,
                    ConnectionAction::LogTimeline {
                        message: "Disconnected by user".to_string(),
                        level: LogLevel::Info,
                    },
                    ConnectionAction::EmitUiEvent {
                        event_type: "DISCONNECTED".to_string(),
                        data: "user_requested".to_string(),
                    },
                ];
                (ConnectionState::Disconnected, actions)
            }
            
            // ═══════════════════════════════════════
            // From Reconnecting
            // ═══════════════════════════════════════
            (ConnectionState::Reconnecting { device_id, .. }, ConnectionEvent::ConnectionEstablished) => {
                let new_state = ConnectionState::Connected {
                    device_id: device_id.clone(),
                    connected_at: now,
                    last_heartbeat: now,
                };
                let actions = vec![
                    ConnectionAction::StartHeartbeat { interval_ms: 5000 },
                    ConnectionAction::LogTimeline {
                        message: "Reconnected successfully".to_string(),
                        level: LogLevel::Info,
                    },
                    ConnectionAction::EmitUiEvent {
                        event_type: "RECONNECTED".to_string(),
                        data: device_id.clone(),
                    },
                ];
                (new_state, actions)
            }
            
            (ConnectionState::Reconnecting { device_id, attempt, .. }, ConnectionEvent::ConnectionFailed { reason })
                if *attempt < 5 =>
            {
                let new_state = ConnectionState::Reconnecting {
                    device_id: device_id.clone(),
                    attempt: attempt + 1,
                    last_connected_at: now,
                };
                let delay = (*attempt as u64) * 2000; // Longer delay for reconnect
                let actions = vec![
                    ConnectionAction::ScheduleReconnect { 
                        delay_ms: delay,
                        attempt: attempt + 1,
                    },
                    ConnectionAction::LogTimeline {
                        message: format!("Reconnect attempt {} failed. Retry in {}ms", attempt, delay),
                        level: LogLevel::Warn,
                    },
                    ConnectionAction::EmitUiEvent {
                        event_type: "RECONNECTING".to_string(),
                        data: format!("attempt:{}", attempt + 1),
                    },
                ];
                (new_state, actions)
            }
            
            (ConnectionState::Reconnecting { device_id, attempt, .. }, ConnectionEvent::ConnectionFailed { reason }) => {
                let new_state = ConnectionState::Failed {
                    device_id: device_id.clone(),
                    reason: reason.clone(),
                    failed_at: now,
                };
                let actions = vec![
                    ConnectionAction::NotifyConnectionFailed {
                        reason: format!("Reconnection failed after {} attempts: {}", attempt, reason),
                    },
                    ConnectionAction::LogTimeline {
                        message: format!("Reconnection failed permanently: {}", reason),
                        level: LogLevel::Error,
                    },
                    ConnectionAction::EmitUiEvent {
                        event_type: "CONNECTION_FAILED".to_string(),
                        data: reason.clone(),
                    },
                    ConnectionAction::Cleanup,
                ];
                (new_state, actions)
            }
            
            // ═══════════════════════════════════════
            // From Failed
            // ═══════════════════════════════════════
            (ConnectionState::Failed { .. }, ConnectionEvent::Reset) => {
                let actions = vec![
                    ConnectionAction::LogTimeline {
                        message: "State reset to Disconnected".to_string(),
                        level: LogLevel::Info,
                    },
                ];
                (ConnectionState::Disconnected, actions)
            }
            
            (ConnectionState::Failed { device_id, .. }, ConnectionEvent::Connect { device_id: new_device_id }) => {
                let target_device = if new_device_id.is_empty() { device_id.clone() } else { new_device_id.clone() };
                let new_state = ConnectionState::Connecting {
                    device_id: target_device.clone(),
                    attempt: 1,
                    started_at: now,
                };
                let actions = vec![
                    ConnectionAction::StartConnection {
                        device_id: target_device.clone(),
                        attempt: 1,
                    },
                    ConnectionAction::LogTimeline {
                        message: format!("Retrying connection to {}", target_device),
                        level: LogLevel::Info,
                    },
                ];
                (new_state, actions)
            }
            
            // ═══════════════════════════════════════
            // Invalid transition
            // ═══════════════════════════════════════
            _ => {
                return Err(StateError::InvalidTransition {
                    from: from_state,
                    event: event_type,
                });
            }
        };
        
        let to_state = format!("{:?}", new_state.kind());
        let actions_produced: Vec<String> = actions.iter().map(|a| format!("{:?}", a)).collect();
        
        let timeline_entry = TimelineEntry {
            timestamp: now,
            sequence,
            event_type,
            from_state,
            to_state,
            actions_produced,
            data: None,
        };
        
        Ok(TransitionResult {
            new_state,
            actions,
            timeline_entry,
        })
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ConnectionStateKind {
    Disconnected,
    Connecting,
    Connected,
    Reconnecting,
    Failed,
}

#[derive(Debug, Clone)]
pub enum ConnectionEvent {
    Connect { device_id: String },
    Disconnect,
    Cancel,
    ConnectionEstablished,
    ConnectionLost,
    ConnectionFailed { reason: String },
    HeartbeatReceived,
    Reset,
}

// ============================================
// Transfer State Machine
// ============================================

#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
#[serde(tag = "state", rename_all = "lowercase")]
pub enum TransferState {
    Idle,
    Preparing {
        transfer_id: String,
        started_at: i64,
    },
    Transferring {
        transfer_id: String,
        started_at: i64,
        bytes_transferred: u64,
        total_bytes: u64,
        speed_bps: f64,
    },
    Paused {
        transfer_id: String,
        paused_at: i64,
        bytes_transferred: u64,
        total_bytes: u64,
    },
    Resuming {
        transfer_id: String,
        from_offset: u64,
        total_bytes: u64,
        attempt: u32,
    },
    Completed {
        transfer_id: String,
        completed_at: i64,
        total_bytes: u64,
        duration_ms: u64,
    },
    Failed {
        transfer_id: String,
        failed_at: i64,
        bytes_at_failure: u64,
        error: TransferError,
    },
}

impl Default for TransferState {
    fn default() -> Self {
        Self::Idle
    }
}

impl TransferState {
    pub fn kind(&self) -> TransferStateKind {
        match self {
            Self::Idle => TransferStateKind::Idle,
            Self::Preparing { .. } => TransferStateKind::Preparing,
            Self::Transferring { .. } => TransferStateKind::Transferring,
            Self::Paused { .. } => TransferStateKind::Paused,
            Self::Resuming { .. } => TransferStateKind::Resuming,
            Self::Completed { .. } => TransferStateKind::Completed,
            Self::Failed { .. } => TransferStateKind::Failed,
        }
    }
    
    pub fn transfer_id(&self) -> Option<&str> {
        match self {
            Self::Idle => None,
            Self::Preparing { transfer_id, .. } |
            Self::Transferring { transfer_id, .. } |
            Self::Paused { transfer_id, .. } |
            Self::Resuming { transfer_id, .. } |
            Self::Completed { transfer_id, .. } |
            Self::Failed { transfer_id, .. } => Some(transfer_id),
        }
    }
    
    /// Process event and return new state + actions
    pub fn transition(
        &self,
        event: TransferEvent,
        sequence: u64,
    ) -> Result<TransitionResult<TransferState, TransferAction>, StateError> {
        let now = current_timestamp();
        let from_state = format!("{:?}", self.kind());
        let event_type = format!("{:?}", event);
        
        let (new_state, actions) = match (self, &event) {
            // ═══════════════════════════════════════
            // From Idle
            // ═══════════════════════════════════════
            (TransferState::Idle, TransferEvent::Start { transfer_id, url, total_bytes }) => {
                let new_state = TransferState::Preparing {
                    transfer_id: transfer_id.clone(),
                    started_at: now,
                };
                let actions = vec![
                    TransferAction::StartTransfer {
                        transfer_id: transfer_id.clone(),
                        url: url.clone(),
                        offset: 0,
                    },
                    TransferAction::LogTimeline {
                        message: format!("Starting transfer {} ({} bytes)", transfer_id, total_bytes),
                        level: LogLevel::Info,
                    },
                    TransferAction::EmitUiEvent {
                        event_type: "TRANSFER_STARTED".to_string(),
                        data: transfer_id.clone(),
                    },
                ];
                (new_state, actions)
            }
            
            // ═══════════════════════════════════════
            // From Preparing
            // ═══════════════════════════════════════
            (TransferState::Preparing { transfer_id, started_at }, TransferEvent::Ready { total_bytes }) => {
                let new_state = TransferState::Transferring {
                    transfer_id: transfer_id.clone(),
                    started_at: *started_at,
                    bytes_transferred: 0,
                    total_bytes: *total_bytes,
                    speed_bps: 0.0,
                };
                let actions = vec![
                    TransferAction::LogTimeline {
                        message: format!("Transfer {} ready, {} bytes total", transfer_id, total_bytes),
                        level: LogLevel::Info,
                    },
                ];
                (new_state, actions)
            }
            
            (TransferState::Preparing { transfer_id, .. }, TransferEvent::Error { error }) => {
                let new_state = TransferState::Failed {
                    transfer_id: transfer_id.clone(),
                    failed_at: now,
                    bytes_at_failure: 0,
                    error: error.clone(),
                };
                let actions = vec![
                    TransferAction::NotifyFailed {
                        transfer_id: transfer_id.clone(),
                        error: error.message.clone(),
                        can_retry: error.is_retryable,
                    },
                    TransferAction::LogTimeline {
                        message: format!("Transfer {} failed in preparation: {}", transfer_id, error.message),
                        level: LogLevel::Error,
                    },
                    TransferAction::EmitUiEvent {
                        event_type: "TRANSFER_FAILED".to_string(),
                        data: error.message.clone(),
                    },
                ];
                (new_state, actions)
            }
            
            // ═══════════════════════════════════════
            // From Transferring
            // ═══════════════════════════════════════
            (TransferState::Transferring { transfer_id, started_at, total_bytes, .. }, 
             TransferEvent::Progress { bytes, speed }) => 
            {
                let new_state = TransferState::Transferring {
                    transfer_id: transfer_id.clone(),
                    started_at: *started_at,
                    bytes_transferred: *bytes,
                    total_bytes: *total_bytes,
                    speed_bps: *speed,
                };
                let actions = vec![
                    TransferAction::UpdateProgress {
                        bytes: *bytes,
                        total: *total_bytes,
                        speed: *speed,
                    },
                ];
                (new_state, actions)
            }
            
            (TransferState::Transferring { transfer_id, bytes_transferred, total_bytes, .. },
             TransferEvent::Pause) =>
            {
                let new_state = TransferState::Paused {
                    transfer_id: transfer_id.clone(),
                    paused_at: now,
                    bytes_transferred: *bytes_transferred,
                    total_bytes: *total_bytes,
                };
                let actions = vec![
                    TransferAction::PauseTransfer {
                        transfer_id: transfer_id.clone(),
                    },
                    TransferAction::LogTimeline {
                        message: format!("Transfer {} paused at {} bytes", transfer_id, bytes_transferred),
                        level: LogLevel::Info,
                    },
                    TransferAction::EmitUiEvent {
                        event_type: "TRANSFER_PAUSED".to_string(),
                        data: bytes_transferred.to_string(),
                    },
                ];
                (new_state, actions)
            }
            
            (TransferState::Transferring { transfer_id, started_at, total_bytes, .. },
             TransferEvent::Done) =>
            {
                let duration_ms = (now - *started_at) as u64;
                let new_state = TransferState::Completed {
                    transfer_id: transfer_id.clone(),
                    completed_at: now,
                    total_bytes: *total_bytes,
                    duration_ms,
                };
                let actions = vec![
                    TransferAction::NotifyComplete {
                        transfer_id: transfer_id.clone(),
                    },
                    TransferAction::LogTimeline {
                        message: format!("Transfer {} completed in {}ms", transfer_id, duration_ms),
                        level: LogLevel::Info,
                    },
                    TransferAction::EmitUiEvent {
                        event_type: "TRANSFER_COMPLETED".to_string(),
                        data: transfer_id.clone(),
                    },
                ];
                (new_state, actions)
            }
            
            (TransferState::Transferring { transfer_id, bytes_transferred, .. },
             TransferEvent::Error { error }) =>
            {
                if error.is_retryable {
                    // Auto-retry with backoff
                    let new_state = TransferState::Resuming {
                        transfer_id: transfer_id.clone(),
                        from_offset: *bytes_transferred,
                        total_bytes: 0, // will be updated
                        attempt: 1,
                    };
                    let actions = vec![
                        TransferAction::ScheduleRetry {
                            delay_ms: 1000,
                            attempt: 1,
                            from_offset: *bytes_transferred,
                        },
                        TransferAction::LogTimeline {
                            message: format!("Transfer {} interrupted at {} bytes, retrying...", transfer_id, bytes_transferred),
                            level: LogLevel::Warn,
                        },
                        TransferAction::EmitUiEvent {
                            event_type: "TRANSFER_RETRYING".to_string(),
                            data: "1".to_string(),
                        },
                    ];
                    (new_state, actions)
                } else {
                    let new_state = TransferState::Failed {
                        transfer_id: transfer_id.clone(),
                        failed_at: now,
                        bytes_at_failure: *bytes_transferred,
                        error: error.clone(),
                    };
                    let actions = vec![
                        TransferAction::NotifyFailed {
                            transfer_id: transfer_id.clone(),
                            error: error.message.clone(),
                            can_retry: false,
                        },
                        TransferAction::LogTimeline {
                            message: format!("Transfer {} failed: {}", transfer_id, error.message),
                            level: LogLevel::Error,
                        },
                        TransferAction::EmitUiEvent {
                            event_type: "TRANSFER_FAILED".to_string(),
                            data: error.message.clone(),
                        },
                    ];
                    (new_state, actions)
                }
            }
            
            // ═══════════════════════════════════════
            // From Paused
            // ═══════════════════════════════════════
            (TransferState::Paused { transfer_id, bytes_transferred, total_bytes, .. },
             TransferEvent::Resume) =>
            {
                let new_state = TransferState::Resuming {
                    transfer_id: transfer_id.clone(),
                    from_offset: *bytes_transferred,
                    total_bytes: *total_bytes,
                    attempt: 1,
                };
                let actions = vec![
                    TransferAction::ResumeTransfer {
                        transfer_id: transfer_id.clone(),
                        from_offset: *bytes_transferred,
                    },
                    TransferAction::LogTimeline {
                        message: format!("Resuming transfer {} from {} bytes", transfer_id, bytes_transferred),
                        level: LogLevel::Info,
                    },
                ];
                (new_state, actions)
            }
            
            (TransferState::Paused { transfer_id, .. }, TransferEvent::Cancel) => {
                let actions = vec![
                    TransferAction::CancelTransfer {
                        transfer_id: transfer_id.clone(),
                    },
                    TransferAction::LogTimeline {
                        message: format!("Transfer {} cancelled", transfer_id),
                        level: LogLevel::Info,
                    },
                    TransferAction::EmitUiEvent {
                        event_type: "TRANSFER_CANCELLED".to_string(),
                        data: transfer_id.clone(),
                    },
                ];
                (TransferState::Idle, actions)
            }
            
            // ═══════════════════════════════════════
            // From Resuming
            // ═══════════════════════════════════════
            (TransferState::Resuming { transfer_id, from_offset, total_bytes, .. },
             TransferEvent::Ready { total_bytes: new_total }) =>
            {
                let actual_total = if *total_bytes > 0 { *total_bytes } else { *new_total };
                let new_state = TransferState::Transferring {
                    transfer_id: transfer_id.clone(),
                    started_at: now,
                    bytes_transferred: *from_offset,
                    total_bytes: actual_total,
                    speed_bps: 0.0,
                };
                let actions = vec![
                    TransferAction::LogTimeline {
                        message: format!("Transfer {} resumed from {} bytes", transfer_id, from_offset),
                        level: LogLevel::Info,
                    },
                    TransferAction::EmitUiEvent {
                        event_type: "TRANSFER_RESUMED".to_string(),
                        data: from_offset.to_string(),
                    },
                ];
                (new_state, actions)
            }
            
            (TransferState::Resuming { transfer_id, from_offset, total_bytes, attempt },
             TransferEvent::Error { error }) if *attempt < 3 && error.is_retryable =>
            {
                let new_state = TransferState::Resuming {
                    transfer_id: transfer_id.clone(),
                    from_offset: *from_offset,
                    total_bytes: *total_bytes,
                    attempt: attempt + 1,
                };
                let delay = (2u64).pow(*attempt) * 1000; // Exponential backoff
                let actions = vec![
                    TransferAction::ScheduleRetry {
                        delay_ms: delay,
                        attempt: attempt + 1,
                        from_offset: *from_offset,
                    },
                    TransferAction::LogTimeline {
                        message: format!("Resume attempt {} failed, retry in {}ms", attempt, delay),
                        level: LogLevel::Warn,
                    },
                ];
                (new_state, actions)
            }
            
            (TransferState::Resuming { transfer_id, from_offset, .. },
             TransferEvent::Error { error }) =>
            {
                let new_state = TransferState::Failed {
                    transfer_id: transfer_id.clone(),
                    failed_at: now,
                    bytes_at_failure: *from_offset,
                    error: error.clone(),
                };
                let actions = vec![
                    TransferAction::NotifyFailed {
                        transfer_id: transfer_id.clone(),
                        error: error.message.clone(),
                        can_retry: error.is_retryable,
                    },
                    TransferAction::LogTimeline {
                        message: format!("Transfer {} failed after max retries: {}", transfer_id, error.message),
                        level: LogLevel::Error,
                    },
                    TransferAction::EmitUiEvent {
                        event_type: "TRANSFER_FAILED".to_string(),
                        data: error.message.clone(),
                    },
                ];
                (new_state, actions)
            }
            
            // ═══════════════════════════════════════
            // From Failed - Manual retry
            // ═══════════════════════════════════════
            (TransferState::Failed { transfer_id, bytes_at_failure, error, .. },
             TransferEvent::Retry { url }) if error.is_retryable && *bytes_at_failure > 0 =>
            {
                let new_state = TransferState::Resuming {
                    transfer_id: transfer_id.clone(),
                    from_offset: *bytes_at_failure,
                    total_bytes: 0,
                    attempt: 1,
                };
                let actions = vec![
                    TransferAction::StartTransfer {
                        transfer_id: transfer_id.clone(),
                        url: url.clone(),
                        offset: *bytes_at_failure,
                    },
                    TransferAction::LogTimeline {
                        message: format!("Manual retry of transfer {} from {} bytes", transfer_id, bytes_at_failure),
                        level: LogLevel::Info,
                    },
                ];
                (new_state, actions)
            }
            
            (TransferState::Failed { .. }, TransferEvent::Reset) |
            (TransferState::Completed { .. }, TransferEvent::Reset) => {
                let actions = vec![
                    TransferAction::LogTimeline {
                        message: "Transfer state reset to Idle".to_string(),
                        level: LogLevel::Info,
                    },
                ];
                (TransferState::Idle, actions)
            }
            
            // ═══════════════════════════════════════
            // Invalid transition
            // ═══════════════════════════════════════
            _ => {
                return Err(StateError::InvalidTransition {
                    from: from_state,
                    event: event_type,
                });
            }
        };
        
        let to_state = format!("{:?}", new_state.kind());
        let actions_produced: Vec<String> = actions.iter().map(|a| format!("{:?}", a)).collect();
        
        let timeline_entry = TimelineEntry {
            timestamp: now,
            sequence,
            event_type,
            from_state,
            to_state,
            actions_produced,
            data: None,
        };
        
        Ok(TransitionResult {
            new_state,
            actions,
            timeline_entry,
        })
    }
    
    pub fn is_terminal(&self) -> bool {
        matches!(self, TransferState::Completed { .. } | TransferState::Failed { .. })
    }
    
    pub fn can_pause(&self) -> bool {
        matches!(self, TransferState::Transferring { .. })
    }
    
    pub fn can_resume(&self) -> bool {
        match self {
            TransferState::Paused { .. } => true,
            TransferState::Failed { error, .. } => error.is_retryable,
            _ => false,
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum TransferStateKind {
    Idle,
    Preparing,
    Transferring,
    Paused,
    Resuming,
    Completed,
    Failed,
}

#[derive(Debug, Clone)]
pub enum TransferEvent {
    Start { transfer_id: String, url: String, total_bytes: u64 },
    Ready { total_bytes: u64 },
    Progress { bytes: u64, speed: f64 },
    Pause,
    Resume,
    Done,
    Error { error: TransferError },
    Cancel,
    Retry { url: String },
    Reset,
}

#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct TransferError {
    pub code: String,
    pub message: String,
    pub is_retryable: bool,
}

// ============================================
// Common Types
// ============================================

#[derive(Debug, Clone)]
pub enum StateError {
    InvalidTransition { from: String, event: String },
}

impl std::fmt::Display for StateError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            StateError::InvalidTransition { from, event } => {
                write!(f, "Invalid transition from {} with event {}", from, event)
            }
        }
    }
}

impl std::error::Error for StateError {}

fn current_timestamp() -> i64 {
    std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .unwrap()
        .as_millis() as i64
}

// ============================================
// Tests
// ============================================

#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn test_connection_with_actions() {
        let mut timeline = Timeline::new(100);
        let mut state = ConnectionState::Disconnected;
        
        // Connect
        let result = state.transition(
            ConnectionEvent::Connect { device_id: "test-device".to_string() },
            timeline.next_sequence(),
        ).unwrap();
        
        state = result.new_state;
        timeline.record(result.timeline_entry);
        
        // Check state
        assert!(matches!(state, ConnectionState::Connecting { attempt: 1, .. }));
        
        // Check actions
        assert!(result.actions.iter().any(|a| matches!(a, ConnectionAction::StartConnection { .. })));
        assert!(result.actions.iter().any(|a| matches!(a, ConnectionAction::EmitUiEvent { .. })));
        
        // Connection established
        let result = state.transition(
            ConnectionEvent::ConnectionEstablished,
            timeline.next_sequence(),
        ).unwrap();
        
        state = result.new_state;
        timeline.record(result.timeline_entry);
        
        assert!(matches!(state, ConnectionState::Connected { .. }));
        assert!(result.actions.iter().any(|a| matches!(a, ConnectionAction::StartHeartbeat { .. })));
        
        // Check timeline
        assert_eq!(timeline.entries().len(), 2);
    }
    
    #[test]
    fn test_transfer_with_auto_retry() {
        let mut timeline = Timeline::new(100);
        let mut state = TransferState::Idle;
        
        // Start
        let result = state.transition(
            TransferEvent::Start { 
                transfer_id: "t1".to_string(), 
                url: "http://test".to_string(),
                total_bytes: 10000,
            },
            timeline.next_sequence(),
        ).unwrap();
        state = result.new_state;
        timeline.record(result.timeline_entry);
        
        // Ready
        let result = state.transition(
            TransferEvent::Ready { total_bytes: 10000 },
            timeline.next_sequence(),
        ).unwrap();
        state = result.new_state;
        timeline.record(result.timeline_entry);
        
        // Progress
        let result = state.transition(
            TransferEvent::Progress { bytes: 5000, speed: 1000.0 },
            timeline.next_sequence(),
        ).unwrap();
        state = result.new_state;
        timeline.record(result.timeline_entry);
        
        // Error (retryable)
        let result = state.transition(
            TransferEvent::Error { 
                error: TransferError {
                    code: "CONNECTION_LOST".to_string(),
                    message: "Connection lost".to_string(),
                    is_retryable: true,
                }
            },
            timeline.next_sequence(),
        ).unwrap();
        state = result.new_state;
        timeline.record(result.timeline_entry);
        
        // Should be in Resuming state with retry scheduled
        assert!(matches!(state, TransferState::Resuming { from_offset: 5000, attempt: 1, .. }));
        assert!(result.actions.iter().any(|a| matches!(a, TransferAction::ScheduleRetry { .. })));
        
        // Dump timeline
        println!("Timeline:\n{}", timeline.dump_json());
    }
    
    #[test]
    fn test_timeline_dump() {
        let mut timeline = Timeline::new(10);
        
        timeline.record(TimelineEntry {
            timestamp: 1000,
            sequence: 1,
            event_type: "Connect".to_string(),
            from_state: "Disconnected".to_string(),
            to_state: "Connecting".to_string(),
            actions_produced: vec!["StartConnection".to_string()],
            data: None,
        });
        
        let json = timeline.dump_json();
        assert!(json.contains("Connect"));
        assert!(json.contains("Disconnected"));
    }
}
