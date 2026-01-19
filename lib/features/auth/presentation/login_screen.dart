import 'package:flutter/material.dart';

/// Placeholder login screen for Phase 0
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Text('Login Screen - Coming in Phase 2'),
      ),
    );
  }
}
