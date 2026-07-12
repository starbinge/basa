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
  static const VerificationMeta _ivlMeta = const VerificationMeta('ivl');
  @override
  late final GeneratedColumn<int> ivl = GeneratedColumn<int>(
    'ivl',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _odueMeta = const VerificationMeta('odue');
  @override
  late final GeneratedColumn<int> odue = GeneratedColumn<int>(
    'odue',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _leftMeta = const VerificationMeta('left');
  @override
  late final GeneratedColumn<int> left = GeneratedColumn<int>(
    'left',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _flagsMeta = const VerificationMeta('flags');
  @override
  late final GeneratedColumn<int> flags = GeneratedColumn<int>(
    'flags',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );

  @override
  List<GeneratedColumn> get $columns => [
    queue,
    id,
    nid,
    reps,
    factor,
    ivl,
    odue,
    left,
    flags,
  ];

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
    if (data.containsKey('ivl')) {
      context.handle(
        _ivlMeta,
        ivl.isAcceptableOrUnknown(data['ivl']!, _ivlMeta),
      );
    } else if (isInserting) {
      context.missing(_ivlMeta);
    }
    if (data.containsKey('odue')) {
      context.handle(
        _odueMeta,
        odue.isAcceptableOrUnknown(data['odue']!, _odueMeta),
      );
    } else if (isInserting) {
      context.missing(_odueMeta);
    }
    if (data.containsKey('left')) {
      context.handle(
        _leftMeta,
        left.isAcceptableOrUnknown(data['left']!, _leftMeta),
      );
    } else if (isInserting) {
      context.missing(_leftMeta);
    }
    if (data.containsKey('flags')) {
      context.handle(
        _flagsMeta,
        flags.isAcceptableOrUnknown(data['flags']!, _flagsMeta),
      );
    } else if (isInserting) {
      context.missing(_flagsMeta);
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
      ivl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ivl'],
      )!,
      odue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odue'],
      )!,
      left: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}left'],
      )!,
      flags: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}flags'],
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
  final int ivl;
  final int odue;
  final int left;
  final int flags;

  const CardsTableData({
    required this.queue,
    required this.id,
    required this.nid,
    required this.reps,
    required this.factor,
    required this.ivl,
    required this.odue,
    required this.left,
    required this.flags,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['queue'] = Variable<int>(queue);
    map['id'] = Variable<int>(id);
    map['nid'] = Variable<int>(nid);
    map['reps'] = Variable<int>(reps);
    map['factor'] = Variable<int>(factor);
    map['ivl'] = Variable<int>(ivl);
    map['odue'] = Variable<int>(odue);
    map['left'] = Variable<int>(left);
    map['flags'] = Variable<int>(flags);
    return map;
  }

  CardsTableCompanion toCompanion(bool nullToAbsent) {
    return CardsTableCompanion(
      queue: Value(queue),
      id: Value(id),
      nid: Value(nid),
      reps: Value(reps),
      factor: Value(factor),
      ivl: Value(ivl),
      odue: Value(odue),
      left: Value(left),
      flags: Value(flags),
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
      ivl: serializer.fromJson<int>(json['ivl']),
      odue: serializer.fromJson<int>(json['odue']),
      left: serializer.fromJson<int>(json['left']),
      flags: serializer.fromJson<int>(json['flags']),
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
      'ivl': serializer.toJson<int>(ivl),
      'odue': serializer.toJson<int>(odue),
      'left': serializer.toJson<int>(left),
      'flags': serializer.toJson<int>(flags),
    };
  }

  CardsTableData copyWith({
    int? queue,
    int? id,
    int? nid,
    int? reps,
    int? factor,
    int? ivl,
    int? odue,
    int? left,
    int? flags,
  }) => CardsTableData(
    queue: queue ?? this.queue,
    id: id ?? this.id,
    nid: nid ?? this.nid,
    reps: reps ?? this.reps,
    factor: factor ?? this.factor,
    ivl: ivl ?? this.ivl,
    odue: odue ?? this.odue,
    left: left ?? this.left,
    flags: flags ?? this.flags,
  );

  CardsTableData copyWithCompanion(CardsTableCompanion data) {
    return CardsTableData(
      queue: data.queue.present ? data.queue.value : this.queue,
      id: data.id.present ? data.id.value : this.id,
      nid: data.nid.present ? data.nid.value : this.nid,
      reps: data.reps.present ? data.reps.value : this.reps,
      factor: data.factor.present ? data.factor.value : this.factor,
      ivl: data.ivl.present ? data.ivl.value : this.ivl,
      odue: data.odue.present ? data.odue.value : this.odue,
      left: data.left.present ? data.left.value : this.left,
      flags: data.flags.present ? data.flags.value : this.flags,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardsTableData(')
          ..write('queue: $queue, ')
          ..write('id: $id, ')
          ..write('nid: $nid, ')
          ..write('reps: $reps, ')
          ..write('factor: $factor, ')
          ..write('ivl: $ivl, ')
          ..write('odue: $odue, ')
          ..write('left: $left, ')
          ..write('flags: $flags')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(queue, id, nid, reps, factor, ivl, odue, left, flags);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardsTableData &&
          other.queue == this.queue &&
          other.id == this.id &&
          other.nid == this.nid &&
          other.reps == this.reps &&
          other.factor == this.factor &&
          other.ivl == this.ivl &&
          other.odue == this.odue &&
          other.left == this.left &&
          other.flags == this.flags);
}

class CardsTableCompanion extends UpdateCompanion<CardsTableData> {
  final Value<int> queue;
  final Value<int> id;
  final Value<int> nid;
  final Value<int> reps;
  final Value<int> factor;
  final Value<int> ivl;
  final Value<int> odue;
  final Value<int> left;
  final Value<int> flags;

  const CardsTableCompanion({
    this.queue = const Value.absent(),
    this.id = const Value.absent(),
    this.nid = const Value.absent(),
    this.reps = const Value.absent(),
    this.factor = const Value.absent(),
    this.ivl = const Value.absent(),
    this.odue = const Value.absent(),
    this.left = const Value.absent(),
    this.flags = const Value.absent(),
  });

  CardsTableCompanion.insert({
    required int queue,
    this.id = const Value.absent(),
    required int nid,
    required int reps,
    required int factor,
    required int ivl,
    required int odue,
    required int left,
    required int flags,
  }) : queue = Value(queue),
       nid = Value(nid),
       reps = Value(reps),
       factor = Value(factor),
       ivl = Value(ivl),
       odue = Value(odue),
       left = Value(left),
       flags = Value(flags);

  static Insertable<CardsTableData> custom({
    Expression<int>? queue,
    Expression<int>? id,
    Expression<int>? nid,
    Expression<int>? reps,
    Expression<int>? factor,
    Expression<int>? ivl,
    Expression<int>? odue,
    Expression<int>? left,
    Expression<int>? flags,
  }) {
    return RawValuesInsertable({
      if (queue != null) 'queue': queue,
      if (id != null) 'id': id,
      if (nid != null) 'nid': nid,
      if (reps != null) 'reps': reps,
      if (factor != null) 'factor': factor,
      if (ivl != null) 'ivl': ivl,
      if (odue != null) 'odue': odue,
      if (left != null) 'left': left,
      if (flags != null) 'flags': flags,
    });
  }

  CardsTableCompanion copyWith({
    Value<int>? queue,
    Value<int>? id,
    Value<int>? nid,
    Value<int>? reps,
    Value<int>? factor,
    Value<int>? ivl,
    Value<int>? odue,
    Value<int>? left,
    Value<int>? flags,
  }) {
    return CardsTableCompanion(
      queue: queue ?? this.queue,
      id: id ?? this.id,
      nid: nid ?? this.nid,
      reps: reps ?? this.reps,
      factor: factor ?? this.factor,
      ivl: ivl ?? this.ivl,
      odue: odue ?? this.odue,
      left: left ?? this.left,
      flags: flags ?? this.flags,
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
    if (ivl.present) {
      map['ivl'] = Variable<int>(ivl.value);
    }
    if (odue.present) {
      map['odue'] = Variable<int>(odue.value);
    }
    if (left.present) {
      map['left'] = Variable<int>(left.value);
    }
    if (flags.present) {
      map['flags'] = Variable<int>(flags.value);
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
          ..write('factor: $factor, ')
          ..write('ivl: $ivl, ')
          ..write('odue: $odue, ')
          ..write('left: $left, ')
          ..write('flags: $flags')
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

class $RevlogTableTable extends RevlogTable
    with TableInfo<$RevlogTableTable, RevlogTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;

  $RevlogTableTable(this.attachedDatabase, [this._alias]);

  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cidMeta = const VerificationMeta('cid');
  @override
  late final GeneratedColumn<int> cid = GeneratedColumn<int>(
    'cid',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usnMeta = const VerificationMeta('usn');
  @override
  late final GeneratedColumn<int> usn = GeneratedColumn<int>(
    'usn',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _easeMeta = const VerificationMeta('ease');
  @override
  late final GeneratedColumn<int> ease = GeneratedColumn<int>(
    'ease',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ivlMeta = const VerificationMeta('ivl');
  @override
  late final GeneratedColumn<int> ivl = GeneratedColumn<int>(
    'ivl',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastIvlMeta = const VerificationMeta(
    'lastIvl',
  );
  @override
  late final GeneratedColumn<int> lastIvl = GeneratedColumn<int>(
    'lastIvl',
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
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<int> time = GeneratedColumn<int>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );

  @override
  List<GeneratedColumn> get $columns => [
    id,
    cid,
    usn,
    ease,
    ivl,
    lastIvl,
    factor,
    time,
    type,
  ];

  @override
  String get aliasedName => _alias ?? actualTableName;

  @override
  String get actualTableName => $name;
  static const String $name = 'revlog';

  @override
  VerificationContext validateIntegrity(
    Insertable<RevlogTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cid')) {
      context.handle(
        _cidMeta,
        cid.isAcceptableOrUnknown(data['cid']!, _cidMeta),
      );
    } else if (isInserting) {
      context.missing(_cidMeta);
    }
    if (data.containsKey('usn')) {
      context.handle(
        _usnMeta,
        usn.isAcceptableOrUnknown(data['usn']!, _usnMeta),
      );
    } else if (isInserting) {
      context.missing(_usnMeta);
    }
    if (data.containsKey('ease')) {
      context.handle(
        _easeMeta,
        ease.isAcceptableOrUnknown(data['ease']!, _easeMeta),
      );
    } else if (isInserting) {
      context.missing(_easeMeta);
    }
    if (data.containsKey('ivl')) {
      context.handle(
        _ivlMeta,
        ivl.isAcceptableOrUnknown(data['ivl']!, _ivlMeta),
      );
    } else if (isInserting) {
      context.missing(_ivlMeta);
    }
    if (data.containsKey('lastIvl')) {
      context.handle(
        _lastIvlMeta,
        lastIvl.isAcceptableOrUnknown(data['lastIvl']!, _lastIvlMeta),
      );
    } else if (isInserting) {
      context.missing(_lastIvlMeta);
    }
    if (data.containsKey('factor')) {
      context.handle(
        _factorMeta,
        factor.isAcceptableOrUnknown(data['factor']!, _factorMeta),
      );
    } else if (isInserting) {
      context.missing(_factorMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  RevlogTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RevlogTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cid'],
      )!,
      usn: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usn'],
      )!,
      ease: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ease'],
      )!,
      ivl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ivl'],
      )!,
      lastIvl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lastIvl'],
      )!,
      factor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}factor'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      )!,
    );
  }

  @override
  $RevlogTableTable createAlias(String alias) {
    return $RevlogTableTable(attachedDatabase, alias);
  }
}

class RevlogTableData extends DataClass implements Insertable<RevlogTableData> {
  final int id;
  final int cid;
  final int usn;
  final int ease;
  final int ivl;
  final int lastIvl;
  final int factor;
  final int time;
  final int type;

  const RevlogTableData({
    required this.id,
    required this.cid,
    required this.usn,
    required this.ease,
    required this.ivl,
    required this.lastIvl,
    required this.factor,
    required this.time,
    required this.type,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cid'] = Variable<int>(cid);
    map['usn'] = Variable<int>(usn);
    map['ease'] = Variable<int>(ease);
    map['ivl'] = Variable<int>(ivl);
    map['lastIvl'] = Variable<int>(lastIvl);
    map['factor'] = Variable<int>(factor);
    map['time'] = Variable<int>(time);
    map['type'] = Variable<int>(type);
    return map;
  }

  RevlogTableCompanion toCompanion(bool nullToAbsent) {
    return RevlogTableCompanion(
      id: Value(id),
      cid: Value(cid),
      usn: Value(usn),
      ease: Value(ease),
      ivl: Value(ivl),
      lastIvl: Value(lastIvl),
      factor: Value(factor),
      time: Value(time),
      type: Value(type),
    );
  }

  factory RevlogTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RevlogTableData(
      id: serializer.fromJson<int>(json['id']),
      cid: serializer.fromJson<int>(json['cid']),
      usn: serializer.fromJson<int>(json['usn']),
      ease: serializer.fromJson<int>(json['ease']),
      ivl: serializer.fromJson<int>(json['ivl']),
      lastIvl: serializer.fromJson<int>(json['lastIvl']),
      factor: serializer.fromJson<int>(json['factor']),
      time: serializer.fromJson<int>(json['time']),
      type: serializer.fromJson<int>(json['type']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cid': serializer.toJson<int>(cid),
      'usn': serializer.toJson<int>(usn),
      'ease': serializer.toJson<int>(ease),
      'ivl': serializer.toJson<int>(ivl),
      'lastIvl': serializer.toJson<int>(lastIvl),
      'factor': serializer.toJson<int>(factor),
      'time': serializer.toJson<int>(time),
      'type': serializer.toJson<int>(type),
    };
  }

  RevlogTableData copyWith({
    int? id,
    int? cid,
    int? usn,
    int? ease,
    int? ivl,
    int? lastIvl,
    int? factor,
    int? time,
    int? type,
  }) => RevlogTableData(
    id: id ?? this.id,
    cid: cid ?? this.cid,
    usn: usn ?? this.usn,
    ease: ease ?? this.ease,
    ivl: ivl ?? this.ivl,
    lastIvl: lastIvl ?? this.lastIvl,
    factor: factor ?? this.factor,
    time: time ?? this.time,
    type: type ?? this.type,
  );

  RevlogTableData copyWithCompanion(RevlogTableCompanion data) {
    return RevlogTableData(
      id: data.id.present ? data.id.value : this.id,
      cid: data.cid.present ? data.cid.value : this.cid,
      usn: data.usn.present ? data.usn.value : this.usn,
      ease: data.ease.present ? data.ease.value : this.ease,
      ivl: data.ivl.present ? data.ivl.value : this.ivl,
      lastIvl: data.lastIvl.present ? data.lastIvl.value : this.lastIvl,
      factor: data.factor.present ? data.factor.value : this.factor,
      time: data.time.present ? data.time.value : this.time,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RevlogTableData(')
          ..write('id: $id, ')
          ..write('cid: $cid, ')
          ..write('usn: $usn, ')
          ..write('ease: $ease, ')
          ..write('ivl: $ivl, ')
          ..write('lastIvl: $lastIvl, ')
          ..write('factor: $factor, ')
          ..write('time: $time, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, cid, usn, ease, ivl, lastIvl, factor, time, type);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RevlogTableData &&
          other.id == this.id &&
          other.cid == this.cid &&
          other.usn == this.usn &&
          other.ease == this.ease &&
          other.ivl == this.ivl &&
          other.lastIvl == this.lastIvl &&
          other.factor == this.factor &&
          other.time == this.time &&
          other.type == this.type);

  read(amountOfTodos) {}
}

class RevlogTableCompanion extends UpdateCompanion<RevlogTableData> {
  final Value<int> id;
  final Value<int> cid;
  final Value<int> usn;
  final Value<int> ease;
  final Value<int> ivl;
  final Value<int> lastIvl;
  final Value<int> factor;
  final Value<int> time;
  final Value<int> type;

  const RevlogTableCompanion({
    this.id = const Value.absent(),
    this.cid = const Value.absent(),
    this.usn = const Value.absent(),
    this.ease = const Value.absent(),
    this.ivl = const Value.absent(),
    this.lastIvl = const Value.absent(),
    this.factor = const Value.absent(),
    this.time = const Value.absent(),
    this.type = const Value.absent(),
  });

  RevlogTableCompanion.insert({
    this.id = const Value.absent(),
    required int cid,
    required int usn,
    required int ease,
    required int ivl,
    required int lastIvl,
    required int factor,
    required int time,
    required int type,
  }) : cid = Value(cid),
       usn = Value(usn),
       ease = Value(ease),
       ivl = Value(ivl),
       lastIvl = Value(lastIvl),
       factor = Value(factor),
       time = Value(time),
       type = Value(type);

  static Insertable<RevlogTableData> custom({
    Expression<int>? id,
    Expression<int>? cid,
    Expression<int>? usn,
    Expression<int>? ease,
    Expression<int>? ivl,
    Expression<int>? lastIvl,
    Expression<int>? factor,
    Expression<int>? time,
    Expression<int>? type,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cid != null) 'cid': cid,
      if (usn != null) 'usn': usn,
      if (ease != null) 'ease': ease,
      if (ivl != null) 'ivl': ivl,
      if (lastIvl != null) 'lastIvl': lastIvl,
      if (factor != null) 'factor': factor,
      if (time != null) 'time': time,
      if (type != null) 'type': type,
    });
  }

  RevlogTableCompanion copyWith({
    Value<int>? id,
    Value<int>? cid,
    Value<int>? usn,
    Value<int>? ease,
    Value<int>? ivl,
    Value<int>? lastIvl,
    Value<int>? factor,
    Value<int>? time,
    Value<int>? type,
  }) {
    return RevlogTableCompanion(
      id: id ?? this.id,
      cid: cid ?? this.cid,
      usn: usn ?? this.usn,
      ease: ease ?? this.ease,
      ivl: ivl ?? this.ivl,
      lastIvl: lastIvl ?? this.lastIvl,
      factor: factor ?? this.factor,
      time: time ?? this.time,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cid.present) {
      map['cid'] = Variable<int>(cid.value);
    }
    if (usn.present) {
      map['usn'] = Variable<int>(usn.value);
    }
    if (ease.present) {
      map['ease'] = Variable<int>(ease.value);
    }
    if (ivl.present) {
      map['ivl'] = Variable<int>(ivl.value);
    }
    if (lastIvl.present) {
      map['lastIvl'] = Variable<int>(lastIvl.value);
    }
    if (factor.present) {
      map['factor'] = Variable<int>(factor.value);
    }
    if (time.present) {
      map['time'] = Variable<int>(time.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RevlogTableCompanion(')
          ..write('id: $id, ')
          ..write('cid: $cid, ')
          ..write('usn: $usn, ')
          ..write('ease: $ease, ')
          ..write('ivl: $ivl, ')
          ..write('lastIvl: $lastIvl, ')
          ..write('factor: $factor, ')
          ..write('time: $time, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

abstract class _$ExternalDatabase extends GeneratedDatabase {
  _$ExternalDatabase(QueryExecutor e) : super(e);

  $ExternalDatabaseManager get managers => $ExternalDatabaseManager(this);
  late final $CardsTableTable cardsTable = $CardsTableTable(this);
  late final $NotesTableTable notesTable = $NotesTableTable(this);
  late final $RevlogTableTable revlogTable = $RevlogTableTable(this);
  late final CardsDao cardsDao = CardsDao(this as ExternalDatabase);

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();

  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cardsTable,
    notesTable,
    revlogTable,
  ];
}

typedef $$CardsTableTableCreateCompanionBuilder =
    CardsTableCompanion Function({
      required int queue,
      Value<int> id,
      required int nid,
      required int reps,
      required int factor,
      required int ivl,
      required int odue,
      required int left,
      required int flags,
    });
typedef $$CardsTableTableUpdateCompanionBuilder =
    CardsTableCompanion Function({
      Value<int> queue,
      Value<int> id,
      Value<int> nid,
      Value<int> reps,
      Value<int> factor,
      Value<int> ivl,
      Value<int> odue,
      Value<int> left,
      Value<int> flags,
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

  ColumnFilters<int> get ivl => $composableBuilder(
    column: $table.ivl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odue => $composableBuilder(
    column: $table.odue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get left => $composableBuilder(
    column: $table.left,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get flags => $composableBuilder(
    column: $table.flags,
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

  ColumnOrderings<int> get ivl => $composableBuilder(
    column: $table.ivl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odue => $composableBuilder(
    column: $table.odue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get left => $composableBuilder(
    column: $table.left,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get flags => $composableBuilder(
    column: $table.flags,
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

  GeneratedColumn<int> get ivl =>
      $composableBuilder(column: $table.ivl, builder: (column) => column);

  GeneratedColumn<int> get odue =>
      $composableBuilder(column: $table.odue, builder: (column) => column);

  GeneratedColumn<int> get left =>
      $composableBuilder(column: $table.left, builder: (column) => column);

  GeneratedColumn<int> get flags =>
      $composableBuilder(column: $table.flags, builder: (column) => column);
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
                Value<int> ivl = const Value.absent(),
                Value<int> odue = const Value.absent(),
                Value<int> left = const Value.absent(),
                Value<int> flags = const Value.absent(),
              }) => CardsTableCompanion(
                queue: queue,
                id: id,
                nid: nid,
                reps: reps,
                factor: factor,
                ivl: ivl,
                odue: odue,
                left: left,
                flags: flags,
              ),
          createCompanionCallback:
              ({
                required int queue,
                Value<int> id = const Value.absent(),
                required int nid,
                required int reps,
                required int factor,
                required int ivl,
                required int odue,
                required int left,
                required int flags,
              }) => CardsTableCompanion.insert(
                queue: queue,
                id: id,
                nid: nid,
                reps: reps,
                factor: factor,
                ivl: ivl,
                odue: odue,
                left: left,
                flags: flags,
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
typedef $$RevlogTableTableCreateCompanionBuilder =
    RevlogTableCompanion Function({
      Value<int> id,
      required int cid,
      required int usn,
      required int ease,
      required int ivl,
      required int lastIvl,
      required int factor,
      required int time,
      required int type,
    });
typedef $$RevlogTableTableUpdateCompanionBuilder =
    RevlogTableCompanion Function({
      Value<int> id,
      Value<int> cid,
      Value<int> usn,
      Value<int> ease,
      Value<int> ivl,
      Value<int> lastIvl,
      Value<int> factor,
      Value<int> time,
      Value<int> type,
    });

class $$RevlogTableTableFilterComposer
    extends Composer<_$ExternalDatabase, $RevlogTableTable> {
  $$RevlogTableTableFilterComposer({
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

  ColumnFilters<int> get cid => $composableBuilder(
    column: $table.cid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get usn => $composableBuilder(
    column: $table.usn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ease => $composableBuilder(
    column: $table.ease,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ivl => $composableBuilder(
    column: $table.ivl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastIvl => $composableBuilder(
    column: $table.lastIvl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get factor => $composableBuilder(
    column: $table.factor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RevlogTableTableOrderingComposer
    extends Composer<_$ExternalDatabase, $RevlogTableTable> {
  $$RevlogTableTableOrderingComposer({
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

  ColumnOrderings<int> get cid => $composableBuilder(
    column: $table.cid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get usn => $composableBuilder(
    column: $table.usn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ease => $composableBuilder(
    column: $table.ease,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ivl => $composableBuilder(
    column: $table.ivl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastIvl => $composableBuilder(
    column: $table.lastIvl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get factor => $composableBuilder(
    column: $table.factor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RevlogTableTableAnnotationComposer
    extends Composer<_$ExternalDatabase, $RevlogTableTable> {
  $$RevlogTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cid =>
      $composableBuilder(column: $table.cid, builder: (column) => column);

  GeneratedColumn<int> get usn =>
      $composableBuilder(column: $table.usn, builder: (column) => column);

  GeneratedColumn<int> get ease =>
      $composableBuilder(column: $table.ease, builder: (column) => column);

  GeneratedColumn<int> get ivl =>
      $composableBuilder(column: $table.ivl, builder: (column) => column);

  GeneratedColumn<int> get lastIvl =>
      $composableBuilder(column: $table.lastIvl, builder: (column) => column);

  GeneratedColumn<int> get factor =>
      $composableBuilder(column: $table.factor, builder: (column) => column);

  GeneratedColumn<int> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);
}

class $$RevlogTableTableTableManager
    extends
        RootTableManager<
          _$ExternalDatabase,
          $RevlogTableTable,
          RevlogTableData,
          $$RevlogTableTableFilterComposer,
          $$RevlogTableTableOrderingComposer,
          $$RevlogTableTableAnnotationComposer,
          $$RevlogTableTableCreateCompanionBuilder,
          $$RevlogTableTableUpdateCompanionBuilder,
          (
            RevlogTableData,
            BaseReferences<
              _$ExternalDatabase,
              $RevlogTableTable,
              RevlogTableData
            >,
          ),
          RevlogTableData,
          PrefetchHooks Function()
        > {
  $$RevlogTableTableTableManager(_$ExternalDatabase db, $RevlogTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RevlogTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RevlogTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RevlogTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cid = const Value.absent(),
                Value<int> usn = const Value.absent(),
                Value<int> ease = const Value.absent(),
                Value<int> ivl = const Value.absent(),
                Value<int> lastIvl = const Value.absent(),
                Value<int> factor = const Value.absent(),
                Value<int> time = const Value.absent(),
                Value<int> type = const Value.absent(),
              }) => RevlogTableCompanion(
                id: id,
                cid: cid,
                usn: usn,
                ease: ease,
                ivl: ivl,
                lastIvl: lastIvl,
                factor: factor,
                time: time,
                type: type,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cid,
                required int usn,
                required int ease,
                required int ivl,
                required int lastIvl,
                required int factor,
                required int time,
                required int type,
              }) => RevlogTableCompanion.insert(
                id: id,
                cid: cid,
                usn: usn,
                ease: ease,
                ivl: ivl,
                lastIvl: lastIvl,
                factor: factor,
                time: time,
                type: type,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RevlogTableTableProcessedTableManager =
    ProcessedTableManager<
      _$ExternalDatabase,
      $RevlogTableTable,
      RevlogTableData,
      $$RevlogTableTableFilterComposer,
      $$RevlogTableTableOrderingComposer,
      $$RevlogTableTableAnnotationComposer,
      $$RevlogTableTableCreateCompanionBuilder,
      $$RevlogTableTableUpdateCompanionBuilder,
      (
        RevlogTableData,
        BaseReferences<_$ExternalDatabase, $RevlogTableTable, RevlogTableData>,
      ),
      RevlogTableData,
      PrefetchHooks Function()
    >;

class $ExternalDatabaseManager {
  final _$ExternalDatabase _db;

  $ExternalDatabaseManager(this._db);

  $$CardsTableTableTableManager get cardsTable =>
      $$CardsTableTableTableManager(_db, _db.cardsTable);

  $$NotesTableTableTableManager get notesTable =>
      $$NotesTableTableTableManager(_db, _db.notesTable);

  $$RevlogTableTableTableManager get revlogTable =>
      $$RevlogTableTableTableManager(_db, _db.revlogTable);
}
