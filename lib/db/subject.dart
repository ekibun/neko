import 'package:moor/moor.dart';

class Subjects extends Table {
  @override
  Set<Column> get primaryKey => {site, id};

  TextColumn get site => text()();
  TextColumn get id => text()();

  TextColumn get subjectType => text()();

  TextColumn get name => text()();
  TextColumn get image => text().nullable()();

  TextColumn get summary => text().nullable()();
  IntColumn get score => integer().nullable()();
  TextColumn get tags => text().nullable()();
}
