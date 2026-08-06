// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generated_database.dart';

// ignore_for_file: type=lint
mixin _$GeneratedDeckDaoMixin on DatabaseAccessor<GeneratedDeckDatabase> {
  $GeneratedCardsTableTable get generatedCardsTable =>
      attachedDatabase.generatedCardsTable;
  $HistoryTableTable get historyTable => attachedDatabase.historyTable;
  GeneratedDeckDaoManager get managers => GeneratedDeckDaoManager(this);
}

class GeneratedDeckDaoManager {
  final _$GeneratedDeckDaoMixin _db;
  GeneratedDeckDaoManager(this._db);
  $$GeneratedCardsTableTableTableManager get generatedCardsTable =>
      $$GeneratedCardsTableTableTableManager(
        _db.attachedDatabase,
        _db.generatedCardsTable,
      );
  $$HistoryTableTableTableManager get historyTable =>
      $$HistoryTableTableTableManager(_db.attachedDatabase, _db.historyTable);
}

class $GeneratedCardsTableTable extends GeneratedCardsTable
    with TableInfo<$GeneratedCardsTableTable, GeneratedCardsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GeneratedCardsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _defaultLanguageMeta = const VerificationMeta(
    'defaultLanguage',
  );
  @override
  late final GeneratedColumn<String> defaultLanguage = GeneratedColumn<String>(
    'default_language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translationMeta = const VerificationMeta(
    'translation',
  );
  @override
  late final GeneratedColumn<String> translation = GeneratedColumn<String>(
    'translation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _additionalContextMeta = const VerificationMeta(
    'additionalContext',
  );
  @override
  late final GeneratedColumn<String> additionalContext =
      GeneratedColumn<String>(
        'additional_context',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _pronunciationMeta = const VerificationMeta(
    'pronunciation',
  );
  @override
  late final GeneratedColumn<String> pronunciation = GeneratedColumn<String>(
    'pronunciation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    defaultLanguage,
    translation,
    additionalContext,
    pronunciation,
    score,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<GeneratedCardsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('default_language')) {
      context.handle(
        _defaultLanguageMeta,
        defaultLanguage.isAcceptableOrUnknown(
          data['default_language']!,
          _defaultLanguageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_defaultLanguageMeta);
    }
    if (data.containsKey('translation')) {
      context.handle(
        _translationMeta,
        translation.isAcceptableOrUnknown(
          data['translation']!,
          _translationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translationMeta);
    }
    if (data.containsKey('additional_context')) {
      context.handle(
        _additionalContextMeta,
        additionalContext.isAcceptableOrUnknown(
          data['additional_context']!,
          _additionalContextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_additionalContextMeta);
    }
    if (data.containsKey('pronunciation')) {
      context.handle(
        _pronunciationMeta,
        pronunciation.isAcceptableOrUnknown(
          data['pronunciation']!,
          _pronunciationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pronunciationMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GeneratedCardsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GeneratedCardsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      defaultLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_language'],
      )!,
      translation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation'],
      )!,
      additionalContext: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}additional_context'],
      )!,
      pronunciation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pronunciation'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
    );
  }

  @override
  $GeneratedCardsTableTable createAlias(String alias) {
    return $GeneratedCardsTableTable(attachedDatabase, alias);
  }
}

