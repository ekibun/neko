import 'package:moor/moor.dart';

class Collections extends Table {
  @override
  Set<Column> get primaryKey => {site, id};

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (site,id) REFERENCES subjects(site,id)'
  ];

  TextColumn get site => text()();
  TextColumn get id => text()();
  
  TextColumn get lastViewEp => text().nullable()();

  IntColumn get score => integer().nullable()();
  TextColumn get comment => text().nullable()();
  TextColumn get tags => text().nullable()();

  DateTimeColumn get createTime => dateTime()();
  DateTimeColumn get updateTime => dateTime()();
}