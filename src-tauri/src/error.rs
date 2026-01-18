//! Centralized Error Handling
//! 
//! This module provides structured error types for the entire backend.
//! 
//! ## Design Principles:
//! 
//! 1. **ErrorKind** - Semantic classification for UI decisions
//!    - UI can decide: retry automatically? ask user? show error silently?
//! 
//! 2. **AppError** - Detailed error with context
//!    - Maps to ErrorKind automatically
//!    - Serializable for frontend consumption

use serde::{Serialize, Serializer};
use std::fmt;

/// Semantic error classification
/// 
/// UI uses this to decide what action to take:
/// - `Transient`: Can retry automatically (network hiccup, temporary lock)
/// - `Permanent`: Don't retry, it won't help (file deleted, disk full)
/// - `Permission`: Need user action (grant permission, authenticate)
/// - `NotFound`: Resource doesn't exist
/// - `InvalidState`: App logic error, shouldn't happen in normal use
/// - `Cancelled`: User cancelled the operation
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(rename_all = "SCREAMING_SNAKE_CASE")]
pub enum ErrorKind {
    /// Can retry automatically (network timeout, temporary lock)
    Transient,
    /// Don't retry - permanent failure (disk full, file corrupted)
    Permanent,
    /// Need user permission (Android SAF, admin rights)
    Permission,
    /// Resource not found
    NotFound,
    /// Invalid application state
    InvalidState,
    /// Operation was cancelled by user
    Cancelled,
}

/// Application error with full context
#[derive(Debug, thiserror::Error)]
pub enum AppError {
    // ═══════════════════════════════════════
    // I/O Errors
    // ═══════════════════════════════════════
    
    #[error("I/O error: {0}")]
    Io(#[from] std::io::Error),

    #[error("Path not found: {0}")]
    NotFound(String),
    
    #[error("Path is invalid: {0}")]
    PathInvalid(String),
    
    #[error("Already exists: {0}")]
    AlreadyExists(String),

    // ═══════════════════════════════════════
    // Permission Errors
    // ═══════════════════════════════════════
    
    #[error("Permission denied: {0}")]
    PermissionDenied(String),
    
    #[error("Permission was revoked: {0}")]
    PermissionRevoked(String),

    // ═══════════════════════════════════════
    // Storage Errors
    // ═══════════════════════════════════════
    
    #[error("Storage is full")]
    StorageFull,

    // ═══════════════════════════════════════
    // Network Errors
    // ═══════════════════════════════════════
    
    #[error("Network error: {0}")]
    Network(String),
    
    #[error("Connection lost: {0}")]
    ConnectionLost(String),
    
    #[error("Connection timeout")]
    Timeout,

    // ═══════════════════════════════════════
    // Transfer Errors
    // ═══════════════════════════════════════
    
    #[error("Transfer error: {0}")]
    Transfer(String),
    
    #[error("Checksum mismatch")]
    ChecksumMismatch,

    // ═══════════════════════════════════════
    // State Errors
    // ═══════════════════════════════════════
    
    #[error("Invalid state: {0}")]
    InvalidState(String),
    
    #[error("Operation cancelled: {0}")]
    Cancelled(String),

    // ═══════════════════════════════════════
    // Generic
    // ═══════════════════════════════════════
    
    #[error("Unknown error: {0}")]
    Unknown(String),
}

impl AppError {
    /// Get the semantic error kind for UI decision making
    pub fn kind(&self) -> ErrorKind {
        match self {
            // Transient - can retry
            AppError::Network(_) => ErrorKind::Transient,
            AppError::ConnectionLost(_) => ErrorKind::Transient,
            AppError::Timeout => ErrorKind::Transient,
            AppError::Io(e) if e.kind() == std::io::ErrorKind::TimedOut => ErrorKind::Transient,
            AppError::Io(e) if e.kind() == std::io::ErrorKind::Interrupted => ErrorKind::Transient,
            AppError::Io(e) if e.kind() == std::io::ErrorKind::WouldBlock => ErrorKind::Transient,
            
            // Permission - need user action
            AppError::PermissionDenied(_) => ErrorKind::Permission,
            AppError::PermissionRevoked(_) => ErrorKind::Permission,
            AppError::Io(e) if e.kind() == std::io::ErrorKind::PermissionDenied => ErrorKind::Permission,
            
            // NotFound
            AppError::NotFound(_) => ErrorKind::NotFound,
            AppError::Io(e) if e.kind() == std::io::ErrorKind::NotFound => ErrorKind::NotFound,
            
            // Cancelled
            AppError::Cancelled(_) => ErrorKind::Cancelled,
            
            // InvalidState
            AppError::InvalidState(_) => ErrorKind::InvalidState,
            AppError::PathInvalid(_) => ErrorKind::InvalidState,
            
            // Permanent - don't retry
            AppError::StorageFull => ErrorKind::Permanent,
            AppError::AlreadyExists(_) => ErrorKind::Permanent,
            AppError::ChecksumMismatch => ErrorKind::Permanent,
            AppError::Transfer(_) => ErrorKind::Permanent,
            AppError::Unknown(_) => ErrorKind::Permanent,
            
            // Default for remaining Io errors
            AppError::Io(_) => ErrorKind::Permanent,
        }
    }
    
