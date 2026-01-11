import { useState, useEffect } from "react";
import "./App.css";
import { invoke } from "@tauri-apps/api/core";
import {
  Folder, File, HardDrive,
  ArrowLeft, ArrowUp,
  RefreshCw, X
} from "lucide-react";
import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

// Types matching Rust structs
interface FileEntry {
  id: string;
  name: string;
  path: string;
  display_path: string;
  is_dir: boolean;
  size: number;
  modified_at: number;
  extension: string;
  mime_type: string;
  is_hidden: boolean;
  is_readonly: boolean;
}

export default function App() {
  const [path, setPath] = useState("/drive_c/Users/Bordin");
  const [files, setFiles] = useState<FileEntry[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [selected, setSelected] = useState<Set<string>>(new Set());

  useEffect(() => {
    loadFiles(path);
  }, [path]);

  async function loadFiles(targetPath: string) {
    setLoading(true);
    setError(null);
    try {
      // Default pagination: 0-1000 items
      const entries = await invoke<FileEntry[]>("list_dir", {
        path: targetPath,
        pageToken: "",
        pageSize: 1000
      });
      setFiles(entries);
    } catch (err) {
      console.error(err);
      setError(String(err));
    } finally {
      setLoading(false);
    }
  }

  function handleNavigate(newPath: string) {
    setPath(newPath);
    setSelected(new Set());
  }

  function handleUp() {
    const parent = path.split("/").slice(0, -1).join("/") || "/";
    // Prevent going to strict root if needed, or handle drive listing
    if (parent === "" || parent === "/") {
      // TODO: Go to drives list
      return;
    }
    handleNavigate(parent);
  }

  function handleSelect(entry: FileEntry, multi: boolean) {
    if (multi) {
      const newSet = new Set(selected);
      if (newSet.has(entry.path)) {
        newSet.delete(entry.path);
      } else {
        newSet.add(entry.path);
      }
      setSelected(newSet);
    } else {
      setSelected(new Set([entry.path]));
    }
  }

  return (
    <div className="flex h-screen w-full bg-background text-text overflow-hidden font-sans">
      {/* Sidebar */}
      <aside className="w-64 bg-surface border-r border-white/5 flex flex-col">
        <div className="p-4 flex items-center gap-2 border-b border-white/5 h-14">
          <div className="w-8 h-8 bg-primary/20 rounded-lg flex items-center justify-center text-primary shadow-[0_0_10px_rgba(139,92,246,0.1)]">
            <Folder size={18} />
          </div>
          <span className="font-bold text-lg tracking-tight">FileNode</span>
        </div>

        <nav className="flex-1 p-2 space-y-1 overflow-y-auto">
          <SidebarItem icon={HardDrive} label="Local Disk (C:)" active={path.startsWith("/drive_c")} onClick={() => handleNavigate("/drive_c")} />
          <SidebarItem icon={Folder} label="Documents" onClick={() => handleNavigate("/drive_c/Users/Bordin/Documents")} />
          <SidebarItem icon={Folder} label="Downloads" onClick={() => handleNavigate("/drive_c/Users/Bordin/Downloads")} />
          <SidebarItem icon={Folder} label="Desktop" onClick={() => handleNavigate("/drive_c/Users/Bordin/Desktop")} />
        </nav>
      </aside>

      {/* Main Content */}
      <main className="flex-1 flex flex-col min-w-0 bg-background/50">
        {/* Toolbar */}
        <header className="h-14 border-b border-white/5 flex items-center px-4 gap-2 bg-surface/50 backdrop-blur-sm">
          <div className="flex items-center gap-1">
            <IconButton icon={ArrowLeft} onClick={handleUp} />
            <IconButton icon={ArrowUp} onClick={handleUp} />
          </div>

          <div className="flex-1 ml-2 bg-secondary/50 h-9 rounded-md flex items-center px-3 text-sm text-muted border border-white/5 hover:border-white/10 transition-colors">
            <span className="truncate select-all cursor-text">{path}</span>
          </div>

          <IconButton icon={RefreshCw} onClick={() => loadFiles(path)} disabled={loading} className={loading ? "animate-spin" : ""} />
        </header>

        {/* File List */}
        <div className="flex-1 overflow-auto p-2" onClick={() => setSelected(new Set())}>
          {error && (
            <div className="flex flex-col items-center justify-center h-full text-red-400">
              <div className="bg-red-500/10 p-4 rounded-full mb-4">
                <X size={32} />
              </div>
              <p className="font-medium text-lg">Unable to load files</p>
              <p className="text-sm opacity-60 mt-1 max-w-md text-center">{error}</p>
              <button
                onClick={() => loadFiles(path)}
                className="mt-6 px-6 py-2 bg-red-500/20 hover:bg-red-500/30 text-red-200 rounded-full text-sm font-medium transition-colors"
              >
                Try Again
              </button>
            </div>
          )}

          {!error && (
            <div className="min-w-[700px]">
              {/* List Header */}
              <div className="grid grid-cols-[40px_1fr_120px_160px] gap-2 px-4 py-3 text-xs font-semibold text-muted/50 uppercase tracking-wider border-b border-white/5 bg-background/50 sticky top-0 backdrop-blur-md z-10 transition-colors">
                <span className="text-center">#</span>
                <span>Name</span>
                <span className="text-right">Size</span>
                <span className="text-right">Date Modified</span>
              </div>

              <div className="mt-1 space-y-0.5">
                {files.map((file) => (
                  <FileRow
                    key={file.path}
                    file={file}
                    selected={selected.has(file.path)}
                    onSelect={(multi) => handleSelect(file, multi)}
                    onNavigate={() => handleNavigate(file.path)}
                  />
                ))}
              </div>

              {files.length === 0 && !loading && (
                <div className="flex flex-col items-center justify-center py-20 text-muted/30 select-none">
                  <Folder size={64} strokeWidth={0.5} className="mb-4" />
                  <p className="text-lg font-light">This folder is empty</p>
                </div>
              )}
            </div>
          )}
        </div>
      </main>
    </div>
  );
}

function SidebarItem({ icon: Icon, label, active, onClick }: { icon: any, label: string, active?: boolean, onClick: () => void }) {
  return (
    <button
      onClick={onClick}
      className={cn(
        "w-full flex items-center gap-3 px-3 py-2 rounded-lg text-sm font-medium transition-all duration-200 group relative overflow-hidden",
        active
          ? "bg-primary/10 text-primary"
          : "text-muted hover:text-text hover:bg-white/5 active:bg-white/10"
      )}
    >
      {active && <div className="absolute left-0 top-1/2 -translate-y-1/2 w-1 h-8 bg-primary rounded-r-full shadow-[0_0_10px_#8b5cf6]" />}
      <Icon size={18} className={cn("transition-colors", active ? "fill-primary/20 text-primary" : "text-muted group-hover:text-text")} />
      {label}
    </button>
  );
}

function IconButton({ icon: Icon, onClick, className, disabled }: { icon: any, onClick: () => void, className?: string, disabled?: boolean }) {
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={cn(
        "p-2 rounded-lg text-muted hover:text-text hover:bg-white/10 transition-colors disabled:opacity-30 disabled:cursor-not-allowed active:bg-white/5",
        className
      )}
    >
      <Icon size={20} />
    </button>
  );
}

