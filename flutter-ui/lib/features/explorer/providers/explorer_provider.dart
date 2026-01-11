import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/grpc/client.dart';
import '../../../core/proto/filenode.pb.dart' as pb;

// State class
class ExplorerState {
  final String? currentPath;
  final List<FileEntryModel> files;
  final List<DriveModel> drives;
  final bool isLoading;
  final String? error;
  final Set<String> selectedPaths;
  final SortBy sortBy;
  final SortOrder sortOrder;
  final bool showHidden;

  const ExplorerState({
    this.currentPath,
    this.files = const [],
    this.drives = const [],
    this.isLoading = false,
    this.error,
    this.selectedPaths = const {},
    this.sortBy = SortBy.name,
    this.sortOrder = SortOrder.asc,
    this.showHidden = false,
  });

  ExplorerState copyWith({
    String? currentPath,
    List<FileEntryModel>? files,
    List<DriveModel>? drives,
    bool? isLoading,
    String? error,
    Set<String>? selectedPaths,
    SortBy? sortBy,
    SortOrder? sortOrder,
    bool? showHidden,
  }) {
    return ExplorerState(
      currentPath: currentPath ?? this.currentPath,
      files: files ?? this.files,
      drives: drives ?? this.drives,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedPaths: selectedPaths ?? this.selectedPaths,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      showHidden: showHidden ?? this.showHidden,
    );
  }
}

// Models
class FileEntryModel {
  final String id;
  final String name;
  final String path;
  final String displayPath;
  final bool isDir;
  final int size;
  final DateTime modifiedAt;
  final String extension;
  final String mimeType;
  final bool isHidden;
  final bool isReadonly;

  const FileEntryModel({
    required this.id,
    required this.name,
    required this.path,
    required this.displayPath,
    required this.isDir,
    required this.size,
    required this.modifiedAt,
    required this.extension,
    required this.mimeType,
    required this.isHidden,
    required this.isReadonly,
  });
}

class DriveModel {
  final String name;
  final String path;
  final String label;
  final int totalSpace;
  final int freeSpace;
  final bool isRemovable;

  const DriveModel({
    required this.name,
    required this.path,
    required this.label,
    required this.totalSpace,
    required this.freeSpace,
    required this.isRemovable,
  });

  double get usedPercent => totalSpace > 0 
      ? ((totalSpace - freeSpace) / totalSpace) * 100 
      : 0;
}

enum SortBy { name, size, modified, type }
enum SortOrder { asc, desc }

// Provider
final explorerProvider = StateNotifierProvider<ExplorerNotifier, ExplorerState>(
  (ref) => ExplorerNotifier(),
);

class ExplorerNotifier extends StateNotifier<ExplorerState> {
  ExplorerNotifier() : super(const ExplorerState());

  final _client = FileNodeGrpcClient.instance;

  /// Load available drives
  Future<void> loadDrives() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await _client.getDrives();
      final drives = response.drives.map((d) => DriveModel(
        name: d.name,
        path: d.path,
        label: d.label,
        totalSpace: d.totalSpace.toInt(),
        freeSpace: d.freeSpace.toInt(),
        isRemovable: d.isRemovable,
      )).toList();
      
      state = state.copyWith(
        drives: drives,
        isLoading: false,
      );
      
