//! Transfer Commands
//!
//! Tauri commands for file transfer operations.
//! 
//! ## Responsibilities (ONLY):
//! - Stream data (upload/download)
//! - Track progress (bytes transferred)
//! - Report status (success, error, in-progress)
//! 
//! ## NOT Responsible For:
//! - Path validation (→ filesystem module)
//! - Directory creation (→ filesystem module)
//! - Retry decisions (→ core/policy layer)
//! - Connection management (→ connection module)
//!
//! ## Design:
//! - transfer.rs รายงานสถานะ
//! - core ตัดสินใจ retry based on policy

use serde::{Deserialize, Serialize};
use tauri::command;

/// Transfer information - represents current state of a transfer
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct TransferInfo {
    pub id: String,
    pub transfer_type: TransferType,
    pub status: TransferStatus,
    
    // Progress info (what transfer knows)
    pub total_bytes: u64,
    pub transferred_bytes: u64,
    pub speed_bytes_per_sec: f64,
    pub eta_seconds: Option<u32>,
    
    // Status info
    pub error: Option<TransferError>,
    pub started_at: i64,
    pub completed_at: Option<i64>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum TransferType {
    Download,
    Upload,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum TransferStatus {
    Pending,
    InProgress,
    Paused,
    Completed,
    Failed,
    Cancelled,
}

/// Transfer error - just reports what happened, doesn't decide what to do
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct TransferError {
    pub code: TransferErrorCode,
    pub message: String,
    pub is_retryable: bool,  // Hint for policy layer
    pub bytes_at_failure: u64,  // For resume
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "SCREAMING_SNAKE_CASE")]
pub enum TransferErrorCode {
    ConnectionLost,
    Timeout,
    ServerError,
    Cancelled,
    Unknown,
}

/// Input for starting a transfer
/// Note: Does NOT include path validation - that's filesystem's job
#[derive(Debug, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct TransferRequest {
    pub stream_url: String,          // HTTP URL to stream from/to
    pub stream_offset: u64,          // For resume support
    pub expected_size: Option<u64>,  // If known
    pub operation_id: String,        // For idempotency
}

/// Output destination (prepared by filesystem module)
#[derive(Debug, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct TransferDestination {
    pub local_path: String,          // Already validated by filesystem
    pub can_resume: bool,            // Filesystem tells us if resume is possible
    pub existing_bytes: u64,         // If resuming, how much we already have
}

/// Start a download stream
/// 
/// NOTE: Path validation and directory creation should be done by 
/// filesystem module BEFORE calling this
#[command]
pub async fn start_download_stream(
    request: TransferRequest,
    destination: TransferDestination,
) -> Result<String, String> {
    log::info!(
        "Starting download stream: {} -> {} (offset: {})",
        request.stream_url,
        destination.local_path,
        request.stream_offset
    );
    
    // TODO: Implement actual HTTP streaming download
    // This module ONLY handles the streaming - not path decisions
    
    Err("Not implemented yet".to_string())
}

/// Start an upload stream
#[command]
pub async fn start_upload_stream(
    source_path: String,  // Already validated by filesystem
    request: TransferRequest,
) -> Result<String, String> {
    log::info!(
        "Starting upload stream: {} -> {} (offset: {})",
        source_path,
        request.stream_url,
        request.stream_offset
    );
    
    // TODO: Implement actual HTTP streaming upload
    
    Err("Not implemented yet".to_string())
}

/// Get transfer progress - just returns current state
#[command]
pub async fn get_transfer_status(transfer_id: String) -> Result<TransferInfo, String> {
    log::debug!("Getting status for transfer: {}", transfer_id);
    
    // TODO: Lookup from transfer registry
    
    Err("Transfer not found".to_string())
}

/// Get all active transfers
#[command]
pub async fn get_all_transfers() -> Result<Vec<TransferInfo>, String> {
    Ok(vec![])
}

/// Pause a stream (just stops reading/writing)
#[command]
pub async fn pause_stream(transfer_id: String) -> Result<u64, String> {
    log::info!("Pausing stream: {}", transfer_id);
    
    // Returns bytes_at_pause for potential resume
    Err("Not implemented yet".to_string())
}

/// Resume a stream from offset
#[command]
pub async fn resume_stream(
    transfer_id: String,
    from_offset: u64,
) -> Result<(), String> {
    log::info!("Resuming stream {} from offset {}", transfer_id, from_offset);
    
    Err("Not implemented yet".to_string())
}

/// Cancel a stream
#[command]
pub async fn cancel_stream(transfer_id: String) -> Result<(), String> {
    log::info!("Cancelling stream: {}", transfer_id);
    
    // TODO: Stop the stream, cleanup
    
    Err("Not implemented yet".to_string())
}
