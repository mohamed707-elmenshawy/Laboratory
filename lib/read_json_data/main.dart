import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/design_system/design_system.dart';
import 'parsers.dart';

// flutter run -d chrome -t lib/read_json_data/main.dart
void main() => runApp(const ReadJsonDataApp());

const String _folder = 'lib/read_json_data/json';

class ReadJsonDataApp extends StatelessWidget {
  const ReadJsonDataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'read_json_data',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(arabic: false),
      home: const JsonPlaygroundScreen(),
    );
  }
}

class JsonPlaygroundScreen extends StatefulWidget {
  const JsonPlaygroundScreen({super.key});

  @override
  State<JsonPlaygroundScreen> createState() => _JsonPlaygroundScreenState();
}

class _JsonPlaygroundScreenState extends State<JsonPlaygroundScreen> {
  Map<String, String>? _files;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final Map<String, String> files = <String, String>{};
    for (final String name in parsers.keys) {
      // cache: false عشان لو عدّلت ملف JSON وضغطت R يقرا الجديد.
      files[name] = await rootBundle.loadString(
        '$_folder/$name',
        cache: false,
      );
    }
    if (mounted) setState(() => _files = files);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String>? files = _files;

    return Scaffold(
      appBar: AppBar(title: const Text('read_json_data')),
      body: files == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: <Widget>[
                // الـ parsing بيحصل جوه build، فكل ضغطة r بتشغّل الكود الجديد.
                for (final MapEntry<String, String> file in files.entries)
                  _JsonCard(name: file.key, raw: file.value),
              ],
            ),
    );
  }
}

class _JsonCard extends StatelessWidget {
  const _JsonCard({required this.name, required this.raw});

  final String name;
  final String raw;

  @override
  Widget build(BuildContext context) {
    final (String text, Color color) = _run();

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(name, style: AppTextStyles.h3),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              color: AppColors.surfaceMuted,
              child: SelectableText(
                raw.trim(),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SelectableText(
              text,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  (String, Color) _run() {
    try {
      final Object? result = parsers[name]!(jsonDecode(raw));
      if (result == null) {
        return ('لسه مربطتش موديل في parsers.dart', AppColors.inkSubtle);
      }
      return ('✓ $result', AppColors.success);
    } catch (error) {
      return ('✗ $error', AppColors.danger);
    }
  }
}
