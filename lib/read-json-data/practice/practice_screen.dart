import 'package:flutter/material.dart';

import '../../core/design_system/design_system.dart';
import '../server/fake_api.dart';
import 'practice_engine.dart';
import 'practice_levels.dart';
import 'practice_widgets.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  Map<String, dynamic>? _bodies;
  Object? _loadError;
  int _selectedLevel = 1;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _reload() async {
    setState(() {
      _bodies = null;
      _loadError = null;
    });
    await _load();
  }

  Future<void> _load() async {
    final List<String> paths = <String>{
      for (final PracticeLevel level in buildPracticeLevels())
        for (final PracticeSample sample in level.samples) sample.path,
    }.toList();

    try {
      final List<dynamic> bodies = await Future.wait<dynamic>(
        paths.map(FakeApi.get),
      );
      if (!mounted) return;
      setState(() {
        _bodies = <String, dynamic>{
          for (int index = 0; index < paths.length; index++)
            paths[index]: bodies[index],
        };
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadError = error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _buildBody()));
  }

  Widget _buildBody() {
    final Object? loadError = _loadError;
    if (loadError != null) {
      return LoadErrorView(error: loadError, onRetry: _reload);
    }

    final Map<String, dynamic>? bodies = _bodies;
    if (bodies == null) {
      return const LoadingView();
    }

    final List<LevelReport> reports = evaluateLevels(
      buildPracticeLevels(),
      bodies,
    );
    final LevelReport selected = reports.firstWhere(
      (LevelReport report) => report.level.number == _selectedLevel,
      orElse: () => reports.first,
    );
    final int doneCount = reports
        .where((LevelReport report) => report.status == LevelStatus.done)
        .length;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: AppSpacing.x3l,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              PracticeHeader(
                doneCount: doneCount,
                totalCount: reports.length,
                onReload: _reload,
              ),
              const SizedBox(height: AppSpacing.xxl),
              LevelTabs(
                reports: reports,
                selectedLevel: selected.level.number,
                onSelected: (int number) =>
                    setState(() => _selectedLevel = number),
              ),
              const SizedBox(height: AppSpacing.x3l),
              LevelPanel(report: selected),
            ],
          ),
        ),
      ),
    );
  }
}
