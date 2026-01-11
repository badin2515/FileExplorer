import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/grpc/client.dart';
import 'widgets/file_list.dart';
import 'widgets/sidebar.dart';
import 'widgets/toolbar.dart';
import 'widgets/preview_panel.dart';
import 'providers/explorer_provider.dart';

class ExplorerScreen extends ConsumerStatefulWidget {
  const ExplorerScreen({super.key});

  @override
  ConsumerState<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends ConsumerState<ExplorerScreen> {
  @override
  void initState() {
    super.initState();
    // Initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(explorerProvider.notifier).loadDrives();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Toolbar
          const ExplorerToolbar(),
          
          // Main content
          Expanded(
            child: Row(
              children: [
                // Sidebar (drives, bookmarks)
                const ExplorerSidebar(),
                
                // Vertical divider
                Container(
                  width: 1,
                  color: Theme.of(context).dividerColor,
                ),
                
                // File list
                const Expanded(
                  child: FileListPanel(),
                ),

                // Vertical divider
                Container(
                  width: 1,
                  color: Theme.of(context).dividerColor,
                ),

                // Preview Panel
                const PreviewPanel(),
              ],
            ),
          ),
          
          // Status bar
          const StatusBar(),
        ],
      ),
    );
  }
}

class StatusBar extends ConsumerWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(explorerProvider);
    
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          Text(
            state.currentPath ?? 'No folder selected',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
          const Spacer(),
          if (state.files.isNotEmpty)
            Text(
              '${state.files.length} items',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }
}
