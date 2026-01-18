//! Filesystem Commands
//!
//! Tauri commands for local file system operations.
//! These commands provide the bridge between React UI and Rust filesystem operations.

use serde::{Deserialize, Serialize};
use std::fs;
use std::path::{Path, PathBuf};
use tauri::command;
use crate::error::AppError;

/// File or folder information
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct FileInfo {
    pub id: String,
    pub name: String,
    pub path: String,
    #[serde(rename = "type")]
    pub file_type: FileType,
    pub size: Option<u64>,
    pub modified: Option<i64>,
    pub created: Option<i64>,
    pub is_hidden: bool,
    pub is_readonly: bool,
    pub extension: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum FileType {
    File,
    Folder,
    Symlink,
}

/// List directory request
#[derive(Debug, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct ListDirRequest {
    pub path: String,
    pub include_hidden: Option<bool>,
    pub sort_by: Option<String>,
    pub sort_desc: Option<bool>,
}

/// List directory response
#[derive(Debug, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct ListDirResponse {
    pub path: String,
    pub items: Vec<FileInfo>,
    pub total_count: usize,
}

/// List files and folders in a directory
#[command]
pub async fn list_directory(request: ListDirRequest) -> Result<ListDirResponse, AppError> {
    let path = PathBuf::from(&request.path);
    
    if !path.exists() {
        return Err(AppError::NotFound(request.path));
    }
    
    if !path.is_dir() {
        return Err(AppError::PathInvalid(format!("Not a directory: {}", request.path)));
    }
    
    let include_hidden = request.include_hidden.unwrap_or(false);
    
    let entries = fs::read_dir(&path).map_err(AppError::Io)?;
    
    let mut files: Vec<FileInfo> = Vec::new();
    
    for entry in entries {
        let entry = entry.map_err(AppError::Io)?;
        let metadata = entry.metadata().map_err(AppError::Io)?;
        
        let file_name = entry.file_name().to_string_lossy().to_string();
        
        // Skip hidden files if not requested
        if !include_hidden && file_name.starts_with('.') {
            continue;
        }
        
        // Skip hidden files on Windows
        #[cfg(windows)]
        {
            use std::os::windows::fs::MetadataExt;
            if !include_hidden && (metadata.file_attributes() & 0x2) != 0 {
                continue;
            }
        }
        
        let file_path = entry.path();
        let extension = file_path.extension()
            .map(|e| e.to_string_lossy().to_string());
        
        let file_type = if metadata.is_dir() {
            FileType::Folder
        } else if metadata.is_symlink() {
            FileType::Symlink
        } else {
            FileType::File
        };
        
        let modified = metadata.modified()
            .ok()
            .and_then(|t| t.duration_since(std::time::UNIX_EPOCH).ok())
            .map(|d| d.as_millis() as i64);
        
        let created = metadata.created()
            .ok()
            .and_then(|t| t.duration_since(std::time::UNIX_EPOCH).ok())
            .map(|d| d.as_millis() as i64);
        
        // Generate unique ID from path
        let id = format!("{:x}", md5_hash(&file_path.to_string_lossy()));
        
        files.push(FileInfo {
            id,
            name: file_name,
            path: file_path.to_string_lossy().to_string(),
            file_type,
            size: if metadata.is_file() { Some(metadata.len()) } else { None },
            modified,
            created,
            is_hidden: is_hidden(&entry),
            is_readonly: metadata.permissions().readonly(),
            extension,
        });
    }
    
    // Sort files (folders first, then by name)
    files.sort_by(|a, b| {
        match (&a.file_type, &b.file_type) {
            (FileType::Folder, FileType::File) => std::cmp::Ordering::Less,
            (FileType::File, FileType::Folder) => std::cmp::Ordering::Greater,
            _ => a.name.to_lowercase().cmp(&b.name.to_lowercase()),
        }
    });
    
    let total_count = files.len();
    
    Ok(ListDirResponse {
        path: request.path,
        items: files,
        total_count,
    })
}

