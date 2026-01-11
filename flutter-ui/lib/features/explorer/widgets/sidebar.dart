import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/explorer_provider.dart';

class ExplorerSidebar extends ConsumerWidget {
  const ExplorerSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(explorerProvider);
    
    return Container(
      width: 220,
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Access section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Quick Access',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          
          _SidebarItem(
            icon: Icons.home_rounded,
            label: 'Home',
            path: _getHomePath(),
            currentPath: state.currentPath,
            onTap: () => ref.read(explorerProvider.notifier).navigateTo(_getHomePath()),
          ),
          
          _SidebarItem(
            icon: Icons.folder_rounded,
            label: 'Documents',
            path: _getDocumentsPath(),
            currentPath: state.currentPath,
            onTap: () => ref.read(explorerProvider.notifier).navigateTo(_getDocumentsPath()),
          ),
          
          _SidebarItem(
            icon: Icons.download_rounded,
            label: 'Downloads',
            path: _getDownloadsPath(),
            currentPath: state.currentPath,
            onTap: () => ref.read(explorerProvider.notifier).navigateTo(_getDownloadsPath()),
          ),
          
          _SidebarItem(
            icon: Icons.desktop_windows_rounded,
            label: 'Desktop',
            path: _getDesktopPath(),
            currentPath: state.currentPath,
            onTap: () => ref.read(explorerProvider.notifier).navigateTo(_getDesktopPath()),
          ),
          
          const SizedBox(height: 16),
          const Divider(height: 1),
          
          // Drives section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Drives',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          
          if (state.isLoading && state.drives.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            ...state.drives.map((drive) => _DriveItem(
              drive: drive,
              isSelected: state.currentPath?.startsWith(drive.path) ?? false,
              onTap: () => ref.read(explorerProvider.notifier).navigateTo(drive.path),
            )),
          
          const Spacer(),
          
          // Devices section (for future LAN devices)
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.devices_rounded,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'Devices',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'No devices found',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }
  
  // Platform-specific paths (Windows)
  // mapped to Virtual Paths: /drive_c mapped to C:\
  static String _getHomePath() {
    final user = _getUserName();
    return '/drive_c/Users/$user';
  }
  
  static String _getDocumentsPath() {
    final user = _getUserName();
    return '/drive_c/Users/$user/Documents';
  }
  
  static String _getDownloadsPath() {
    final user = _getUserName();
    return '/drive_c/Users/$user/Downloads';
  }
  
  static String _getDesktopPath() {
    final user = _getUserName();
    return '/drive_c/Users/$user/Desktop';
  }
  
  static String _getUserName() {
    // This would be replaced with actual user detection
    return 'Bordin';
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String path;
  final String? currentPath;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.path,
    required this.currentPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentPath == path;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : null,
            border: Border(
              left: BorderSide(
                color: isSelected 
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey[300],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DriveItem extends StatelessWidget {
  final DriveModel drive;
  final bool isSelected;
  final VoidCallback onTap;

  const _DriveItem({
    required this.drive,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : null,
            border: Border(
              left: BorderSide(
                color: isSelected 
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    drive.isRemovable 
                        ? Icons.usb_rounded 
                        : Icons.storage_rounded,
                    size: 18,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${drive.label} (${drive.name})',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[300],
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const SizedBox(width: 30),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: drive.usedPercent / 100,
                      backgroundColor: Colors.grey[800],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        drive.usedPercent > 90 
                            ? Colors.red 
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const SizedBox(width: 30),
                  Text(
                    '${_formatBytes(drive.freeSpace)} free of ${_formatBytes(drive.totalSpace)}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
