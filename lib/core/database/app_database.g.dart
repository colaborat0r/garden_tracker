// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $GardensTable extends Gardens with TableInfo<$GardensTable, Garden> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GardensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _locationMeta =
      const VerificationMeta('location');
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
      'location', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, description, location, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gardens';
  @override
  VerificationContext validateIntegrity(Insertable<Garden> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('location')) {
      context.handle(_locationMeta,
          location.isAcceptableOrUnknown(data['location']!, _locationMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Garden map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Garden(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      location: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $GardensTable createAlias(String alias) {
    return $GardensTable(attachedDatabase, alias);
  }
}

class Garden extends DataClass implements Insertable<Garden> {
  final int id;
  final String name;
  final String? description;
  final String? location;
  final DateTime createdAt;
  const Garden(
      {required this.id,
      required this.name,
      this.description,
      this.location,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GardensCompanion toCompanion(bool nullToAbsent) {
    return GardensCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      createdAt: Value(createdAt),
    );
  }

  factory Garden.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Garden(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      location: serializer.fromJson<String?>(json['location']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'location': serializer.toJson<String?>(location),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Garden copyWith(
          {int? id,
          String? name,
          Value<String?> description = const Value.absent(),
          Value<String?> location = const Value.absent(),
          DateTime? createdAt}) =>
      Garden(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        location: location.present ? location.value : this.location,
        createdAt: createdAt ?? this.createdAt,
      );
  Garden copyWithCompanion(GardensCompanion data) {
    return Garden(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      location: data.location.present ? data.location.value : this.location,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Garden(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('location: $location, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, location, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Garden &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.location == this.location &&
          other.createdAt == this.createdAt);
}

class GardensCompanion extends UpdateCompanion<Garden> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> location;
  final Value<DateTime> createdAt;
  const GardensCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.location = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  GardensCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.location = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Garden> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? location,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (location != null) 'location': location,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  GardensCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<String?>? location,
      Value<DateTime>? createdAt}) {
    return GardensCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GardensCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('location: $location, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $BedsTable extends Beds with TableInfo<$BedsTable, Bed> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BedsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _gardenIdMeta =
      const VerificationMeta('gardenId');
  @override
  late final GeneratedColumn<int> gardenId = GeneratedColumn<int>(
      'garden_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES gardens (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('raised'));
  static const VerificationMeta _areaSqFtMeta =
      const VerificationMeta('areaSqFt');
  @override
  late final GeneratedColumn<double> areaSqFt = GeneratedColumn<double>(
      'area_sq_ft', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _locationMeta =
      const VerificationMeta('location');
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
      'location', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _soilTypeMeta =
      const VerificationMeta('soilType');
  @override
  late final GeneratedColumn<String> soilType = GeneratedColumn<String>(
      'soil_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        gardenId,
        name,
        type,
        areaSqFt,
        location,
        soilType,
        notes,
        photoPath,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'beds';
  @override
  VerificationContext validateIntegrity(Insertable<Bed> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('garden_id')) {
      context.handle(_gardenIdMeta,
          gardenId.isAcceptableOrUnknown(data['garden_id']!, _gardenIdMeta));
    } else if (isInserting) {
      context.missing(_gardenIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('area_sq_ft')) {
      context.handle(_areaSqFtMeta,
          areaSqFt.isAcceptableOrUnknown(data['area_sq_ft']!, _areaSqFtMeta));
    }
    if (data.containsKey('location')) {
      context.handle(_locationMeta,
          location.isAcceptableOrUnknown(data['location']!, _locationMeta));
    }
    if (data.containsKey('soil_type')) {
      context.handle(_soilTypeMeta,
          soilType.isAcceptableOrUnknown(data['soil_type']!, _soilTypeMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bed map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bed(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      gardenId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}garden_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      areaSqFt: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}area_sq_ft']),
      location: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location']),
      soilType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}soil_type']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $BedsTable createAlias(String alias) {
    return $BedsTable(attachedDatabase, alias);
  }
}

class Bed extends DataClass implements Insertable<Bed> {
  final int id;
  final int gardenId;
  final String name;
  final String type;
  final double? areaSqFt;
  final String? location;
  final String? soilType;
  final String? notes;
  final String? photoPath;
  final DateTime createdAt;
  const Bed(
      {required this.id,
      required this.gardenId,
      required this.name,
      required this.type,
      this.areaSqFt,
      this.location,
      this.soilType,
      this.notes,
      this.photoPath,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['garden_id'] = Variable<int>(gardenId);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || areaSqFt != null) {
      map['area_sq_ft'] = Variable<double>(areaSqFt);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || soilType != null) {
      map['soil_type'] = Variable<String>(soilType);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BedsCompanion toCompanion(bool nullToAbsent) {
    return BedsCompanion(
      id: Value(id),
      gardenId: Value(gardenId),
      name: Value(name),
      type: Value(type),
      areaSqFt: areaSqFt == null && nullToAbsent
          ? const Value.absent()
          : Value(areaSqFt),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      soilType: soilType == null && nullToAbsent
          ? const Value.absent()
          : Value(soilType),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      createdAt: Value(createdAt),
    );
  }

  factory Bed.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bed(
      id: serializer.fromJson<int>(json['id']),
      gardenId: serializer.fromJson<int>(json['gardenId']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      areaSqFt: serializer.fromJson<double?>(json['areaSqFt']),
      location: serializer.fromJson<String?>(json['location']),
      soilType: serializer.fromJson<String?>(json['soilType']),
      notes: serializer.fromJson<String?>(json['notes']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gardenId': serializer.toJson<int>(gardenId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'areaSqFt': serializer.toJson<double?>(areaSqFt),
      'location': serializer.toJson<String?>(location),
      'soilType': serializer.toJson<String?>(soilType),
      'notes': serializer.toJson<String?>(notes),
      'photoPath': serializer.toJson<String?>(photoPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Bed copyWith(
          {int? id,
          int? gardenId,
          String? name,
          String? type,
          Value<double?> areaSqFt = const Value.absent(),
          Value<String?> location = const Value.absent(),
          Value<String?> soilType = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<String?> photoPath = const Value.absent(),
          DateTime? createdAt}) =>
      Bed(
        id: id ?? this.id,
        gardenId: gardenId ?? this.gardenId,
        name: name ?? this.name,
        type: type ?? this.type,
        areaSqFt: areaSqFt.present ? areaSqFt.value : this.areaSqFt,
        location: location.present ? location.value : this.location,
        soilType: soilType.present ? soilType.value : this.soilType,
        notes: notes.present ? notes.value : this.notes,
        photoPath: photoPath.present ? photoPath.value : this.photoPath,
        createdAt: createdAt ?? this.createdAt,
      );
  Bed copyWithCompanion(BedsCompanion data) {
    return Bed(
      id: data.id.present ? data.id.value : this.id,
      gardenId: data.gardenId.present ? data.gardenId.value : this.gardenId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      areaSqFt: data.areaSqFt.present ? data.areaSqFt.value : this.areaSqFt,
      location: data.location.present ? data.location.value : this.location,
      soilType: data.soilType.present ? data.soilType.value : this.soilType,
      notes: data.notes.present ? data.notes.value : this.notes,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bed(')
          ..write('id: $id, ')
          ..write('gardenId: $gardenId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('areaSqFt: $areaSqFt, ')
          ..write('location: $location, ')
          ..write('soilType: $soilType, ')
          ..write('notes: $notes, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, gardenId, name, type, areaSqFt, location,
      soilType, notes, photoPath, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bed &&
          other.id == this.id &&
          other.gardenId == this.gardenId &&
          other.name == this.name &&
          other.type == this.type &&
          other.areaSqFt == this.areaSqFt &&
          other.location == this.location &&
          other.soilType == this.soilType &&
          other.notes == this.notes &&
          other.photoPath == this.photoPath &&
          other.createdAt == this.createdAt);
}

class BedsCompanion extends UpdateCompanion<Bed> {
  final Value<int> id;
  final Value<int> gardenId;
  final Value<String> name;
  final Value<String> type;
  final Value<double?> areaSqFt;
  final Value<String?> location;
  final Value<String?> soilType;
  final Value<String?> notes;
  final Value<String?> photoPath;
  final Value<DateTime> createdAt;
  const BedsCompanion({
    this.id = const Value.absent(),
    this.gardenId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.areaSqFt = const Value.absent(),
    this.location = const Value.absent(),
    this.soilType = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BedsCompanion.insert({
    this.id = const Value.absent(),
    required int gardenId,
    required String name,
    this.type = const Value.absent(),
    this.areaSqFt = const Value.absent(),
    this.location = const Value.absent(),
    this.soilType = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : gardenId = Value(gardenId),
        name = Value(name);
  static Insertable<Bed> custom({
    Expression<int>? id,
    Expression<int>? gardenId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<double>? areaSqFt,
    Expression<String>? location,
    Expression<String>? soilType,
    Expression<String>? notes,
    Expression<String>? photoPath,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gardenId != null) 'garden_id': gardenId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (areaSqFt != null) 'area_sq_ft': areaSqFt,
      if (location != null) 'location': location,
      if (soilType != null) 'soil_type': soilType,
      if (notes != null) 'notes': notes,
      if (photoPath != null) 'photo_path': photoPath,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BedsCompanion copyWith(
      {Value<int>? id,
      Value<int>? gardenId,
      Value<String>? name,
      Value<String>? type,
      Value<double?>? areaSqFt,
      Value<String?>? location,
      Value<String?>? soilType,
      Value<String?>? notes,
      Value<String?>? photoPath,
      Value<DateTime>? createdAt}) {
    return BedsCompanion(
      id: id ?? this.id,
      gardenId: gardenId ?? this.gardenId,
      name: name ?? this.name,
      type: type ?? this.type,
      areaSqFt: areaSqFt ?? this.areaSqFt,
      location: location ?? this.location,
      soilType: soilType ?? this.soilType,
      notes: notes ?? this.notes,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (gardenId.present) {
      map['garden_id'] = Variable<int>(gardenId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (areaSqFt.present) {
      map['area_sq_ft'] = Variable<double>(areaSqFt.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (soilType.present) {
      map['soil_type'] = Variable<String>(soilType.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BedsCompanion(')
          ..write('id: $id, ')
          ..write('gardenId: $gardenId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('areaSqFt: $areaSqFt, ')
          ..write('location: $location, ')
          ..write('soilType: $soilType, ')
          ..write('notes: $notes, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PlantsTable extends Plants with TableInfo<$PlantsTable, Plant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _bedIdMeta = const VerificationMeta('bedId');
  @override
  late final GeneratedColumn<int> bedId = GeneratedColumn<int>(
      'bed_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES beds (id)'));
  static const VerificationMeta _varietyMeta =
      const VerificationMeta('variety');
  @override
  late final GeneratedColumn<String> variety = GeneratedColumn<String>(
      'variety', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _commonNameMeta =
      const VerificationMeta('commonName');
  @override
  late final GeneratedColumn<String> commonName = GeneratedColumn<String>(
      'common_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _seedStartDateMeta =
      const VerificationMeta('seedStartDate');
  @override
  late final GeneratedColumn<DateTime> seedStartDate =
      GeneratedColumn<DateTime>('seed_start_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _transplantDateMeta =
      const VerificationMeta('transplantDate');
  @override
  late final GeneratedColumn<DateTime> transplantDate =
      GeneratedColumn<DateTime>('transplant_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _expectedHarvestStartMeta =
      const VerificationMeta('expectedHarvestStart');
  @override
  late final GeneratedColumn<DateTime> expectedHarvestStart =
      GeneratedColumn<DateTime>('expected_harvest_start', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('planted'));
  static const VerificationMeta _growthStageMeta =
      const VerificationMeta('growthStage');
  @override
  late final GeneratedColumn<String> growthStage = GeneratedColumn<String>(
      'growth_stage', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        bedId,
        variety,
        commonName,
        seedStartDate,
        transplantDate,
        expectedHarvestStart,
        status,
        growthStage,
        quantity,
        source,
        notes,
        photoPath,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plants';
  @override
  VerificationContext validateIntegrity(Insertable<Plant> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bed_id')) {
      context.handle(
          _bedIdMeta, bedId.isAcceptableOrUnknown(data['bed_id']!, _bedIdMeta));
    } else if (isInserting) {
      context.missing(_bedIdMeta);
    }
    if (data.containsKey('variety')) {
      context.handle(_varietyMeta,
          variety.isAcceptableOrUnknown(data['variety']!, _varietyMeta));
    } else if (isInserting) {
      context.missing(_varietyMeta);
    }
    if (data.containsKey('common_name')) {
      context.handle(
          _commonNameMeta,
          commonName.isAcceptableOrUnknown(
              data['common_name']!, _commonNameMeta));
    } else if (isInserting) {
      context.missing(_commonNameMeta);
    }
    if (data.containsKey('seed_start_date')) {
      context.handle(
          _seedStartDateMeta,
          seedStartDate.isAcceptableOrUnknown(
              data['seed_start_date']!, _seedStartDateMeta));
    }
    if (data.containsKey('transplant_date')) {
      context.handle(
          _transplantDateMeta,
          transplantDate.isAcceptableOrUnknown(
              data['transplant_date']!, _transplantDateMeta));
    }
    if (data.containsKey('expected_harvest_start')) {
      context.handle(
          _expectedHarvestStartMeta,
          expectedHarvestStart.isAcceptableOrUnknown(
              data['expected_harvest_start']!, _expectedHarvestStartMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('growth_stage')) {
      context.handle(
          _growthStageMeta,
          growthStage.isAcceptableOrUnknown(
              data['growth_stage']!, _growthStageMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Plant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Plant(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bedId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bed_id'])!,
      variety: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}variety'])!,
      commonName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}common_name'])!,
      seedStartDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}seed_start_date']),
      transplantDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}transplant_date']),
      expectedHarvestStart: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}expected_harvest_start']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      growthStage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}growth_stage']),
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity']),
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PlantsTable createAlias(String alias) {
    return $PlantsTable(attachedDatabase, alias);
  }
}

class Plant extends DataClass implements Insertable<Plant> {
  final int id;
  final int bedId;
  final String variety;
  final String commonName;
  final DateTime? seedStartDate;
  final DateTime? transplantDate;
  final DateTime? expectedHarvestStart;
  final String status;
  final String? growthStage;
  final int? quantity;
  final String? source;
  final String? notes;
  final String? photoPath;
  final DateTime createdAt;
  const Plant(
      {required this.id,
      required this.bedId,
      required this.variety,
      required this.commonName,
      this.seedStartDate,
      this.transplantDate,
      this.expectedHarvestStart,
      required this.status,
      this.growthStage,
      this.quantity,
      this.source,
      this.notes,
      this.photoPath,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bed_id'] = Variable<int>(bedId);
    map['variety'] = Variable<String>(variety);
    map['common_name'] = Variable<String>(commonName);
    if (!nullToAbsent || seedStartDate != null) {
      map['seed_start_date'] = Variable<DateTime>(seedStartDate);
    }
    if (!nullToAbsent || transplantDate != null) {
      map['transplant_date'] = Variable<DateTime>(transplantDate);
    }
    if (!nullToAbsent || expectedHarvestStart != null) {
      map['expected_harvest_start'] = Variable<DateTime>(expectedHarvestStart);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || growthStage != null) {
      map['growth_stage'] = Variable<String>(growthStage);
    }
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<int>(quantity);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PlantsCompanion toCompanion(bool nullToAbsent) {
    return PlantsCompanion(
      id: Value(id),
      bedId: Value(bedId),
      variety: Value(variety),
      commonName: Value(commonName),
      seedStartDate: seedStartDate == null && nullToAbsent
          ? const Value.absent()
          : Value(seedStartDate),
      transplantDate: transplantDate == null && nullToAbsent
          ? const Value.absent()
          : Value(transplantDate),
      expectedHarvestStart: expectedHarvestStart == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedHarvestStart),
      status: Value(status),
      growthStage: growthStage == null && nullToAbsent
          ? const Value.absent()
          : Value(growthStage),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      source:
          source == null && nullToAbsent ? const Value.absent() : Value(source),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      createdAt: Value(createdAt),
    );
  }

  factory Plant.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Plant(
      id: serializer.fromJson<int>(json['id']),
      bedId: serializer.fromJson<int>(json['bedId']),
      variety: serializer.fromJson<String>(json['variety']),
      commonName: serializer.fromJson<String>(json['commonName']),
      seedStartDate: serializer.fromJson<DateTime?>(json['seedStartDate']),
      transplantDate: serializer.fromJson<DateTime?>(json['transplantDate']),
      expectedHarvestStart:
          serializer.fromJson<DateTime?>(json['expectedHarvestStart']),
      status: serializer.fromJson<String>(json['status']),
      growthStage: serializer.fromJson<String?>(json['growthStage']),
      quantity: serializer.fromJson<int?>(json['quantity']),
      source: serializer.fromJson<String?>(json['source']),
      notes: serializer.fromJson<String?>(json['notes']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bedId': serializer.toJson<int>(bedId),
      'variety': serializer.toJson<String>(variety),
      'commonName': serializer.toJson<String>(commonName),
      'seedStartDate': serializer.toJson<DateTime?>(seedStartDate),
      'transplantDate': serializer.toJson<DateTime?>(transplantDate),
      'expectedHarvestStart':
          serializer.toJson<DateTime?>(expectedHarvestStart),
      'status': serializer.toJson<String>(status),
      'growthStage': serializer.toJson<String?>(growthStage),
      'quantity': serializer.toJson<int?>(quantity),
      'source': serializer.toJson<String?>(source),
      'notes': serializer.toJson<String?>(notes),
      'photoPath': serializer.toJson<String?>(photoPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Plant copyWith(
          {int? id,
          int? bedId,
          String? variety,
          String? commonName,
          Value<DateTime?> seedStartDate = const Value.absent(),
          Value<DateTime?> transplantDate = const Value.absent(),
          Value<DateTime?> expectedHarvestStart = const Value.absent(),
          String? status,
          Value<String?> growthStage = const Value.absent(),
          Value<int?> quantity = const Value.absent(),
          Value<String?> source = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<String?> photoPath = const Value.absent(),
          DateTime? createdAt}) =>
      Plant(
        id: id ?? this.id,
        bedId: bedId ?? this.bedId,
        variety: variety ?? this.variety,
        commonName: commonName ?? this.commonName,
        seedStartDate:
            seedStartDate.present ? seedStartDate.value : this.seedStartDate,
        transplantDate:
            transplantDate.present ? transplantDate.value : this.transplantDate,
        expectedHarvestStart: expectedHarvestStart.present
            ? expectedHarvestStart.value
            : this.expectedHarvestStart,
        status: status ?? this.status,
        growthStage: growthStage.present ? growthStage.value : this.growthStage,
        quantity: quantity.present ? quantity.value : this.quantity,
        source: source.present ? source.value : this.source,
        notes: notes.present ? notes.value : this.notes,
        photoPath: photoPath.present ? photoPath.value : this.photoPath,
        createdAt: createdAt ?? this.createdAt,
      );
  Plant copyWithCompanion(PlantsCompanion data) {
    return Plant(
      id: data.id.present ? data.id.value : this.id,
      bedId: data.bedId.present ? data.bedId.value : this.bedId,
      variety: data.variety.present ? data.variety.value : this.variety,
      commonName:
          data.commonName.present ? data.commonName.value : this.commonName,
      seedStartDate: data.seedStartDate.present
          ? data.seedStartDate.value
          : this.seedStartDate,
      transplantDate: data.transplantDate.present
          ? data.transplantDate.value
          : this.transplantDate,
      expectedHarvestStart: data.expectedHarvestStart.present
          ? data.expectedHarvestStart.value
          : this.expectedHarvestStart,
      status: data.status.present ? data.status.value : this.status,
      growthStage:
          data.growthStage.present ? data.growthStage.value : this.growthStage,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      source: data.source.present ? data.source.value : this.source,
      notes: data.notes.present ? data.notes.value : this.notes,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Plant(')
          ..write('id: $id, ')
          ..write('bedId: $bedId, ')
          ..write('variety: $variety, ')
          ..write('commonName: $commonName, ')
          ..write('seedStartDate: $seedStartDate, ')
          ..write('transplantDate: $transplantDate, ')
          ..write('expectedHarvestStart: $expectedHarvestStart, ')
          ..write('status: $status, ')
          ..write('growthStage: $growthStage, ')
          ..write('quantity: $quantity, ')
          ..write('source: $source, ')
          ..write('notes: $notes, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      bedId,
      variety,
      commonName,
      seedStartDate,
      transplantDate,
      expectedHarvestStart,
      status,
      growthStage,
      quantity,
      source,
      notes,
      photoPath,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Plant &&
          other.id == this.id &&
          other.bedId == this.bedId &&
          other.variety == this.variety &&
          other.commonName == this.commonName &&
          other.seedStartDate == this.seedStartDate &&
          other.transplantDate == this.transplantDate &&
          other.expectedHarvestStart == this.expectedHarvestStart &&
          other.status == this.status &&
          other.growthStage == this.growthStage &&
          other.quantity == this.quantity &&
          other.source == this.source &&
          other.notes == this.notes &&
          other.photoPath == this.photoPath &&
          other.createdAt == this.createdAt);
}

class PlantsCompanion extends UpdateCompanion<Plant> {
  final Value<int> id;
  final Value<int> bedId;
  final Value<String> variety;
  final Value<String> commonName;
  final Value<DateTime?> seedStartDate;
  final Value<DateTime?> transplantDate;
  final Value<DateTime?> expectedHarvestStart;
  final Value<String> status;
  final Value<String?> growthStage;
  final Value<int?> quantity;
  final Value<String?> source;
  final Value<String?> notes;
  final Value<String?> photoPath;
  final Value<DateTime> createdAt;
  const PlantsCompanion({
    this.id = const Value.absent(),
    this.bedId = const Value.absent(),
    this.variety = const Value.absent(),
    this.commonName = const Value.absent(),
    this.seedStartDate = const Value.absent(),
    this.transplantDate = const Value.absent(),
    this.expectedHarvestStart = const Value.absent(),
    this.status = const Value.absent(),
    this.growthStage = const Value.absent(),
    this.quantity = const Value.absent(),
    this.source = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PlantsCompanion.insert({
    this.id = const Value.absent(),
    required int bedId,
    required String variety,
    required String commonName,
    this.seedStartDate = const Value.absent(),
    this.transplantDate = const Value.absent(),
    this.expectedHarvestStart = const Value.absent(),
    this.status = const Value.absent(),
    this.growthStage = const Value.absent(),
    this.quantity = const Value.absent(),
    this.source = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : bedId = Value(bedId),
        variety = Value(variety),
        commonName = Value(commonName);
  static Insertable<Plant> custom({
    Expression<int>? id,
    Expression<int>? bedId,
    Expression<String>? variety,
    Expression<String>? commonName,
    Expression<DateTime>? seedStartDate,
    Expression<DateTime>? transplantDate,
    Expression<DateTime>? expectedHarvestStart,
    Expression<String>? status,
    Expression<String>? growthStage,
    Expression<int>? quantity,
    Expression<String>? source,
    Expression<String>? notes,
    Expression<String>? photoPath,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bedId != null) 'bed_id': bedId,
      if (variety != null) 'variety': variety,
      if (commonName != null) 'common_name': commonName,
      if (seedStartDate != null) 'seed_start_date': seedStartDate,
      if (transplantDate != null) 'transplant_date': transplantDate,
      if (expectedHarvestStart != null)
        'expected_harvest_start': expectedHarvestStart,
      if (status != null) 'status': status,
      if (growthStage != null) 'growth_stage': growthStage,
      if (quantity != null) 'quantity': quantity,
      if (source != null) 'source': source,
      if (notes != null) 'notes': notes,
      if (photoPath != null) 'photo_path': photoPath,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PlantsCompanion copyWith(
      {Value<int>? id,
      Value<int>? bedId,
      Value<String>? variety,
      Value<String>? commonName,
      Value<DateTime?>? seedStartDate,
      Value<DateTime?>? transplantDate,
      Value<DateTime?>? expectedHarvestStart,
      Value<String>? status,
      Value<String?>? growthStage,
      Value<int?>? quantity,
      Value<String?>? source,
      Value<String?>? notes,
      Value<String?>? photoPath,
      Value<DateTime>? createdAt}) {
    return PlantsCompanion(
      id: id ?? this.id,
      bedId: bedId ?? this.bedId,
      variety: variety ?? this.variety,
      commonName: commonName ?? this.commonName,
      seedStartDate: seedStartDate ?? this.seedStartDate,
      transplantDate: transplantDate ?? this.transplantDate,
      expectedHarvestStart: expectedHarvestStart ?? this.expectedHarvestStart,
      status: status ?? this.status,
      growthStage: growthStage ?? this.growthStage,
      quantity: quantity ?? this.quantity,
      source: source ?? this.source,
      notes: notes ?? this.notes,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bedId.present) {
      map['bed_id'] = Variable<int>(bedId.value);
    }
    if (variety.present) {
      map['variety'] = Variable<String>(variety.value);
    }
    if (commonName.present) {
      map['common_name'] = Variable<String>(commonName.value);
    }
    if (seedStartDate.present) {
      map['seed_start_date'] = Variable<DateTime>(seedStartDate.value);
    }
    if (transplantDate.present) {
      map['transplant_date'] = Variable<DateTime>(transplantDate.value);
    }
    if (expectedHarvestStart.present) {
      map['expected_harvest_start'] =
          Variable<DateTime>(expectedHarvestStart.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (growthStage.present) {
      map['growth_stage'] = Variable<String>(growthStage.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlantsCompanion(')
          ..write('id: $id, ')
          ..write('bedId: $bedId, ')
          ..write('variety: $variety, ')
          ..write('commonName: $commonName, ')
          ..write('seedStartDate: $seedStartDate, ')
          ..write('transplantDate: $transplantDate, ')
          ..write('expectedHarvestStart: $expectedHarvestStart, ')
          ..write('status: $status, ')
          ..write('growthStage: $growthStage, ')
          ..write('quantity: $quantity, ')
          ..write('source: $source, ')
          ..write('notes: $notes, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ObservationsTable extends Observations
    with TableInfo<$ObservationsTable, Observation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ObservationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _plantIdMeta =
      const VerificationMeta('plantId');
  @override
  late final GeneratedColumn<int> plantId = GeneratedColumn<int>(
      'plant_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES plants (id)'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, plantId, date, type, description, amount, unit, photoPath];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'observations';
  @override
  VerificationContext validateIntegrity(Insertable<Observation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plant_id')) {
      context.handle(_plantIdMeta,
          plantId.isAcceptableOrUnknown(data['plant_id']!, _plantIdMeta));
    } else if (isInserting) {
      context.missing(_plantIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Observation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Observation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      plantId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}plant_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit']),
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path']),
    );
  }

  @override
  $ObservationsTable createAlias(String alias) {
    return $ObservationsTable(attachedDatabase, alias);
  }
}

class Observation extends DataClass implements Insertable<Observation> {
  final int id;
  final int plantId;
  final DateTime date;
  final String type;
  final String description;
  final double? amount;
  final String? unit;
  final String? photoPath;
  const Observation(
      {required this.id,
      required this.plantId,
      required this.date,
      required this.type,
      required this.description,
      this.amount,
      this.unit,
      this.photoPath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plant_id'] = Variable<int>(plantId);
    map['date'] = Variable<DateTime>(date);
    map['type'] = Variable<String>(type);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    return map;
  }

  ObservationsCompanion toCompanion(bool nullToAbsent) {
    return ObservationsCompanion(
      id: Value(id),
      plantId: Value(plantId),
      date: Value(date),
      type: Value(type),
      description: Value(description),
      amount:
          amount == null && nullToAbsent ? const Value.absent() : Value(amount),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
    );
  }

  factory Observation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Observation(
      id: serializer.fromJson<int>(json['id']),
      plantId: serializer.fromJson<int>(json['plantId']),
      date: serializer.fromJson<DateTime>(json['date']),
      type: serializer.fromJson<String>(json['type']),
      description: serializer.fromJson<String>(json['description']),
      amount: serializer.fromJson<double?>(json['amount']),
      unit: serializer.fromJson<String?>(json['unit']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'plantId': serializer.toJson<int>(plantId),
      'date': serializer.toJson<DateTime>(date),
      'type': serializer.toJson<String>(type),
      'description': serializer.toJson<String>(description),
      'amount': serializer.toJson<double?>(amount),
      'unit': serializer.toJson<String?>(unit),
      'photoPath': serializer.toJson<String?>(photoPath),
    };
  }

  Observation copyWith(
          {int? id,
          int? plantId,
          DateTime? date,
          String? type,
          String? description,
          Value<double?> amount = const Value.absent(),
          Value<String?> unit = const Value.absent(),
          Value<String?> photoPath = const Value.absent()}) =>
      Observation(
        id: id ?? this.id,
        plantId: plantId ?? this.plantId,
        date: date ?? this.date,
        type: type ?? this.type,
        description: description ?? this.description,
        amount: amount.present ? amount.value : this.amount,
        unit: unit.present ? unit.value : this.unit,
        photoPath: photoPath.present ? photoPath.value : this.photoPath,
      );
  Observation copyWithCompanion(ObservationsCompanion data) {
    return Observation(
      id: data.id.present ? data.id.value : this.id,
      plantId: data.plantId.present ? data.plantId.value : this.plantId,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
      description:
          data.description.present ? data.description.value : this.description,
      amount: data.amount.present ? data.amount.value : this.amount,
      unit: data.unit.present ? data.unit.value : this.unit,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Observation(')
          ..write('id: $id, ')
          ..write('plantId: $plantId, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('photoPath: $photoPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, plantId, date, type, description, amount, unit, photoPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Observation &&
          other.id == this.id &&
          other.plantId == this.plantId &&
          other.date == this.date &&
          other.type == this.type &&
          other.description == this.description &&
          other.amount == this.amount &&
          other.unit == this.unit &&
          other.photoPath == this.photoPath);
}

class ObservationsCompanion extends UpdateCompanion<Observation> {
  final Value<int> id;
  final Value<int> plantId;
  final Value<DateTime> date;
  final Value<String> type;
  final Value<String> description;
  final Value<double?> amount;
  final Value<String?> unit;
  final Value<String?> photoPath;
  const ObservationsCompanion({
    this.id = const Value.absent(),
    this.plantId = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.description = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.photoPath = const Value.absent(),
  });
  ObservationsCompanion.insert({
    this.id = const Value.absent(),
    required int plantId,
    this.date = const Value.absent(),
    required String type,
    required String description,
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.photoPath = const Value.absent(),
  })  : plantId = Value(plantId),
        type = Value(type),
        description = Value(description);
  static Insertable<Observation> custom({
    Expression<int>? id,
    Expression<int>? plantId,
    Expression<DateTime>? date,
    Expression<String>? type,
    Expression<String>? description,
    Expression<double>? amount,
    Expression<String>? unit,
    Expression<String>? photoPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (plantId != null) 'plant_id': plantId,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (description != null) 'description': description,
      if (amount != null) 'amount': amount,
      if (unit != null) 'unit': unit,
      if (photoPath != null) 'photo_path': photoPath,
    });
  }

  ObservationsCompanion copyWith(
      {Value<int>? id,
      Value<int>? plantId,
      Value<DateTime>? date,
      Value<String>? type,
      Value<String>? description,
      Value<double?>? amount,
      Value<String?>? unit,
      Value<String?>? photoPath}) {
    return ObservationsCompanion(
      id: id ?? this.id,
      plantId: plantId ?? this.plantId,
      date: date ?? this.date,
      type: type ?? this.type,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      photoPath: photoPath ?? this.photoPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (plantId.present) {
      map['plant_id'] = Variable<int>(plantId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ObservationsCompanion(')
          ..write('id: $id, ')
          ..write('plantId: $plantId, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('photoPath: $photoPath')
          ..write(')'))
        .toString();
  }
}

class $HarvestsTable extends Harvests with TableInfo<$HarvestsTable, Harvest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HarvestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _plantIdMeta =
      const VerificationMeta('plantId');
  @override
  late final GeneratedColumn<int> plantId = GeneratedColumn<int>(
      'plant_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES plants (id)'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('lb'));
  static const VerificationMeta _qualityRatingMeta =
      const VerificationMeta('qualityRating');
  @override
  late final GeneratedColumn<int> qualityRating = GeneratedColumn<int>(
      'quality_rating', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, plantId, date, quantity, unit, qualityRating, notes, photoPath];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'harvests';
  @override
  VerificationContext validateIntegrity(Insertable<Harvest> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plant_id')) {
      context.handle(_plantIdMeta,
          plantId.isAcceptableOrUnknown(data['plant_id']!, _plantIdMeta));
    } else if (isInserting) {
      context.missing(_plantIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('quality_rating')) {
      context.handle(
          _qualityRatingMeta,
          qualityRating.isAcceptableOrUnknown(
              data['quality_rating']!, _qualityRatingMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Harvest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Harvest(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      plantId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}plant_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      qualityRating: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quality_rating']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path']),
    );
  }

  @override
  $HarvestsTable createAlias(String alias) {
    return $HarvestsTable(attachedDatabase, alias);
  }
}

class Harvest extends DataClass implements Insertable<Harvest> {
  final int id;
  final int plantId;
  final DateTime date;
  final double quantity;
  final String unit;
  final int? qualityRating;
  final String? notes;
  final String? photoPath;
  const Harvest(
      {required this.id,
      required this.plantId,
      required this.date,
      required this.quantity,
      required this.unit,
      this.qualityRating,
      this.notes,
      this.photoPath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plant_id'] = Variable<int>(plantId);
    map['date'] = Variable<DateTime>(date);
    map['quantity'] = Variable<double>(quantity);
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || qualityRating != null) {
      map['quality_rating'] = Variable<int>(qualityRating);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    return map;
  }

  HarvestsCompanion toCompanion(bool nullToAbsent) {
    return HarvestsCompanion(
      id: Value(id),
      plantId: Value(plantId),
      date: Value(date),
      quantity: Value(quantity),
      unit: Value(unit),
      qualityRating: qualityRating == null && nullToAbsent
          ? const Value.absent()
          : Value(qualityRating),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
    );
  }

  factory Harvest.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Harvest(
      id: serializer.fromJson<int>(json['id']),
      plantId: serializer.fromJson<int>(json['plantId']),
      date: serializer.fromJson<DateTime>(json['date']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
      qualityRating: serializer.fromJson<int?>(json['qualityRating']),
      notes: serializer.fromJson<String?>(json['notes']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'plantId': serializer.toJson<int>(plantId),
      'date': serializer.toJson<DateTime>(date),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String>(unit),
      'qualityRating': serializer.toJson<int?>(qualityRating),
      'notes': serializer.toJson<String?>(notes),
      'photoPath': serializer.toJson<String?>(photoPath),
    };
  }

  Harvest copyWith(
          {int? id,
          int? plantId,
          DateTime? date,
          double? quantity,
          String? unit,
          Value<int?> qualityRating = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<String?> photoPath = const Value.absent()}) =>
      Harvest(
        id: id ?? this.id,
        plantId: plantId ?? this.plantId,
        date: date ?? this.date,
        quantity: quantity ?? this.quantity,
        unit: unit ?? this.unit,
        qualityRating:
            qualityRating.present ? qualityRating.value : this.qualityRating,
        notes: notes.present ? notes.value : this.notes,
        photoPath: photoPath.present ? photoPath.value : this.photoPath,
      );
  Harvest copyWithCompanion(HarvestsCompanion data) {
    return Harvest(
      id: data.id.present ? data.id.value : this.id,
      plantId: data.plantId.present ? data.plantId.value : this.plantId,
      date: data.date.present ? data.date.value : this.date,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      qualityRating: data.qualityRating.present
          ? data.qualityRating.value
          : this.qualityRating,
      notes: data.notes.present ? data.notes.value : this.notes,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Harvest(')
          ..write('id: $id, ')
          ..write('plantId: $plantId, ')
          ..write('date: $date, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('qualityRating: $qualityRating, ')
          ..write('notes: $notes, ')
          ..write('photoPath: $photoPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, plantId, date, quantity, unit, qualityRating, notes, photoPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Harvest &&
          other.id == this.id &&
          other.plantId == this.plantId &&
          other.date == this.date &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.qualityRating == this.qualityRating &&
          other.notes == this.notes &&
          other.photoPath == this.photoPath);
}

class HarvestsCompanion extends UpdateCompanion<Harvest> {
  final Value<int> id;
  final Value<int> plantId;
  final Value<DateTime> date;
  final Value<double> quantity;
  final Value<String> unit;
  final Value<int?> qualityRating;
  final Value<String?> notes;
  final Value<String?> photoPath;
  const HarvestsCompanion({
    this.id = const Value.absent(),
    this.plantId = const Value.absent(),
    this.date = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.qualityRating = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoPath = const Value.absent(),
  });
  HarvestsCompanion.insert({
    this.id = const Value.absent(),
    required int plantId,
    this.date = const Value.absent(),
    required double quantity,
    this.unit = const Value.absent(),
    this.qualityRating = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoPath = const Value.absent(),
  })  : plantId = Value(plantId),
        quantity = Value(quantity);
  static Insertable<Harvest> custom({
    Expression<int>? id,
    Expression<int>? plantId,
    Expression<DateTime>? date,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<int>? qualityRating,
    Expression<String>? notes,
    Expression<String>? photoPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (plantId != null) 'plant_id': plantId,
      if (date != null) 'date': date,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (qualityRating != null) 'quality_rating': qualityRating,
      if (notes != null) 'notes': notes,
      if (photoPath != null) 'photo_path': photoPath,
    });
  }

  HarvestsCompanion copyWith(
      {Value<int>? id,
      Value<int>? plantId,
      Value<DateTime>? date,
      Value<double>? quantity,
      Value<String>? unit,
      Value<int?>? qualityRating,
      Value<String?>? notes,
      Value<String?>? photoPath}) {
    return HarvestsCompanion(
      id: id ?? this.id,
      plantId: plantId ?? this.plantId,
      date: date ?? this.date,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      qualityRating: qualityRating ?? this.qualityRating,
      notes: notes ?? this.notes,
      photoPath: photoPath ?? this.photoPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (plantId.present) {
      map['plant_id'] = Variable<int>(plantId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (qualityRating.present) {
      map['quality_rating'] = Variable<int>(qualityRating.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HarvestsCompanion(')
          ..write('id: $id, ')
          ..write('plantId: $plantId, ')
          ..write('date: $date, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('qualityRating: $qualityRating, ')
          ..write('notes: $notes, ')
          ..write('photoPath: $photoPath')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _vendorMeta = const VerificationMeta('vendor');
  @override
  late final GeneratedColumn<String> vendor = GeneratedColumn<String>(
      'vendor', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, date, category, description, amount, vendor, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(Insertable<Expense> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('vendor')) {
      context.handle(_vendorMeta,
          vendor.isAcceptableOrUnknown(data['vendor']!, _vendorMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      vendor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vendor']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final DateTime date;
  final String category;
  final String description;
  final double amount;
  final String? vendor;
  final String? notes;
  const Expense(
      {required this.id,
      required this.date,
      required this.category,
      required this.description,
      required this.amount,
      this.vendor,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['category'] = Variable<String>(category);
    map['description'] = Variable<String>(description);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || vendor != null) {
      map['vendor'] = Variable<String>(vendor);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      date: Value(date),
      category: Value(category),
      description: Value(description),
      amount: Value(amount),
      vendor:
          vendor == null && nullToAbsent ? const Value.absent() : Value(vendor),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory Expense.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      category: serializer.fromJson<String>(json['category']),
      description: serializer.fromJson<String>(json['description']),
      amount: serializer.fromJson<double>(json['amount']),
      vendor: serializer.fromJson<String?>(json['vendor']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'category': serializer.toJson<String>(category),
      'description': serializer.toJson<String>(description),
      'amount': serializer.toJson<double>(amount),
      'vendor': serializer.toJson<String?>(vendor),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Expense copyWith(
          {int? id,
          DateTime? date,
          String? category,
          String? description,
          double? amount,
          Value<String?> vendor = const Value.absent(),
          Value<String?> notes = const Value.absent()}) =>
      Expense(
        id: id ?? this.id,
        date: date ?? this.date,
        category: category ?? this.category,
        description: description ?? this.description,
        amount: amount ?? this.amount,
        vendor: vendor.present ? vendor.value : this.vendor,
        notes: notes.present ? notes.value : this.notes,
      );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      category: data.category.present ? data.category.value : this.category,
      description:
          data.description.present ? data.description.value : this.description,
      amount: data.amount.present ? data.amount.value : this.amount,
      vendor: data.vendor.present ? data.vendor.value : this.vendor,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('vendor: $vendor, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, category, description, amount, vendor, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.date == this.date &&
          other.category == this.category &&
          other.description == this.description &&
          other.amount == this.amount &&
          other.vendor == this.vendor &&
          other.notes == this.notes);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> category;
  final Value<String> description;
  final Value<double> amount;
  final Value<String?> vendor;
  final Value<String?> notes;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.amount = const Value.absent(),
    this.vendor = const Value.absent(),
    this.notes = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    required String category,
    required String description,
    required double amount,
    this.vendor = const Value.absent(),
    this.notes = const Value.absent(),
  })  : category = Value(category),
        description = Value(description),
        amount = Value(amount);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? category,
    Expression<String>? description,
    Expression<double>? amount,
    Expression<String>? vendor,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (amount != null) 'amount': amount,
      if (vendor != null) 'vendor': vendor,
      if (notes != null) 'notes': notes,
    });
  }

  ExpensesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<String>? category,
      Value<String>? description,
      Value<double>? amount,
      Value<String?>? vendor,
      Value<String?>? notes}) {
    return ExpensesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      category: category ?? this.category,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      vendor: vendor ?? this.vendor,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (vendor.present) {
      map['vendor'] = Variable<String>(vendor.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('vendor: $vendor, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _plantIdMeta =
      const VerificationMeta('plantId');
  @override
  late final GeneratedColumn<int> plantId = GeneratedColumn<int>(
      'plant_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isRepeatingMeta =
      const VerificationMeta('isRepeating');
  @override
  late final GeneratedColumn<bool> isRepeating = GeneratedColumn<bool>(
      'is_repeating', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_repeating" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _repeatIntervalMeta =
      const VerificationMeta('repeatInterval');
  @override
  late final GeneratedColumn<String> repeatInterval = GeneratedColumn<String>(
      'repeat_interval', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        plantId,
        type,
        title,
        notes,
        dueDate,
        isCompleted,
        isRepeating,
        repeatInterval
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(Insertable<Reminder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plant_id')) {
      context.handle(_plantIdMeta,
          plantId.isAcceptableOrUnknown(data['plant_id']!, _plantIdMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('is_repeating')) {
      context.handle(
          _isRepeatingMeta,
          isRepeating.isAcceptableOrUnknown(
              data['is_repeating']!, _isRepeatingMeta));
    }
    if (data.containsKey('repeat_interval')) {
      context.handle(
          _repeatIntervalMeta,
          repeatInterval.isAcceptableOrUnknown(
              data['repeat_interval']!, _repeatIntervalMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      plantId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}plant_id']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      isRepeating: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_repeating'])!,
      repeatInterval: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}repeat_interval']),
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final int id;
  final int? plantId;
  final String type;
  final String title;
  final String? notes;
  final DateTime dueDate;
  final bool isCompleted;
  final bool isRepeating;
  final String? repeatInterval;
  const Reminder(
      {required this.id,
      this.plantId,
      required this.type,
      required this.title,
      this.notes,
      required this.dueDate,
      required this.isCompleted,
      required this.isRepeating,
      this.repeatInterval});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || plantId != null) {
      map['plant_id'] = Variable<int>(plantId);
    }
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['due_date'] = Variable<DateTime>(dueDate);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['is_repeating'] = Variable<bool>(isRepeating);
    if (!nullToAbsent || repeatInterval != null) {
      map['repeat_interval'] = Variable<String>(repeatInterval);
    }
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      plantId: plantId == null && nullToAbsent
          ? const Value.absent()
          : Value(plantId),
      type: Value(type),
      title: Value(title),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      dueDate: Value(dueDate),
      isCompleted: Value(isCompleted),
      isRepeating: Value(isRepeating),
      repeatInterval: repeatInterval == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatInterval),
    );
  }

  factory Reminder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<int>(json['id']),
      plantId: serializer.fromJson<int?>(json['plantId']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      notes: serializer.fromJson<String?>(json['notes']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      isRepeating: serializer.fromJson<bool>(json['isRepeating']),
      repeatInterval: serializer.fromJson<String?>(json['repeatInterval']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'plantId': serializer.toJson<int?>(plantId),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'notes': serializer.toJson<String?>(notes),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'isRepeating': serializer.toJson<bool>(isRepeating),
      'repeatInterval': serializer.toJson<String?>(repeatInterval),
    };
  }

  Reminder copyWith(
          {int? id,
          Value<int?> plantId = const Value.absent(),
          String? type,
          String? title,
          Value<String?> notes = const Value.absent(),
          DateTime? dueDate,
          bool? isCompleted,
          bool? isRepeating,
          Value<String?> repeatInterval = const Value.absent()}) =>
      Reminder(
        id: id ?? this.id,
        plantId: plantId.present ? plantId.value : this.plantId,
        type: type ?? this.type,
        title: title ?? this.title,
        notes: notes.present ? notes.value : this.notes,
        dueDate: dueDate ?? this.dueDate,
        isCompleted: isCompleted ?? this.isCompleted,
        isRepeating: isRepeating ?? this.isRepeating,
        repeatInterval:
            repeatInterval.present ? repeatInterval.value : this.repeatInterval,
      );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      plantId: data.plantId.present ? data.plantId.value : this.plantId,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      isRepeating:
          data.isRepeating.present ? data.isRepeating.value : this.isRepeating,
      repeatInterval: data.repeatInterval.present
          ? data.repeatInterval.value
          : this.repeatInterval,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('plantId: $plantId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('dueDate: $dueDate, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('isRepeating: $isRepeating, ')
          ..write('repeatInterval: $repeatInterval')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, plantId, type, title, notes, dueDate,
      isCompleted, isRepeating, repeatInterval);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.plantId == this.plantId &&
          other.type == this.type &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.dueDate == this.dueDate &&
          other.isCompleted == this.isCompleted &&
          other.isRepeating == this.isRepeating &&
          other.repeatInterval == this.repeatInterval);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<int> id;
  final Value<int?> plantId;
  final Value<String> type;
  final Value<String> title;
  final Value<String?> notes;
  final Value<DateTime> dueDate;
  final Value<bool> isCompleted;
  final Value<bool> isRepeating;
  final Value<String?> repeatInterval;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.plantId = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.isRepeating = const Value.absent(),
    this.repeatInterval = const Value.absent(),
  });
  RemindersCompanion.insert({
    this.id = const Value.absent(),
    this.plantId = const Value.absent(),
    required String type,
    required String title,
    this.notes = const Value.absent(),
    required DateTime dueDate,
    this.isCompleted = const Value.absent(),
    this.isRepeating = const Value.absent(),
    this.repeatInterval = const Value.absent(),
  })  : type = Value(type),
        title = Value(title),
        dueDate = Value(dueDate);
  static Insertable<Reminder> custom({
    Expression<int>? id,
    Expression<int>? plantId,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<DateTime>? dueDate,
    Expression<bool>? isCompleted,
    Expression<bool>? isRepeating,
    Expression<String>? repeatInterval,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (plantId != null) 'plant_id': plantId,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (dueDate != null) 'due_date': dueDate,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (isRepeating != null) 'is_repeating': isRepeating,
      if (repeatInterval != null) 'repeat_interval': repeatInterval,
    });
  }

  RemindersCompanion copyWith(
      {Value<int>? id,
      Value<int?>? plantId,
      Value<String>? type,
      Value<String>? title,
      Value<String?>? notes,
      Value<DateTime>? dueDate,
      Value<bool>? isCompleted,
      Value<bool>? isRepeating,
      Value<String?>? repeatInterval}) {
    return RemindersCompanion(
      id: id ?? this.id,
      plantId: plantId ?? this.plantId,
      type: type ?? this.type,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      isRepeating: isRepeating ?? this.isRepeating,
      repeatInterval: repeatInterval ?? this.repeatInterval,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (plantId.present) {
      map['plant_id'] = Variable<int>(plantId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (isRepeating.present) {
      map['is_repeating'] = Variable<bool>(isRepeating.value);
    }
    if (repeatInterval.present) {
      map['repeat_interval'] = Variable<String>(repeatInterval.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('plantId: $plantId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('dueDate: $dueDate, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('isRepeating: $isRepeating, ')
          ..write('repeatInterval: $repeatInterval')
          ..write(')'))
        .toString();
  }
}

class $PlantPhotosTable extends PlantPhotos
    with TableInfo<$PlantPhotosTable, PlantPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlantPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _plantIdMeta =
      const VerificationMeta('plantId');
  @override
  late final GeneratedColumn<int> plantId = GeneratedColumn<int>(
      'plant_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES plants (id)'));
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _captionMeta =
      const VerificationMeta('caption');
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
      'caption', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _takenAtMeta =
      const VerificationMeta('takenAt');
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
      'taken_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, plantId, photoPath, caption, takenAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plant_photos';
  @override
  VerificationContext validateIntegrity(Insertable<PlantPhoto> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plant_id')) {
      context.handle(_plantIdMeta,
          plantId.isAcceptableOrUnknown(data['plant_id']!, _plantIdMeta));
    } else if (isInserting) {
      context.missing(_plantIdMeta);
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    } else if (isInserting) {
      context.missing(_photoPathMeta);
    }
    if (data.containsKey('caption')) {
      context.handle(_captionMeta,
          caption.isAcceptableOrUnknown(data['caption']!, _captionMeta));
    }
    if (data.containsKey('taken_at')) {
      context.handle(_takenAtMeta,
          takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlantPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlantPhoto(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      plantId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}plant_id'])!,
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path'])!,
      caption: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}caption']),
      takenAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}taken_at'])!,
    );
  }

  @override
  $PlantPhotosTable createAlias(String alias) {
    return $PlantPhotosTable(attachedDatabase, alias);
  }
}

class PlantPhoto extends DataClass implements Insertable<PlantPhoto> {
  final int id;
  final int plantId;
  final String photoPath;
  final String? caption;
  final DateTime takenAt;
  const PlantPhoto(
      {required this.id,
      required this.plantId,
      required this.photoPath,
      this.caption,
      required this.takenAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plant_id'] = Variable<int>(plantId);
    map['photo_path'] = Variable<String>(photoPath);
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    map['taken_at'] = Variable<DateTime>(takenAt);
    return map;
  }

  PlantPhotosCompanion toCompanion(bool nullToAbsent) {
    return PlantPhotosCompanion(
      id: Value(id),
      plantId: Value(plantId),
      photoPath: Value(photoPath),
      caption: caption == null && nullToAbsent
          ? const Value.absent()
          : Value(caption),
      takenAt: Value(takenAt),
    );
  }

  factory PlantPhoto.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlantPhoto(
      id: serializer.fromJson<int>(json['id']),
      plantId: serializer.fromJson<int>(json['plantId']),
      photoPath: serializer.fromJson<String>(json['photoPath']),
      caption: serializer.fromJson<String?>(json['caption']),
      takenAt: serializer.fromJson<DateTime>(json['takenAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'plantId': serializer.toJson<int>(plantId),
      'photoPath': serializer.toJson<String>(photoPath),
      'caption': serializer.toJson<String?>(caption),
      'takenAt': serializer.toJson<DateTime>(takenAt),
    };
  }

  PlantPhoto copyWith(
          {int? id,
          int? plantId,
          String? photoPath,
          Value<String?> caption = const Value.absent(),
          DateTime? takenAt}) =>
      PlantPhoto(
        id: id ?? this.id,
        plantId: plantId ?? this.plantId,
        photoPath: photoPath ?? this.photoPath,
        caption: caption.present ? caption.value : this.caption,
        takenAt: takenAt ?? this.takenAt,
      );
  PlantPhoto copyWithCompanion(PlantPhotosCompanion data) {
    return PlantPhoto(
      id: data.id.present ? data.id.value : this.id,
      plantId: data.plantId.present ? data.plantId.value : this.plantId,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      caption: data.caption.present ? data.caption.value : this.caption,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlantPhoto(')
          ..write('id: $id, ')
          ..write('plantId: $plantId, ')
          ..write('photoPath: $photoPath, ')
          ..write('caption: $caption, ')
          ..write('takenAt: $takenAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, plantId, photoPath, caption, takenAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlantPhoto &&
          other.id == this.id &&
          other.plantId == this.plantId &&
          other.photoPath == this.photoPath &&
          other.caption == this.caption &&
          other.takenAt == this.takenAt);
}

class PlantPhotosCompanion extends UpdateCompanion<PlantPhoto> {
  final Value<int> id;
  final Value<int> plantId;
  final Value<String> photoPath;
  final Value<String?> caption;
  final Value<DateTime> takenAt;
  const PlantPhotosCompanion({
    this.id = const Value.absent(),
    this.plantId = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.caption = const Value.absent(),
    this.takenAt = const Value.absent(),
  });
  PlantPhotosCompanion.insert({
    this.id = const Value.absent(),
    required int plantId,
    required String photoPath,
    this.caption = const Value.absent(),
    this.takenAt = const Value.absent(),
  })  : plantId = Value(plantId),
        photoPath = Value(photoPath);
  static Insertable<PlantPhoto> custom({
    Expression<int>? id,
    Expression<int>? plantId,
    Expression<String>? photoPath,
    Expression<String>? caption,
    Expression<DateTime>? takenAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (plantId != null) 'plant_id': plantId,
      if (photoPath != null) 'photo_path': photoPath,
      if (caption != null) 'caption': caption,
      if (takenAt != null) 'taken_at': takenAt,
    });
  }

  PlantPhotosCompanion copyWith(
      {Value<int>? id,
      Value<int>? plantId,
      Value<String>? photoPath,
      Value<String?>? caption,
      Value<DateTime>? takenAt}) {
    return PlantPhotosCompanion(
      id: id ?? this.id,
      plantId: plantId ?? this.plantId,
      photoPath: photoPath ?? this.photoPath,
      caption: caption ?? this.caption,
      takenAt: takenAt ?? this.takenAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (plantId.present) {
      map['plant_id'] = Variable<int>(plantId.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<DateTime>(takenAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlantPhotosCompanion(')
          ..write('id: $id, ')
          ..write('plantId: $plantId, ')
          ..write('photoPath: $photoPath, ')
          ..write('caption: $caption, ')
          ..write('takenAt: $takenAt')
          ..write(')'))
        .toString();
  }
}

class $JournalEntriesTable extends JournalEntries
    with TableInfo<$JournalEntriesTable, JournalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<String> mood = GeneratedColumn<String>(
      'mood', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, body, photoPath, mood, tags, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries';
  @override
  VerificationContext validateIntegrity(Insertable<JournalEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    }
    if (data.containsKey('mood')) {
      context.handle(
          _moodMeta, mood.isAcceptableOrUnknown(data['mood']!, _moodMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body']),
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path']),
      mood: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mood']),
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $JournalEntriesTable createAlias(String alias) {
    return $JournalEntriesTable(attachedDatabase, alias);
  }
}

class JournalEntry extends DataClass implements Insertable<JournalEntry> {
  final int id;
  final String title;
  final String? body;
  final String? photoPath;
  final String? mood;
  final String? tags;
  final DateTime createdAt;
  const JournalEntry(
      {required this.id,
      required this.title,
      this.body,
      this.photoPath,
      this.mood,
      this.tags,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String>(body);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || mood != null) {
      map['mood'] = Variable<String>(mood);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  JournalEntriesCompanion toCompanion(bool nullToAbsent) {
    return JournalEntriesCompanion(
      id: Value(id),
      title: Value(title),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      mood: mood == null && nullToAbsent ? const Value.absent() : Value(mood),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      createdAt: Value(createdAt),
    );
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntry(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String?>(json['body']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      mood: serializer.fromJson<String?>(json['mood']),
      tags: serializer.fromJson<String?>(json['tags']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String?>(body),
      'photoPath': serializer.toJson<String?>(photoPath),
      'mood': serializer.toJson<String?>(mood),
      'tags': serializer.toJson<String?>(tags),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  JournalEntry copyWith(
          {int? id,
          String? title,
          Value<String?> body = const Value.absent(),
          Value<String?> photoPath = const Value.absent(),
          Value<String?> mood = const Value.absent(),
          Value<String?> tags = const Value.absent(),
          DateTime? createdAt}) =>
      JournalEntry(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body.present ? body.value : this.body,
        photoPath: photoPath.present ? photoPath.value : this.photoPath,
        mood: mood.present ? mood.value : this.mood,
        tags: tags.present ? tags.value : this.tags,
        createdAt: createdAt ?? this.createdAt,
      );
  JournalEntry copyWithCompanion(JournalEntriesCompanion data) {
    return JournalEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      mood: data.mood.present ? data.mood.value : this.mood,
      tags: data.tags.present ? data.tags.value : this.tags,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('photoPath: $photoPath, ')
          ..write('mood: $mood, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, body, photoPath, mood, tags, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.photoPath == this.photoPath &&
          other.mood == this.mood &&
          other.tags == this.tags &&
          other.createdAt == this.createdAt);
}

class JournalEntriesCompanion extends UpdateCompanion<JournalEntry> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> body;
  final Value<String?> photoPath;
  final Value<String?> mood;
  final Value<String?> tags;
  final Value<DateTime> createdAt;
  const JournalEntriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.mood = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  JournalEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.body = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.mood = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : title = Value(title);
  static Insertable<JournalEntry> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? photoPath,
    Expression<String>? mood,
    Expression<String>? tags,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (photoPath != null) 'photo_path': photoPath,
      if (mood != null) 'mood': mood,
      if (tags != null) 'tags': tags,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  JournalEntriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String?>? body,
      Value<String?>? photoPath,
      Value<String?>? mood,
      Value<String?>? tags,
      Value<DateTime>? createdAt}) {
    return JournalEntriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      photoPath: photoPath ?? this.photoPath,
      mood: mood ?? this.mood,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (mood.present) {
      map['mood'] = Variable<String>(mood.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('photoPath: $photoPath, ')
          ..write('mood: $mood, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GardensTable gardens = $GardensTable(this);
  late final $BedsTable beds = $BedsTable(this);
  late final $PlantsTable plants = $PlantsTable(this);
  late final $ObservationsTable observations = $ObservationsTable(this);
  late final $HarvestsTable harvests = $HarvestsTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $PlantPhotosTable plantPhotos = $PlantPhotosTable(this);
  late final $JournalEntriesTable journalEntries = $JournalEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        gardens,
        beds,
        plants,
        observations,
        harvests,
        expenses,
        reminders,
        plantPhotos,
        journalEntries
      ];
}

typedef $$GardensTableCreateCompanionBuilder = GardensCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> description,
  Value<String?> location,
  Value<DateTime> createdAt,
});
typedef $$GardensTableUpdateCompanionBuilder = GardensCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> description,
  Value<String?> location,
  Value<DateTime> createdAt,
});

final class $$GardensTableReferences
    extends BaseReferences<_$AppDatabase, $GardensTable, Garden> {
  $$GardensTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BedsTable, List<Bed>> _bedsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.beds,
          aliasName: $_aliasNameGenerator(db.gardens.id, db.beds.gardenId));

  $$BedsTableProcessedTableManager get bedsRefs {
    final manager = $$BedsTableTableManager($_db, $_db.beds)
        .filter((f) => f.gardenId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_bedsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$GardensTableFilterComposer
    extends Composer<_$AppDatabase, $GardensTable> {
  $$GardensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> bedsRefs(
      Expression<bool> Function($$BedsTableFilterComposer f) f) {
    final $$BedsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.beds,
        getReferencedColumn: (t) => t.gardenId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BedsTableFilterComposer(
              $db: $db,
              $table: $db.beds,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GardensTableOrderingComposer
    extends Composer<_$AppDatabase, $GardensTable> {
  $$GardensTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$GardensTableAnnotationComposer
    extends Composer<_$AppDatabase, $GardensTable> {
  $$GardensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> bedsRefs<T extends Object>(
      Expression<T> Function($$BedsTableAnnotationComposer a) f) {
    final $$BedsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.beds,
        getReferencedColumn: (t) => t.gardenId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BedsTableAnnotationComposer(
              $db: $db,
              $table: $db.beds,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GardensTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GardensTable,
    Garden,
    $$GardensTableFilterComposer,
    $$GardensTableOrderingComposer,
    $$GardensTableAnnotationComposer,
    $$GardensTableCreateCompanionBuilder,
    $$GardensTableUpdateCompanionBuilder,
    (Garden, $$GardensTableReferences),
    Garden,
    PrefetchHooks Function({bool bedsRefs})> {
  $$GardensTableTableManager(_$AppDatabase db, $GardensTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GardensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GardensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GardensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> location = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              GardensCompanion(
            id: id,
            name: name,
            description: description,
            location: location,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
            Value<String?> location = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              GardensCompanion.insert(
            id: id,
            name: name,
            description: description,
            location: location,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$GardensTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({bedsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (bedsRefs) db.beds],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (bedsRefs)
                    await $_getPrefetchedData<Garden, $GardensTable, Bed>(
                        currentTable: table,
                        referencedTable:
                            $$GardensTableReferences._bedsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GardensTableReferences(db, table, p0).bedsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.gardenId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$GardensTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GardensTable,
    Garden,
    $$GardensTableFilterComposer,
    $$GardensTableOrderingComposer,
    $$GardensTableAnnotationComposer,
    $$GardensTableCreateCompanionBuilder,
    $$GardensTableUpdateCompanionBuilder,
    (Garden, $$GardensTableReferences),
    Garden,
    PrefetchHooks Function({bool bedsRefs})>;
typedef $$BedsTableCreateCompanionBuilder = BedsCompanion Function({
  Value<int> id,
  required int gardenId,
  required String name,
  Value<String> type,
  Value<double?> areaSqFt,
  Value<String?> location,
  Value<String?> soilType,
  Value<String?> notes,
  Value<String?> photoPath,
  Value<DateTime> createdAt,
});
typedef $$BedsTableUpdateCompanionBuilder = BedsCompanion Function({
  Value<int> id,
  Value<int> gardenId,
  Value<String> name,
  Value<String> type,
  Value<double?> areaSqFt,
  Value<String?> location,
  Value<String?> soilType,
  Value<String?> notes,
  Value<String?> photoPath,
  Value<DateTime> createdAt,
});

final class $$BedsTableReferences
    extends BaseReferences<_$AppDatabase, $BedsTable, Bed> {
  $$BedsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GardensTable _gardenIdTable(_$AppDatabase db) => db.gardens
      .createAlias($_aliasNameGenerator(db.beds.gardenId, db.gardens.id));

  $$GardensTableProcessedTableManager get gardenId {
    final $_column = $_itemColumn<int>('garden_id')!;

    final manager = $$GardensTableTableManager($_db, $_db.gardens)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gardenIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PlantsTable, List<Plant>> _plantsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.plants,
          aliasName: $_aliasNameGenerator(db.beds.id, db.plants.bedId));

  $$PlantsTableProcessedTableManager get plantsRefs {
    final manager = $$PlantsTableTableManager($_db, $_db.plants)
        .filter((f) => f.bedId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_plantsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$BedsTableFilterComposer extends Composer<_$AppDatabase, $BedsTable> {
  $$BedsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get areaSqFt => $composableBuilder(
      column: $table.areaSqFt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get soilType => $composableBuilder(
      column: $table.soilType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$GardensTableFilterComposer get gardenId {
    final $$GardensTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gardenId,
        referencedTable: $db.gardens,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GardensTableFilterComposer(
              $db: $db,
              $table: $db.gardens,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> plantsRefs(
      Expression<bool> Function($$PlantsTableFilterComposer f) f) {
    final $$PlantsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.plants,
        getReferencedColumn: (t) => t.bedId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlantsTableFilterComposer(
              $db: $db,
              $table: $db.plants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BedsTableOrderingComposer extends Composer<_$AppDatabase, $BedsTable> {
  $$BedsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get areaSqFt => $composableBuilder(
      column: $table.areaSqFt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get soilType => $composableBuilder(
      column: $table.soilType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$GardensTableOrderingComposer get gardenId {
    final $$GardensTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gardenId,
        referencedTable: $db.gardens,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GardensTableOrderingComposer(
              $db: $db,
              $table: $db.gardens,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BedsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BedsTable> {
  $$BedsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get areaSqFt =>
      $composableBuilder(column: $table.areaSqFt, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get soilType =>
      $composableBuilder(column: $table.soilType, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$GardensTableAnnotationComposer get gardenId {
    final $$GardensTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gardenId,
        referencedTable: $db.gardens,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GardensTableAnnotationComposer(
              $db: $db,
              $table: $db.gardens,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> plantsRefs<T extends Object>(
      Expression<T> Function($$PlantsTableAnnotationComposer a) f) {
    final $$PlantsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.plants,
        getReferencedColumn: (t) => t.bedId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlantsTableAnnotationComposer(
              $db: $db,
              $table: $db.plants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BedsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BedsTable,
    Bed,
    $$BedsTableFilterComposer,
    $$BedsTableOrderingComposer,
    $$BedsTableAnnotationComposer,
    $$BedsTableCreateCompanionBuilder,
    $$BedsTableUpdateCompanionBuilder,
    (Bed, $$BedsTableReferences),
    Bed,
    PrefetchHooks Function({bool gardenId, bool plantsRefs})> {
  $$BedsTableTableManager(_$AppDatabase db, $BedsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BedsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BedsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BedsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> gardenId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double?> areaSqFt = const Value.absent(),
            Value<String?> location = const Value.absent(),
            Value<String?> soilType = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              BedsCompanion(
            id: id,
            gardenId: gardenId,
            name: name,
            type: type,
            areaSqFt: areaSqFt,
            location: location,
            soilType: soilType,
            notes: notes,
            photoPath: photoPath,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int gardenId,
            required String name,
            Value<String> type = const Value.absent(),
            Value<double?> areaSqFt = const Value.absent(),
            Value<String?> location = const Value.absent(),
            Value<String?> soilType = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              BedsCompanion.insert(
            id: id,
            gardenId: gardenId,
            name: name,
            type: type,
            areaSqFt: areaSqFt,
            location: location,
            soilType: soilType,
            notes: notes,
            photoPath: photoPath,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$BedsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({gardenId = false, plantsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (plantsRefs) db.plants],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (gardenId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.gardenId,
                    referencedTable: $$BedsTableReferences._gardenIdTable(db),
                    referencedColumn:
                        $$BedsTableReferences._gardenIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (plantsRefs)
                    await $_getPrefetchedData<Bed, $BedsTable, Plant>(
                        currentTable: table,
                        referencedTable:
                            $$BedsTableReferences._plantsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BedsTableReferences(db, table, p0).plantsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.bedId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$BedsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BedsTable,
    Bed,
    $$BedsTableFilterComposer,
    $$BedsTableOrderingComposer,
    $$BedsTableAnnotationComposer,
    $$BedsTableCreateCompanionBuilder,
    $$BedsTableUpdateCompanionBuilder,
    (Bed, $$BedsTableReferences),
    Bed,
    PrefetchHooks Function({bool gardenId, bool plantsRefs})>;
typedef $$PlantsTableCreateCompanionBuilder = PlantsCompanion Function({
  Value<int> id,
  required int bedId,
  required String variety,
  required String commonName,
  Value<DateTime?> seedStartDate,
  Value<DateTime?> transplantDate,
  Value<DateTime?> expectedHarvestStart,
  Value<String> status,
  Value<String?> growthStage,
  Value<int?> quantity,
  Value<String?> source,
  Value<String?> notes,
  Value<String?> photoPath,
  Value<DateTime> createdAt,
});
typedef $$PlantsTableUpdateCompanionBuilder = PlantsCompanion Function({
  Value<int> id,
  Value<int> bedId,
  Value<String> variety,
  Value<String> commonName,
  Value<DateTime?> seedStartDate,
  Value<DateTime?> transplantDate,
  Value<DateTime?> expectedHarvestStart,
  Value<String> status,
  Value<String?> growthStage,
  Value<int?> quantity,
  Value<String?> source,
  Value<String?> notes,
  Value<String?> photoPath,
  Value<DateTime> createdAt,
});

final class $$PlantsTableReferences
    extends BaseReferences<_$AppDatabase, $PlantsTable, Plant> {
  $$PlantsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BedsTable _bedIdTable(_$AppDatabase db) =>
      db.beds.createAlias($_aliasNameGenerator(db.plants.bedId, db.beds.id));

  $$BedsTableProcessedTableManager get bedId {
    final $_column = $_itemColumn<int>('bed_id')!;

    final manager = $$BedsTableTableManager($_db, $_db.beds)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bedIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ObservationsTable, List<Observation>>
      _observationsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.observations,
              aliasName:
                  $_aliasNameGenerator(db.plants.id, db.observations.plantId));

  $$ObservationsTableProcessedTableManager get observationsRefs {
    final manager = $$ObservationsTableTableManager($_db, $_db.observations)
        .filter((f) => f.plantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_observationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$HarvestsTable, List<Harvest>> _harvestsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.harvests,
          aliasName: $_aliasNameGenerator(db.plants.id, db.harvests.plantId));

  $$HarvestsTableProcessedTableManager get harvestsRefs {
    final manager = $$HarvestsTableTableManager($_db, $_db.harvests)
        .filter((f) => f.plantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_harvestsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PlantPhotosTable, List<PlantPhoto>>
      _plantPhotosRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.plantPhotos,
              aliasName:
                  $_aliasNameGenerator(db.plants.id, db.plantPhotos.plantId));

  $$PlantPhotosTableProcessedTableManager get plantPhotosRefs {
    final manager = $$PlantPhotosTableTableManager($_db, $_db.plantPhotos)
        .filter((f) => f.plantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_plantPhotosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PlantsTableFilterComposer
    extends Composer<_$AppDatabase, $PlantsTable> {
  $$PlantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get variety => $composableBuilder(
      column: $table.variety, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get commonName => $composableBuilder(
      column: $table.commonName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get seedStartDate => $composableBuilder(
      column: $table.seedStartDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get transplantDate => $composableBuilder(
      column: $table.transplantDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expectedHarvestStart => $composableBuilder(
      column: $table.expectedHarvestStart,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get growthStage => $composableBuilder(
      column: $table.growthStage, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$BedsTableFilterComposer get bedId {
    final $$BedsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bedId,
        referencedTable: $db.beds,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BedsTableFilterComposer(
              $db: $db,
              $table: $db.beds,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> observationsRefs(
      Expression<bool> Function($$ObservationsTableFilterComposer f) f) {
    final $$ObservationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.observations,
        getReferencedColumn: (t) => t.plantId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ObservationsTableFilterComposer(
              $db: $db,
              $table: $db.observations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> harvestsRefs(
      Expression<bool> Function($$HarvestsTableFilterComposer f) f) {
    final $$HarvestsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.harvests,
        getReferencedColumn: (t) => t.plantId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HarvestsTableFilterComposer(
              $db: $db,
              $table: $db.harvests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> plantPhotosRefs(
      Expression<bool> Function($$PlantPhotosTableFilterComposer f) f) {
    final $$PlantPhotosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.plantPhotos,
        getReferencedColumn: (t) => t.plantId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlantPhotosTableFilterComposer(
              $db: $db,
              $table: $db.plantPhotos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PlantsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlantsTable> {
  $$PlantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get variety => $composableBuilder(
      column: $table.variety, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get commonName => $composableBuilder(
      column: $table.commonName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get seedStartDate => $composableBuilder(
      column: $table.seedStartDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get transplantDate => $composableBuilder(
      column: $table.transplantDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expectedHarvestStart => $composableBuilder(
      column: $table.expectedHarvestStart,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get growthStage => $composableBuilder(
      column: $table.growthStage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$BedsTableOrderingComposer get bedId {
    final $$BedsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bedId,
        referencedTable: $db.beds,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BedsTableOrderingComposer(
              $db: $db,
              $table: $db.beds,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlantsTable> {
  $$PlantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get variety =>
      $composableBuilder(column: $table.variety, builder: (column) => column);

  GeneratedColumn<String> get commonName => $composableBuilder(
      column: $table.commonName, builder: (column) => column);

  GeneratedColumn<DateTime> get seedStartDate => $composableBuilder(
      column: $table.seedStartDate, builder: (column) => column);

  GeneratedColumn<DateTime> get transplantDate => $composableBuilder(
      column: $table.transplantDate, builder: (column) => column);

  GeneratedColumn<DateTime> get expectedHarvestStart => $composableBuilder(
      column: $table.expectedHarvestStart, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get growthStage => $composableBuilder(
      column: $table.growthStage, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$BedsTableAnnotationComposer get bedId {
    final $$BedsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bedId,
        referencedTable: $db.beds,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BedsTableAnnotationComposer(
              $db: $db,
              $table: $db.beds,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> observationsRefs<T extends Object>(
      Expression<T> Function($$ObservationsTableAnnotationComposer a) f) {
    final $$ObservationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.observations,
        getReferencedColumn: (t) => t.plantId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ObservationsTableAnnotationComposer(
              $db: $db,
              $table: $db.observations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> harvestsRefs<T extends Object>(
      Expression<T> Function($$HarvestsTableAnnotationComposer a) f) {
    final $$HarvestsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.harvests,
        getReferencedColumn: (t) => t.plantId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HarvestsTableAnnotationComposer(
              $db: $db,
              $table: $db.harvests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> plantPhotosRefs<T extends Object>(
      Expression<T> Function($$PlantPhotosTableAnnotationComposer a) f) {
    final $$PlantPhotosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.plantPhotos,
        getReferencedColumn: (t) => t.plantId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlantPhotosTableAnnotationComposer(
              $db: $db,
              $table: $db.plantPhotos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PlantsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlantsTable,
    Plant,
    $$PlantsTableFilterComposer,
    $$PlantsTableOrderingComposer,
    $$PlantsTableAnnotationComposer,
    $$PlantsTableCreateCompanionBuilder,
    $$PlantsTableUpdateCompanionBuilder,
    (Plant, $$PlantsTableReferences),
    Plant,
    PrefetchHooks Function(
        {bool bedId,
        bool observationsRefs,
        bool harvestsRefs,
        bool plantPhotosRefs})> {
  $$PlantsTableTableManager(_$AppDatabase db, $PlantsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> bedId = const Value.absent(),
            Value<String> variety = const Value.absent(),
            Value<String> commonName = const Value.absent(),
            Value<DateTime?> seedStartDate = const Value.absent(),
            Value<DateTime?> transplantDate = const Value.absent(),
            Value<DateTime?> expectedHarvestStart = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> growthStage = const Value.absent(),
            Value<int?> quantity = const Value.absent(),
            Value<String?> source = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PlantsCompanion(
            id: id,
            bedId: bedId,
            variety: variety,
            commonName: commonName,
            seedStartDate: seedStartDate,
            transplantDate: transplantDate,
            expectedHarvestStart: expectedHarvestStart,
            status: status,
            growthStage: growthStage,
            quantity: quantity,
            source: source,
            notes: notes,
            photoPath: photoPath,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int bedId,
            required String variety,
            required String commonName,
            Value<DateTime?> seedStartDate = const Value.absent(),
            Value<DateTime?> transplantDate = const Value.absent(),
            Value<DateTime?> expectedHarvestStart = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> growthStage = const Value.absent(),
            Value<int?> quantity = const Value.absent(),
            Value<String?> source = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PlantsCompanion.insert(
            id: id,
            bedId: bedId,
            variety: variety,
            commonName: commonName,
            seedStartDate: seedStartDate,
            transplantDate: transplantDate,
            expectedHarvestStart: expectedHarvestStart,
            status: status,
            growthStage: growthStage,
            quantity: quantity,
            source: source,
            notes: notes,
            photoPath: photoPath,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PlantsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {bedId = false,
              observationsRefs = false,
              harvestsRefs = false,
              plantPhotosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (observationsRefs) db.observations,
                if (harvestsRefs) db.harvests,
                if (plantPhotosRefs) db.plantPhotos
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (bedId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.bedId,
                    referencedTable: $$PlantsTableReferences._bedIdTable(db),
                    referencedColumn:
                        $$PlantsTableReferences._bedIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (observationsRefs)
                    await $_getPrefetchedData<Plant, $PlantsTable, Observation>(
                        currentTable: table,
                        referencedTable:
                            $$PlantsTableReferences._observationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PlantsTableReferences(db, table, p0)
                                .observationsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.plantId == item.id),
                        typedResults: items),
                  if (harvestsRefs)
                    await $_getPrefetchedData<Plant, $PlantsTable, Harvest>(
                        currentTable: table,
                        referencedTable:
                            $$PlantsTableReferences._harvestsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PlantsTableReferences(db, table, p0).harvestsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.plantId == item.id),
                        typedResults: items),
                  if (plantPhotosRefs)
                    await $_getPrefetchedData<Plant, $PlantsTable, PlantPhoto>(
                        currentTable: table,
                        referencedTable:
                            $$PlantsTableReferences._plantPhotosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PlantsTableReferences(db, table, p0)
                                .plantPhotosRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.plantId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PlantsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlantsTable,
    Plant,
    $$PlantsTableFilterComposer,
    $$PlantsTableOrderingComposer,
    $$PlantsTableAnnotationComposer,
    $$PlantsTableCreateCompanionBuilder,
    $$PlantsTableUpdateCompanionBuilder,
    (Plant, $$PlantsTableReferences),
    Plant,
    PrefetchHooks Function(
        {bool bedId,
        bool observationsRefs,
        bool harvestsRefs,
        bool plantPhotosRefs})>;
typedef $$ObservationsTableCreateCompanionBuilder = ObservationsCompanion
    Function({
  Value<int> id,
  required int plantId,
  Value<DateTime> date,
  required String type,
  required String description,
  Value<double?> amount,
  Value<String?> unit,
  Value<String?> photoPath,
});
typedef $$ObservationsTableUpdateCompanionBuilder = ObservationsCompanion
    Function({
  Value<int> id,
  Value<int> plantId,
  Value<DateTime> date,
  Value<String> type,
  Value<String> description,
  Value<double?> amount,
  Value<String?> unit,
  Value<String?> photoPath,
});

final class $$ObservationsTableReferences
    extends BaseReferences<_$AppDatabase, $ObservationsTable, Observation> {
  $$ObservationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlantsTable _plantIdTable(_$AppDatabase db) => db.plants
      .createAlias($_aliasNameGenerator(db.observations.plantId, db.plants.id));

  $$PlantsTableProcessedTableManager get plantId {
    final $_column = $_itemColumn<int>('plant_id')!;

    final manager = $$PlantsTableTableManager($_db, $_db.plants)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_plantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ObservationsTableFilterComposer
    extends Composer<_$AppDatabase, $ObservationsTable> {
  $$ObservationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnFilters(column));

  $$PlantsTableFilterComposer get plantId {
    final $$PlantsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.plantId,
        referencedTable: $db.plants,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlantsTableFilterComposer(
              $db: $db,
              $table: $db.plants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ObservationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ObservationsTable> {
  $$ObservationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnOrderings(column));

  $$PlantsTableOrderingComposer get plantId {
    final $$PlantsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.plantId,
        referencedTable: $db.plants,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlantsTableOrderingComposer(
              $db: $db,
              $table: $db.plants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ObservationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ObservationsTable> {
  $$ObservationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  $$PlantsTableAnnotationComposer get plantId {
    final $$PlantsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.plantId,
        referencedTable: $db.plants,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlantsTableAnnotationComposer(
              $db: $db,
              $table: $db.plants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ObservationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ObservationsTable,
    Observation,
    $$ObservationsTableFilterComposer,
    $$ObservationsTableOrderingComposer,
    $$ObservationsTableAnnotationComposer,
    $$ObservationsTableCreateCompanionBuilder,
    $$ObservationsTableUpdateCompanionBuilder,
    (Observation, $$ObservationsTableReferences),
    Observation,
    PrefetchHooks Function({bool plantId})> {
  $$ObservationsTableTableManager(_$AppDatabase db, $ObservationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ObservationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ObservationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ObservationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> plantId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<double?> amount = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
          }) =>
              ObservationsCompanion(
            id: id,
            plantId: plantId,
            date: date,
            type: type,
            description: description,
            amount: amount,
            unit: unit,
            photoPath: photoPath,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int plantId,
            Value<DateTime> date = const Value.absent(),
            required String type,
            required String description,
            Value<double?> amount = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
          }) =>
              ObservationsCompanion.insert(
            id: id,
            plantId: plantId,
            date: date,
            type: type,
            description: description,
            amount: amount,
            unit: unit,
            photoPath: photoPath,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ObservationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({plantId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (plantId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.plantId,
                    referencedTable:
                        $$ObservationsTableReferences._plantIdTable(db),
                    referencedColumn:
                        $$ObservationsTableReferences._plantIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ObservationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ObservationsTable,
    Observation,
    $$ObservationsTableFilterComposer,
    $$ObservationsTableOrderingComposer,
    $$ObservationsTableAnnotationComposer,
    $$ObservationsTableCreateCompanionBuilder,
    $$ObservationsTableUpdateCompanionBuilder,
    (Observation, $$ObservationsTableReferences),
    Observation,
    PrefetchHooks Function({bool plantId})>;
typedef $$HarvestsTableCreateCompanionBuilder = HarvestsCompanion Function({
  Value<int> id,
  required int plantId,
  Value<DateTime> date,
  required double quantity,
  Value<String> unit,
  Value<int?> qualityRating,
  Value<String?> notes,
  Value<String?> photoPath,
});
typedef $$HarvestsTableUpdateCompanionBuilder = HarvestsCompanion Function({
  Value<int> id,
  Value<int> plantId,
  Value<DateTime> date,
  Value<double> quantity,
  Value<String> unit,
  Value<int?> qualityRating,
  Value<String?> notes,
  Value<String?> photoPath,
});

final class $$HarvestsTableReferences
    extends BaseReferences<_$AppDatabase, $HarvestsTable, Harvest> {
  $$HarvestsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlantsTable _plantIdTable(_$AppDatabase db) => db.plants
      .createAlias($_aliasNameGenerator(db.harvests.plantId, db.plants.id));

  $$PlantsTableProcessedTableManager get plantId {
    final $_column = $_itemColumn<int>('plant_id')!;

    final manager = $$PlantsTableTableManager($_db, $_db.plants)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_plantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$HarvestsTableFilterComposer
    extends Composer<_$AppDatabase, $HarvestsTable> {
  $$HarvestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get qualityRating => $composableBuilder(
      column: $table.qualityRating, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnFilters(column));

  $$PlantsTableFilterComposer get plantId {
    final $$PlantsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.plantId,
        referencedTable: $db.plants,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlantsTableFilterComposer(
              $db: $db,
              $table: $db.plants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HarvestsTableOrderingComposer
    extends Composer<_$AppDatabase, $HarvestsTable> {
  $$HarvestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get qualityRating => $composableBuilder(
      column: $table.qualityRating,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnOrderings(column));

  $$PlantsTableOrderingComposer get plantId {
    final $$PlantsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.plantId,
        referencedTable: $db.plants,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlantsTableOrderingComposer(
              $db: $db,
              $table: $db.plants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HarvestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HarvestsTable> {
  $$HarvestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get qualityRating => $composableBuilder(
      column: $table.qualityRating, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  $$PlantsTableAnnotationComposer get plantId {
    final $$PlantsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.plantId,
        referencedTable: $db.plants,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlantsTableAnnotationComposer(
              $db: $db,
              $table: $db.plants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HarvestsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HarvestsTable,
    Harvest,
    $$HarvestsTableFilterComposer,
    $$HarvestsTableOrderingComposer,
    $$HarvestsTableAnnotationComposer,
    $$HarvestsTableCreateCompanionBuilder,
    $$HarvestsTableUpdateCompanionBuilder,
    (Harvest, $$HarvestsTableReferences),
    Harvest,
    PrefetchHooks Function({bool plantId})> {
  $$HarvestsTableTableManager(_$AppDatabase db, $HarvestsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HarvestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HarvestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HarvestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> plantId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<int?> qualityRating = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
          }) =>
              HarvestsCompanion(
            id: id,
            plantId: plantId,
            date: date,
            quantity: quantity,
            unit: unit,
            qualityRating: qualityRating,
            notes: notes,
            photoPath: photoPath,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int plantId,
            Value<DateTime> date = const Value.absent(),
            required double quantity,
            Value<String> unit = const Value.absent(),
            Value<int?> qualityRating = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
          }) =>
              HarvestsCompanion.insert(
            id: id,
            plantId: plantId,
            date: date,
            quantity: quantity,
            unit: unit,
            qualityRating: qualityRating,
            notes: notes,
            photoPath: photoPath,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$HarvestsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({plantId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (plantId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.plantId,
                    referencedTable:
                        $$HarvestsTableReferences._plantIdTable(db),
                    referencedColumn:
                        $$HarvestsTableReferences._plantIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$HarvestsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HarvestsTable,
    Harvest,
    $$HarvestsTableFilterComposer,
    $$HarvestsTableOrderingComposer,
    $$HarvestsTableAnnotationComposer,
    $$HarvestsTableCreateCompanionBuilder,
    $$HarvestsTableUpdateCompanionBuilder,
    (Harvest, $$HarvestsTableReferences),
    Harvest,
    PrefetchHooks Function({bool plantId})>;
typedef $$ExpensesTableCreateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  Value<DateTime> date,
  required String category,
  required String description,
  required double amount,
  Value<String?> vendor,
  Value<String?> notes,
});
typedef $$ExpensesTableUpdateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  Value<DateTime> date,
  Value<String> category,
  Value<String> description,
  Value<double> amount,
  Value<String?> vendor,
  Value<String?> notes,
});

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get vendor => $composableBuilder(
      column: $table.vendor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get vendor => $composableBuilder(
      column: $table.vendor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get vendor =>
      $composableBuilder(column: $table.vendor, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$ExpensesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
    Expense,
    PrefetchHooks Function()> {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String?> vendor = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              ExpensesCompanion(
            id: id,
            date: date,
            category: category,
            description: description,
            amount: amount,
            vendor: vendor,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            required String category,
            required String description,
            required double amount,
            Value<String?> vendor = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              ExpensesCompanion.insert(
            id: id,
            date: date,
            category: category,
            description: description,
            amount: amount,
            vendor: vendor,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExpensesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
    Expense,
    PrefetchHooks Function()>;
typedef $$RemindersTableCreateCompanionBuilder = RemindersCompanion Function({
  Value<int> id,
  Value<int?> plantId,
  required String type,
  required String title,
  Value<String?> notes,
  required DateTime dueDate,
  Value<bool> isCompleted,
  Value<bool> isRepeating,
  Value<String?> repeatInterval,
});
typedef $$RemindersTableUpdateCompanionBuilder = RemindersCompanion Function({
  Value<int> id,
  Value<int?> plantId,
  Value<String> type,
  Value<String> title,
  Value<String?> notes,
  Value<DateTime> dueDate,
  Value<bool> isCompleted,
  Value<bool> isRepeating,
  Value<String?> repeatInterval,
});

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get plantId => $composableBuilder(
      column: $table.plantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRepeating => $composableBuilder(
      column: $table.isRepeating, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get repeatInterval => $composableBuilder(
      column: $table.repeatInterval,
      builder: (column) => ColumnFilters(column));
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get plantId => $composableBuilder(
      column: $table.plantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRepeating => $composableBuilder(
      column: $table.isRepeating, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get repeatInterval => $composableBuilder(
      column: $table.repeatInterval,
      builder: (column) => ColumnOrderings(column));
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get plantId =>
      $composableBuilder(column: $table.plantId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<bool> get isRepeating => $composableBuilder(
      column: $table.isRepeating, builder: (column) => column);

  GeneratedColumn<String> get repeatInterval => $composableBuilder(
      column: $table.repeatInterval, builder: (column) => column);
}

class $$RemindersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RemindersTable,
    Reminder,
    $$RemindersTableFilterComposer,
    $$RemindersTableOrderingComposer,
    $$RemindersTableAnnotationComposer,
    $$RemindersTableCreateCompanionBuilder,
    $$RemindersTableUpdateCompanionBuilder,
    (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
    Reminder,
    PrefetchHooks Function()> {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> plantId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> dueDate = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<bool> isRepeating = const Value.absent(),
            Value<String?> repeatInterval = const Value.absent(),
          }) =>
              RemindersCompanion(
            id: id,
            plantId: plantId,
            type: type,
            title: title,
            notes: notes,
            dueDate: dueDate,
            isCompleted: isCompleted,
            isRepeating: isRepeating,
            repeatInterval: repeatInterval,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> plantId = const Value.absent(),
            required String type,
            required String title,
            Value<String?> notes = const Value.absent(),
            required DateTime dueDate,
            Value<bool> isCompleted = const Value.absent(),
            Value<bool> isRepeating = const Value.absent(),
            Value<String?> repeatInterval = const Value.absent(),
          }) =>
              RemindersCompanion.insert(
            id: id,
            plantId: plantId,
            type: type,
            title: title,
            notes: notes,
            dueDate: dueDate,
            isCompleted: isCompleted,
            isRepeating: isRepeating,
            repeatInterval: repeatInterval,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RemindersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RemindersTable,
    Reminder,
    $$RemindersTableFilterComposer,
    $$RemindersTableOrderingComposer,
    $$RemindersTableAnnotationComposer,
    $$RemindersTableCreateCompanionBuilder,
    $$RemindersTableUpdateCompanionBuilder,
    (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
    Reminder,
    PrefetchHooks Function()>;
typedef $$PlantPhotosTableCreateCompanionBuilder = PlantPhotosCompanion
    Function({
  Value<int> id,
  required int plantId,
  required String photoPath,
  Value<String?> caption,
  Value<DateTime> takenAt,
});
typedef $$PlantPhotosTableUpdateCompanionBuilder = PlantPhotosCompanion
    Function({
  Value<int> id,
  Value<int> plantId,
  Value<String> photoPath,
  Value<String?> caption,
  Value<DateTime> takenAt,
});

final class $$PlantPhotosTableReferences
    extends BaseReferences<_$AppDatabase, $PlantPhotosTable, PlantPhoto> {
  $$PlantPhotosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlantsTable _plantIdTable(_$AppDatabase db) => db.plants
      .createAlias($_aliasNameGenerator(db.plantPhotos.plantId, db.plants.id));

  $$PlantsTableProcessedTableManager get plantId {
    final $_column = $_itemColumn<int>('plant_id')!;

    final manager = $$PlantsTableTableManager($_db, $_db.plants)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_plantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PlantPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $PlantPhotosTable> {
  $$PlantPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get caption => $composableBuilder(
      column: $table.caption, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get takenAt => $composableBuilder(
      column: $table.takenAt, builder: (column) => ColumnFilters(column));

  $$PlantsTableFilterComposer get plantId {
    final $$PlantsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.plantId,
        referencedTable: $db.plants,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlantsTableFilterComposer(
              $db: $db,
              $table: $db.plants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlantPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $PlantPhotosTable> {
  $$PlantPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get caption => $composableBuilder(
      column: $table.caption, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get takenAt => $composableBuilder(
      column: $table.takenAt, builder: (column) => ColumnOrderings(column));

  $$PlantsTableOrderingComposer get plantId {
    final $$PlantsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.plantId,
        referencedTable: $db.plants,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlantsTableOrderingComposer(
              $db: $db,
              $table: $db.plants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlantPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlantPhotosTable> {
  $$PlantPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  GeneratedColumn<DateTime> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  $$PlantsTableAnnotationComposer get plantId {
    final $$PlantsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.plantId,
        referencedTable: $db.plants,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlantsTableAnnotationComposer(
              $db: $db,
              $table: $db.plants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlantPhotosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlantPhotosTable,
    PlantPhoto,
    $$PlantPhotosTableFilterComposer,
    $$PlantPhotosTableOrderingComposer,
    $$PlantPhotosTableAnnotationComposer,
    $$PlantPhotosTableCreateCompanionBuilder,
    $$PlantPhotosTableUpdateCompanionBuilder,
    (PlantPhoto, $$PlantPhotosTableReferences),
    PlantPhoto,
    PrefetchHooks Function({bool plantId})> {
  $$PlantPhotosTableTableManager(_$AppDatabase db, $PlantPhotosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlantPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlantPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlantPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> plantId = const Value.absent(),
            Value<String> photoPath = const Value.absent(),
            Value<String?> caption = const Value.absent(),
            Value<DateTime> takenAt = const Value.absent(),
          }) =>
              PlantPhotosCompanion(
            id: id,
            plantId: plantId,
            photoPath: photoPath,
            caption: caption,
            takenAt: takenAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int plantId,
            required String photoPath,
            Value<String?> caption = const Value.absent(),
            Value<DateTime> takenAt = const Value.absent(),
          }) =>
              PlantPhotosCompanion.insert(
            id: id,
            plantId: plantId,
            photoPath: photoPath,
            caption: caption,
            takenAt: takenAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PlantPhotosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({plantId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (plantId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.plantId,
                    referencedTable:
                        $$PlantPhotosTableReferences._plantIdTable(db),
                    referencedColumn:
                        $$PlantPhotosTableReferences._plantIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PlantPhotosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlantPhotosTable,
    PlantPhoto,
    $$PlantPhotosTableFilterComposer,
    $$PlantPhotosTableOrderingComposer,
    $$PlantPhotosTableAnnotationComposer,
    $$PlantPhotosTableCreateCompanionBuilder,
    $$PlantPhotosTableUpdateCompanionBuilder,
    (PlantPhoto, $$PlantPhotosTableReferences),
    PlantPhoto,
    PrefetchHooks Function({bool plantId})>;
typedef $$JournalEntriesTableCreateCompanionBuilder = JournalEntriesCompanion
    Function({
  Value<int> id,
  required String title,
  Value<String?> body,
  Value<String?> photoPath,
  Value<String?> mood,
  Value<String?> tags,
  Value<DateTime> createdAt,
});
typedef $$JournalEntriesTableUpdateCompanionBuilder = JournalEntriesCompanion
    Function({
  Value<int> id,
  Value<String> title,
  Value<String?> body,
  Value<String?> photoPath,
  Value<String?> mood,
  Value<String?> tags,
  Value<DateTime> createdAt,
});

class $$JournalEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mood => $composableBuilder(
      column: $table.mood, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$JournalEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mood => $composableBuilder(
      column: $table.mood, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$JournalEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$JournalEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $JournalEntriesTable,
    JournalEntry,
    $$JournalEntriesTableFilterComposer,
    $$JournalEntriesTableOrderingComposer,
    $$JournalEntriesTableAnnotationComposer,
    $$JournalEntriesTableCreateCompanionBuilder,
    $$JournalEntriesTableUpdateCompanionBuilder,
    (
      JournalEntry,
      BaseReferences<_$AppDatabase, $JournalEntriesTable, JournalEntry>
    ),
    JournalEntry,
    PrefetchHooks Function()> {
  $$JournalEntriesTableTableManager(
      _$AppDatabase db, $JournalEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> body = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<String?> mood = const Value.absent(),
            Value<String?> tags = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              JournalEntriesCompanion(
            id: id,
            title: title,
            body: body,
            photoPath: photoPath,
            mood: mood,
            tags: tags,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            Value<String?> body = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<String?> mood = const Value.absent(),
            Value<String?> tags = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              JournalEntriesCompanion.insert(
            id: id,
            title: title,
            body: body,
            photoPath: photoPath,
            mood: mood,
            tags: tags,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$JournalEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $JournalEntriesTable,
    JournalEntry,
    $$JournalEntriesTableFilterComposer,
    $$JournalEntriesTableOrderingComposer,
    $$JournalEntriesTableAnnotationComposer,
    $$JournalEntriesTableCreateCompanionBuilder,
    $$JournalEntriesTableUpdateCompanionBuilder,
    (
      JournalEntry,
      BaseReferences<_$AppDatabase, $JournalEntriesTable, JournalEntry>
    ),
    JournalEntry,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GardensTableTableManager get gardens =>
      $$GardensTableTableManager(_db, _db.gardens);
  $$BedsTableTableManager get beds => $$BedsTableTableManager(_db, _db.beds);
  $$PlantsTableTableManager get plants =>
      $$PlantsTableTableManager(_db, _db.plants);
  $$ObservationsTableTableManager get observations =>
      $$ObservationsTableTableManager(_db, _db.observations);
  $$HarvestsTableTableManager get harvests =>
      $$HarvestsTableTableManager(_db, _db.harvests);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$PlantPhotosTableTableManager get plantPhotos =>
      $$PlantPhotosTableTableManager(_db, _db.plantPhotos);
  $$JournalEntriesTableTableManager get journalEntries =>
      $$JournalEntriesTableTableManager(_db, _db.journalEntries);
}