class GeneratedCardsTableData extends DataClass
    implements Insertable<GeneratedCardsTableData> {
  final int id;
  final String defaultLanguage;
  final String translation;
  final String additionalContext;
  final String pronunciation;
  final int score;
  const GeneratedCardsTableData({
    required this.id,
    required this.defaultLanguage,
    required this.translation,
    required this.additionalContext,
    required this.pronunciation,
    required this.score,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['default_language'] = Variable<String>(defaultLanguage);
    map['translation'] = Variable<String>(translation);
    map['additional_context'] = Variable<String>(additionalContext);
    map['pronunciation'] = Variable<String>(pronunciation);
    map['score'] = Variable<int>(score);
    return map;
  }

  GeneratedCardsTableCompanion toCompanion(bool nullToAbsent) {
    return GeneratedCardsTableCompanion(
      id: Value(id),
      defaultLanguage: Value(defaultLanguage),
      translation: Value(translation),
      additionalContext: Value(additionalContext),
      pronunciation: Value(pronunciation),
      score: Value(score),
    );
  }

  factory GeneratedCardsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GeneratedCardsTableData(
      id: serializer.fromJson<int>(json['id']),
      defaultLanguage: serializer.fromJson<String>(json['defaultLanguage']),
      translation: serializer.fromJson<String>(json['translation']),
      additionalContext: serializer.fromJson<String>(json['additionalContext']),
      pronunciation: serializer.fromJson<String>(json['pronunciation']),
      score: serializer.fromJson<int>(json['score']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'defaultLanguage': serializer.toJson<String>(defaultLanguage),
      'translation': serializer.toJson<String>(translation),
      'additionalContext': serializer.toJson<String>(additionalContext),
      'pronunciation': serializer.toJson<String>(pronunciation),
      'score': serializer.toJson<int>(score),
    };
  }

  GeneratedCardsTableData copyWith({
    int? id,
    String? defaultLanguage,
    String? translation,
    String? additionalContext,
    String? pronunciation,
    int? score,
  }) => GeneratedCardsTableData(
    id: id ?? this.id,
    defaultLanguage: defaultLanguage ?? this.defaultLanguage,
    translation: translation ?? this.translation,
    additionalContext: additionalContext ?? this.additionalContext,
    pronunciation: pronunciation ?? this.pronunciation,
    score: score ?? this.score,
  );
  GeneratedCardsTableData copyWithCompanion(GeneratedCardsTableCompanion data) {
    return GeneratedCardsTableData(
      id: data.id.present ? data.id.value : this.id,
      defaultLanguage: data.defaultLanguage.present
          ? data.defaultLanguage.value
          : this.defaultLanguage,
      translation: data.translation.present
          ? data.translation.value
          : this.translation,
      additionalContext: data.additionalContext.present
          ? data.additionalContext.value
          : this.additionalContext,
      pronunciation: data.pronunciation.present
          ? data.pronunciation.value
          : this.pronunciation,
      score: data.score.present ? data.score.value : this.score,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GeneratedCardsTableData(')
          ..write('id: $id, ')
          ..write('defaultLanguage: $defaultLanguage, ')
          ..write('translation: $translation, ')
          ..write('additionalContext: $additionalContext, ')
          ..write('pronunciation: $pronunciation, ')
          ..write('score: $score')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    defaultLanguage,
    translation,
    additionalContext,
    pronunciation,
    score,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GeneratedCardsTableData &&
          other.id == this.id &&
          other.defaultLanguage == this.defaultLanguage &&
          other.translation == this.translation &&
          other.additionalContext == this.additionalContext &&
          other.pronunciation == this.pronunciation &&
          other.score == this.score);
}

class GeneratedCardsTableCompanion
    extends UpdateCompanion<GeneratedCardsTableData> {
  final Value<int> id;
  final Value<String> defaultLanguage;
  final Value<String> translation;
  final Value<String> additionalContext;
  final Value<String> pronunciation;
  final Value<int> score;
  const GeneratedCardsTableCompanion({
    this.id = const Value.absent(),
    this.defaultLanguage = const Value.absent(),
    this.translation = const Value.absent(),
    this.additionalContext = const Value.absent(),
    this.pronunciation = const Value.absent(),
    this.score = const Value.absent(),
  });
  GeneratedCardsTableCompanion.insert({
    this.id = const Value.absent(),
    required String defaultLanguage,
    required String translation,
    required String additionalContext,
    required String pronunciation,
    this.score = const Value.absent(),
  }) : defaultLanguage = Value(defaultLanguage),
       translation = Value(translation),
       additionalContext = Value(additionalContext),
       pronunciation = Value(pronunciation);
  static Insertable<GeneratedCardsTableData> custom({
    Expression<int>? id,
    Expression<String>? defaultLanguage,
    Expression<String>? translation,
    Expression<String>? additionalContext,
    Expression<String>? pronunciation,
    Expression<int>? score,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (defaultLanguage != null) 'default_language': defaultLanguage,
      if (translation != null) 'translation': translation,
      if (additionalContext != null) 'additional_context': additionalContext,
      if (pronunciation != null) 'pronunciation': pronunciation,
      if (score != null) 'score': score,
    });
  }

  GeneratedCardsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? defaultLanguage,
    Value<String>? translation,
    Value<String>? additionalContext,
    Value<String>? pronunciation,
    Value<int>? score,
  }) {
    return GeneratedCardsTableCompanion(
      id: id ?? this.id,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      translation: translation ?? this.translation,
      additionalContext: additionalContext ?? this.additionalContext,
      pronunciation: pronunciation ?? this.pronunciation,
      score: score ?? this.score,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (defaultLanguage.present) {
      map['default_language'] = Variable<String>(defaultLanguage.value);
    }
    if (translation.present) {
      map['translation'] = Variable<String>(translation.value);
    }
    if (additionalContext.present) {
      map['additional_context'] = Variable<String>(additionalContext.value);
    }
    if (pronunciation.present) {
      map['pronunciation'] = Variable<String>(pronunciation.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GeneratedCardsTableCompanion(')
          ..write('id: $id, ')
          ..write('defaultLanguage: $defaultLanguage, ')
          ..write('translation: $translation, ')
          ..write('additionalContext: $additionalContext, ')
          ..write('pronunciation: $pronunciation, ')
          ..write('score: $score')
          ..write(')'))
        .toString();
  }
}

class $HistoryTableTable extends HistoryTable
    with TableInfo<$HistoryTableTable, HistoryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idHMeta = const VerificationMeta('idH');
  @override
  late final GeneratedColumn<int> idH = GeneratedColumn<int>(
    'id_h',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idCMeta = const VerificationMeta('idC');
  @override
  late final GeneratedColumn<int> idC = GeneratedColumn<int>(
    'id_c',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answerMeta = const VerificationMeta('answer');
  @override
  late final GeneratedColumn<int> answer = GeneratedColumn<int>(
    'answer',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalTimeMeta = const VerificationMeta(
    'totalTime',
  );
  @override
  late final GeneratedColumn<int> totalTime = GeneratedColumn<int>(
    'total_time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _timeCodeMeta = const VerificationMeta(
    'timeCode',
  );
  @override
  late final GeneratedColumn<int> timeCode = GeneratedColumn<int>(
    'time_code',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [idH, idC, answer, totalTime, timeCode];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'history';
  @override
  VerificationContext validateIntegrity(
    Insertable<HistoryTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_h')) {
      context.handle(
        _idHMeta,
        idH.isAcceptableOrUnknown(data['id_h']!, _idHMeta),
      );
    }
    if (data.containsKey('id_c')) {
      context.handle(
        _idCMeta,
        idC.isAcceptableOrUnknown(data['id_c']!, _idCMeta),
      );
    } else if (isInserting) {
      context.missing(_idCMeta);
    }
    if (data.containsKey('answer')) {
      context.handle(
        _answerMeta,
        answer.isAcceptableOrUnknown(data['answer']!, _answerMeta),
      );
    } else if (isInserting) {
      context.missing(_answerMeta);
    }
    if (data.containsKey('total_time')) {
      context.handle(
        _totalTimeMeta,
        totalTime.isAcceptableOrUnknown(data['total_time']!, _totalTimeMeta),
      );
    }
    if (data.containsKey('time_code')) {
      context.handle(
        _timeCodeMeta,
        timeCode.isAcceptableOrUnknown(data['time_code']!, _timeCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeCodeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idH};
  @override
  HistoryTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistoryTableData(
      idH: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_h'],
      )!,
      idC: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_c'],
      )!,
      answer: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}answer'],
      )!,
      totalTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_time'],
      )!,
      timeCode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_code'],
      )!,
    );
  }

  @override
  $HistoryTableTable createAlias(String alias) {
    return $HistoryTableTable(attachedDatabase, alias);
  }
}

class HistoryTableData extends DataClass
    implements Insertable<HistoryTableData> {
  final int idH;
  final int idC;
  final int answer;
  final int totalTime;
  final int timeCode;
  const HistoryTableData({
    required this.idH,
    required this.idC,
    required this.answer,
    required this.totalTime,
    required this.timeCode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_h'] = Variable<int>(idH);
    map['id_c'] = Variable<int>(idC);
    map['answer'] = Variable<int>(answer);
    map['total_time'] = Variable<int>(totalTime);
    map['time_code'] = Variable<int>(timeCode);
    return map;
  }

  HistoryTableCompanion toCompanion(bool nullToAbsent) {
    return HistoryTableCompanion(
      idH: Value(idH),
      idC: Value(idC),
      answer: Value(answer),
      totalTime: Value(totalTime),
      timeCode: Value(timeCode),
    );
  }

  factory HistoryTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistoryTableData(
      idH: serializer.fromJson<int>(json['idH']),
      idC: serializer.fromJson<int>(json['idC']),
      answer: serializer.fromJson<int>(json['answer']),
      totalTime: serializer.fromJson<int>(json['totalTime']),
      timeCode: serializer.fromJson<int>(json['timeCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idH': serializer.toJson<int>(idH),
      'idC': serializer.toJson<int>(idC),
      'answer': serializer.toJson<int>(answer),
      'totalTime': serializer.toJson<int>(totalTime),
      'timeCode': serializer.toJson<int>(timeCode),
    };
  }

  HistoryTableData copyWith({
    int? idH,
    int? idC,
    int? answer,
    int? totalTime,
    int? timeCode,
  }) => HistoryTableData(
    idH: idH ?? this.idH,
    idC: idC ?? this.idC,
    answer: answer ?? this.answer,
    totalTime: totalTime ?? this.totalTime,
    timeCode: timeCode ?? this.timeCode,
  );
  HistoryTableData copyWithCompanion(HistoryTableCompanion data) {
    return HistoryTableData(
      idH: data.idH.present ? data.idH.value : this.idH,
      idC: data.idC.present ? data.idC.value : this.idC,
      answer: data.answer.present ? data.answer.value : this.answer,
      totalTime: data.totalTime.present ? data.totalTime.value : this.totalTime,
      timeCode: data.timeCode.present ? data.timeCode.value : this.timeCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistoryTableData(')
          ..write('idH: $idH, ')
          ..write('idC: $idC, ')
          ..write('answer: $answer, ')
          ..write('totalTime: $totalTime, ')
          ..write('timeCode: $timeCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idH, idC, answer, totalTime, timeCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistoryTableData &&
          other.idH == this.idH &&
          other.idC == this.idC &&
          other.answer == this.answer &&
          other.totalTime == this.totalTime &&
          other.timeCode == this.timeCode);
}

class HistoryTableCompanion extends UpdateCompanion<HistoryTableData> {
  final Value<int> idH;
  final Value<int> idC;
  final Value<int> answer;
  final Value<int> totalTime;
  final Value<int> timeCode;
  const HistoryTableCompanion({
    this.idH = const Value.absent(),
    this.idC = const Value.absent(),
    this.answer = const Value.absent(),
    this.totalTime = const Value.absent(),
    this.timeCode = const Value.absent(),
  });
  HistoryTableCompanion.insert({
    this.idH = const Value.absent(),
    required int idC,
    required int answer,
    this.totalTime = const Value.absent(),
    required int timeCode,
  }) : idC = Value(idC),
       answer = Value(answer),
       timeCode = Value(timeCode);
  static Insertable<HistoryTableData> custom({
    Expression<int>? idH,
    Expression<int>? idC,
    Expression<int>? answer,
    Expression<int>? totalTime,
    Expression<int>? timeCode,
  }) {
    return RawValuesInsertable({
      if (idH != null) 'id_h': idH,
      if (idC != null) 'id_c': idC,
      if (answer != null) 'answer': answer,
      if (totalTime != null) 'total_time': totalTime,
      if (timeCode != null) 'time_code': timeCode,
    });
  }

  HistoryTableCompanion copyWith({
    Value<int>? idH,
    Value<int>? idC,
    Value<int>? answer,
    Value<int>? totalTime,
    Value<int>? timeCode,
  }) {
    return HistoryTableCompanion(
      idH: idH ?? this.idH,
      idC: idC ?? this.idC,
      answer: answer ?? this.answer,
      totalTime: totalTime ?? this.totalTime,
      timeCode: timeCode ?? this.timeCode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idH.present) {
      map['id_h'] = Variable<int>(idH.value);
    }
    if (idC.present) {
      map['id_c'] = Variable<int>(idC.value);
    }
    if (answer.present) {
      map['answer'] = Variable<int>(answer.value);
    }
    if (totalTime.present) {
      map['total_time'] = Variable<int>(totalTime.value);
    }
    if (timeCode.present) {
      map['time_code'] = Variable<int>(timeCode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistoryTableCompanion(')
          ..write('idH: $idH, ')
          ..write('idC: $idC, ')
          ..write('answer: $answer, ')
          ..write('totalTime: $totalTime, ')
          ..write('timeCode: $timeCode')
          ..write(')'))
        .toString();
  }
}

abstract class _$GeneratedDeckDatabase extends GeneratedDatabase {
  _$GeneratedDeckDatabase(QueryExecutor e) : super(e);
  $GeneratedDeckDatabaseManager get managers =>
      $GeneratedDeckDatabaseManager(this);
  late final $GeneratedCardsTableTable generatedCardsTable =
      $GeneratedCardsTableTable(this);
  late final $HistoryTableTable historyTable = $HistoryTableTable(this);
  late final GeneratedDeckDao generatedDeckDao = GeneratedDeckDao(
    this as GeneratedDeckDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    generatedCardsTable,
    historyTable,
  ];
}

typedef $$GeneratedCardsTableTableCreateCompanionBuilder =
    GeneratedCardsTableCompanion Function({
      Value<int> id,
      required String defaultLanguage,
      required String translation,
      required String additionalContext,
      required String pronunciation,
      Value<int> score,
    });
typedef $$GeneratedCardsTableTableUpdateCompanionBuilder =
    GeneratedCardsTableCompanion Function({
      Value<int> id,
      Value<String> defaultLanguage,
      Value<String> translation,
      Value<String> additionalContext,
      Value<String> pronunciation,
      Value<int> score,
    });

class $$GeneratedCardsTableTableFilterComposer
    extends Composer<_$GeneratedDeckDatabase, $GeneratedCardsTableTable> {
  $$GeneratedCardsTableTableFilterComposer({
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

  ColumnFilters<String> get defaultLanguage => $composableBuilder(
    column: $table.defaultLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get additionalContext => $composableBuilder(
    column: $table.additionalContext,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pronunciation => $composableBuilder(
    column: $table.pronunciation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GeneratedCardsTableTableOrderingComposer
    extends Composer<_$GeneratedDeckDatabase, $GeneratedCardsTableTable> {
  $$GeneratedCardsTableTableOrderingComposer({
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

  ColumnOrderings<String> get defaultLanguage => $composableBuilder(
    column: $table.defaultLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get additionalContext => $composableBuilder(
    column: $table.additionalContext,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pronunciation => $composableBuilder(
    column: $table.pronunciation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GeneratedCardsTableTableAnnotationComposer
    extends Composer<_$GeneratedDeckDatabase, $GeneratedCardsTableTable> {
  $$GeneratedCardsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get defaultLanguage => $composableBuilder(
    column: $table.defaultLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get additionalContext => $composableBuilder(
    column: $table.additionalContext,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pronunciation => $composableBuilder(
    column: $table.pronunciation,
    builder: (column) => column,
  );

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);
}

class $$GeneratedCardsTableTableTableManager
    extends
        RootTableManager<
          _$GeneratedDeckDatabase,
          $GeneratedCardsTableTable,
          GeneratedCardsTableData,
          $$GeneratedCardsTableTableFilterComposer,
          $$GeneratedCardsTableTableOrderingComposer,
          $$GeneratedCardsTableTableAnnotationComposer,
          $$GeneratedCardsTableTableCreateCompanionBuilder,
          $$GeneratedCardsTableTableUpdateCompanionBuilder,
          (
            GeneratedCardsTableData,
            BaseReferences<
              _$GeneratedDeckDatabase,
              $GeneratedCardsTableTable,
              GeneratedCardsTableData
            >,
          ),
          GeneratedCardsTableData,
          PrefetchHooks Function()
        > {
  $$GeneratedCardsTableTableTableManager(
    _$GeneratedDeckDatabase db,
    $GeneratedCardsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GeneratedCardsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GeneratedCardsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$GeneratedCardsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> defaultLanguage = const Value.absent(),
                Value<String> translation = const Value.absent(),
                Value<String> additionalContext = const Value.absent(),
                Value<String> pronunciation = const Value.absent(),
                Value<int> score = const Value.absent(),
              }) => GeneratedCardsTableCompanion(
                id: id,
                defaultLanguage: defaultLanguage,
                translation: translation,
                additionalContext: additionalContext,
                pronunciation: pronunciation,
                score: score,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String defaultLanguage,
                required String translation,
                required String additionalContext,
                required String pronunciation,
                Value<int> score = const Value.absent(),
              }) => GeneratedCardsTableCompanion.insert(
                id: id,
                defaultLanguage: defaultLanguage,
                translation: translation,
                additionalContext: additionalContext,
                pronunciation: pronunciation,
                score: score,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GeneratedCardsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$GeneratedDeckDatabase,
      $GeneratedCardsTableTable,
      GeneratedCardsTableData,
      $$GeneratedCardsTableTableFilterComposer,
      $$GeneratedCardsTableTableOrderingComposer,
      $$GeneratedCardsTableTableAnnotationComposer,
      $$GeneratedCardsTableTableCreateCompanionBuilder,
      $$GeneratedCardsTableTableUpdateCompanionBuilder,
      (
        GeneratedCardsTableData,
        BaseReferences<
          _$GeneratedDeckDatabase,
          $GeneratedCardsTableTable,
          GeneratedCardsTableData
        >,
      ),
      GeneratedCardsTableData,
      PrefetchHooks Function()
    >;
typedef $$HistoryTableTableCreateCompanionBuilder =
    HistoryTableCompanion Function({
      Value<int> idH,
      required int idC,
      required int answer,
      Value<int> totalTime,
      required int timeCode,
    });
typedef $$HistoryTableTableUpdateCompanionBuilder =
    HistoryTableCompanion Function({
      Value<int> idH,
      Value<int> idC,
      Value<int> answer,
      Value<int> totalTime,
      Value<int> timeCode,
    });

class $$HistoryTableTableFilterComposer
    extends Composer<_$GeneratedDeckDatabase, $HistoryTableTable> {
  $$HistoryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idH => $composableBuilder(
    column: $table.idH,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get idC => $composableBuilder(
    column: $table.idC,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get answer => $composableBuilder(
    column: $table.answer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalTime => $composableBuilder(
    column: $table.totalTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeCode => $composableBuilder(
    column: $table.timeCode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HistoryTableTableOrderingComposer
    extends Composer<_$GeneratedDeckDatabase, $HistoryTableTable> {
  $$HistoryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idH => $composableBuilder(
    column: $table.idH,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get idC => $composableBuilder(
    column: $table.idC,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get answer => $composableBuilder(
    column: $table.answer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalTime => $composableBuilder(
    column: $table.totalTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeCode => $composableBuilder(
    column: $table.timeCode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HistoryTableTableAnnotationComposer
    extends Composer<_$GeneratedDeckDatabase, $HistoryTableTable> {
  $$HistoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idH =>
      $composableBuilder(column: $table.idH, builder: (column) => column);

  GeneratedColumn<int> get idC =>
      $composableBuilder(column: $table.idC, builder: (column) => column);

  GeneratedColumn<int> get answer =>
      $composableBuilder(column: $table.answer, builder: (column) => column);

  GeneratedColumn<int> get totalTime =>
      $composableBuilder(column: $table.totalTime, builder: (column) => column);

  GeneratedColumn<int> get timeCode =>
      $composableBuilder(column: $table.timeCode, builder: (column) => column);
}

class $$HistoryTableTableTableManager
    extends
        RootTableManager<
          _$GeneratedDeckDatabase,
          $HistoryTableTable,
          HistoryTableData,
          $$HistoryTableTableFilterComposer,
          $$HistoryTableTableOrderingComposer,
          $$HistoryTableTableAnnotationComposer,
          $$HistoryTableTableCreateCompanionBuilder,
          $$HistoryTableTableUpdateCompanionBuilder,
          (
            HistoryTableData,
            BaseReferences<
              _$GeneratedDeckDatabase,
              $HistoryTableTable,
              HistoryTableData
            >,
          ),
          HistoryTableData,
          PrefetchHooks Function()
        > {
  $$HistoryTableTableTableManager(
    _$GeneratedDeckDatabase db,
    $HistoryTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HistoryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HistoryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HistoryTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idH = const Value.absent(),
                Value<int> idC = const Value.absent(),
                Value<int> answer = const Value.absent(),
                Value<int> totalTime = const Value.absent(),
                Value<int> timeCode = const Value.absent(),
              }) => HistoryTableCompanion(
                idH: idH,
                idC: idC,
                answer: answer,
                totalTime: totalTime,
                timeCode: timeCode,
              ),
          createCompanionCallback:
              ({
                Value<int> idH = const Value.absent(),
                required int idC,
                required int answer,
                Value<int> totalTime = const Value.absent(),
                required int timeCode,
              }) => HistoryTableCompanion.insert(
                idH: idH,
                idC: idC,
                answer: answer,
                totalTime: totalTime,
                timeCode: timeCode,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HistoryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$GeneratedDeckDatabase,
      $HistoryTableTable,
      HistoryTableData,
      $$HistoryTableTableFilterComposer,
      $$HistoryTableTableOrderingComposer,
      $$HistoryTableTableAnnotationComposer,
      $$HistoryTableTableCreateCompanionBuilder,
      $$HistoryTableTableUpdateCompanionBuilder,
      (
        HistoryTableData,
        BaseReferences<
          _$GeneratedDeckDatabase,
          $HistoryTableTable,
          HistoryTableData
        >,
      ),
      HistoryTableData,
      PrefetchHooks Function()
    >;

class $GeneratedDeckDatabaseManager {
  final _$GeneratedDeckDatabase _db;
  $GeneratedDeckDatabaseManager(this._db);
  $$GeneratedCardsTableTableTableManager get generatedCardsTable =>
      $$GeneratedCardsTableTableTableManager(_db, _db.generatedCardsTable);
  $$HistoryTableTableTableManager get historyTable =>
      $$HistoryTableTableTableManager(_db, _db.historyTable);
}
