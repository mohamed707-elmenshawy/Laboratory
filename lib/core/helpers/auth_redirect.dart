import 'dart:async';

import 'package:flutter/widgets.dart';

mixin AuthRedirect<T extends StatefulWidget> on State<T> {
  static const Duration delay = Duration(seconds: 3);

  Timer? _redirectTimer;

  void scheduleRedirect(void Function(NavigatorState navigator) redirect) {
    _redirectTimer?.cancel();
    _redirectTimer = Timer(delay, () {
      if (!mounted || !(ModalRoute.of(context)?.isCurrent ?? false)) return;
      redirect(Navigator.of(context));
    });
  }

  void redirectToSignIn() => scheduleRedirect(
    (NavigatorState navigator) =>
        navigator.popUntil((Route<dynamic> route) => route.isFirst),
  );

  @override
  void dispose() {
    _redirectTimer?.cancel();
    super.dispose();
  }
}
