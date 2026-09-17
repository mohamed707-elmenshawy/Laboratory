import 'package:flutter/material.dart';

import '../core/design_system/design_system.dart';
import 'practice/practice_screen.dart';

void main() => runApp(const ReadJsonDataApp());

class ReadJsonDataApp extends StatelessWidget {
  const ReadJsonDataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Read JSON Data',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(arabic: true),
      builder: (BuildContext context, Widget? child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      home: const PracticeScreen(),
    );
  }
}
