use tauri::Emitter;

pub mod filenode {
    tonic::include_proto!("filenode");
}

use filenode::file_node_client::FileNodeClient;
use filenode::{ListDirRequest, SortBy, SortOrder};
use tonic::transport::Channel;

async fn connect() -> Result<FileNodeClient<Channel>, String> {
    FileNodeClient::connect("http://127.0.0.1:50051")
        .await
        .map_err(|e| format!("Failed to connect to gRPC server: {}", e))
}

#[tauri::command]
async fn list_dir(
    path: String,
    page_token: String,
    page_size: i32,
) -> Result<Vec<filenode::FileEntry>, String> {
    let mut client = connect().await?;

    let request = tonic::Request::new(ListDirRequest {
        path,
        show_hidden: false,
        sort_by: SortBy::SortName.into(),
        sort_order: SortOrder::Asc.into(),
        page_token,
        page_size,
    });

    let mut stream = client
        .list_dir(request)
        .await
        .map_err(|e| format!("gRPC call failed: {}", e))?
        .into_inner();

    let mut entries = Vec::new();

    while let Some(entry) = stream
        .message()
        .await
        .map_err(|e| format!("Stream error: {}", e))?
    {
        entries.push(entry);
    }

    Ok(entries)
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_opener::init())
        .invoke_handler(tauri::generate_handler![list_dir])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