/// Get file info
#[command]
pub async fn get_file_info(path: String) -> Result<FileInfo, AppError> {
    let path_buf = PathBuf::from(&path);
    
    if !path_buf.exists() {
        return Err(AppError::NotFound(path));
    }
    
    let metadata = fs::metadata(&path_buf).map_err(AppError::Io)?;
    
    let file_name = path_buf.file_name()
        .map(|n| n.to_string_lossy().to_string())
        .unwrap_or_default();
    
    let extension = path_buf.extension()
        .map(|e| e.to_string_lossy().to_string());
    
    let file_type = if metadata.is_dir() {
        FileType::Folder
    } else if metadata.is_symlink() {
        FileType::Symlink
    } else {
        FileType::File
    };
    
    let modified = metadata.modified()
        .ok()
        .and_then(|t| t.duration_since(std::time::UNIX_EPOCH).ok())
        .map(|d| d.as_millis() as i64);
    
    let created = metadata.created()
        .ok()
        .and_then(|t| t.duration_since(std::time::UNIX_EPOCH).ok())
        .map(|d| d.as_millis() as i64);
    
    Ok(FileInfo {
        id: format!("{:x}", md5_hash(&path)),
        name: file_name,
        path,
        file_type,
        size: if metadata.is_file() { Some(metadata.len()) } else { None },
        modified,
        created,
        is_hidden: false, // TODO: check properly
        is_readonly: metadata.permissions().readonly(),
        extension,
    })
}

/// Create a new folder
#[command]
pub async fn create_folder(path: String, name: String) -> Result<FileInfo, AppError> {
    let parent = PathBuf::from(&path);
    let new_folder = parent.join(&name);
    
    if new_folder.exists() {
        return Err(AppError::AlreadyExists(format!("Folder already exists: {}", name)));
    }
    
    fs::create_dir(&new_folder).map_err(AppError::Io)?;
    
    get_file_info(new_folder.to_string_lossy().to_string()).await
}

/// Delete files or folders
#[command]
pub async fn delete_items(paths: Vec<String>, permanent: bool) -> Result<usize, AppError> {
    let mut deleted = 0;
    
    for path_str in paths {
        let path = PathBuf::from(&path_str);
        
        if !path.exists() {
            continue;
        }
        
        let result = if permanent {
            if path.is_dir() {
                fs::remove_dir_all(&path)
            } else {
                fs::remove_file(&path)
            }
        } else {
            // TODO: Move to trash instead of permanent delete
            // For now, just do permanent delete
            if path.is_dir() {
                fs::remove_dir_all(&path)
            } else {
                fs::remove_file(&path)
            }
        };

        result.map_err(AppError::Io)?;
        
        deleted += 1;
    }
    
    Ok(deleted)
}

/// Rename a file or folder
#[command]
pub async fn rename_item(path: String, new_name: String) -> Result<FileInfo, AppError> {
    let old_path = PathBuf::from(&path);
    
    if !old_path.exists() {
        return Err(AppError::NotFound(path));
    }
    
    let parent = old_path.parent()
        .ok_or_else(|| AppError::PathInvalid("Cannot rename root directory".into()))?;
    
    let new_path = parent.join(&new_name);
    
    if new_path.exists() {
        return Err(AppError::AlreadyExists(format!("'{}' already exists", new_name)));
    }
    
    fs::rename(&old_path, &new_path).map_err(AppError::Io)?;
    
    get_file_info(new_path.to_string_lossy().to_string()).await
}

/// Get storage volumes
#[command]
pub async fn get_storage_volumes() -> Result<Vec<StorageVolume>, AppError> {
    let mut volumes = Vec::new();
    
    #[cfg(windows)]
    {
        // Get Windows drives
        for letter in b'A'..=b'Z' {
            let drive = format!("{}:\\", letter as char);
            let path = PathBuf::from(&drive);
            
            if path.exists() {
                // TODO: Get actual disk space info
                volumes.push(StorageVolume {
                    name: format!("Local Disk ({}:)", letter as char),
                    path: drive,
                    total_bytes: 0,
                    used_bytes: 0,
                    available_bytes: 0,
                    is_removable: false,
                });
            }
        }
    }
    
    #[cfg(unix)]
    {
        volumes.push(StorageVolume {
            name: "Root".to_string(),
            path: "/".to_string(),
            total_bytes: 0,
            used_bytes: 0,
            available_bytes: 0,
            is_removable: false,
        });
        
        // Check common mount points
        let home = std::env::var("HOME").unwrap_or_default();
        if !home.is_empty() {
            volumes.push(StorageVolume {
                name: "Home".to_string(),
                path: home,
                total_bytes: 0,
                used_bytes: 0,
                available_bytes: 0,
                is_removable: false,
            });
        }
    }
    
    Ok(volumes)
}

#[derive(Debug, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct StorageVolume {
    pub name: String,
    pub path: String,
    pub total_bytes: u64,
    pub used_bytes: u64,
    pub available_bytes: u64,
    pub is_removable: bool,
}

// Helper functions

fn md5_hash(s: &str) -> u64 {
    use std::collections::hash_map::DefaultHasher;
    use std::hash::{Hash, Hasher};
    let mut hasher = DefaultHasher::new();
    s.hash(&mut hasher);
    hasher.finish()
}

