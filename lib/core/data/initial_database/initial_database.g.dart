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
  static const VerificationMeta _countryDeckMeta = const VerificationMeta(
    'countryDeck',
  );
  @override
  late final GeneratedColumn<String> countryDeck = GeneratedColumn<String>(
    'country_deck',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dbPathMeta = const VerificationMeta('dbPath');
  @override
  late final GeneratedColumn<String> dbPath = GeneratedColumn<String>(
    'db_path',
    aliasedName,
    false,
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
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
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
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rolePlayMeta = const VerificationMeta(
    'rolePlay',
  );
  @override
  late final GeneratedColumn<String> rolePlay = GeneratedColumn<String>(
    'role_play',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationRolePlayMeta =
      const VerificationMeta('explanationRolePlay');
  @override
  late final GeneratedColumn<String> explanationRolePlay =
      GeneratedColumn<String>(
        'explanation_role_play',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deckName,
    deckLanguage,
    countryDeck,
    dbPath,
    activeHour,
    filePath,
    importedDate,
    colorDeck,
    language,
    rolePlay,
    difficulty,
    explanationRolePlay,
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
    if (data.containsKey('country_deck')) {
      context.handle(
        _countryDeckMeta,
        countryDeck.isAcceptableOrUnknown(
          data['country_deck']!,
          _countryDeckMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_countryDeckMeta);
    }
    if (data.containsKey('db_path')) {
      context.handle(
        _dbPathMeta,
        dbPath.isAcceptableOrUnknown(data['db_path']!, _dbPathMeta),
      );
    } else if (isInserting) {
      context.missing(_dbPathMeta);
    }
    if (data.containsKey('active_hour')) {
      context.handle(
        _activeHourMeta,
        activeHour.isAcceptableOrUnknown(data['active_hour']!, _activeHourMeta),
      );
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
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
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('role_play')) {
      context.handle(
        _rolePlayMeta,
        rolePlay.isAcceptableOrUnknown(data['role_play']!, _rolePlayMeta),
      );
    } else if (isInserting) {
      context.missing(_rolePlayMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('explanation_role_play')) {
      context.handle(
        _explanationRolePlayMeta,
        explanationRolePlay.isAcceptableOrUnknown(
          data['explanation_role_play']!,
          _explanationRolePlayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_explanationRolePlayMeta);
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
      countryDeck: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country_deck'],
      )!,
      dbPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}db_path'],
      )!,
      activeHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}active_hour'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      importedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}imported_date'],
      )!,
      colorDeck: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_deck'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      rolePlay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role_play'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      )!,
      explanationRolePlay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation_role_play'],
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
  final String countryDeck;
  final String dbPath;
  final int activeHour;
  final String filePath;
  final DateTime importedDate;
  final int colorDeck;
  final String language;
  final String rolePlay;
  final String difficulty;
  final String explanationRolePlay;
  const ImportedDeckData({
    required this.id,
    required this.deckName,
    required this.deckLanguage,
    required this.countryDeck,
    required this.dbPath,
    required this.activeHour,
    required this.filePath,
    required this.importedDate,
    required this.colorDeck,
    required this.language,
    required this.rolePlay,
    required this.difficulty,
    required this.explanationRolePlay,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['deck_name'] = Variable<String>(deckName);
    map['deck_language'] = Variable<String>(deckLanguage);
    map['country_deck'] = Variable<String>(countryDeck);
    map['db_path'] = Variable<String>(dbPath);
    map['active_hour'] = Variable<int>(activeHour);
    map['file_path'] = Variable<String>(filePath);
    map['imported_date'] = Variable<DateTime>(importedDate);
    map['color_deck'] = Variable<int>(colorDeck);
    map['language'] = Variable<String>(language);
    map['role_play'] = Variable<String>(rolePlay);
    map['difficulty'] = Variable<String>(difficulty);
    map['explanation_role_play'] = Variable<String>(explanationRolePlay);
    return map;
  }

  ImportedDeckCompanion toCompanion(bool nullToAbsent) {
    return ImportedDeckCompanion(
      id: Value(id),
      deckName: Value(deckName),
      deckLanguage: Value(deckLanguage),
      countryDeck: Value(countryDeck),
      dbPath: Value(dbPath),
      activeHour: Value(activeHour),
      filePath: Value(filePath),
      importedDate: Value(importedDate),
      colorDeck: Value(colorDeck),
      language: Value(language),
      rolePlay: Value(rolePlay),
      difficulty: Value(difficulty),
      explanationRolePlay: Value(explanationRolePlay),
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
      countryDeck: serializer.fromJson<String>(json['countryDeck']),
      dbPath: serializer.fromJson<String>(json['dbPath']),
      activeHour: serializer.fromJson<int>(json['activeHour']),
      filePath: serializer.fromJson<String>(json['filePath']),
      importedDate: serializer.fromJson<DateTime>(json['importedDate']),
      colorDeck: serializer.fromJson<int>(json['colorDeck']),
      language: serializer.fromJson<String>(json['language']),
      rolePlay: serializer.fromJson<String>(json['rolePlay']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      explanationRolePlay: serializer.fromJson<String>(
        json['explanationRolePlay'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deckName': serializer.toJson<String>(deckName),
      'deckLanguage': serializer.toJson<String>(deckLanguage),
      'countryDeck': serializer.toJson<String>(countryDeck),
      'dbPath': serializer.toJson<String>(dbPath),
      'activeHour': serializer.toJson<int>(activeHour),
      'filePath': serializer.toJson<String>(filePath),
      'importedDate': serializer.toJson<DateTime>(importedDate),
      'colorDeck': serializer.toJson<int>(colorDeck),
      'language': serializer.toJson<String>(language),
      'rolePlay': serializer.toJson<String>(rolePlay),
      'difficulty': serializer.toJson<String>(difficulty),
      'explanationRolePlay': serializer.toJson<String>(explanationRolePlay),
    };
  }

  ImportedDeckData copyWith({
    int? id,
    String? deckName,
    String? deckLanguage,
    String? countryDeck,
    String? dbPath,
    int? activeHour,
    String? filePath,
    DateTime? importedDate,
    int? colorDeck,
    String? language,
    String? rolePlay,
    String? difficulty,
    String? explanationRolePlay,
  }) => ImportedDeckData(
    id: id ?? this.id,
    deckName: deckName ?? this.deckName,
    deckLanguage: deckLanguage ?? this.deckLanguage,
    countryDeck: countryDeck ?? this.countryDeck,
    dbPath: dbPath ?? this.dbPath,
    activeHour: activeHour ?? this.activeHour,
    filePath: filePath ?? this.filePath,
    importedDate: importedDate ?? this.importedDate,
    colorDeck: colorDeck ?? this.colorDeck,
    language: language ?? this.language,
    rolePlay: rolePlay ?? this.rolePlay,
    difficulty: difficulty ?? this.difficulty,
    explanationRolePlay: explanationRolePlay ?? this.explanationRolePlay,
  );
  ImportedDeckData copyWithCompanion(ImportedDeckCompanion data) {
    return ImportedDeckData(
      id: data.id.present ? data.id.value : this.id,
      deckName: data.deckName.present ? data.deckName.value : this.deckName,
      deckLanguage: data.deckLanguage.present
          ? data.deckLanguage.value
          : this.deckLanguage,
      countryDeck: data.countryDeck.present
          ? data.countryDeck.value
          : this.countryDeck,
      dbPath: data.dbPath.present ? data.dbPath.value : this.dbPath,
      activeHour: data.activeHour.present
          ? data.activeHour.value
          : this.activeHour,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      importedDate: data.importedDate.present
          ? data.importedDate.value
          : this.importedDate,
      colorDeck: data.colorDeck.present ? data.colorDeck.value : this.colorDeck,
      language: data.language.present ? data.language.value : this.language,
      rolePlay: data.rolePlay.present ? data.rolePlay.value : this.rolePlay,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      explanationRolePlay: data.explanationRolePlay.present
          ? data.explanationRolePlay.value
          : this.explanationRolePlay,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImportedDeckData(')
          ..write('id: $id, ')
          ..write('deckName: $deckName, ')
          ..write('deckLanguage: $deckLanguage, ')
          ..write('countryDeck: $countryDeck, ')
          ..write('dbPath: $dbPath, ')
          ..write('activeHour: $activeHour, ')
          ..write('filePath: $filePath, ')
          ..write('importedDate: $importedDate, ')
          ..write('colorDeck: $colorDeck, ')
          ..write('language: $language, ')
          ..write('rolePlay: $rolePlay, ')
          ..write('difficulty: $difficulty, ')
          ..write('explanationRolePlay: $explanationRolePlay')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    deckName,
    deckLanguage,
    countryDeck,
    dbPath,
    activeHour,
    filePath,
    importedDate,
    colorDeck,
    language,
    rolePlay,
    difficulty,
    explanationRolePlay,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImportedDeckData &&
          other.id == this.id &&
          other.deckName == this.deckName &&
          other.deckLanguage == this.deckLanguage &&
          other.countryDeck == this.countryDeck &&
          other.dbPath == this.dbPath &&
          other.activeHour == this.activeHour &&
          other.filePath == this.filePath &&
          other.importedDate == this.importedDate &&
          other.colorDeck == this.colorDeck &&
          other.language == this.language &&
          other.rolePlay == this.rolePlay &&
          other.difficulty == this.difficulty &&
          other.explanationRolePlay == this.explanationRolePlay);
}

class ImportedDeckCompanion extends UpdateCompanion<ImportedDeckData> {
  final Value<int> id;
  final Value<String> deckName;
  final Value<String> deckLanguage;
  final Value<String> countryDeck;
  final Value<String> dbPath;
  final Value<int> activeHour;
  final Value<String> filePath;
  final Value<DateTime> importedDate;
  final Value<int> colorDeck;
  final Value<String> language;
  final Value<String> rolePlay;
  final Value<String> difficulty;
  final Value<String> explanationRolePlay;
  const ImportedDeckCompanion({
    this.id = const Value.absent(),
    this.deckName = const Value.absent(),
    this.deckLanguage = const Value.absent(),
    this.countryDeck = const Value.absent(),
    this.dbPath = const Value.absent(),
    this.activeHour = const Value.absent(),
    this.filePath = const Value.absent(),
    this.importedDate = const Value.absent(),
    this.colorDeck = const Value.absent(),
    this.language = const Value.absent(),
    this.rolePlay = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.explanationRolePlay = const Value.absent(),
  });
  ImportedDeckCompanion.insert({
    this.id = const Value.absent(),
    required String deckName,
    required String deckLanguage,
    required String countryDeck,
    required String dbPath,
    this.activeHour = const Value.absent(),
    required String filePath,
    this.importedDate = const Value.absent(),
    required int colorDeck,
    required String language,
    required String rolePlay,
    required String difficulty,
    required String explanationRolePlay,
  }) : deckName = Value(deckName),
       deckLanguage = Value(deckLanguage),
       countryDeck = Value(countryDeck),
       dbPath = Value(dbPath),
       filePath = Value(filePath),
       colorDeck = Value(colorDeck),
       language = Value(language),
       rolePlay = Value(rolePlay),
       difficulty = Value(difficulty),
       explanationRolePlay = Value(explanationRolePlay);
  static Insertable<ImportedDeckData> custom({
    Expression<int>? id,
    Expression<String>? deckName,
    Expression<String>? deckLanguage,
    Expression<String>? countryDeck,
    Expression<String>? dbPath,
    Expression<int>? activeHour,
    Expression<String>? filePath,
    Expression<DateTime>? importedDate,
    Expression<int>? colorDeck,
    Expression<String>? language,
    Expression<String>? rolePlay,
    Expression<String>? difficulty,
    Expression<String>? explanationRolePlay,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deckName != null) 'deck_name': deckName,
      if (deckLanguage != null) 'deck_language': deckLanguage,
      if (countryDeck != null) 'country_deck': countryDeck,
      if (dbPath != null) 'db_path': dbPath,
      if (activeHour != null) 'active_hour': activeHour,
      if (filePath != null) 'file_path': filePath,
      if (importedDate != null) 'imported_date': importedDate,
      if (colorDeck != null) 'color_deck': colorDeck,
      if (language != null) 'language': language,
      if (rolePlay != null) 'role_play': rolePlay,
      if (difficulty != null) 'difficulty': difficulty,
      if (explanationRolePlay != null)
        'explanation_role_play': explanationRolePlay,
    });
  }

  ImportedDeckCompanion copyWith({
    Value<int>? id,
    Value<String>? deckName,
    Value<String>? deckLanguage,
    Value<String>? countryDeck,
    Value<String>? dbPath,
    Value<int>? activeHour,
    Value<String>? filePath,
    Value<DateTime>? importedDate,
    Value<int>? colorDeck,
    Value<String>? language,
    Value<String>? rolePlay,
    Value<String>? difficulty,
    Value<String>? explanationRolePlay,
  }) {
    return ImportedDeckCompanion(
      id: id ?? this.id,
      deckName: deckName ?? this.deckName,
      deckLanguage: deckLanguage ?? this.deckLanguage,
      countryDeck: countryDeck ?? this.countryDeck,
      dbPath: dbPath ?? this.dbPath,
      activeHour: activeHour ?? this.activeHour,
      filePath: filePath ?? this.filePath,
      importedDate: importedDate ?? this.importedDate,
      colorDeck: colorDeck ?? this.colorDeck,
      language: language ?? this.language,
      rolePlay: rolePlay ?? this.rolePlay,
      difficulty: difficulty ?? this.difficulty,
      explanationRolePlay: explanationRolePlay ?? this.explanationRolePlay,
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
    if (countryDeck.present) {
      map['country_deck'] = Variable<String>(countryDeck.value);
    }
    if (dbPath.present) {
      map['db_path'] = Variable<String>(dbPath.value);
    }
    if (activeHour.present) {
      map['active_hour'] = Variable<int>(activeHour.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (importedDate.present) {
      map['imported_date'] = Variable<DateTime>(importedDate.value);
    }
    if (colorDeck.present) {
      map['color_deck'] = Variable<int>(colorDeck.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (rolePlay.present) {
      map['role_play'] = Variable<String>(rolePlay.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (explanationRolePlay.present) {
      map['explanation_role_play'] = Variable<String>(
        explanationRolePlay.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImportedDeckCompanion(')
          ..write('id: $id, ')
          ..write('deckName: $deckName, ')
          ..write('deckLanguage: $deckLanguage, ')
          ..write('countryDeck: $countryDeck, ')
          ..write('dbPath: $dbPath, ')
          ..write('activeHour: $activeHour, ')
          ..write('filePath: $filePath, ')
          ..write('importedDate: $importedDate, ')
          ..write('colorDeck: $colorDeck, ')
          ..write('language: $language, ')
          ..write('rolePlay: $rolePlay, ')
          ..write('difficulty: $difficulty, ')
          ..write('explanationRolePlay: $explanationRolePlay')
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
      required String countryDeck,
      required String dbPath,
      Value<int> activeHour,
      required String filePath,
      Value<DateTime> importedDate,
      required int colorDeck,
      required String language,
      required String rolePlay,
      required String difficulty,
      required String explanationRolePlay,
    });
typedef $$ImportedDeckTableUpdateCompanionBuilder =
    ImportedDeckCompanion Function({
      Value<int> id,
      Value<String> deckName,
      Value<String> deckLanguage,
      Value<String> countryDeck,
      Value<String> dbPath,
      Value<int> activeHour,
      Value<String> filePath,
      Value<DateTime> importedDate,
      Value<int> colorDeck,
      Value<String> language,
      Value<String> rolePlay,
      Value<String> difficulty,
      Value<String> explanationRolePlay,
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

  ColumnFilters<String> get countryDeck => $composableBuilder(
    column: $table.countryDeck,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dbPath => $composableBuilder(
    column: $table.dbPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activeHour => $composableBuilder(
    column: $table.activeHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
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

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rolePlay => $composableBuilder(
    column: $table.rolePlay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanationRolePlay => $composableBuilder(
    column: $table.explanationRolePlay,
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

  ColumnOrderings<String> get countryDeck => $composableBuilder(
    column: $table.countryDeck,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dbPath => $composableBuilder(
    column: $table.dbPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activeHour => $composableBuilder(
    column: $table.activeHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
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

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rolePlay => $composableBuilder(
    column: $table.rolePlay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanationRolePlay => $composableBuilder(
    column: $table.explanationRolePlay,
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

  GeneratedColumn<String> get countryDeck => $composableBuilder(
    column: $table.countryDeck,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dbPath =>
      $composableBuilder(column: $table.dbPath, builder: (column) => column);

  GeneratedColumn<int> get activeHour => $composableBuilder(
    column: $table.activeHour,
    builder: (column) => column,
  );

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<DateTime> get importedDate => $composableBuilder(
    column: $table.importedDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get colorDeck =>
      $composableBuilder(column: $table.colorDeck, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get rolePlay =>
      $composableBuilder(column: $table.rolePlay, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get explanationRolePlay => $composableBuilder(
    column: $table.explanationRolePlay,
    builder: (column) => column,
  );
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
                Value<String> countryDeck = const Value.absent(),
                Value<String> dbPath = const Value.absent(),
                Value<int> activeHour = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<DateTime> importedDate = const Value.absent(),
                Value<int> colorDeck = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> rolePlay = const Value.absent(),
                Value<String> difficulty = const Value.absent(),
                Value<String> explanationRolePlay = const Value.absent(),
              }) => ImportedDeckCompanion(
                id: id,
                deckName: deckName,
                deckLanguage: deckLanguage,
                countryDeck: countryDeck,
                dbPath: dbPath,
                activeHour: activeHour,
                filePath: filePath,
                importedDate: importedDate,
                colorDeck: colorDeck,
                language: language,
                rolePlay: rolePlay,
                difficulty: difficulty,
                explanationRolePlay: explanationRolePlay,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String deckName,
                required String deckLanguage,
                required String countryDeck,
                required String dbPath,
                Value<int> activeHour = const Value.absent(),
                required String filePath,
                Value<DateTime> importedDate = const Value.absent(),
                required int colorDeck,
                required String language,
                required String rolePlay,
                required String difficulty,
                required String explanationRolePlay,
              }) => ImportedDeckCompanion.insert(
                id: id,
                deckName: deckName,
                deckLanguage: deckLanguage,
                countryDeck: countryDeck,
                dbPath: dbPath,
                activeHour: activeHour,
                filePath: filePath,
                importedDate: importedDate,
                colorDeck: colorDeck,
                language: language,
                rolePlay: rolePlay,
                difficulty: difficulty,
                explanationRolePlay: explanationRolePlay,
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
