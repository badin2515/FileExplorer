import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/explorer_provider.dart';

class PreviewPanel extends ConsumerWidget {
  const PreviewPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(explorerProvider);
    
    // Logic to determine what to preview
    // If multiple selected: show count
    // If single selected: show details
    // If none selected: show nothing or hint
    
    if (state.selectedPaths.isEmpty) {
      return Container(
        width: 300,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border(
            left: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        child: const Center(
          child: Text(
            'Select a file to preview',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    if (state.selectedPaths.length > 1) {
       return Container(
        width: 300,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border(
            left: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.copy, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                '${state.selectedPaths.length} items selected',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      );
    }

    // Single file preview
    final selectedPath = state.selectedPaths.first;
    final file = state.files.firstWhere(
      (f) => f.path == selectedPath,
      orElse: () => state.files.first, // Should not happen if sync is correct
    );

    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          left: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(
                  _getFileIcon(file.extension), 
                  size: 64, 
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  file.name,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),

          // Details List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildInfoRow(context, 'Type', file.extension.toUpperCase()),
                _buildInfoRow(context, 'Size', _formatSize(file.size)),
                _buildInfoRow(context, 'Modified', _formatDate(file.modifiedAt)),
                _buildInfoRow(context, 'Path', file.displayPath),
                
                const SizedBox(height: 24),
                
                // Info Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: const Text(
                    'Preview not supported for this file type yet.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const SizedBox(height: 16),
                FilledButton.tonalIcon(
                  onPressed: () {
                    // Open logic
                    if (file.isDir) {
                      ref.read(explorerProvider.notifier).navigateTo(file.path);
                    }
                  }, 
                  icon: const Icon(Icons.open_in_new), 
                  label: const Text('Open'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
  
  IconData _getFileIcon(String ext) {
    // Basic mapping (duplicate of file_list logic, should refactor to shared)
     return Icons.insert_drive_file;
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  String _formatDate(DateTime date) {
    return date.toString().split('.')[0];
  }
}
