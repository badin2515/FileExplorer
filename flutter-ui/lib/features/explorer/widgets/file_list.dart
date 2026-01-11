import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/explorer_provider.dart';

class FileListPanel extends ConsumerStatefulWidget {
  const FileListPanel({super.key});

  @override
  ConsumerState<FileListPanel> createState() => _FileListPanelState();
}

class _FileListPanelState extends ConsumerState<FileListPanel> {
  final ScrollController _scrollController = ScrollController();
  
  // Double-tap implementation
  int? _lastTapTime;
  String? _lastTapPath;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(explorerProvider.notifier).loadMore();
    }
  }
  
  void _handleTap(FileEntryModel file, ExplorerNotifier notifier, bool isCtrlPressed) {
    final now = DateTime.now().millisecondsSinceEpoch;
    
    // Check for double tap
    if (_lastTapPath == file.path && 
        _lastTapTime != null && 
        (now - _lastTapTime! < 300)) { // 300ms threshold
      
      // Double tap detected
      if (file.isDir) {
        notifier.navigateTo(file.path);
      }
      // TODO: Open file
      
      _lastTapTime = null; // Reset
      return;
    }
    
    // Single tap logic (Selection)
    _lastTapPath = file.path;
    _lastTapTime = now;
    
    if (isCtrlPressed) {
      notifier.toggleSelection(file.path);
    } else {
      notifier.selectSingle(file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(explorerProvider);
    final notifier = ref.read(explorerProvider.notifier);
    
    if (state.isLoading && state.files.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              state.error!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.red[400],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => notifier.refresh(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    if (state.files.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 48, color: Colors.grey[600]),
            const SizedBox(height: 16),
            Text(
              'This folder is empty',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }
    
    return Column(
      children: [
        // Header row
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
              bottom: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 48), // Space for icon matching list item
              Expanded(
                flex: 3,
                child: Text(
                  'Name',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Size',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Modified',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // File list
        Expanded(
          child: CallbackShortcuts(
            bindings: {
              const SingleActivator(LogicalKeyboardKey.keyA, control: true): () => notifier.selectAll(),
              const SingleActivator(LogicalKeyboardKey.escape): () => notifier.clearSelection(),
            },
            child: Focus(
              autofocus: true,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.files.length + (state.isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.files.length) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final file = state.files[index];
                  final isSelected = state.selectedPaths.contains(file.path);
                  
                  return _FileListItem(
                    file: file,
                    isSelected: isSelected,
                    onTap: () {
                      final isCtrlPressed = HardwareKeyboard.instance.logicalKeysPressed
                          .contains(LogicalKeyboardKey.controlLeft) || 
                          HardwareKeyboard.instance.logicalKeysPressed
                          .contains(LogicalKeyboardKey.controlRight);

                      _handleTap(file, notifier, isCtrlPressed);
                    },
                    onContextMenu: (offset) {
                      // Select if not already selected
                      if (!isSelected) {
                        notifier.selectSingle(file.path);
                      }
                      _showContextMenu(context, offset, file, notifier);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showContextMenu(
    BuildContext context,
    Offset offset,
    FileEntryModel file,
    ExplorerNotifier notifier,
  ) {
    showMenu<void>(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx, offset.dy),
      items: <PopupMenuEntry<void>>[
        PopupMenuItem<void>(
          child: const Row(
            children: [
              Icon(Icons.folder_open, size: 18),
              SizedBox(width: 12),
              Text('Open'),
            ],
          ),
          onTap: () {
            if (file.isDir) {
              notifier.navigateTo(file.path);
            }
          },
        ),
        const PopupMenuDivider(),
        PopupMenuItem<void>(
          child: const Row(
            children: [
              Icon(Icons.content_copy, size: 18),
              SizedBox(width: 12),
              Text('Copy'),
            ],
          ),
          onTap: () {
            // TODO: Copy to clipboard
          },
        ),
        PopupMenuItem<void>(
          child: const Row(
            children: [
              Icon(Icons.content_cut, size: 18),
              SizedBox(width: 12),
              Text('Cut'),
            ],
          ),
          onTap: () {
            // TODO: Cut to clipboard
          },
        ),
        const PopupMenuDivider(),
        PopupMenuItem<void>(
          child: const Row(
            children: [
              Icon(Icons.drive_file_rename_outline, size: 18),
              SizedBox(width: 12),
              Text('Rename'),
            ],
          ),
          onTap: () async {
            await Future.delayed(Duration.zero);
            if (!context.mounted) return;
            _showRenameDialog(context, file, notifier);
          },
        ),
        PopupMenuItem<void>(
          child: Row(
            children: [
              Icon(Icons.delete, size: 18, color: Colors.red[400]),
              const SizedBox(width: 12),
              Text('Delete', style: TextStyle(color: Colors.red[400])),
            ],
          ),
          onTap: () {
            notifier.deleteSelected();
          },
        ),
      ],
    );
  }

  Future<void> _showRenameDialog(
    BuildContext context,
    FileEntryModel file,
    ExplorerNotifier notifier,
  ) async {
    final controller = TextEditingController(text: file.name);
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'New name',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) => Navigator.pop(context, value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Rename'),
          ),
        ],
      ),
    );
    
    if (result != null && result.isNotEmpty && result != file.name) {
      await notifier.renameItem(file.path, result);
    }
  }
}

class _FileListItem extends StatelessWidget {
  final FileEntryModel file;
  final bool isSelected;
  final VoidCallback onTap;
  final void Function(Offset) onContextMenu;

  const _FileListItem({
    required this.file,
    required this.isSelected,
    required this.onTap,
    required this.onContextMenu,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapUp: (details) => onContextMenu(details.globalPosition),
      child: Material(
        color: isSelected 
            ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
            : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashFactory: NoSplash.splashFactory,
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const SizedBox(width: 8),
                SizedBox(
                  width: 24,
                  child: Icon(
                    _getFileIcon(),
                    size: 20,
                    color: _getIconColor(context),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Text(
                    file.name,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected 
                          ? Theme.of(context).colorScheme.primary
                          : (file.isHidden ? Colors.grey[600] : Colors.grey[200]),
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Text(
                    file.isDir ? '--' : _formatSize(file.size),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected 
                          ? Theme.of(context).colorScheme.primary.withOpacity(0.8)
                          : Colors.grey[500],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    _formatDate(file.modifiedAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected 
                          ? Theme.of(context).colorScheme.primary.withOpacity(0.8)
                          : Colors.grey[500],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getFileIcon() {
    if (file.isDir) return Icons.folder_rounded;
    
    switch (file.extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'doc':
      case 'docx':
        return Icons.description_rounded;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart_rounded;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow_rounded;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
      case 'bmp':
        return Icons.image_rounded;
      case 'mp4':
      case 'avi':
      case 'mkv':
      case 'mov':
      case 'webm':
        return Icons.video_file_rounded;
      case 'mp3':
      case 'wav':
      case 'ogg':
      case 'flac':
        return Icons.audio_file_rounded;
      case 'zip':
      case 'rar':
      case '7z':
      case 'tar':
      case 'gz':
        return Icons.folder_zip_rounded;
      case 'txt':
      case 'md':
        return Icons.text_snippet_rounded;
      case 'js':
      case 'ts':
      case 'py':
      case 'java':
      case 'c':
      case 'cpp':
      case 'go':
      case 'rs':
      case 'dart':
        return Icons.code_rounded;
      case 'html':
      case 'css':
        return Icons.web_rounded;
      case 'json':
      case 'xml':
      case 'yaml':
      case 'yml':
        return Icons.data_object_rounded;
      case 'exe':
      case 'msi':
        return Icons.apps_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  Color _getIconColor(BuildContext context) {
    if (file.isDir) return const Color(0xFFFBBF24); // Yellow for folders
    
    switch (file.extension.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'xls':
      case 'xlsx':
        return Colors.green;
      case 'ppt':
      case 'pptx':
        return Colors.orange;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Colors.purple;
      case 'mp4':
      case 'avi':
      case 'mkv':
        return Colors.pink;
      case 'mp3':
      case 'wav':
        return Colors.cyan;
      case 'zip':
      case 'rar':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays == 0) {
      return 'Today ${DateFormat('HH:mm').format(date)}';
    } else if (diff.inDays == 1) {
      return 'Yesterday ${DateFormat('HH:mm').format(date)}';
    } else if (diff.inDays < 7) {
      return DateFormat('EEEE HH:mm').format(date);
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }
}
