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
  Future<void> navigateTo(String path) async {
    state = state.copyWith(isLoading: true, error: null, selectedPaths: {});
    
    try {
      final files = <FileEntryModel>[];
      
      await for (final entry in _client.listDir(
        path,
        showHidden: state.showHidden,
        sortBy: _mapSortBy(state.sortBy),
        sortOrder: _mapSortOrder(state.sortOrder),
      )) {
        files.add(FileEntryModel(
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
        ));
      }
      
      state = state.copyWith(
        currentPath: path,
        files: files,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load directory: $e',
      );
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
    
    final path = '${state.currentPath}\\$name';
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
    
    final path = '${state.currentPath}\\$name';
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
  String? _getParentPath(String path) {
    // Handle Windows paths
    if (path.length <= 3) return null; // Root drive like "C:\"
    
    final normalized = path.replaceAll('/', '\\');
    final lastSep = normalized.lastIndexOf('\\');
    if (lastSep <= 2) return '${normalized.substring(0, 3)}';
    
    return normalized.substring(0, lastSep);
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
