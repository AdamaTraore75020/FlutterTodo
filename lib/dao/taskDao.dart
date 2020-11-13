import 'package:todo/database/database.dart';
import 'package:todo/model/TaskObject.dart';

class TaskDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> createTask(TaskObject task) async {
    final db = await dbProvider.database;
    var result = db.insert(taskTable, task.toDatabaseJson());
    return result;
  }

  Future<List<TaskObject>> getAllTasks({List<String> columns, String query}) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty) {
        result = await db.query(taskTable, columns: columns, where: 'description LIKE ?', whereArgs: ["%$query%"]);
      }
    }
    else {
        result = await db.query(taskTable, columns: columns);
    }
      
    List<TaskObject> tasks = result.isNotEmpty 
      ? result.map((item) => TaskObject.fromDatabaseJson(item)).toList()
      : [];

    return tasks;
  }

  Future<int> updateTask(TaskObject task) async {
    final db = await dbProvider.database;
    var result = await db.update(taskTable, task.toDatabaseJson(), where: 'id = ?', whereArgs: [task.id]);
    return result;
  }

  Future<int> deleteTask(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(taskTable, where: 'id = ?', whereArgs: [id]);
    return result;
  }
}