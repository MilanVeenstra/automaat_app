import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'core/providers/core_providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiseer timezone database voor notificaties
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Amsterdam'));

  runApp(const ProviderScope(child: AutoMaatApp()));
}

/// Root widget voor de AutoMaat applicatie
class AutoMaatApp extends ConsumerStatefulWidget {
  const AutoMaatApp({super.key});

  @override
  ConsumerState<AutoMaatApp> createState() => _AutoMaatAppState();
}

class _AutoMaatAppState extends ConsumerState<AutoMaatApp> {
  @override
  void initState() {
    super.initState();
    // Controleer auth status bij app start (sessie persistentie)
    Future.microtask(() {
      ref.read(authNotifierProvider.notifier).checkAuthStatus();

      // Initialiseer sync service om te luisteren naar connectiviteit wijzigingen
      ref.read(syncServiceProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'AutoMaat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
