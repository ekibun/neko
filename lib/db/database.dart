import 'package:moor/moor.dart';
import 'collection.dart';
import 'subject.dart';

part 'database.g.dart';

class SubjectCollection {
  Subject subject;
  Collection collection;
}

@UseMoor(tables: [Subjects, Collections])
class SubjectDatabase extends _$SubjectDatabase {
  // we tell the database where to store the data with this constructor
  SubjectDatabase(DatabaseConnection connection) : super.connect(connection);

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON;');
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1) {
          await m.addColumn(collections, collections.relate);
        }
      },
    );
  }

  Stream<List<SubjectCollection>> watchCollections() =>
      select(collections).join([
        innerJoin(
            subjects,
            subjects.site.equalsExp(collections.site) &
                subjects.id.equalsExp(collections.id))
      ]).map((rows) {
        return SubjectCollection()
          ..collection = rows.readTable(collections)
          ..subject = rows.readTable(subjects);
      }).watch();

  Future insertSubject(Insertable<Subject> subject) =>
      into(subjects).insert(subject, mode: InsertMode.insertOrReplace);
  Future insertCollection(Insertable<Collection> collection) =>
      into(collections).insert(collection,
          onConflict: DoUpdate((old) => CollectionsCompanion.custom(
                createTime: old.createTime,
              )));
  Future insertSubjectCollection(SubjectCollection subjectCollection) async {
    await insertSubject(subjectCollection.subject);
    await insertCollection(subjectCollection.collection);
  }

  Future<Collection> getCollection(Subject subject) => (select(collections)
        ..where(
            (tbl) => tbl.id.equals(subject.id) & tbl.site.equals(subject.site)))
      .getSingle();

  Future<List<Collection>> getCollections(Iterable<Subject> subjects) =>
      (select(collections)
            ..where((tbl) =>
                tbl.id.isIn(subjects.map((e) => e.id).toSet()) &
                tbl.site.isIn(subjects.map((e) => e.site).toSet())))
          .get();

  Future removeCollection(Insertable<Collection> collection) =>
      delete(collections).delete(collection);
}