    /// Check if this error is retryable
    pub fn is_retryable(&self) -> bool {
        self.kind() == ErrorKind::Transient
    }
    
    /// Check if this error needs user interaction
    pub fn needs_user_action(&self) -> bool {
        matches!(self.kind(), ErrorKind::Permission | ErrorKind::NotFound)
    }
    
    /// Alias for needs_user_action() - matches common naming convention
    pub fn is_user_action_required(&self) -> bool {
        self.needs_user_action()
    }
}

// Serialize AppError to structured JSON for frontend
impl Serialize for AppError {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        use serde::ser::SerializeStruct;
        
        let code = match self {
            AppError::Io(_) => "IO_ERROR",
            AppError::NotFound(_) => "NOT_FOUND",
            AppError::PathInvalid(_) => "PATH_INVALID",
            AppError::AlreadyExists(_) => "ALREADY_EXISTS",
            AppError::PermissionDenied(_) => "PERMISSION_DENIED",
            AppError::PermissionRevoked(_) => "PERMISSION_REVOKED",
            AppError::StorageFull => "STORAGE_FULL",
            AppError::Network(_) => "NETWORK_ERROR",
            AppError::ConnectionLost(_) => "CONNECTION_LOST",
            AppError::Timeout => "TIMEOUT",
            AppError::Transfer(_) => "TRANSFER_ERROR",
            AppError::ChecksumMismatch => "CHECKSUM_MISMATCH",
            AppError::InvalidState(_) => "INVALID_STATE",
            AppError::Cancelled(_) => "CANCELLED",
            AppError::Unknown(_) => "UNKNOWN_ERROR",
        };
        
        let mut state = serializer.serialize_struct("AppError", 3)?;
        state.serialize_field("code", code)?;
        state.serialize_field("message", &self.to_string())?;
        state.serialize_field("kind", &self.kind())?;
        state.end()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn test_error_kind_mapping() {
        assert_eq!(AppError::Timeout.kind(), ErrorKind::Transient);
        assert_eq!(AppError::NotFound("test".into()).kind(), ErrorKind::NotFound);
        assert_eq!(AppError::StorageFull.kind(), ErrorKind::Permanent);
        assert_eq!(AppError::PermissionDenied("test".into()).kind(), ErrorKind::Permission);
    }
    
    #[test]
    fn test_retryable() {
        assert!(AppError::Timeout.is_retryable());
        assert!(!AppError::StorageFull.is_retryable());
    }
    
    #[test]
    fn test_serialize() {
        let error = AppError::NotFound("/path/to/file".into());
        let json = serde_json::to_string(&error).unwrap();
        assert!(json.contains("\"code\":\"NOT_FOUND\""));
        assert!(json.contains("\"kind\":\"NOT_FOUND\""));
    }
}
