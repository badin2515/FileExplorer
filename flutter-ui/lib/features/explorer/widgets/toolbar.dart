import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/explorer_provider.dart';

class ExplorerToolbar extends ConsumerWidget {
  const ExplorerToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(explorerProvider);
    final notifier = ref.read(explorerProvider.notifier);
    
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          // Navigation buttons
          _ToolbarButton(
            icon: Icons.arrow_back_rounded,
            tooltip: 'Back',
            onPressed: () => notifier.goUp(),
          ),
          
          _ToolbarButton(
            icon: Icons.arrow_upward_rounded,
            tooltip: 'Up',
            onPressed: state.currentPath != null ? () => notifier.goUp() : null,
          ),
          
          _ToolbarButton(
            icon: Icons.refresh_rounded,
            tooltip: 'Refresh',
            onPressed: () => notifier.refresh(),
          ),
          
          const SizedBox(width: 8),
          const VerticalDivider(width: 1),
          const SizedBox(width: 8),
          
          // Path bar
          Expanded(
            child: Container(
              height: 32,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(
                    Icons.folder_rounded,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.currentPath ?? 'Select a folder',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[300],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          const VerticalDivider(width: 1),
          const SizedBox(width: 8),
          
          // Action buttons
          _ToolbarButton(
            icon: Icons.create_new_folder_rounded,
            tooltip: 'New Folder',
            onPressed: () => _showNewFolderDialog(context, notifier),
          ),
          
          _ToolbarButton(
            icon: Icons.note_add_rounded,
            tooltip: 'New File',
            onPressed: () => _showNewFileDialog(context, notifier),
          ),
          
          const SizedBox(width: 8),
          const VerticalDivider(width: 1),
          const SizedBox(width: 8),
          
          // View options
          _ToolbarButton(
            icon: state.showHidden 
                ? Icons.visibility_rounded 
                : Icons.visibility_off_rounded,
            tooltip: state.showHidden ? 'Hide hidden files' : 'Show hidden files',
            onPressed: () => notifier.toggleHidden(),
          ),
          
          // Sort dropdown
          PopupMenuButton<SortBy>(
            tooltip: 'Sort by',
            icon: const Icon(Icons.sort_rounded, size: 20),
            onSelected: (sortBy) {
              final newOrder = sortBy == state.sortBy && state.sortOrder == SortOrder.asc
                  ? SortOrder.desc
                  : SortOrder.asc;
              notifier.setSort(sortBy, newOrder);
            },
            itemBuilder: (context) => [
              _buildSortMenuItem(context, 'Name', SortBy.name, state),
              _buildSortMenuItem(context, 'Size', SortBy.size, state),
              _buildSortMenuItem(context, 'Date Modified', SortBy.modified, state),
              _buildSortMenuItem(context, 'Type', SortBy.type, state),
            ],
          ),
        ],
      ),
    );
  }

  PopupMenuItem<SortBy> _buildSortMenuItem(
    BuildContext context,
    String label,
    SortBy sortBy,
    ExplorerState state,
  ) {
    final isSelected = state.sortBy == sortBy;
    return PopupMenuItem(
      value: sortBy,
      child: Row(
        children: [
          if (isSelected)
            Icon(
              state.sortOrder == SortOrder.asc 
                  ? Icons.arrow_upward 
                  : Icons.arrow_downward,
              size: 16,
            )
          else
            const SizedBox(width: 16),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  Future<void> _showNewFolderDialog(BuildContext context, ExplorerNotifier notifier) async {
    final controller = TextEditingController();
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Folder'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Folder name',
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
            child: const Text('Create'),
          ),
        ],
      ),
    );
    
    if (result != null && result.isNotEmpty) {
      await notifier.createFolder(result);
    }
  }

  Future<void> _showNewFileDialog(BuildContext context, ExplorerNotifier notifier) async {
    final controller = TextEditingController();
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New File'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'File name',
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
            child: const Text('Create'),
          ),
        ],
      ),
    );
    
    if (result != null && result.isNotEmpty) {
      await notifier.createFile(result);
    }
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  const _ToolbarButton({
    required this.icon,
    required this.tooltip,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 20),
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        foregroundColor: onPressed != null ? Colors.grey[300] : Colors.grey[600],
      ),
    );
  }
}
