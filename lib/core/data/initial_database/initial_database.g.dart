// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initial_database.dart';

// ignore_for_file: type=lint
class $ImportedDeckTable extends ImportedDeck
    with TableInfo<$ImportedDeckTable, ImportedDeckData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImportedDeckTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _deckNameMeta = const VerificationMeta(
    'deckName',
  );
  @override
  late final GeneratedColumn<String> deckName = GeneratedColumn<String>(
    'deck_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deckLanguageMeta = const VerificationMeta(
    'deckLanguage',
  );
  @override
  late final GeneratedColumn<String> deckLanguage = GeneratedColumn<String>(
    'deck_language',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 30,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeHourMeta = const VerificationMeta(
    'activeHour',
  );
  @override
  late final GeneratedColumn<int> activeHour = GeneratedColumn<int>(
    'active_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _apkgPathMeta = const VerificationMeta(
    'apkgPath',
  );
  @override
  late final GeneratedColumn<String> apkgPath = GeneratedColumn<String>(
    'apkg_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extractedPathMeta = const VerificationMeta(
    'extractedPath',
  );
  @override
  late final GeneratedColumn<String> extractedPath = GeneratedColumn<String>(
    'extracted_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _importedDateMeta = const VerificationMeta(
    'importedDate',
  );
  @override
  late final GeneratedColumn<DateTime> importedDate = GeneratedColumn<DateTime>(
    'imported_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: Constant(DateTime.now()),
  );
  static const VerificationMeta _colorDeckMeta = const VerificationMeta(
    'colorDeck',
  );
  @override
  late final GeneratedColumn<int> colorDeck = GeneratedColumn<int>(
    'color_deck',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deckName,
    deckLanguage,
    activeHour,
    apkgPath,
    extractedPath,
    importedDate,
    colorDeck,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'imported_deck';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImportedDeckData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('deck_name')) {
      context.handle(
        _deckNameMeta,
        deckName.isAcceptableOrUnknown(data['deck_name']!, _deckNameMeta),
      );
    } else if (isInserting) {
      context.missing(_deckNameMeta);
    }
    if (data.containsKey('deck_language')) {
      context.handle(
        _deckLanguageMeta,
        deckLanguage.isAcceptableOrUnknown(
          data['deck_language']!,
          _deckLanguageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_deckLanguageMeta);
    }
    if (data.containsKey('active_hour')) {
      context.handle(
        _activeHourMeta,
        activeHour.isAcceptableOrUnknown(data['active_hour']!, _activeHourMeta),
      );
    }
    if (data.containsKey('apkg_path')) {
      context.handle(
        _apkgPathMeta,
        apkgPath.isAcceptableOrUnknown(data['apkg_path']!, _apkgPathMeta),
      );
    } else if (isInserting) {
      context.missing(_apkgPathMeta);
    }
    if (data.containsKey('extracted_path')) {
      context.handle(
        _extractedPathMeta,
        extractedPath.isAcceptableOrUnknown(
          data['extracted_path']!,
          _extractedPathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_extractedPathMeta);
    }
    if (data.containsKey('imported_date')) {
      context.handle(
        _importedDateMeta,
        importedDate.isAcceptableOrUnknown(
          data['imported_date']!,
          _importedDateMeta,
        ),
      );
    }
    if (data.containsKey('color_deck')) {
      context.handle(
        _colorDeckMeta,
        colorDeck.isAcceptableOrUnknown(data['color_deck']!, _colorDeckMeta),
      );
    } else if (isInserting) {
      context.missing(_colorDeckMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImportedDeckData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImportedDeckData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      deckName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deck_name'],
      )!,
      deckLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deck_language'],
      )!,
      activeHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}active_hour'],
      )!,
      apkgPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}apkg_path'],
      )!,
      extractedPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extracted_path'],
      )!,
      importedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}imported_date'],
      )!,
      colorDeck: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_deck'],
      )!,
    );
  }

  @override
  $ImportedDeckTable createAlias(String alias) {
    return $ImportedDeckTable(attachedDatabase, alias);
  }
}

