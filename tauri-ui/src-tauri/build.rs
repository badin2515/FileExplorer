fn main() {
    // Fix for stale PATH in VSCode terminal: explicitly point to Winget's protoc
    let protoc_path = std::path::Path::new("C:/Users/Bordin/AppData/Local/Microsoft/WinGet/Links/protoc.exe");
    if protoc_path.exists() {
        std::env::set_var("PROTOC", protoc_path);
    }

    tonic_build::configure()
        .type_attribute(".", "#[derive(serde::Serialize, serde::Deserialize)]")
        .compile_protos(&["proto/filenode.proto"], &["proto"])
        .unwrap_or_else(|e| panic!("Failed to compile protos: {:?}", e));
    tauri_build::build();
}
