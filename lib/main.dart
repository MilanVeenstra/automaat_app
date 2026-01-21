import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

void main() {
  runApp(const ProviderScope(child: AutoMaatApp()));
}

/// Root widget for the AutoMaat application
class AutoMaatApp extends ConsumerStatefulWidget {
  const AutoMaatApp({super.key});

  @override
  ConsumerState<AutoMaatApp> createState() => _AutoMaatAppState();
}

class _AutoMaatAppState extends ConsumerState<AutoMaatApp> {
  @override
  void initState() {
    super.initState();
    // Check auth status on app start (session persistence)
    Future.microtask(() {
      ref.read(authNotifierProvider.notifier).checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'AutoMaat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