/// Progress event payload for file operations
#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct OperationProgress {
    pub operation_id: String,
    pub current_file: String,
    pub current_index: usize,
    pub total_files: usize,
    pub bytes_copied: u64,
    pub total_bytes: u64,
}

/// Copy files or folders to a destination
#[command]
pub async fn copy_items(
    app: tauri::AppHandle,
    source_paths: Vec<String>,
    target_folder: String,
    operation_id: Option<String>
) -> Result<(), AppError> {
    use tauri::Emitter;
    
    let target_dir = PathBuf::from(&target_folder);
    
    if !target_dir.exists() {
        return Err(AppError::NotFound(target_folder));
    }
    
    let op_id = operation_id.unwrap_or_else(|| "unknown".to_string());
    let total_files = source_paths.len();
    
    for (index, path_str) in source_paths.iter().enumerate() {
        let source_path = PathBuf::from(path_str);
        if !source_path.exists() {
            continue; // Skip invalid paths
        }
        
        let file_name = source_path.file_name()
            .ok_or_else(|| AppError::PathInvalid("Invalid source path".into()))?;
        let file_name_str = file_name.to_string_lossy().to_string();
            
        let dest_path = target_dir.join(file_name);
        
        // Emit progress event
        let _ = app.emit("copy:progress", OperationProgress {
            operation_id: op_id.clone(),
            current_file: file_name_str,
            current_index: index + 1,
            total_files,
            bytes_copied: 0,
            total_bytes: 0,
        });
        
        if source_path.is_dir() {
            copy_dir_recursive(&source_path, &dest_path)?;
        } else {
            fs::copy(&source_path, &dest_path).map_err(AppError::Io)?;
        }
    }
    
    Ok(())
}

/// Move files or folders to a destination
#[command]
pub async fn move_items(
    app: tauri::AppHandle,
    source_paths: Vec<String>,
    target_folder: String,
    operation_id: Option<String>
) -> Result<(), AppError> {
    use tauri::Emitter;
    
    let target_dir = PathBuf::from(&target_folder);
    
    if !target_dir.exists() {
        return Err(AppError::NotFound(target_folder));
    }
    
    let op_id = operation_id.unwrap_or_else(|| "unknown".to_string());
    let total_files = source_paths.len();
    
    for (index, path_str) in source_paths.iter().enumerate() {
        let source_path = PathBuf::from(path_str);
        if !source_path.exists() {
            continue;
        }
        
        let file_name = source_path.file_name()
            .ok_or_else(|| AppError::PathInvalid("Invalid source path".into()))?;
        let file_name_str = file_name.to_string_lossy().to_string();
            
        let dest_path = target_dir.join(file_name);
        
        // Emit progress event
        let _ = app.emit("move:progress", OperationProgress {
            operation_id: op_id.clone(),
            current_file: file_name_str,
            current_index: index + 1,
            total_files,
            bytes_copied: 0,
            total_bytes: 0,
        });
        
        // Try simple rename first (atomic move on same filesystem)
        if fs::rename(&source_path, &dest_path).is_err() {
            // Fallback: Copy and Delete (across filesystems)
            if source_path.is_dir() {
                copy_dir_recursive(&source_path, &dest_path)?;
                fs::remove_dir_all(&source_path).map_err(AppError::Io)?;
            } else {
                fs::copy(&source_path, &dest_path).map_err(AppError::Io)?;
                fs::remove_file(&source_path).map_err(AppError::Io)?;
            }
        }
    }
    
    Ok(())
}

// Helper for recursive directory copy
fn copy_dir_recursive(src: &Path, dst: &Path) -> Result<(), AppError> {
    if !dst.exists() {
        fs::create_dir_all(dst).map_err(AppError::Io)?;
    }
    
    for entry in fs::read_dir(src).map_err(AppError::Io)? {
        let entry = entry.map_err(AppError::Io)?;
        let file_type = entry.file_type().map_err(AppError::Io)?;
        let dest_path = dst.join(entry.file_name());
        
        if file_type.is_dir() {
            copy_dir_recursive(&entry.path(), &dest_path)?;
        } else {
            fs::copy(entry.path(), &dest_path).map_err(AppError::Io)?;
        }
    }
    Ok(())
}

#[cfg(windows)]
fn is_hidden(entry: &fs::DirEntry) -> bool {
    use std::os::windows::fs::MetadataExt;
    entry.metadata()
        .map(|m| (m.file_attributes() & 0x2) != 0)
        .unwrap_or(false)
}

#[cfg(unix)]
fn is_hidden(entry: &fs::DirEntry) -> bool {
    entry.file_name()
        .to_string_lossy()
        .starts_with('.')
}