function FileRow({ file, selected, onSelect, onNavigate }: {
  file: FileEntry,
  selected: boolean,
  onSelect: (multi: boolean) => void,
  onNavigate: () => void
}) {
  return (
    <div
      className={cn(
        "group grid grid-cols-[40px_1fr_120px_160px] gap-2 px-4 py-2 rounded-md items-center cursor-pointer select-none transition-all duration-100 border border-transparent",
        selected
          ? "bg-primary/20 border-primary/20 shadow-sm z-10"
          : "hover:bg-white/5 hover:border-white/5 active:scale-[0.995]"
      )}
      onClick={(e) => {
        e.stopPropagation();
        onSelect(e.ctrlKey || e.metaKey);
      }}
      onDoubleClick={(e) => {
        e.stopPropagation();
        if (file.is_dir) onNavigate();
      }}
    >
      <div className={cn("flex items-center justify-center", selected ? "text-primary" : "text-muted group-hover:text-text")}>
        {file.is_dir
          ? <Folder size={20} fill="currentColor" fillOpacity={selected ? 0.3 : 0.1} />
          : <File size={18} className="opacity-80" />
        }
      </div>

      <span className={cn("truncate font-medium flex items-center", selected ? "text-white" : "text-gray-300 group-hover:text-white")}>
        {file.name}
      </span>

      <span className="text-right text-muted/60 text-xs tabular-nums font-mono group-hover:text-muted">
        {file.is_dir ? "" : formatBytes(file.size)}
      </span>

      <span className="text-right text-muted/60 text-xs tabular-nums font-mono group-hover:text-muted">
        {new Date(file.modified_at).toLocaleDateString()}
      </span>
    </div>
  );
}

function formatBytes(bytes: number, decimals = 2) {
  if (!+bytes) return '0 B'
  const k = 1024
  const dm = decimals < 0 ? 0 : decimals
  const sizes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return `${parseFloat((bytes / Math.pow(k, i)).toFixed(dm))} ${sizes[i]}`
}
