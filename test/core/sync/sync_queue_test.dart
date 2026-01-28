import 'package:automaat_app/core/database/app_database.dart';
import 'package:automaat_app/core/sync/sync_models.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    // Create an in-memory database for testing
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  group('Sync Queue Tests', () {
    test('should add action to sync queue', () async {
      // Arrange
      final payload = EndRentalPayload(
        rentalId: 1,
        carId: 2,
        longitude: 4.4777,
        latitude: 51.9244,
      );

      // Act
      final id = await database.addToSyncQueue(
        SyncQueueCompanion(
          actionType: Value(SyncActionType.endRental.toJson()),
          payload: Value(SyncPayloadCodec.encode(payload)),
          createdAt: Value(DateTime.now()),
        ),
      );

      // Assert
      expect(id, greaterThan(0));
      final count = await database.getSyncQueueCount();
      expect(count, 1);
    });

    test('should retrieve pending sync actions', () async {
      // Arrange - Add multiple actions
      final endRentalPayload = EndRentalPayload(
        rentalId: 1,
        carId: 2,
        longitude: 4.4777,
        latitude: 51.9244,
      );

      final damageReportPayload = CreateDamageReportPayload(
        rentalId: 3,
        result: 'DAMAGED',
        odometer: 50000,
        description: 'Scratch on door',
      );

      await database.addToSyncQueue(
        SyncQueueCompanion(
          actionType: Value(SyncActionType.endRental.toJson()),
          payload: Value(SyncPayloadCodec.encode(endRentalPayload)),
          createdAt: Value(DateTime.now()),
        ),
      );

      await database.addToSyncQueue(
        SyncQueueCompanion(
          actionType: Value(SyncActionType.createDamageReport.toJson()),
          payload: Value(SyncPayloadCodec.encode(damageReportPayload)),
          createdAt: Value(DateTime.now()),
        ),
      );

      // Act
      final actions = await database.getPendingSyncActions();

      // Assert
      expect(actions.length, 2);
      expect(actions[0].actionType, SyncActionType.endRental.toJson());
      expect(actions[1].actionType, SyncActionType.createDamageReport.toJson());
    });

    test('should remove action from sync queue', () async {
      // Arrange
      final payload = ToggleFavoritePayload(carId: 1, isFavorite: true);

      final id = await database.addToSyncQueue(
        SyncQueueCompanion(
          actionType: Value(SyncActionType.toggleFavorite.toJson()),
          payload: Value(SyncPayloadCodec.encode(payload)),
          createdAt: Value(DateTime.now()),
        ),
      );

      // Act
      await database.removeSyncAction(id);

      // Assert
      final count = await database.getSyncQueueCount();
      expect(count, 0);
    });

    test('should update retry count and error', () async {
      // Arrange
      final payload = EndRentalPayload(
        rentalId: 1,
        carId: 2,
        longitude: 4.4777,
        latitude: 51.9244,
      );

      final id = await database.addToSyncQueue(
        SyncQueueCompanion(
          actionType: Value(SyncActionType.endRental.toJson()),
          payload: Value(SyncPayloadCodec.encode(payload)),
          createdAt: Value(DateTime.now()),
        ),
      );

      // Act
      await database.updateSyncActionError(id, 1, 'Network error');

      // Assert
      final actions = await database.getPendingSyncActions();
      expect(actions.length, 1);
      expect(actions.first.retryCount, 1);
      expect(actions.first.error, 'Network error');
    });

    test('should decode payload correctly', () async {
      // Arrange
      final originalPayload = EndRentalPayload(
        rentalId: 123,
        carId: 456,
        longitude: 4.4777,
        latitude: 51.9244,
      );

      final id = await database.addToSyncQueue(
        SyncQueueCompanion(
          actionType: Value(SyncActionType.endRental.toJson()),
          payload: Value(SyncPayloadCodec.encode(originalPayload)),
          createdAt: Value(DateTime.now()),
        ),
      );

      // Act
      final actions = await database.getPendingSyncActions();
      final action = actions.first;
      final actionType = SyncActionType.fromJson(action.actionType);
      final decodedPayload =
          SyncPayloadCodec.decode(actionType, action.payload);

      // Assert
      expect(decodedPayload, isA<EndRentalPayload>());
      final payload = decodedPayload as EndRentalPayload;
      expect(payload.rentalId, 123);
      expect(payload.carId, 456);
      expect(payload.longitude, 4.4777);
      expect(payload.latitude, 51.9244);
    });

    test('should clear sync queue', () async {
      // Arrange - Add multiple actions
      final payload1 = EndRentalPayload(
        rentalId: 1,
        carId: 2,
        longitude: 4.4777,
        latitude: 51.9244,
      );
      final payload2 = ToggleFavoritePayload(carId: 3, isFavorite: true);

      await database.addToSyncQueue(
        SyncQueueCompanion(
          actionType: Value(SyncActionType.endRental.toJson()),
          payload: Value(SyncPayloadCodec.encode(payload1)),
          createdAt: Value(DateTime.now()),
        ),
      );

      await database.addToSyncQueue(
        SyncQueueCompanion(
          actionType: Value(SyncActionType.toggleFavorite.toJson()),
          payload: Value(SyncPayloadCodec.encode(payload2)),
          createdAt: Value(DateTime.now()),
        ),
      );

      // Act
      await database.clearSyncQueue();

      // Assert
      final count = await database.getSyncQueueCount();
      expect(count, 0);
    });
  });
}
