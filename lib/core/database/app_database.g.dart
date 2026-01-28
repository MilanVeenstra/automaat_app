// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CarsCacheTable extends CarsCache
    with TableInfo<$CarsCacheTable, CarsCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CarsCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pictureMeta = const VerificationMeta(
    'picture',
  );
  @override
  late final GeneratedColumn<String> picture = GeneratedColumn<String>(
    'picture',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fuelMeta = const VerificationMeta('fuel');
  @override
  late final GeneratedColumn<String> fuel = GeneratedColumn<String>(
    'fuel',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _licensePlateMeta = const VerificationMeta(
    'licensePlate',
  );
  @override
  late final GeneratedColumn<String> licensePlate = GeneratedColumn<String>(
    'license_plate',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _engineSizeMeta = const VerificationMeta(
    'engineSize',
  );
  @override
  late final GeneratedColumn<double> engineSize = GeneratedColumn<double>(
    'engine_size',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelYearMeta = const VerificationMeta(
    'modelYear',
  );
  @override
  late final GeneratedColumn<int> modelYear = GeneratedColumn<int>(
    'model_year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nrOfSeatsMeta = const VerificationMeta(
    'nrOfSeats',
  );
  @override
  late final GeneratedColumn<int> nrOfSeats = GeneratedColumn<int>(
    'nr_of_seats',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    brand,
    model,
    picture,
    fuel,
    licensePlate,
    engineSize,
    modelYear,
    price,
    nrOfSeats,
    body,
    longitude,
    latitude,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cars_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<CarsCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    } else if (isInserting) {
      context.missing(_brandMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('picture')) {
      context.handle(
        _pictureMeta,
        picture.isAcceptableOrUnknown(data['picture']!, _pictureMeta),
      );
    }
    if (data.containsKey('fuel')) {
      context.handle(
        _fuelMeta,
        fuel.isAcceptableOrUnknown(data['fuel']!, _fuelMeta),
      );
    } else if (isInserting) {
      context.missing(_fuelMeta);
    }
    if (data.containsKey('license_plate')) {
      context.handle(
        _licensePlateMeta,
        licensePlate.isAcceptableOrUnknown(
          data['license_plate']!,
          _licensePlateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_licensePlateMeta);
    }
    if (data.containsKey('engine_size')) {
      context.handle(
        _engineSizeMeta,
        engineSize.isAcceptableOrUnknown(data['engine_size']!, _engineSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_engineSizeMeta);
    }
    if (data.containsKey('model_year')) {
      context.handle(
        _modelYearMeta,
        modelYear.isAcceptableOrUnknown(data['model_year']!, _modelYearMeta),
      );
    } else if (isInserting) {
      context.missing(_modelYearMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('nr_of_seats')) {
      context.handle(
        _nrOfSeatsMeta,
        nrOfSeats.isAcceptableOrUnknown(data['nr_of_seats']!, _nrOfSeatsMeta),
      );
    } else if (isInserting) {
      context.missing(_nrOfSeatsMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CarsCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CarsCacheData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      picture: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}picture'],
      ),
      fuel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fuel'],
      )!,
      licensePlate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}license_plate'],
      )!,
      engineSize: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}engine_size'],
      )!,
      modelYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}model_year'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      nrOfSeats: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nr_of_seats'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $CarsCacheTable createAlias(String alias) {
    return $CarsCacheTable(attachedDatabase, alias);
  }
}

class CarsCacheData extends DataClass implements Insertable<CarsCacheData> {
  final int id;
  final String brand;
  final String model;
  final String? picture;
  final String fuel;
  final String licensePlate;
  final double engineSize;
  final int modelYear;
  final double price;
  final int nrOfSeats;
  final String body;
  final double? longitude;
  final double? latitude;
  final DateTime cachedAt;
  const CarsCacheData({
    required this.id,
    required this.brand,
    required this.model,
    this.picture,
    required this.fuel,
    required this.licensePlate,
    required this.engineSize,
    required this.modelYear,
    required this.price,
    required this.nrOfSeats,
    required this.body,
    this.longitude,
    this.latitude,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['brand'] = Variable<String>(brand);
    map['model'] = Variable<String>(model);
    if (!nullToAbsent || picture != null) {
      map['picture'] = Variable<String>(picture);
    }
    map['fuel'] = Variable<String>(fuel);
    map['license_plate'] = Variable<String>(licensePlate);
    map['engine_size'] = Variable<double>(engineSize);
    map['model_year'] = Variable<int>(modelYear);
    map['price'] = Variable<double>(price);
    map['nr_of_seats'] = Variable<int>(nrOfSeats);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  CarsCacheCompanion toCompanion(bool nullToAbsent) {
    return CarsCacheCompanion(
      id: Value(id),
      brand: Value(brand),
      model: Value(model),
      picture: picture == null && nullToAbsent
          ? const Value.absent()
          : Value(picture),
      fuel: Value(fuel),
      licensePlate: Value(licensePlate),
      engineSize: Value(engineSize),
      modelYear: Value(modelYear),
      price: Value(price),
      nrOfSeats: Value(nrOfSeats),
      body: Value(body),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      cachedAt: Value(cachedAt),
    );
  }

  factory CarsCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CarsCacheData(
      id: serializer.fromJson<int>(json['id']),
      brand: serializer.fromJson<String>(json['brand']),
      model: serializer.fromJson<String>(json['model']),
      picture: serializer.fromJson<String?>(json['picture']),
      fuel: serializer.fromJson<String>(json['fuel']),
      licensePlate: serializer.fromJson<String>(json['licensePlate']),
      engineSize: serializer.fromJson<double>(json['engineSize']),
      modelYear: serializer.fromJson<int>(json['modelYear']),
      price: serializer.fromJson<double>(json['price']),
      nrOfSeats: serializer.fromJson<int>(json['nrOfSeats']),
      body: serializer.fromJson<String>(json['body']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'brand': serializer.toJson<String>(brand),
      'model': serializer.toJson<String>(model),
      'picture': serializer.toJson<String?>(picture),
      'fuel': serializer.toJson<String>(fuel),
      'licensePlate': serializer.toJson<String>(licensePlate),
      'engineSize': serializer.toJson<double>(engineSize),
      'modelYear': serializer.toJson<int>(modelYear),
      'price': serializer.toJson<double>(price),
      'nrOfSeats': serializer.toJson<int>(nrOfSeats),
      'body': serializer.toJson<String>(body),
      'longitude': serializer.toJson<double?>(longitude),
      'latitude': serializer.toJson<double?>(latitude),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CarsCacheData copyWith({
    int? id,
    String? brand,
    String? model,
    Value<String?> picture = const Value.absent(),
    String? fuel,
    String? licensePlate,
    double? engineSize,
    int? modelYear,
    double? price,
    int? nrOfSeats,
    String? body,
    Value<double?> longitude = const Value.absent(),
    Value<double?> latitude = const Value.absent(),
    DateTime? cachedAt,
  }) => CarsCacheData(
    id: id ?? this.id,
    brand: brand ?? this.brand,
    model: model ?? this.model,
    picture: picture.present ? picture.value : this.picture,
    fuel: fuel ?? this.fuel,
    licensePlate: licensePlate ?? this.licensePlate,
    engineSize: engineSize ?? this.engineSize,
    modelYear: modelYear ?? this.modelYear,
    price: price ?? this.price,
    nrOfSeats: nrOfSeats ?? this.nrOfSeats,
    body: body ?? this.body,
    longitude: longitude.present ? longitude.value : this.longitude,
    latitude: latitude.present ? latitude.value : this.latitude,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CarsCacheData copyWithCompanion(CarsCacheCompanion data) {
    return CarsCacheData(
      id: data.id.present ? data.id.value : this.id,
      brand: data.brand.present ? data.brand.value : this.brand,
      model: data.model.present ? data.model.value : this.model,
      picture: data.picture.present ? data.picture.value : this.picture,
      fuel: data.fuel.present ? data.fuel.value : this.fuel,
      licensePlate: data.licensePlate.present
          ? data.licensePlate.value
          : this.licensePlate,
      engineSize: data.engineSize.present
          ? data.engineSize.value
          : this.engineSize,
      modelYear: data.modelYear.present ? data.modelYear.value : this.modelYear,
      price: data.price.present ? data.price.value : this.price,
      nrOfSeats: data.nrOfSeats.present ? data.nrOfSeats.value : this.nrOfSeats,
      body: data.body.present ? data.body.value : this.body,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CarsCacheData(')
          ..write('id: $id, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('picture: $picture, ')
          ..write('fuel: $fuel, ')
          ..write('licensePlate: $licensePlate, ')
          ..write('engineSize: $engineSize, ')
          ..write('modelYear: $modelYear, ')
          ..write('price: $price, ')
          ..write('nrOfSeats: $nrOfSeats, ')
          ..write('body: $body, ')
          ..write('longitude: $longitude, ')
          ..write('latitude: $latitude, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    brand,
    model,
    picture,
    fuel,
    licensePlate,
    engineSize,
    modelYear,
    price,
    nrOfSeats,
    body,
    longitude,
    latitude,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CarsCacheData &&
          other.id == this.id &&
          other.brand == this.brand &&
          other.model == this.model &&
          other.picture == this.picture &&
          other.fuel == this.fuel &&
          other.licensePlate == this.licensePlate &&
          other.engineSize == this.engineSize &&
          other.modelYear == this.modelYear &&
          other.price == this.price &&
          other.nrOfSeats == this.nrOfSeats &&
          other.body == this.body &&
          other.longitude == this.longitude &&
          other.latitude == this.latitude &&
          other.cachedAt == this.cachedAt);
}

class CarsCacheCompanion extends UpdateCompanion<CarsCacheData> {
  final Value<int> id;
  final Value<String> brand;
  final Value<String> model;
  final Value<String?> picture;
  final Value<String> fuel;
  final Value<String> licensePlate;
  final Value<double> engineSize;
  final Value<int> modelYear;
  final Value<double> price;
  final Value<int> nrOfSeats;
  final Value<String> body;
  final Value<double?> longitude;
  final Value<double?> latitude;
  final Value<DateTime> cachedAt;
  const CarsCacheCompanion({
    this.id = const Value.absent(),
    this.brand = const Value.absent(),
    this.model = const Value.absent(),
    this.picture = const Value.absent(),
    this.fuel = const Value.absent(),
    this.licensePlate = const Value.absent(),
    this.engineSize = const Value.absent(),
    this.modelYear = const Value.absent(),
    this.price = const Value.absent(),
    this.nrOfSeats = const Value.absent(),
    this.body = const Value.absent(),
    this.longitude = const Value.absent(),
    this.latitude = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  CarsCacheCompanion.insert({
    this.id = const Value.absent(),
    required String brand,
    required String model,
    this.picture = const Value.absent(),
    required String fuel,
    required String licensePlate,
    required double engineSize,
    required int modelYear,
    required double price,
    required int nrOfSeats,
    required String body,
    this.longitude = const Value.absent(),
    this.latitude = const Value.absent(),
    required DateTime cachedAt,
  }) : brand = Value(brand),
       model = Value(model),
       fuel = Value(fuel),
       licensePlate = Value(licensePlate),
       engineSize = Value(engineSize),
       modelYear = Value(modelYear),
       price = Value(price),
       nrOfSeats = Value(nrOfSeats),
       body = Value(body),
       cachedAt = Value(cachedAt);
  static Insertable<CarsCacheData> custom({
    Expression<int>? id,
    Expression<String>? brand,
    Expression<String>? model,
    Expression<String>? picture,
    Expression<String>? fuel,
    Expression<String>? licensePlate,
    Expression<double>? engineSize,
    Expression<int>? modelYear,
    Expression<double>? price,
    Expression<int>? nrOfSeats,
    Expression<String>? body,
    Expression<double>? longitude,
    Expression<double>? latitude,
    Expression<DateTime>? cachedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (brand != null) 'brand': brand,
      if (model != null) 'model': model,
      if (picture != null) 'picture': picture,
      if (fuel != null) 'fuel': fuel,
      if (licensePlate != null) 'license_plate': licensePlate,
      if (engineSize != null) 'engine_size': engineSize,
      if (modelYear != null) 'model_year': modelYear,
      if (price != null) 'price': price,
      if (nrOfSeats != null) 'nr_of_seats': nrOfSeats,
      if (body != null) 'body': body,
      if (longitude != null) 'longitude': longitude,
      if (latitude != null) 'latitude': latitude,
      if (cachedAt != null) 'cached_at': cachedAt,
    });
  }

  CarsCacheCompanion copyWith({
    Value<int>? id,
    Value<String>? brand,
    Value<String>? model,
    Value<String?>? picture,
    Value<String>? fuel,
    Value<String>? licensePlate,
    Value<double>? engineSize,
    Value<int>? modelYear,
    Value<double>? price,
    Value<int>? nrOfSeats,
    Value<String>? body,
    Value<double?>? longitude,
    Value<double?>? latitude,
    Value<DateTime>? cachedAt,
  }) {
    return CarsCacheCompanion(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      picture: picture ?? this.picture,
      fuel: fuel ?? this.fuel,
      licensePlate: licensePlate ?? this.licensePlate,
      engineSize: engineSize ?? this.engineSize,
      modelYear: modelYear ?? this.modelYear,
      price: price ?? this.price,
      nrOfSeats: nrOfSeats ?? this.nrOfSeats,
      body: body ?? this.body,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (picture.present) {
      map['picture'] = Variable<String>(picture.value);
    }
    if (fuel.present) {
      map['fuel'] = Variable<String>(fuel.value);
    }
    if (licensePlate.present) {
      map['license_plate'] = Variable<String>(licensePlate.value);
    }
    if (engineSize.present) {
      map['engine_size'] = Variable<double>(engineSize.value);
    }
    if (modelYear.present) {
      map['model_year'] = Variable<int>(modelYear.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (nrOfSeats.present) {
      map['nr_of_seats'] = Variable<int>(nrOfSeats.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CarsCacheCompanion(')
          ..write('id: $id, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('picture: $picture, ')
          ..write('fuel: $fuel, ')
          ..write('licensePlate: $licensePlate, ')
          ..write('engineSize: $engineSize, ')
          ..write('modelYear: $modelYear, ')
          ..write('price: $price, ')
          ..write('nrOfSeats: $nrOfSeats, ')
          ..write('body: $body, ')
          ..write('longitude: $longitude, ')
          ..write('latitude: $latitude, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _actionTypeMeta = const VerificationMeta(
    'actionType',
  );
  @override
  late final GeneratedColumn<String> actionType = GeneratedColumn<String>(
    'action_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
    'error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    actionType,
    payload,
    createdAt,
    retryCount,
    error,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('action_type')) {
      context.handle(
        _actionTypeMeta,
        actionType.isAcceptableOrUnknown(data['action_type']!, _actionTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_actionTypeMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('error')) {
      context.handle(
        _errorMeta,
        error.isAcceptableOrUnknown(data['error']!, _errorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      actionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_type'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      error: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error'],
      ),
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int id;
  final String actionType;
  final String payload;
  final DateTime createdAt;
  final int retryCount;
  final String? error;
  const SyncQueueData({
    required this.id,
    required this.actionType,
    required this.payload,
    required this.createdAt,
    required this.retryCount,
    this.error,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['action_type'] = Variable<String>(actionType);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      actionType: Value(actionType),
      payload: Value(payload),
      createdAt: Value(createdAt),
      retryCount: Value(retryCount),
      error: error == null && nullToAbsent
          ? const Value.absent()
          : Value(error),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      actionType: serializer.fromJson<String>(json['actionType']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      error: serializer.fromJson<String?>(json['error']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'actionType': serializer.toJson<String>(actionType),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'retryCount': serializer.toJson<int>(retryCount),
      'error': serializer.toJson<String?>(error),
    };
  }

  SyncQueueData copyWith({
    int? id,
    String? actionType,
    String? payload,
    DateTime? createdAt,
    int? retryCount,
    Value<String?> error = const Value.absent(),
  }) => SyncQueueData(
    id: id ?? this.id,
    actionType: actionType ?? this.actionType,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
    retryCount: retryCount ?? this.retryCount,
    error: error.present ? error.value : this.error,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      actionType: data.actionType.present
          ? data.actionType.value
          : this.actionType,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      error: data.error.present ? data.error.value : this.error,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('actionType: $actionType, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('error: $error')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, actionType, payload, createdAt, retryCount, error);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.actionType == this.actionType &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.retryCount == this.retryCount &&
          other.error == this.error);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<String> actionType;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<int> retryCount;
  final Value<String?> error;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.actionType = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.error = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String actionType,
    required String payload,
    required DateTime createdAt,
    this.retryCount = const Value.absent(),
    this.error = const Value.absent(),
  }) : actionType = Value(actionType),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? actionType,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<int>? retryCount,
    Expression<String>? error,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (actionType != null) 'action_type': actionType,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (retryCount != null) 'retry_count': retryCount,
      if (error != null) 'error': error,
    });
  }

  SyncQueueCompanion copyWith({
    Value<int>? id,
    Value<String>? actionType,
    Value<String>? payload,
    Value<DateTime>? createdAt,
    Value<int>? retryCount,
    Value<String?>? error,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      actionType: actionType ?? this.actionType,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      error: error ?? this.error,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (actionType.present) {
      map['action_type'] = Variable<String>(actionType.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('actionType: $actionType, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('error: $error')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CarsCacheTable carsCache = $CarsCacheTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [carsCache, syncQueue];
}

typedef $$CarsCacheTableCreateCompanionBuilder =
    CarsCacheCompanion Function({
      Value<int> id,
      required String brand,
      required String model,
      Value<String?> picture,
      required String fuel,
      required String licensePlate,
      required double engineSize,
      required int modelYear,
      required double price,
      required int nrOfSeats,
      required String body,
      Value<double?> longitude,
      Value<double?> latitude,
      required DateTime cachedAt,
    });
typedef $$CarsCacheTableUpdateCompanionBuilder =
    CarsCacheCompanion Function({
      Value<int> id,
      Value<String> brand,
      Value<String> model,
      Value<String?> picture,
      Value<String> fuel,
      Value<String> licensePlate,
      Value<double> engineSize,
      Value<int> modelYear,
      Value<double> price,
      Value<int> nrOfSeats,
      Value<String> body,
      Value<double?> longitude,
      Value<double?> latitude,
      Value<DateTime> cachedAt,
    });

class $$CarsCacheTableFilterComposer
    extends Composer<_$AppDatabase, $CarsCacheTable> {
  $$CarsCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get picture => $composableBuilder(
    column: $table.picture,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fuel => $composableBuilder(
    column: $table.fuel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get licensePlate => $composableBuilder(
    column: $table.licensePlate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get engineSize => $composableBuilder(
    column: $table.engineSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get modelYear => $composableBuilder(
    column: $table.modelYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nrOfSeats => $composableBuilder(
    column: $table.nrOfSeats,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CarsCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $CarsCacheTable> {
  $$CarsCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get picture => $composableBuilder(
    column: $table.picture,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fuel => $composableBuilder(
    column: $table.fuel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get licensePlate => $composableBuilder(
    column: $table.licensePlate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get engineSize => $composableBuilder(
    column: $table.engineSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get modelYear => $composableBuilder(
    column: $table.modelYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nrOfSeats => $composableBuilder(
    column: $table.nrOfSeats,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CarsCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $CarsCacheTable> {
  $$CarsCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get picture =>
      $composableBuilder(column: $table.picture, builder: (column) => column);

  GeneratedColumn<String> get fuel =>
      $composableBuilder(column: $table.fuel, builder: (column) => column);

  GeneratedColumn<String> get licensePlate => $composableBuilder(
    column: $table.licensePlate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get engineSize => $composableBuilder(
    column: $table.engineSize,
    builder: (column) => column,
  );

  GeneratedColumn<int> get modelYear =>
      $composableBuilder(column: $table.modelYear, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get nrOfSeats =>
      $composableBuilder(column: $table.nrOfSeats, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CarsCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CarsCacheTable,
          CarsCacheData,
          $$CarsCacheTableFilterComposer,
          $$CarsCacheTableOrderingComposer,
          $$CarsCacheTableAnnotationComposer,
          $$CarsCacheTableCreateCompanionBuilder,
          $$CarsCacheTableUpdateCompanionBuilder,
          (
            CarsCacheData,
            BaseReferences<_$AppDatabase, $CarsCacheTable, CarsCacheData>,
          ),
          CarsCacheData,
          PrefetchHooks Function()
        > {
  $$CarsCacheTableTableManager(_$AppDatabase db, $CarsCacheTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CarsCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CarsCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CarsCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> brand = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<String?> picture = const Value.absent(),
                Value<String> fuel = const Value.absent(),
                Value<String> licensePlate = const Value.absent(),
                Value<double> engineSize = const Value.absent(),
                Value<int> modelYear = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<int> nrOfSeats = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
              }) => CarsCacheCompanion(
                id: id,
                brand: brand,
                model: model,
                picture: picture,
                fuel: fuel,
                licensePlate: licensePlate,
                engineSize: engineSize,
                modelYear: modelYear,
                price: price,
                nrOfSeats: nrOfSeats,
                body: body,
                longitude: longitude,
                latitude: latitude,
                cachedAt: cachedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String brand,
                required String model,
                Value<String?> picture = const Value.absent(),
                required String fuel,
                required String licensePlate,
                required double engineSize,
                required int modelYear,
                required double price,
                required int nrOfSeats,
                required String body,
                Value<double?> longitude = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                required DateTime cachedAt,
              }) => CarsCacheCompanion.insert(
                id: id,
                brand: brand,
                model: model,
                picture: picture,
                fuel: fuel,
                licensePlate: licensePlate,
                engineSize: engineSize,
                modelYear: modelYear,
                price: price,
                nrOfSeats: nrOfSeats,
                body: body,
                longitude: longitude,
                latitude: latitude,
                cachedAt: cachedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CarsCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CarsCacheTable,
      CarsCacheData,
      $$CarsCacheTableFilterComposer,
      $$CarsCacheTableOrderingComposer,
      $$CarsCacheTableAnnotationComposer,
      $$CarsCacheTableCreateCompanionBuilder,
      $$CarsCacheTableUpdateCompanionBuilder,
      (
        CarsCacheData,
        BaseReferences<_$AppDatabase, $CarsCacheTable, CarsCacheData>,
      ),
      CarsCacheData,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      required String actionType,
      required String payload,
      required DateTime createdAt,
      Value<int> retryCount,
      Value<String?> error,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      Value<String> actionType,
      Value<String> payload,
      Value<DateTime> createdAt,
      Value<int> retryCount,
      Value<String?> error,
    });

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> actionType = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> error = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                actionType: actionType,
                payload: payload,
                createdAt: createdAt,
                retryCount: retryCount,
                error: error,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String actionType,
                required String payload,
                required DateTime createdAt,
                Value<int> retryCount = const Value.absent(),
                Value<String?> error = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                actionType: actionType,
                payload: payload,
                createdAt: createdAt,
                retryCount: retryCount,
                error: error,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CarsCacheTableTableManager get carsCache =>
      $$CarsCacheTableTableManager(_db, _db.carsCache);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
}
