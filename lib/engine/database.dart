/*
 * @Description: 
 * @Author: ekibun
 * @Date: 2020-08-27 17:24:16
 * @LastEditors: ekibun
 * @LastEditTime: 2020-08-28 17:09:30
 */
import 'dart:async';
import 'dart:isolate';

import 'package:moor/isolate.dart';
import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:neko/db/database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

// This needs to be a top-level method because it's run on a background isolate
DatabaseConnection _backgroundConnection() {
  // construct the database. You can also wrap the VmDatabase in a "LazyDatabase" if you need to run
  // work before the database opens.
  final database = LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'neko.sqlite'));
    return VmDatabase(file, logStatements: true);
  });
  return DatabaseConnection.fromExecutor(database);
}

class Database {
  static Future<DatabaseConnection> _connection =
      MoorIsolate.spawn(_backgroundConnection).then((value) => value.connect());
  final subject = SubjectDatabase(DatabaseConnection.delayed(_connection));
}
