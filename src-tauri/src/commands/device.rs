//! Device Commands
//!
//! Tauri commands for device identity and discovery.
//! 
//! ## Responsibilities (ONLY):
//! - Device identification (name, id, type)
//! - mDNS/NSD discovery
//! - Pairing flow
//! 
//! ## NOT Responsible For:
//! - Connection state (→ connection module)
//! - Session tokens (→ connection module)
//! - Heartbeat (→ connection module)
//! - Reconnection logic (→ connection module)
//!
//! ## Design:
//! - device = "WHO is out there?"
//! - connection = "Am I connected? Is it still alive?"

use serde::{Deserialize, Serialize};
use tauri::command;

/// Device information - identity only
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct DeviceIdentity {
    pub id: String,
    pub name: String,
    pub device_type: DeviceType,
    pub os_version: Option<String>,
    pub ip_address: String,
    pub grpc_port: u16,
    pub http_port: u16,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum DeviceType {
    Android,
    Windows,
    Linux,
    MacOS,
    Unknown,
}

/// Device capabilities (what this device can do)
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct DeviceCapabilities {
    pub total_storage: u64,
    pub available_storage: u64,
    pub supports_streaming: bool,
    pub max_concurrent_transfers: u32,
    pub protocol_version: String,
}

/// Discovery result
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct DiscoveredDevice {
    pub identity: DeviceIdentity,
    pub last_seen: i64,
    pub signal_strength: Option<i32>,  // For WiFi
}

/// Pairing session (initiated, waiting for code verification)
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct PairingSession {
    pub session_id: String,
    pub device: DeviceIdentity,
    pub code: String,  // 6-digit code to display
    pub expires_at: i64,
}

// ============================================
// Discovery Commands
// ============================================

/// Start mDNS/NSD discovery
#[command]
pub async fn start_discovery() -> Result<(), String> {
    log::info!("Starting device discovery via mDNS...");
    
    // TODO: Implement mDNS discovery
    // Broadcast: "_fileexplorer._tcp.local"
    
    Ok(())
}

/// Stop discovery
#[command]
pub async fn stop_discovery() -> Result<(), String> {
    log::info!("Stopping device discovery...");
    Ok(())
}

/// Get list of discovered devices
#[command]
pub async fn get_discovered_devices() -> Result<Vec<DiscoveredDevice>, String> {
    // TODO: Return from discovery cache
    Ok(vec![])
}

/// Manually add a device by IP
#[command]
pub async fn add_device_manually(
    ip_address: String,
    grpc_port: u16,
    http_port: u16,
) -> Result<DeviceIdentity, String> {
    log::info!("Adding device manually: {}:{}", ip_address, grpc_port);
    
    // TODO: Ping the device to get its identity
    
    Err("Not implemented yet".to_string())
}

// ============================================
// Pairing Commands
// ============================================

/// Request pairing with a device
/// Returns a pairing session with a code to verify
#[command]
pub async fn request_pairing(device_id: String) -> Result<PairingSession, String> {
    log::info!("Requesting pairing with device: {}", device_id);
    
    // TODO: 
    // 1. Find device in discovered list
    // 2. Send pairing request via gRPC
    // 3. Generate 6-digit code
    // 4. Return session
    
    Err("Not implemented yet".to_string())
}

/// Verify pairing code
/// If successful, returns device identity (connection now handles the session)
#[command]
pub async fn verify_pairing(
    session_id: String,
    _code: String,
) -> Result<DeviceIdentity, String> {
    log::info!("Verifying pairing for session: {}", session_id);
    
    // TODO:
    // 1. Verify code with remote device
    // 2. If valid, return device identity
    // 3. Connection module will handle session token
    
    Err("Not implemented yet".to_string())
}

/// Cancel pairing session
#[command]
pub async fn cancel_pairing(session_id: String) -> Result<(), String> {
    log::info!("Cancelling pairing session: {}", session_id);
    Ok(())
}

// ============================================
// Identity Commands
// ============================================

/// Get this device's identity
#[command]
pub async fn get_my_identity() -> Result<DeviceIdentity, String> {
    let hostname = hostname::get()
        .map(|h| h.to_string_lossy().to_string())
        .unwrap_or_else(|_| "Unknown".to_string());
    
    Ok(DeviceIdentity {
        id: generate_device_id(),
        name: hostname,
        device_type: DeviceType::Windows,
        os_version: Some(std::env::consts::OS.to_string()),
        ip_address: "0.0.0.0".to_string(),  // TODO: Get actual IP
        grpc_port: 50051,
        http_port: 8080,
    })
}

// ============================================
// Helpers
// ============================================

fn generate_device_id() -> String {
    // TODO: Generate stable device ID (based on hardware or stored UUID)
    "device-windows-001".to_string()
}
