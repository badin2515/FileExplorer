import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/grpc/client.dart';
import 'features/explorer/explorer_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: FileNodeApp(),
    ),
  );
}

class FileNodeApp extends StatelessWidget {
  const FileNodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FileNode',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFF0F0F12),
        cardColor: const Color(0xFF18181B),
        dividerColor: const Color(0xFF27272A),
      ),
      home: const ExplorerScreen(),
    );
  }
}
