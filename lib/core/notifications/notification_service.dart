import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// Service voor het beheren van lokale notificaties
class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initialiseer de notificatie service
  Future<void> initialize() async {
    if (_isInitialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
  }

  /// Verwerk notificatie tap
  void _onNotificationTapped(NotificationResponse response) {
    // Hier kan navigatie naar specifiek scherm worden toegevoegd
    // payload bevat: response.payload
  }

  /// Vraag notificatie permissies aan
  Future<bool> requestPermissions() async {
    await initialize();

    // Android 13+ vereist runtime permissie
    final androidImpl = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl != null) {
      final granted = await androidImpl.requestNotificationsPermission();
      return granted ?? false;
    }

    // iOS vereist permissies
    final iosImpl = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (iosImpl != null) {
      final granted = await iosImpl.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true; // Andere platformen hebben geen permissies nodig
  }

  /// Controleer of notificaties ingeschakeld zijn
  Future<bool> areNotificationsEnabled() async {
    await initialize();

    final androidImpl = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl != null) {
      return await androidImpl.areNotificationsEnabled() ?? false;
    }

    return true; // Ga uit van ingeschakeld voor andere platformen
  }

  /// Plan een verhuur start herinnering
  Future<void> scheduleRentalStartReminder({
    required int rentalId,
    required DateTime startTime,
    required String carInfo,
  }) async {
    await initialize();

    // Plan 30 minuten voor verhuur start
    final notificationTime = startTime.subtract(const Duration(minutes: 30));

    // Plan niet als de tijd al verstreken is
    if (notificationTime.isBefore(DateTime.now())) {
      return;
    }

    final scheduledTime = tz.TZDateTime.from(notificationTime, tz.local);

    await _notifications.zonedSchedule(
      rentalId, // Gebruik verhuur ID als notificatie ID
      'Rental Starting Soon',
      'Your rental for $carInfo starts in 30 minutes',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'rental_reminders',
          'Rental Reminders',
          channelDescription: 'Notifications for upcoming rental start/end times',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'rental_start_$rentalId',
    );
  }

  /// Plan een verhuur eind herinnering
  Future<void> scheduleRentalEndReminder({
    required int rentalId,
    required DateTime endTime,
    required String carInfo,
  }) async {
    await initialize();

    // Plan 1 uur voor verhuur einde
    final notificationTime = endTime.subtract(const Duration(hours: 1));

    // Plan niet als de tijd al verstreken is
    if (notificationTime.isBefore(DateTime.now())) {
      return;
    }

    final scheduledTime = tz.TZDateTime.from(notificationTime, tz.local);

    await _notifications.zonedSchedule(
      rentalId + 10000, // Offset ID om conflicten met start herinneringen te voorkomen
      'Rental Ending Soon',
      'Your rental for $carInfo ends in 1 hour. Please return the car.',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'rental_reminders',
          'Rental Reminders',
          channelDescription: 'Notifications for upcoming rental start/end times',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'rental_end_$rentalId',
    );
  }

  /// Annuleer een specifieke notificatie
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Annuleer alle notificaties
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Haal aantal wachtende notificaties op
  Future<int> getPendingNotificationsCount() async {
    final pending = await _notifications.pendingNotificationRequests();
    return pending.length;
  }

  /// Toon directe notificatie (voor testen)
  Future<void> showTestNotification() async {
    await initialize();

    await _notifications.show(
      0,
      'Test Notification',
      'AutoMaat notifications are working!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test Notifications',
          channelDescription: 'Test notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
