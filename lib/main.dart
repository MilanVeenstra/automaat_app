import 'package:flutter/material.dart';

import 'core/router/app_router.dart';

void main() {
  runApp(const AutoMaatApp());
}

/// Root widget for the AutoMaat application
class AutoMaatApp extends StatelessWidget {
  const AutoMaatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AutoMaat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
