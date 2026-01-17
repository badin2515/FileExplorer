//! FileExplorer Tauri Application
//!
//! ## Architecture Overview
//! 
//! Commands are organized by domain with clear boundaries:
//! 
//! ```text
//! ┌─────────────────────────────────────────────────────────────┐
//! │                      UI Layer (React)                       │
//! │                         ↓ invoke                            │
//! ├────────────────────────┬───────────────────────────────────┤
//! │                   Commands Layer                            │
//! ├────────────┬───────────┼──────────────┬────────────────────┤
//! │ filesystem │  device   │  connection  │     transfer       │
//! │  (paths)   │ (identity)│  (sessions)  │    (streams)       │
//! └────────────┴───────────┴──────────────┴────────────────────┘
//! ```
//! 
//! ## Module Responsibilities
//! 
//! - **filesystem**: Path decisions, validation, local file ops
//! - **device**: Identity, discovery, pairing
//! - **connection**: Session tokens, heartbeat, reconnection  
//! - **transfer**: Stream data, report progress (no retry decisions)
//!
//! ## Core Modules
//!
//! - **state_machine**: Formal state machines for Connection and Transfer
//! - **events**: Inter-module event definitions
//! - **mock_transport**: Fake transport for testing retry/resume/reconnect

mod commands;
mod state_machine;
mod events;

#[cfg(test)]
mod mock_transport;

#[cfg(test)]
mod chaos_tests;

use commands::{
    // Filesystem commands
    list_directory, get_file_info, create_folder, delete_items, rename_item, get_storage_volumes,
    
    // Device commands (identity + discovery)
    start_discovery, stop_discovery, get_discovered_devices, add_device_manually,
    request_pairing, verify_pairing, cancel_pairing, get_my_identity,
    
    // Connection commands (state + heartbeat)
    get_connection_state, connect, disconnect,
    ping, start_heartbeat, stop_heartbeat, attempt_reconnect, validate_session,
    
    // Transfer commands (streams only)
    start_download_stream, start_upload_stream, get_transfer_status, get_all_transfers,
    pause_stream, resume_stream, cancel_stream,
};

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .setup(|app| {
            if cfg!(debug_assertions) {
                app.handle().plugin(
                    tauri_plugin_log::Builder::default()
                        .level(log::LevelFilter::Info)
                        .build(),
                )?;
            }
            
            log::info!("FileExplorer starting...");
            log::info!("Architecture: filesystem → device → connection → transfer");
            Ok(())
        })
        .invoke_handler(tauri::generate_handler![
            // ═══════════════════════════════════════
            // Filesystem (path decisions)
            // ═══════════════════════════════════════
            list_directory,
            get_file_info,
            create_folder,
            delete_items,
            rename_item,
            get_storage_volumes,
            
            // ═══════════════════════════════════════
            // Device (identity + discovery)
            // ═══════════════════════════════════════
            start_discovery,
            stop_discovery,
            get_discovered_devices,
            add_device_manually,
            request_pairing,
            verify_pairing,
            cancel_pairing,
            get_my_identity,
            
            // ═══════════════════════════════════════
            // Connection (sessions + heartbeat)
            // ═══════════════════════════════════════
            get_connection_state,
            connect,
            disconnect,
            ping,
            start_heartbeat,
            stop_heartbeat,
            attempt_reconnect,
            validate_session,
            
            // ═══════════════════════════════════════
            // Transfer (streams only, no retry logic)
            // ═══════════════════════════════════════
            start_download_stream,
            start_upload_stream,
            get_transfer_status,
            get_all_transfers,
            pause_stream,
            resume_stream,
            cancel_stream,
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
