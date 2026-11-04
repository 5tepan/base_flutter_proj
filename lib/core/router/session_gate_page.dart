import 'package:flutter/material.dart';

/// Показывается, пока из storage читается сессия.
class SessionGatePage extends StatelessWidget {
  const SessionGatePage({super.key});

  static const location = '/session-gate';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
