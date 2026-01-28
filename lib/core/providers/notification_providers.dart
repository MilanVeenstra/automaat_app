import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifications/notification_service.dart';
import '../storage/settings_storage.dart';

/// Provider voor notificatie service
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// Provider voor instellingen opslag
final settingsStorageProvider = Provider<SettingsStorage>((ref) {
  return SettingsStorage();
});

/// Provider voor notificatie ingeschakeld status
final notificationsEnabledProvider = FutureProvider<bool>((ref) async {
  final storage = ref.watch(settingsStorageProvider);
  return await storage.areNotificationsEnabled();
});

/// State notifier voor het beheren van notificatie instellingen
class NotificationSettingsNotifier extends StateNotifier<AsyncValue<bool>> {
  final SettingsStorage _storage;
  final NotificationService _notificationService;

  NotificationSettingsNotifier(this._storage, this._notificationService)
      : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    state = const AsyncValue.loading();
    try {
      final enabled = await _storage.areNotificationsEnabled();
      state = AsyncValue.data(enabled);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Schakel notificatie instelling om
  Future<void> toggleNotifications(bool enabled) async {
    // Vraag permissies aan indien inschakelen
    if (enabled) {
      final granted = await _notificationService.requestPermissions();
      if (!granted) {
        // Permissie geweigerd, houd uitgeschakeld
        state = const AsyncValue.data(false);
        await _storage.setNotificationsEnabled(false);
        return;
      }
    } else {
      // Bij uitschakelen, annuleer alle wachtende notificaties
      await _notificationService.cancelAllNotifications();
    }

    await _storage.setNotificationsEnabled(enabled);
    state = AsyncValue.data(enabled);
  }

  /// Toon test notificatie
  Future<void> showTestNotification() async {
    await _notificationService.showTestNotification();
  }
}

/// Provider voor notificatie instellingen status
final notificationSettingsProvider =
    StateNotifierProvider<NotificationSettingsNotifier, AsyncValue<bool>>(
        (ref) {
  return NotificationSettingsNotifier(
    ref.watch(settingsStorageProvider),
    ref.watch(notificationServiceProvider),
  );
});
