import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final taskTable = 'Task';
class DatabaseProvider  {
  static final DatabaseProvider dbProvider = DatabaseProvider();

  Database _database;
  int databaseVersion = 1;

  Future<Database> get database async  {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //task.db is our database instance name
    String path = join(documentsDirectory.path, "task.db");

    var database = await openDatabase(path,
    version: databaseVersion, onCreate: initDb, onUpgrade: onUpgrade);
    return database;
  }

  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if(newVersion > oldVersion) {
      databaseVersion++;
    }
  }

  void initDb(Database database, int version) async {
      await database.execute('''
      CREATE TABLE $taskTable(
        id INTEGER PRIMARY KEY,
        task TEXT DEFAULT '',
        is_complete INTEGER
      )
      ''');
  }
}