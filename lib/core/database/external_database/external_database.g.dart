// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external_database.dart';

// ignore_for_file: type=lint
class $CardsTableTable extends CardsTable
    with TableInfo<$CardsTableTable, CardsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _queueMeta = const VerificationMeta('queue');
  @override
  late final GeneratedColumn<int> queue = GeneratedColumn<int>(
    'queue',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nidMeta = const VerificationMeta('nid');
  @override
  late final GeneratedColumn<int> nid = GeneratedColumn<int>(
    'nid',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _factorMeta = const VerificationMeta('factor');
  @override
  late final GeneratedColumn<int> factor = GeneratedColumn<int>(
    'factor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [queue, id, nid, reps, factor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('queue')) {
      context.handle(
        _queueMeta,
        queue.isAcceptableOrUnknown(data['queue']!, _queueMeta),
      );
    } else if (isInserting) {
      context.missing(_queueMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nid')) {
      context.handle(
        _nidMeta,
        nid.isAcceptableOrUnknown(data['nid']!, _nidMeta),
      );
    } else if (isInserting) {
      context.missing(_nidMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('factor')) {
      context.handle(
        _factorMeta,
        factor.isAcceptableOrUnknown(data['factor']!, _factorMeta),
      );
    } else if (isInserting) {
      context.missing(_factorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardsTableData(
      queue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}queue'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nid'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
      factor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}factor'],
      )!,
    );
  }

  @override
  $CardsTableTable createAlias(String alias) {
    return $CardsTableTable(attachedDatabase, alias);
  }
}

class CardsTableData extends DataClass implements Insertable<CardsTableData> {
  final int queue;
  final int id;
  final int nid;
  final int reps;
  final int factor;
  const CardsTableData({
    required this.queue,
    required this.id,
    required this.nid,
    required this.reps,
    required this.factor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['queue'] = Variable<int>(queue);
    map['id'] = Variable<int>(id);
    map['nid'] = Variable<int>(nid);
    map['reps'] = Variable<int>(reps);
    map['factor'] = Variable<int>(factor);
    return map;
  }

  CardsTableCompanion toCompanion(bool nullToAbsent) {
    return CardsTableCompanion(
      queue: Value(queue),
      id: Value(id),
      nid: Value(nid),
      reps: Value(reps),
      factor: Value(factor),
    );
  }

  factory CardsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardsTableData(
      queue: serializer.fromJson<int>(json['queue']),
      id: serializer.fromJson<int>(json['id']),
      nid: serializer.fromJson<int>(json['nid']),
      reps: serializer.fromJson<int>(json['reps']),
      factor: serializer.fromJson<int>(json['factor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'queue': serializer.toJson<int>(queue),
      'id': serializer.toJson<int>(id),
      'nid': serializer.toJson<int>(nid),
      'reps': serializer.toJson<int>(reps),
      'factor': serializer.toJson<int>(factor),
    };
  }

  CardsTableData copyWith({
    int? queue,
    int? id,
    int? nid,
    int? reps,
    int? factor,
  }) => CardsTableData(
    queue: queue ?? this.queue,
    id: id ?? this.id,
    nid: nid ?? this.nid,
    reps: reps ?? this.reps,
    factor: factor ?? this.factor,
  );
  CardsTableData copyWithCompanion(CardsTableCompanion data) {
    return CardsTableData(
      queue: data.queue.present ? data.queue.value : this.queue,
      id: data.id.present ? data.id.value : this.id,
      nid: data.nid.present ? data.nid.value : this.nid,
      reps: data.reps.present ? data.reps.value : this.reps,
      factor: data.factor.present ? data.factor.value : this.factor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardsTableData(')
          ..write('queue: $queue, ')
          ..write('id: $id, ')
          ..write('nid: $nid, ')
          ..write('reps: $reps, ')
          ..write('factor: $factor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(queue, id, nid, reps, factor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardsTableData &&
          other.queue == this.queue &&
          other.id == this.id &&
          other.nid == this.nid &&
          other.reps == this.reps &&
          other.factor == this.factor);
}

class CardsTableCompanion extends UpdateCompanion<CardsTableData> {
  final Value<int> queue;
  final Value<int> id;
  final Value<int> nid;
  final Value<int> reps;
  final Value<int> factor;
  const CardsTableCompanion({
    this.queue = const Value.absent(),
    this.id = const Value.absent(),
    this.nid = const Value.absent(),
    this.reps = const Value.absent(),
    this.factor = const Value.absent(),
  });
  CardsTableCompanion.insert({
    required int queue,
    this.id = const Value.absent(),
    required int nid,
    required int reps,
    required int factor,
  }) : queue = Value(queue),
       nid = Value(nid),
       reps = Value(reps),
       factor = Value(factor);
  static Insertable<CardsTableData> custom({
    Expression<int>? queue,
    Expression<int>? id,
    Expression<int>? nid,
    Expression<int>? reps,
    Expression<int>? factor,
  }) {
    return RawValuesInsertable({
      if (queue != null) 'queue': queue,
      if (id != null) 'id': id,
      if (nid != null) 'nid': nid,
      if (reps != null) 'reps': reps,
      if (factor != null) 'factor': factor,
    });
  }

  CardsTableCompanion copyWith({
    Value<int>? queue,
    Value<int>? id,
    Value<int>? nid,
    Value<int>? reps,
    Value<int>? factor,
  }) {
    return CardsTableCompanion(
      queue: queue ?? this.queue,
      id: id ?? this.id,
      nid: nid ?? this.nid,
      reps: reps ?? this.reps,
      factor: factor ?? this.factor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (queue.present) {
      map['queue'] = Variable<int>(queue.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nid.present) {
      map['nid'] = Variable<int>(nid.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (factor.present) {
      map['factor'] = Variable<int>(factor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardsTableCompanion(')
          ..write('queue: $queue, ')
          ..write('id: $id, ')
          ..write('nid: $nid, ')
          ..write('reps: $reps, ')
          ..write('factor: $factor')
          ..write(')'))
        .toString();
  }
}

class $NotesTableTable extends NotesTable
    with TableInfo<$NotesTableTable, NotesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fldsMeta = const VerificationMeta('flds');
  @override
  late final GeneratedColumn<String> flds = GeneratedColumn<String>(
    'flds',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _midMeta = const VerificationMeta('mid');
  @override
  late final GeneratedColumn<int> mid = GeneratedColumn<int>(
    'mid',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, flds, mid, tags];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('flds')) {
      context.handle(
        _fldsMeta,
        flds.isAcceptableOrUnknown(data['flds']!, _fldsMeta),
      );
    } else if (isInserting) {
      context.missing(_fldsMeta);
    }
    if (data.containsKey('mid')) {
      context.handle(
        _midMeta,
        mid.isAcceptableOrUnknown(data['mid']!, _midMeta),
      );
    } else if (isInserting) {
      context.missing(_midMeta);
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    } else if (isInserting) {
      context.missing(_tagsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  NotesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      flds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flds'],
      )!,
      mid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mid'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
    );
  }

  @override
  $NotesTableTable createAlias(String alias) {
    return $NotesTableTable(attachedDatabase, alias);
  }
}

class NotesTableData extends DataClass implements Insertable<NotesTableData> {
  final int id;
  final String flds;
  final int mid;
  final String tags;
  const NotesTableData({
    required this.id,
    required this.flds,
    required this.mid,
    required this.tags,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['flds'] = Variable<String>(flds);
    map['mid'] = Variable<int>(mid);
    map['tags'] = Variable<String>(tags);
    return map;
  }

  NotesTableCompanion toCompanion(bool nullToAbsent) {
    return NotesTableCompanion(
      id: Value(id),
      flds: Value(flds),
      mid: Value(mid),
      tags: Value(tags),
    );
  }

  factory NotesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotesTableData(
      id: serializer.fromJson<int>(json['id']),
      flds: serializer.fromJson<String>(json['flds']),
      mid: serializer.fromJson<int>(json['mid']),
      tags: serializer.fromJson<String>(json['tags']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'flds': serializer.toJson<String>(flds),
      'mid': serializer.toJson<int>(mid),
      'tags': serializer.toJson<String>(tags),
    };
  }

  NotesTableData copyWith({int? id, String? flds, int? mid, String? tags}) =>
      NotesTableData(
        id: id ?? this.id,
        flds: flds ?? this.flds,
        mid: mid ?? this.mid,
        tags: tags ?? this.tags,
      );
  NotesTableData copyWithCompanion(NotesTableCompanion data) {
    return NotesTableData(
      id: data.id.present ? data.id.value : this.id,
      flds: data.flds.present ? data.flds.value : this.flds,
      mid: data.mid.present ? data.mid.value : this.mid,
      tags: data.tags.present ? data.tags.value : this.tags,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotesTableData(')
          ..write('id: $id, ')
          ..write('flds: $flds, ')
          ..write('mid: $mid, ')
          ..write('tags: $tags')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, flds, mid, tags);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotesTableData &&
          other.id == this.id &&
          other.flds == this.flds &&
          other.mid == this.mid &&
          other.tags == this.tags);
}

class NotesTableCompanion extends UpdateCompanion<NotesTableData> {
  final Value<int> id;
  final Value<String> flds;
  final Value<int> mid;
  final Value<String> tags;
  final Value<int> rowid;
  const NotesTableCompanion({
    this.id = const Value.absent(),
    this.flds = const Value.absent(),
    this.mid = const Value.absent(),
    this.tags = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesTableCompanion.insert({
    required int id,
    required String flds,
    required int mid,
    required String tags,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       flds = Value(flds),
       mid = Value(mid),
       tags = Value(tags);
  static Insertable<NotesTableData> custom({
    Expression<int>? id,
    Expression<String>? flds,
    Expression<int>? mid,
    Expression<String>? tags,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (flds != null) 'flds': flds,
      if (mid != null) 'mid': mid,
      if (tags != null) 'tags': tags,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? flds,
    Value<int>? mid,
    Value<String>? tags,
    Value<int>? rowid,
  }) {
    return NotesTableCompanion(
      id: id ?? this.id,
      flds: flds ?? this.flds,
      mid: mid ?? this.mid,
      tags: tags ?? this.tags,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (flds.present) {
      map['flds'] = Variable<String>(flds.value);
    }
    if (mid.present) {
      map['mid'] = Variable<int>(mid.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesTableCompanion(')
          ..write('id: $id, ')
          ..write('flds: $flds, ')
          ..write('mid: $mid, ')
          ..write('tags: $tags, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$ExternalDatabase extends GeneratedDatabase {
  _$ExternalDatabase(QueryExecutor e) : super(e);
  $ExternalDatabaseManager get managers => $ExternalDatabaseManager(this);
  late final $CardsTableTable cardsTable = $CardsTableTable(this);
  late final $NotesTableTable notesTable = $NotesTableTable(this);
  late final CardsDao cardsDao = CardsDao(this as ExternalDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cardsTable, notesTable];
}

typedef $$CardsTableTableCreateCompanionBuilder =
    CardsTableCompanion Function({
      required int queue,
      Value<int> id,
      required int nid,
      required int reps,
      required int factor,
    });
typedef $$CardsTableTableUpdateCompanionBuilder =
    CardsTableCompanion Function({
      Value<int> queue,
      Value<int> id,
      Value<int> nid,
      Value<int> reps,
      Value<int> factor,
    });

class $$CardsTableTableFilterComposer
    extends Composer<_$ExternalDatabase, $CardsTableTable> {
  $$CardsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get queue => $composableBuilder(
    column: $table.queue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nid => $composableBuilder(
    column: $table.nid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get factor => $composableBuilder(
    column: $table.factor,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CardsTableTableOrderingComposer
    extends Composer<_$ExternalDatabase, $CardsTableTable> {
  $$CardsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get queue => $composableBuilder(
    column: $table.queue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nid => $composableBuilder(
    column: $table.nid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get factor => $composableBuilder(
    column: $table.factor,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardsTableTableAnnotationComposer
    extends Composer<_$ExternalDatabase, $CardsTableTable> {
  $$CardsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get queue =>
      $composableBuilder(column: $table.queue, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get nid =>
      $composableBuilder(column: $table.nid, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get factor =>
      $composableBuilder(column: $table.factor, builder: (column) => column);
}

class $$CardsTableTableTableManager
    extends
        RootTableManager<
          _$ExternalDatabase,
          $CardsTableTable,
          CardsTableData,
          $$CardsTableTableFilterComposer,
          $$CardsTableTableOrderingComposer,
          $$CardsTableTableAnnotationComposer,
          $$CardsTableTableCreateCompanionBuilder,
          $$CardsTableTableUpdateCompanionBuilder,
          (
            CardsTableData,
            BaseReferences<
              _$ExternalDatabase,
              $CardsTableTable,
              CardsTableData
            >,
          ),
          CardsTableData,
          PrefetchHooks Function()
        > {
  $$CardsTableTableTableManager(_$ExternalDatabase db, $CardsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> queue = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<int> nid = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<int> factor = const Value.absent(),
              }) => CardsTableCompanion(
                queue: queue,
                id: id,
                nid: nid,
                reps: reps,
                factor: factor,
              ),
          createCompanionCallback:
              ({
                required int queue,
                Value<int> id = const Value.absent(),
                required int nid,
                required int reps,
                required int factor,
              }) => CardsTableCompanion.insert(
                queue: queue,
                id: id,
                nid: nid,
                reps: reps,
                factor: factor,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CardsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$ExternalDatabase,
      $CardsTableTable,
      CardsTableData,
      $$CardsTableTableFilterComposer,
      $$CardsTableTableOrderingComposer,
      $$CardsTableTableAnnotationComposer,
      $$CardsTableTableCreateCompanionBuilder,
      $$CardsTableTableUpdateCompanionBuilder,
      (
        CardsTableData,
        BaseReferences<_$ExternalDatabase, $CardsTableTable, CardsTableData>,
      ),
      CardsTableData,
      PrefetchHooks Function()
    >;
typedef $$NotesTableTableCreateCompanionBuilder =
    NotesTableCompanion Function({
      required int id,
      required String flds,
      required int mid,
      required String tags,
      Value<int> rowid,
    });
typedef $$NotesTableTableUpdateCompanionBuilder =
    NotesTableCompanion Function({
      Value<int> id,
      Value<String> flds,
      Value<int> mid,
      Value<String> tags,
      Value<int> rowid,
    });

class $$NotesTableTableFilterComposer
    extends Composer<_$ExternalDatabase, $NotesTableTable> {
  $$NotesTableTableFilterComposer({
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

  ColumnFilters<String> get flds => $composableBuilder(
    column: $table.flds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mid => $composableBuilder(
    column: $table.mid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotesTableTableOrderingComposer
    extends Composer<_$ExternalDatabase, $NotesTableTable> {
  $$NotesTableTableOrderingComposer({
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

  ColumnOrderings<String> get flds => $composableBuilder(
    column: $table.flds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mid => $composableBuilder(
    column: $table.mid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotesTableTableAnnotationComposer
    extends Composer<_$ExternalDatabase, $NotesTableTable> {
  $$NotesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get flds =>
      $composableBuilder(column: $table.flds, builder: (column) => column);

  GeneratedColumn<int> get mid =>
      $composableBuilder(column: $table.mid, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);
}

class $$NotesTableTableTableManager
    extends
        RootTableManager<
          _$ExternalDatabase,
          $NotesTableTable,
          NotesTableData,
          $$NotesTableTableFilterComposer,
          $$NotesTableTableOrderingComposer,
          $$NotesTableTableAnnotationComposer,
          $$NotesTableTableCreateCompanionBuilder,
          $$NotesTableTableUpdateCompanionBuilder,
          (
            NotesTableData,
            BaseReferences<
              _$ExternalDatabase,
              $NotesTableTable,
              NotesTableData
            >,
          ),
          NotesTableData,
          PrefetchHooks Function()
        > {
  $$NotesTableTableTableManager(_$ExternalDatabase db, $NotesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> flds = const Value.absent(),
                Value<int> mid = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotesTableCompanion(
                id: id,
                flds: flds,
                mid: mid,
                tags: tags,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int id,
                required String flds,
                required int mid,
                required String tags,
                Value<int> rowid = const Value.absent(),
              }) => NotesTableCompanion.insert(
                id: id,
                flds: flds,
                mid: mid,
                tags: tags,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$ExternalDatabase,
      $NotesTableTable,
      NotesTableData,
      $$NotesTableTableFilterComposer,
      $$NotesTableTableOrderingComposer,
      $$NotesTableTableAnnotationComposer,
      $$NotesTableTableCreateCompanionBuilder,
      $$NotesTableTableUpdateCompanionBuilder,
      (
        NotesTableData,
        BaseReferences<_$ExternalDatabase, $NotesTableTable, NotesTableData>,
      ),
      NotesTableData,
      PrefetchHooks Function()
    >;

class $ExternalDatabaseManager {
  final _$ExternalDatabase _db;
  $ExternalDatabaseManager(this._db);
  $$CardsTableTableTableManager get cardsTable =>
      $$CardsTableTableTableManager(_db, _db.cardsTable);
  $$NotesTableTableTableManager get notesTable =>
      $$NotesTableTableTableManager(_db, _db.notesTable);
}