      // Navigate to first drive if no path selected
      if (state.currentPath == null && drives.isNotEmpty) {
        await navigateTo(drives.first.path);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load drives: $e',
      );
    }
  }

  /// Navigate to a path
  Future<void> navigateTo(String path, {bool clearStack = true}) async {
    // Normalize path to use /
    final normalizedPath = path.replaceAll('\\', '/');
    state = state.copyWith(
      isLoading: true, 
      error: null, 
      selectedPaths: {},
      currentPath: normalizedPath,
      files: [], // Clear current files
    );
    
    await _loadPage(0);
  }

  /// Load specific page offset
  Future<void> _loadPage(int offset) async {
    if (state.currentPath == null) return;
    
    try {
      final newFiles = <FileEntryModel>[];
      // Default page size 500 matching server
      const pageSize = 500;
       
      await for (final entry in _client.listDir(
        state.currentPath!,
        pageSize: pageSize,
        pageToken: offset.toString(),
        showHidden: state.showHidden,
        sortBy: _mapSortBy(state.sortBy),
        sortOrder: _mapSortOrder(state.sortOrder),
      )) {
         newFiles.add(_mapFileEntry(entry));
      }

      state = state.copyWith(
        files: [...state.files, ...newFiles],
        isLoading: false,
      );
      
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _mapError(e),
      );
    }
  }

  /// Load more items (Infinite Scroll)
  Future<void> loadMore() async {
    if (state.isLoading) return; // Prevent duplicate requests
    if (state.currentPath == null) return;
    
    // Simple logic: If we have multiple of 500 items, assume there might be more
    if (state.files.length % 500 == 0 && state.files.isNotEmpty) {
      // Need to show loading indicator at bottom? 
      // For now just load.
      await _loadPage(state.files.length);
    }
  }

  /// Go up one directory
  Future<void> goUp() async {
    if (state.currentPath == null) return;
    
    final parent = _getParentPath(state.currentPath!);
    if (parent != null) {
      await navigateTo(parent);
    }
  }

  /// Refresh current directory
  Future<void> refresh() async {
    if (state.currentPath != null) {
      await navigateTo(state.currentPath!);
    }
  }

  /// Select single file (clear others)
  void selectSingle(String path) {
    state = state.copyWith(selectedPaths: {path});
  }

  /// Toggle file selection
  void toggleSelection(String path) {
    final newSelection = Set<String>.from(state.selectedPaths);
    if (newSelection.contains(path)) {
      newSelection.remove(path);
    } else {
      newSelection.add(path);
    }
    state = state.copyWith(selectedPaths: newSelection);
  }

  /// Select all files
  void selectAll() {
    final allPaths = state.files.map((f) => f.path).toSet();
    state = state.copyWith(selectedPaths: allPaths);
  }

  /// Clear selection
  void clearSelection() {
    state = state.copyWith(selectedPaths: {});
  }

  /// Set sort options
  void setSort(SortBy sortBy, SortOrder sortOrder) {
    state = state.copyWith(sortBy: sortBy, sortOrder: sortOrder);
    if (state.currentPath != null) {
      navigateTo(state.currentPath!);
    }
  }

  /// Toggle hidden files
  void toggleHidden() {
    state = state.copyWith(showHidden: !state.showHidden);
    if (state.currentPath != null) {
      navigateTo(state.currentPath!);
    }
  }

  /// Create new folder
  Future<bool> createFolder(String name) async {
    if (state.currentPath == null) return false;
    
    final path = '${state.currentPath}/$name';
    final result = await _client.createDir(path);
    
    if (result.success) {
      await refresh();
      return true;
    }
    return false;
  }

  /// Create new file
  Future<bool> createFile(String name) async {
    if (state.currentPath == null) return false;
    
    final path = '${state.currentPath}/$name';
    final result = await _client.createFile(path);
    
    if (result.success) {
      await refresh();
      return true;
    }
    return false;
  }

  /// Delete selected items
  Future<bool> deleteSelected({bool permanent = false}) async {
    if (state.selectedPaths.isEmpty) return false;
    
    final result = await _client.delete(
      state.selectedPaths.toList(),
      permanent: permanent,
    );
    
    if (result.success) {
      await refresh();
      return true;
    }
    return false;
  }

  /// Rename item
  Future<bool> renameItem(String path, String newName) async {
    final result = await _client.rename(path, newName);
    
    if (result.success) {
      await refresh();
      return true;
    }
    return false;
  }

  // Helper methods
  FileEntryModel _mapFileEntry(pb.FileEntry entry) {
    return FileEntryModel(
      id: entry.id,
      name: entry.name,
      path: entry.path,
      displayPath: entry.displayPath,
      isDir: entry.isDir,
      size: entry.size.toInt(),
      modifiedAt: DateTime.fromMillisecondsSinceEpoch(entry.modifiedAt.toInt()),
      extension: entry.extension_8,
      mimeType: entry.mimeType,
      isHidden: entry.isHidden,
      isReadonly: entry.isReadonly,
    );
  }

  String _mapError(dynamic e) {
    final str = e.toString();
    if (str.contains('ERR_PERMISSION_DENIED')) return 'Permission Denied';
    if (str.contains('ERR_NOT_FOUND')) return 'File Not Found';
    if (str.contains('ERR_FILE_LOCKED')) return 'File is In Use';
    if (str.contains('ERR_OUTSIDE_ROOT')) return 'Access Denied';
    return str;
  }

  String? _getParentPath(String path) {
    // Virtual Path logic: /drive_c/Users -> /drive_c
    if (path == '/' || !path.contains('/')) return null;
    
    final parts = path.split('/').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return null;
    
    parts.removeLast();
    if (parts.isEmpty) return null; // Don't allow going to root /, stay at drive root
    
    return '/' + parts.join('/');
  }

  // Proto enum mappings
  pb.SortBy _mapSortBy(SortBy sortBy) {
    switch (sortBy) {
      case SortBy.name:
        return pb.SortBy.SORT_NAME;
      case SortBy.size:
        return pb.SortBy.SORT_SIZE;
      case SortBy.modified:
        return pb.SortBy.SORT_MODIFIED;
      case SortBy.type:
        return pb.SortBy.SORT_TYPE;
    }
  }

  pb.SortOrder _mapSortOrder(SortOrder sortOrder) {
    switch (sortOrder) {
      case SortOrder.asc:
        return pb.SortOrder.ASC;
      case SortOrder.desc:
        return pb.SortOrder.DESC;
    }
  }
}
