// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Subject extends DataClass implements Insertable<Subject> {
  final String site;
  final String id;
  final String subjectType;
  final String name;
  final String image;
  final String summary;
  final int score;
  final String tags;
  Subject(
      {@required this.site,
      @required this.id,
      @required this.subjectType,
      @required this.name,
      this.image,
      this.summary,
      this.score,
      this.tags});
  factory Subject.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    return Subject(
      site: stringType.mapFromDatabaseResponse(data['${effectivePrefix}site']),
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      subjectType: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}subject_type']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      image:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}image']),
      summary:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}summary']),
      score: intType.mapFromDatabaseResponse(data['${effectivePrefix}score']),
      tags: stringType.mapFromDatabaseResponse(data['${effectivePrefix}tags']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || site != null) {
      map['site'] = Variable<String>(site);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || subjectType != null) {
      map['subject_type'] = Variable<String>(subjectType);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<int>(score);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    return map;
  }

  SubjectsCompanion toCompanion(bool nullToAbsent) {
    return SubjectsCompanion(
      site: site == null && nullToAbsent ? const Value.absent() : Value(site),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      subjectType: subjectType == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectType),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      score:
          score == null && nullToAbsent ? const Value.absent() : Value(score),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
    );
  }

  factory Subject.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Subject(
      site: serializer.fromJson<String>(json['site']),
      id: serializer.fromJson<String>(json['id']),
      subjectType: serializer.fromJson<String>(json['subjectType']),
      name: serializer.fromJson<String>(json['name']),
      image: serializer.fromJson<String>(json['image']),
      summary: serializer.fromJson<String>(json['summary']),
      score: serializer.fromJson<int>(json['score']),
      tags: serializer.fromJson<String>(json['tags']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'site': serializer.toJson<String>(site),
      'id': serializer.toJson<String>(id),
      'subjectType': serializer.toJson<String>(subjectType),
      'name': serializer.toJson<String>(name),
      'image': serializer.toJson<String>(image),
      'summary': serializer.toJson<String>(summary),
      'score': serializer.toJson<int>(score),
      'tags': serializer.toJson<String>(tags),
    };
  }

  Subject copyWith(
          {String site,
          String id,
          String subjectType,
          String name,
          String image,
          String summary,
          int score,
          String tags}) =>
      Subject(
        site: site ?? this.site,
        id: id ?? this.id,
        subjectType: subjectType ?? this.subjectType,
        name: name ?? this.name,
        image: image ?? this.image,
        summary: summary ?? this.summary,
        score: score ?? this.score,
        tags: tags ?? this.tags,
      );
  @override
  String toString() {
    return (StringBuffer('Subject(')
          ..write('site: $site, ')
          ..write('id: $id, ')
          ..write('subjectType: $subjectType, ')
          ..write('name: $name, ')
          ..write('image: $image, ')
          ..write('summary: $summary, ')
          ..write('score: $score, ')
          ..write('tags: $tags')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      site.hashCode,
      $mrjc(
          id.hashCode,
          $mrjc(
              subjectType.hashCode,
              $mrjc(
                  name.hashCode,
                  $mrjc(
                      image.hashCode,
                      $mrjc(summary.hashCode,
                          $mrjc(score.hashCode, tags.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Subject &&
          other.site == this.site &&
          other.id == this.id &&
          other.subjectType == this.subjectType &&
          other.name == this.name &&
          other.image == this.image &&
          other.summary == this.summary &&
          other.score == this.score &&
          other.tags == this.tags);
}

class SubjectsCompanion extends UpdateCompanion<Subject> {
  final Value<String> site;
  final Value<String> id;
  final Value<String> subjectType;
  final Value<String> name;
  final Value<String> image;
  final Value<String> summary;
  final Value<int> score;
  final Value<String> tags;
  const SubjectsCompanion({
    this.site = const Value.absent(),
    this.id = const Value.absent(),
    this.subjectType = const Value.absent(),
    this.name = const Value.absent(),
    this.image = const Value.absent(),
    this.summary = const Value.absent(),
    this.score = const Value.absent(),
    this.tags = const Value.absent(),
  });
  SubjectsCompanion.insert({
    @required String site,
    @required String id,
    @required String subjectType,
    @required String name,
    this.image = const Value.absent(),
    this.summary = const Value.absent(),
    this.score = const Value.absent(),
    this.tags = const Value.absent(),
  })  : site = Value(site),
        id = Value(id),
        subjectType = Value(subjectType),
        name = Value(name);
  static Insertable<Subject> custom({
    Expression<String> site,
    Expression<String> id,
    Expression<String> subjectType,
    Expression<String> name,
    Expression<String> image,
    Expression<String> summary,
    Expression<int> score,
    Expression<String> tags,
  }) {
    return RawValuesInsertable({
      if (site != null) 'site': site,
      if (id != null) 'id': id,
      if (subjectType != null) 'subject_type': subjectType,
      if (name != null) 'name': name,
      if (image != null) 'image': image,
      if (summary != null) 'summary': summary,
      if (score != null) 'score': score,
      if (tags != null) 'tags': tags,
    });
  }

  SubjectsCompanion copyWith(
      {Value<String> site,
      Value<String> id,
      Value<String> subjectType,
      Value<String> name,
      Value<String> image,
      Value<String> summary,
      Value<int> score,
      Value<String> tags}) {
    return SubjectsCompanion(
      site: site ?? this.site,
      id: id ?? this.id,
      subjectType: subjectType ?? this.subjectType,
      name: name ?? this.name,
      image: image ?? this.image,
      summary: summary ?? this.summary,
      score: score ?? this.score,
      tags: tags ?? this.tags,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (site.present) {
      map['site'] = Variable<String>(site.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (subjectType.present) {
      map['subject_type'] = Variable<String>(subjectType.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsCompanion(')
          ..write('site: $site, ')
          ..write('id: $id, ')
          ..write('subjectType: $subjectType, ')
          ..write('name: $name, ')
          ..write('image: $image, ')
          ..write('summary: $summary, ')
          ..write('score: $score, ')
          ..write('tags: $tags')
          ..write(')'))
        .toString();
  }
}

class $SubjectsTable extends Subjects with TableInfo<$SubjectsTable, Subject> {
  final GeneratedDatabase _db;
  final String _alias;
  $SubjectsTable(this._db, [this._alias]);
  final VerificationMeta _siteMeta = const VerificationMeta('site');
  GeneratedTextColumn _site;
  @override
  GeneratedTextColumn get site => _site ??= _constructSite();
  GeneratedTextColumn _constructSite() {
    return GeneratedTextColumn(
      'site',
      $tableName,
      false,
    );
  }

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _subjectTypeMeta =
      const VerificationMeta('subjectType');
  GeneratedTextColumn _subjectType;
  @override
  GeneratedTextColumn get subjectType =>
      _subjectType ??= _constructSubjectType();
  GeneratedTextColumn _constructSubjectType() {
    return GeneratedTextColumn(
      'subject_type',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _imageMeta = const VerificationMeta('image');
  GeneratedTextColumn _image;
  @override
  GeneratedTextColumn get image => _image ??= _constructImage();
  GeneratedTextColumn _constructImage() {
    return GeneratedTextColumn(
      'image',
      $tableName,
      true,
    );
  }

  final VerificationMeta _summaryMeta = const VerificationMeta('summary');
  GeneratedTextColumn _summary;
  @override
  GeneratedTextColumn get summary => _summary ??= _constructSummary();
  GeneratedTextColumn _constructSummary() {
    return GeneratedTextColumn(
      'summary',
      $tableName,
      true,
    );
  }

  final VerificationMeta _scoreMeta = const VerificationMeta('score');
  GeneratedIntColumn _score;
  @override
  GeneratedIntColumn get score => _score ??= _constructScore();
  GeneratedIntColumn _constructScore() {
    return GeneratedIntColumn(
      'score',
      $tableName,
      true,
    );
  }

  final VerificationMeta _tagsMeta = const VerificationMeta('tags');
  GeneratedTextColumn _tags;
  @override
  GeneratedTextColumn get tags => _tags ??= _constructTags();
  GeneratedTextColumn _constructTags() {
    return GeneratedTextColumn(
      'tags',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [site, id, subjectType, name, image, summary, score, tags];
  @override
  $SubjectsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'subjects';
  @override
  final String actualTableName = 'subjects';
  @override
  VerificationContext validateIntegrity(Insertable<Subject> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('site')) {
      context.handle(
          _siteMeta, site.isAcceptableOrUnknown(data['site'], _siteMeta));
    } else if (isInserting) {
      context.missing(_siteMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subject_type')) {
      context.handle(
          _subjectTypeMeta,
          subjectType.isAcceptableOrUnknown(
              data['subject_type'], _subjectTypeMeta));
    } else if (isInserting) {
      context.missing(_subjectTypeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image'], _imageMeta));
    }
    if (data.containsKey('summary')) {
      context.handle(_summaryMeta,
          summary.isAcceptableOrUnknown(data['summary'], _summaryMeta));
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score'], _scoreMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags'], _tagsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {site, id};
  @override
  Subject map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Subject.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $SubjectsTable createAlias(String alias) {
    return $SubjectsTable(_db, alias);
  }
}

class Collection extends DataClass implements Insertable<Collection> {
  final String site;
  final String id;
  final String lastViewEp;
  final int score;
  final String comment;
  final DateTime createTime;
  final DateTime updateTime;
  Collection(
      {@required this.site,
      @required this.id,
      this.lastViewEp,
      this.score,
      this.comment,
      @required this.createTime,
      @required this.updateTime});
  factory Collection.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Collection(
      site: stringType.mapFromDatabaseResponse(data['${effectivePrefix}site']),
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      lastViewEp: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_view_ep']),
      score: intType.mapFromDatabaseResponse(data['${effectivePrefix}score']),
      comment:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}comment']),
      createTime: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}create_time']),
      updateTime: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}update_time']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || site != null) {
      map['site'] = Variable<String>(site);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || lastViewEp != null) {
      map['last_view_ep'] = Variable<String>(lastViewEp);
    }
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<int>(score);
    }
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    if (!nullToAbsent || createTime != null) {
      map['create_time'] = Variable<DateTime>(createTime);
    }
    if (!nullToAbsent || updateTime != null) {
      map['update_time'] = Variable<DateTime>(updateTime);
    }
    return map;
  }

  CollectionsCompanion toCompanion(bool nullToAbsent) {
    return CollectionsCompanion(
      site: site == null && nullToAbsent ? const Value.absent() : Value(site),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      lastViewEp: lastViewEp == null && nullToAbsent
          ? const Value.absent()
          : Value(lastViewEp),
      score:
          score == null && nullToAbsent ? const Value.absent() : Value(score),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      createTime: createTime == null && nullToAbsent
          ? const Value.absent()
          : Value(createTime),
      updateTime: updateTime == null && nullToAbsent
          ? const Value.absent()
          : Value(updateTime),
    );
  }

  factory Collection.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Collection(
      site: serializer.fromJson<String>(json['site']),
      id: serializer.fromJson<String>(json['id']),
      lastViewEp: serializer.fromJson<String>(json['lastViewEp']),
      score: serializer.fromJson<int>(json['score']),
      comment: serializer.fromJson<String>(json['comment']),
      createTime: serializer.fromJson<DateTime>(json['createTime']),
      updateTime: serializer.fromJson<DateTime>(json['updateTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'site': serializer.toJson<String>(site),
      'id': serializer.toJson<String>(id),
      'lastViewEp': serializer.toJson<String>(lastViewEp),
      'score': serializer.toJson<int>(score),
      'comment': serializer.toJson<String>(comment),
      'createTime': serializer.toJson<DateTime>(createTime),
      'updateTime': serializer.toJson<DateTime>(updateTime),
    };
  }

  Collection copyWith(
          {String site,
          String id,
          String lastViewEp,
          int score,
          String comment,
          DateTime createTime,
          DateTime updateTime}) =>
      Collection(
        site: site ?? this.site,
        id: id ?? this.id,
        lastViewEp: lastViewEp ?? this.lastViewEp,
        score: score ?? this.score,
        comment: comment ?? this.comment,
        createTime: createTime ?? this.createTime,
        updateTime: updateTime ?? this.updateTime,
      );
  @override
  String toString() {
    return (StringBuffer('Collection(')
          ..write('site: $site, ')
          ..write('id: $id, ')
          ..write('lastViewEp: $lastViewEp, ')
          ..write('score: $score, ')
          ..write('comment: $comment, ')
          ..write('createTime: $createTime, ')
          ..write('updateTime: $updateTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      site.hashCode,
      $mrjc(
          id.hashCode,
          $mrjc(
              lastViewEp.hashCode,
              $mrjc(
                  score.hashCode,
                  $mrjc(comment.hashCode,
                      $mrjc(createTime.hashCode, updateTime.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Collection &&
          other.site == this.site &&
          other.id == this.id &&
          other.lastViewEp == this.lastViewEp &&
          other.score == this.score &&
          other.comment == this.comment &&
          other.createTime == this.createTime &&
          other.updateTime == this.updateTime);
}

class CollectionsCompanion extends UpdateCompanion<Collection> {
  final Value<String> site;
  final Value<String> id;
  final Value<String> lastViewEp;
  final Value<int> score;
  final Value<String> comment;
  final Value<DateTime> createTime;
  final Value<DateTime> updateTime;
  const CollectionsCompanion({
    this.site = const Value.absent(),
    this.id = const Value.absent(),
    this.lastViewEp = const Value.absent(),
    this.score = const Value.absent(),
    this.comment = const Value.absent(),
    this.createTime = const Value.absent(),
    this.updateTime = const Value.absent(),
  });
  CollectionsCompanion.insert({
    @required String site,
    @required String id,
    this.lastViewEp = const Value.absent(),
    this.score = const Value.absent(),
    this.comment = const Value.absent(),
    @required DateTime createTime,
    @required DateTime updateTime,
  })  : site = Value(site),
        id = Value(id),
        createTime = Value(createTime),
        updateTime = Value(updateTime);
  static Insertable<Collection> custom({
    Expression<String> site,
    Expression<String> id,
    Expression<String> lastViewEp,
    Expression<int> score,
    Expression<String> comment,
    Expression<DateTime> createTime,
    Expression<DateTime> updateTime,
  }) {
    return RawValuesInsertable({
      if (site != null) 'site': site,
      if (id != null) 'id': id,
      if (lastViewEp != null) 'last_view_ep': lastViewEp,
      if (score != null) 'score': score,
      if (comment != null) 'comment': comment,
      if (createTime != null) 'create_time': createTime,
      if (updateTime != null) 'update_time': updateTime,
    });
  }

  CollectionsCompanion copyWith(
      {Value<String> site,
      Value<String> id,
      Value<String> lastViewEp,
      Value<int> score,
      Value<String> comment,
      Value<DateTime> createTime,
      Value<DateTime> updateTime}) {
    return CollectionsCompanion(
      site: site ?? this.site,
      id: id ?? this.id,
      lastViewEp: lastViewEp ?? this.lastViewEp,
      score: score ?? this.score,
      comment: comment ?? this.comment,
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (site.present) {
      map['site'] = Variable<String>(site.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lastViewEp.present) {
      map['last_view_ep'] = Variable<String>(lastViewEp.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (createTime.present) {
      map['create_time'] = Variable<DateTime>(createTime.value);
    }
    if (updateTime.present) {
      map['update_time'] = Variable<DateTime>(updateTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollectionsCompanion(')
          ..write('site: $site, ')
          ..write('id: $id, ')
          ..write('lastViewEp: $lastViewEp, ')
          ..write('score: $score, ')
          ..write('comment: $comment, ')
          ..write('createTime: $createTime, ')
          ..write('updateTime: $updateTime')
          ..write(')'))
        .toString();
  }
}

class $CollectionsTable extends Collections
    with TableInfo<$CollectionsTable, Collection> {
  final GeneratedDatabase _db;
  final String _alias;
  $CollectionsTable(this._db, [this._alias]);
  final VerificationMeta _siteMeta = const VerificationMeta('site');
  GeneratedTextColumn _site;
  @override
  GeneratedTextColumn get site => _site ??= _constructSite();
  GeneratedTextColumn _constructSite() {
    return GeneratedTextColumn(
      'site',
      $tableName,
      false,
    );
  }

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _lastViewEpMeta = const VerificationMeta('lastViewEp');
  GeneratedTextColumn _lastViewEp;
  @override
  GeneratedTextColumn get lastViewEp => _lastViewEp ??= _constructLastViewEp();
  GeneratedTextColumn _constructLastViewEp() {
    return GeneratedTextColumn(
      'last_view_ep',
      $tableName,
      true,
    );
  }

  final VerificationMeta _scoreMeta = const VerificationMeta('score');
  GeneratedIntColumn _score;
  @override
  GeneratedIntColumn get score => _score ??= _constructScore();
  GeneratedIntColumn _constructScore() {
    return GeneratedIntColumn(
      'score',
      $tableName,
      true,
    );
  }

  final VerificationMeta _commentMeta = const VerificationMeta('comment');
  GeneratedTextColumn _comment;
  @override
  GeneratedTextColumn get comment => _comment ??= _constructComment();
  GeneratedTextColumn _constructComment() {
    return GeneratedTextColumn(
      'comment',
      $tableName,
      true,
    );
  }

  final VerificationMeta _createTimeMeta = const VerificationMeta('createTime');
  GeneratedDateTimeColumn _createTime;
  @override
  GeneratedDateTimeColumn get createTime =>
      _createTime ??= _constructCreateTime();
  GeneratedDateTimeColumn _constructCreateTime() {
    return GeneratedDateTimeColumn(
      'create_time',
      $tableName,
      false,
    );
  }

  final VerificationMeta _updateTimeMeta = const VerificationMeta('updateTime');
  GeneratedDateTimeColumn _updateTime;
  @override
  GeneratedDateTimeColumn get updateTime =>
      _updateTime ??= _constructUpdateTime();
  GeneratedDateTimeColumn _constructUpdateTime() {
    return GeneratedDateTimeColumn(
      'update_time',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [site, id, lastViewEp, score, comment, createTime, updateTime];
  @override
  $CollectionsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'collections';
  @override
  final String actualTableName = 'collections';
  @override
  VerificationContext validateIntegrity(Insertable<Collection> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('site')) {
      context.handle(
          _siteMeta, site.isAcceptableOrUnknown(data['site'], _siteMeta));
    } else if (isInserting) {
      context.missing(_siteMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('last_view_ep')) {
      context.handle(
          _lastViewEpMeta,
          lastViewEp.isAcceptableOrUnknown(
              data['last_view_ep'], _lastViewEpMeta));
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score'], _scoreMeta));
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment'], _commentMeta));
    }
    if (data.containsKey('create_time')) {
      context.handle(
          _createTimeMeta,
          createTime.isAcceptableOrUnknown(
              data['create_time'], _createTimeMeta));
    } else if (isInserting) {
      context.missing(_createTimeMeta);
    }
    if (data.containsKey('update_time')) {
      context.handle(
          _updateTimeMeta,
          updateTime.isAcceptableOrUnknown(
              data['update_time'], _updateTimeMeta));
    } else if (isInserting) {
      context.missing(_updateTimeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {site, id};
  @override
  Collection map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Collection.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $CollectionsTable createAlias(String alias) {
    return $CollectionsTable(_db, alias);
  }
}

abstract class _$SubjectDatabase extends GeneratedDatabase {
  _$SubjectDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  _$SubjectDatabase.connect(DatabaseConnection c) : super.connect(c);
  $SubjectsTable _subjects;
  $SubjectsTable get subjects => _subjects ??= $SubjectsTable(this);
  $CollectionsTable _collections;
  $CollectionsTable get collections => _collections ??= $CollectionsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [subjects, collections];
}
