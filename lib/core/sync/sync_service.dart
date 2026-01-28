import 'dart:async';

import '../database/app_database.dart';
import '../network/connectivity_service.dart';
import 'sync_models.dart';

/// Callback type voor het uitvoeren van gesynchroniseerde acties
typedef SyncActionExecutor = Future<void> Function(
    SyncActionType type, SyncActionPayload payload);

/// Service voor het synchroniseren van offline acties in de wachtrij
class SyncService {
  final AppDatabase _database;
  final ConnectivityService _connectivityService;
  final SyncActionExecutor? _actionExecutor;

  StreamSubscription<bool>? _connectivitySubscription;
  bool _isSyncing = false;
  static const int maxRetries = 3;

  SyncService({
    required AppDatabase database,
    required ConnectivityService connectivityService,
    SyncActionExecutor? actionExecutor,
  })  : _database = database,
        _connectivityService = connectivityService,
        _actionExecutor = actionExecutor;

  /// Start luisteren naar connectiviteit wijzigingen
  void startListening() {
    _connectivitySubscription =
        _connectivityService.connectivityStream.listen((isConnected) {
      if (isConnected) {
        syncPendingActions();
      }
    });
  }

  /// Stop luisteren naar connectiviteit wijzigingen
  void stopListening() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  /// Handmatig synchronisatie van wachtende acties starten
  Future<void> syncPendingActions() async {
    if (_isSyncing) return; // Voorkom gelijktijdige synchronisaties

    final isConnected = await _connectivityService.isConnected;
    if (!isConnected) return; // Sla over als offline

    _isSyncing = true;

    try {
      final pendingActions = await _database.getPendingSyncActions();

      for (final action in pendingActions) {
        try {
          await _processSyncAction(action);
          // Gelukt verwijder uit wachtrij
          await _database.removeSyncAction(action.id);
        } catch (e) {
          // Fout update retry teller
          final newRetryCount = action.retryCount + 1;
          if (newRetryCount >= maxRetries) {
            // Maximaal aantal pogingen bereikt verwijder uit wachtrij
            await _database.removeSyncAction(action.id);
          } else {
            // Update fout en retry teller
            await _database.updateSyncActionError(
              action.id,
              newRetryCount,
              e.toString(),
            );
          }
        }
      }
    } finally {
      _isSyncing = false;
    }
  }

  /// Verwerk een enkele sync actie
  Future<void> _processSyncAction(SyncQueueData action) async {
    final actionType = SyncActionType.fromJson(action.actionType);
    final payload = SyncPayloadCodec.decode(actionType, action.payload);

    if (_actionExecutor != null) {
      await _actionExecutor(actionType, payload);
    } else {
      // Standaard implementaties
      switch (actionType) {
        case SyncActionType.toggleFavorite:
          // Favorieten zijn al lokaal opgeslagen geen synchronisatie nodig
          break;
        case SyncActionType.endRental:
        case SyncActionType.createDamageReport:
          throw Exception(
              'No action executor provided for ${actionType.name}');
      }
    }
  }

  /// Haal huidige sync wachtrij aantal op
  Future<int> getQueueCount() async {
    return await _database.getSyncQueueCount();
  }

  /// Ruim resources op
  void dispose() {
    stopListening();
  }
}