class ImportedDeckData extends DataClass
    implements Insertable<ImportedDeckData> {
  final int id;
  final String deckName;
  final String deckLanguage;
  final int activeHour;
  final String apkgPath;
  final String extractedPath;
  final DateTime importedDate;
  final int colorDeck;
  const ImportedDeckData({
    required this.id,
    required this.deckName,
    required this.deckLanguage,
    required this.activeHour,
    required this.apkgPath,
    required this.extractedPath,
    required this.importedDate,
    required this.colorDeck,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['deck_name'] = Variable<String>(deckName);
    map['deck_language'] = Variable<String>(deckLanguage);
    map['active_hour'] = Variable<int>(activeHour);
    map['apkg_path'] = Variable<String>(apkgPath);
    map['extracted_path'] = Variable<String>(extractedPath);
    map['imported_date'] = Variable<DateTime>(importedDate);
    map['color_deck'] = Variable<int>(colorDeck);
    return map;
  }

  ImportedDeckCompanion toCompanion(bool nullToAbsent) {
    return ImportedDeckCompanion(
      id: Value(id),
      deckName: Value(deckName),
      deckLanguage: Value(deckLanguage),
      activeHour: Value(activeHour),
      apkgPath: Value(apkgPath),
      extractedPath: Value(extractedPath),
      importedDate: Value(importedDate),
      colorDeck: Value(colorDeck),
    );
  }

  factory ImportedDeckData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImportedDeckData(
      id: serializer.fromJson<int>(json['id']),
      deckName: serializer.fromJson<String>(json['deckName']),
      deckLanguage: serializer.fromJson<String>(json['deckLanguage']),
      activeHour: serializer.fromJson<int>(json['activeHour']),
      apkgPath: serializer.fromJson<String>(json['apkgPath']),
      extractedPath: serializer.fromJson<String>(json['extractedPath']),
      importedDate: serializer.fromJson<DateTime>(json['importedDate']),
      colorDeck: serializer.fromJson<int>(json['colorDeck']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deckName': serializer.toJson<String>(deckName),
      'deckLanguage': serializer.toJson<String>(deckLanguage),
      'activeHour': serializer.toJson<int>(activeHour),
      'apkgPath': serializer.toJson<String>(apkgPath),
      'extractedPath': serializer.toJson<String>(extractedPath),
      'importedDate': serializer.toJson<DateTime>(importedDate),
      'colorDeck': serializer.toJson<int>(colorDeck),
    };
  }

  ImportedDeckData copyWith({
    int? id,
    String? deckName,
    String? deckLanguage,
    int? activeHour,
    String? apkgPath,
    String? extractedPath,
    DateTime? importedDate,
    int? colorDeck,
  }) => ImportedDeckData(
    id: id ?? this.id,
    deckName: deckName ?? this.deckName,
    deckLanguage: deckLanguage ?? this.deckLanguage,
    activeHour: activeHour ?? this.activeHour,
    apkgPath: apkgPath ?? this.apkgPath,
    extractedPath: extractedPath ?? this.extractedPath,
    importedDate: importedDate ?? this.importedDate,
    colorDeck: colorDeck ?? this.colorDeck,
  );
  ImportedDeckData copyWithCompanion(ImportedDeckCompanion data) {
    return ImportedDeckData(
      id: data.id.present ? data.id.value : this.id,
      deckName: data.deckName.present ? data.deckName.value : this.deckName,
      deckLanguage: data.deckLanguage.present
          ? data.deckLanguage.value
          : this.deckLanguage,
      activeHour: data.activeHour.present
          ? data.activeHour.value
          : this.activeHour,
      apkgPath: data.apkgPath.present ? data.apkgPath.value : this.apkgPath,
      extractedPath: data.extractedPath.present
          ? data.extractedPath.value
          : this.extractedPath,
      importedDate: data.importedDate.present
          ? data.importedDate.value
          : this.importedDate,
      colorDeck: data.colorDeck.present ? data.colorDeck.value : this.colorDeck,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImportedDeckData(')
          ..write('id: $id, ')
          ..write('deckName: $deckName, ')
          ..write('deckLanguage: $deckLanguage, ')
          ..write('activeHour: $activeHour, ')
          ..write('apkgPath: $apkgPath, ')
          ..write('extractedPath: $extractedPath, ')
          ..write('importedDate: $importedDate, ')
          ..write('colorDeck: $colorDeck')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    deckName,
    deckLanguage,
    activeHour,
    apkgPath,
    extractedPath,
    importedDate,
    colorDeck,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImportedDeckData &&
          other.id == this.id &&
          other.deckName == this.deckName &&
          other.deckLanguage == this.deckLanguage &&
          other.activeHour == this.activeHour &&
          other.apkgPath == this.apkgPath &&
          other.extractedPath == this.extractedPath &&
          other.importedDate == this.importedDate &&
          other.colorDeck == this.colorDeck);
}

class ImportedDeckCompanion extends UpdateCompanion<ImportedDeckData> {
  final Value<int> id;
  final Value<String> deckName;
  final Value<String> deckLanguage;
  final Value<int> activeHour;
  final Value<String> apkgPath;
  final Value<String> extractedPath;
  final Value<DateTime> importedDate;
  final Value<int> colorDeck;
  const ImportedDeckCompanion({
    this.id = const Value.absent(),
    this.deckName = const Value.absent(),
    this.deckLanguage = const Value.absent(),
    this.activeHour = const Value.absent(),
    this.apkgPath = const Value.absent(),
    this.extractedPath = const Value.absent(),
    this.importedDate = const Value.absent(),
    this.colorDeck = const Value.absent(),
  });
  ImportedDeckCompanion.insert({
    this.id = const Value.absent(),
    required String deckName,
    required String deckLanguage,
    this.activeHour = const Value.absent(),
    required String apkgPath,
    required String extractedPath,
    this.importedDate = const Value.absent(),
    required int colorDeck,
  }) : deckName = Value(deckName),
       deckLanguage = Value(deckLanguage),
       apkgPath = Value(apkgPath),
       extractedPath = Value(extractedPath),
       colorDeck = Value(colorDeck);
  static Insertable<ImportedDeckData> custom({
    Expression<int>? id,
    Expression<String>? deckName,
    Expression<String>? deckLanguage,
    Expression<int>? activeHour,
    Expression<String>? apkgPath,
    Expression<String>? extractedPath,
    Expression<DateTime>? importedDate,
    Expression<int>? colorDeck,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deckName != null) 'deck_name': deckName,
      if (deckLanguage != null) 'deck_language': deckLanguage,
      if (activeHour != null) 'active_hour': activeHour,
      if (apkgPath != null) 'apkg_path': apkgPath,
      if (extractedPath != null) 'extracted_path': extractedPath,
      if (importedDate != null) 'imported_date': importedDate,
      if (colorDeck != null) 'color_deck': colorDeck,
    });
  }

  ImportedDeckCompanion copyWith({
    Value<int>? id,
    Value<String>? deckName,
    Value<String>? deckLanguage,
    Value<int>? activeHour,
    Value<String>? apkgPath,
    Value<String>? extractedPath,
    Value<DateTime>? importedDate,
    Value<int>? colorDeck,
  }) {
    return ImportedDeckCompanion(
      id: id ?? this.id,
      deckName: deckName ?? this.deckName,
      deckLanguage: deckLanguage ?? this.deckLanguage,
      activeHour: activeHour ?? this.activeHour,
      apkgPath: apkgPath ?? this.apkgPath,
      extractedPath: extractedPath ?? this.extractedPath,
      importedDate: importedDate ?? this.importedDate,
      colorDeck: colorDeck ?? this.colorDeck,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deckName.present) {
      map['deck_name'] = Variable<String>(deckName.value);
    }
    if (deckLanguage.present) {
      map['deck_language'] = Variable<String>(deckLanguage.value);
    }
    if (activeHour.present) {
      map['active_hour'] = Variable<int>(activeHour.value);
    }
    if (apkgPath.present) {
      map['apkg_path'] = Variable<String>(apkgPath.value);
    }
    if (extractedPath.present) {
      map['extracted_path'] = Variable<String>(extractedPath.value);
    }
    if (importedDate.present) {
      map['imported_date'] = Variable<DateTime>(importedDate.value);
    }
    if (colorDeck.present) {
      map['color_deck'] = Variable<int>(colorDeck.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImportedDeckCompanion(')
          ..write('id: $id, ')
          ..write('deckName: $deckName, ')
          ..write('deckLanguage: $deckLanguage, ')
          ..write('activeHour: $activeHour, ')
          ..write('apkgPath: $apkgPath, ')
          ..write('extractedPath: $extractedPath, ')
          ..write('importedDate: $importedDate, ')
          ..write('colorDeck: $colorDeck')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ImportedDeckTable importedDeck = $ImportedDeckTable(this);
  late final DecksDao decksDao = DecksDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [importedDeck];
}

typedef $$ImportedDeckTableCreateCompanionBuilder =
    ImportedDeckCompanion Function({
      Value<int> id,
      required String deckName,
      required String deckLanguage,
      Value<int> activeHour,
      required String apkgPath,
      required String extractedPath,
      Value<DateTime> importedDate,
      required int colorDeck,
    });
typedef $$ImportedDeckTableUpdateCompanionBuilder =
    ImportedDeckCompanion Function({
      Value<int> id,
      Value<String> deckName,
      Value<String> deckLanguage,
      Value<int> activeHour,
      Value<String> apkgPath,
      Value<String> extractedPath,
      Value<DateTime> importedDate,
      Value<int> colorDeck,
    });

class $$ImportedDeckTableFilterComposer
    extends Composer<_$AppDatabase, $ImportedDeckTable> {
  $$ImportedDeckTableFilterComposer({
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

  ColumnFilters<String> get deckName => $composableBuilder(
    column: $table.deckName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deckLanguage => $composableBuilder(
    column: $table.deckLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activeHour => $composableBuilder(
    column: $table.activeHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get apkgPath => $composableBuilder(
    column: $table.apkgPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extractedPath => $composableBuilder(
    column: $table.extractedPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get importedDate => $composableBuilder(
    column: $table.importedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorDeck => $composableBuilder(
    column: $table.colorDeck,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ImportedDeckTableOrderingComposer
    extends Composer<_$AppDatabase, $ImportedDeckTable> {
  $$ImportedDeckTableOrderingComposer({
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

  ColumnOrderings<String> get deckName => $composableBuilder(
    column: $table.deckName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deckLanguage => $composableBuilder(
    column: $table.deckLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activeHour => $composableBuilder(
    column: $table.activeHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get apkgPath => $composableBuilder(
    column: $table.apkgPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extractedPath => $composableBuilder(
    column: $table.extractedPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get importedDate => $composableBuilder(
    column: $table.importedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorDeck => $composableBuilder(
    column: $table.colorDeck,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ImportedDeckTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImportedDeckTable> {
  $$ImportedDeckTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get deckName =>
      $composableBuilder(column: $table.deckName, builder: (column) => column);

  GeneratedColumn<String> get deckLanguage => $composableBuilder(
    column: $table.deckLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get activeHour => $composableBuilder(
    column: $table.activeHour,
    builder: (column) => column,
  );

  GeneratedColumn<String> get apkgPath =>
      $composableBuilder(column: $table.apkgPath, builder: (column) => column);

  GeneratedColumn<String> get extractedPath => $composableBuilder(
    column: $table.extractedPath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get importedDate => $composableBuilder(
    column: $table.importedDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get colorDeck =>
      $composableBuilder(column: $table.colorDeck, builder: (column) => column);
}

class $$ImportedDeckTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ImportedDeckTable,
          ImportedDeckData,
          $$ImportedDeckTableFilterComposer,
          $$ImportedDeckTableOrderingComposer,
          $$ImportedDeckTableAnnotationComposer,
          $$ImportedDeckTableCreateCompanionBuilder,
          $$ImportedDeckTableUpdateCompanionBuilder,
          (
            ImportedDeckData,
            BaseReferences<_$AppDatabase, $ImportedDeckTable, ImportedDeckData>,
          ),
          ImportedDeckData,
          PrefetchHooks Function()
        > {
  $$ImportedDeckTableTableManager(_$AppDatabase db, $ImportedDeckTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImportedDeckTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImportedDeckTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImportedDeckTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> deckName = const Value.absent(),
                Value<String> deckLanguage = const Value.absent(),
                Value<int> activeHour = const Value.absent(),
                Value<String> apkgPath = const Value.absent(),
                Value<String> extractedPath = const Value.absent(),
                Value<DateTime> importedDate = const Value.absent(),
                Value<int> colorDeck = const Value.absent(),
              }) => ImportedDeckCompanion(
                id: id,
                deckName: deckName,
                deckLanguage: deckLanguage,
                activeHour: activeHour,
                apkgPath: apkgPath,
                extractedPath: extractedPath,
                importedDate: importedDate,
                colorDeck: colorDeck,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String deckName,
                required String deckLanguage,
                Value<int> activeHour = const Value.absent(),
                required String apkgPath,
                required String extractedPath,
                Value<DateTime> importedDate = const Value.absent(),
                required int colorDeck,
              }) => ImportedDeckCompanion.insert(
                id: id,
                deckName: deckName,
                deckLanguage: deckLanguage,
                activeHour: activeHour,
                apkgPath: apkgPath,
                extractedPath: extractedPath,
                importedDate: importedDate,
                colorDeck: colorDeck,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ImportedDeckTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ImportedDeckTable,
      ImportedDeckData,
      $$ImportedDeckTableFilterComposer,
      $$ImportedDeckTableOrderingComposer,
      $$ImportedDeckTableAnnotationComposer,
      $$ImportedDeckTableCreateCompanionBuilder,
      $$ImportedDeckTableUpdateCompanionBuilder,
      (
        ImportedDeckData,
        BaseReferences<_$AppDatabase, $ImportedDeckTable, ImportedDeckData>,
      ),
      ImportedDeckData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ImportedDeckTableTableManager get importedDeck =>
      $$ImportedDeckTableTableManager(_db, _db.importedDeck);
}
