import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;

part 'app_database.g.dart';

/// Tabel voor het cachen van auto data
class CarsCache extends Table {
  IntColumn get id => integer()();
  TextColumn get brand => text()();
  TextColumn get model => text()();
  TextColumn get picture => text().nullable()();
  TextColumn get fuel => text()();
  TextColumn get licensePlate => text()();
  RealColumn get engineSize => real()();
  IntColumn get modelYear => integer()();
  RealColumn get price => real()();
  IntColumn get nrOfSeats => integer()();
  TextColumn get body => text()();
  RealColumn get longitude => real().nullable()();
  RealColumn get latitude => real().nullable()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tabel voor het wachtrijen van offline acties
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get actionType => text()();
  TextColumn get payload => text()(); // JSON string
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get error => text().nullable()();
}

/// Hoofd database class
@DriftDatabase(tables: [CarsCache, SyncQueue])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Test constructor met custom executor
  @visibleForTesting
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  // Auto Cache Operaties 

  /// Haal alle gecachte auto's op
  Future<List<CarsCacheData>> getAllCachedCars() async {
    return await select(carsCache).get();
  }

  /// Cache een enkele auto
  Future<void> cacheCar(CarsCacheCompanion car) async {
    await into(carsCache).insertOnConflictUpdate(car);
  }

  /// Cache meerdere auto's
  Future<void> cacheAllCars(List<CarsCacheCompanion> cars) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(carsCache, cars);
    });
  }

  /// Wis alle gecachte auto's
  Future<void> clearCarsCache() async {
    await delete(carsCache).go();
  }

  /// Haal gecachte auto op via ID
  Future<CarsCacheData?> getCachedCarById(int id) async {
    return await (select(carsCache)..where((c) => c.id.equals(id)))
        .getSingleOrNull();
  }

  // Sync Wachtrij Operaties 

  /// Voeg actie toe aan sync wachtrij
  Future<int> addToSyncQueue(SyncQueueCompanion action) async {
    return await into(syncQueue).insert(action);
  }

  /// Haal alle wachtende sync acties op
  Future<List<SyncQueueData>> getPendingSyncActions() async {
    return await (select(syncQueue)..orderBy([(s) => OrderingTerm.asc(s.id)]))
        .get();
  }

  /// Verwijder actie uit sync wachtrij
  Future<void> removeSyncAction(int id) async {
    await (delete(syncQueue)..where((s) => s.id.equals(id))).go();
  }

  /// Update sync actie retry teller en fout
  Future<void> updateSyncActionError(
      int id, int retryCount, String error) async {
    await (update(syncQueue)..where((s) => s.id.equals(id))).write(
      SyncQueueCompanion(
        retryCount: Value(retryCount),
        error: Value(error),
      ),
    );
  }

  /// Wis alle sync wachtrij
  Future<void> clearSyncQueue() async {
    await delete(syncQueue).go();
  }

  /// Haal sync wachtrij aantal op
  Future<int> getSyncQueueCount() async {
    final count = syncQueue.id.count();
    final query = selectOnly(syncQueue)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }
}

/// Open verbinding naar de database
QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'automaat_db',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}
