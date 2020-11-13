import 'package:todo/dao/taskDao.dart';
import 'package:todo/model/TaskObject.dart';

class taskRepository {
  final taskDao = TaskDao();

  Future getAllTasks({String query}) => taskDao.getAllTasks(query: query);

  Future insertTask(TaskObject task) => taskDao.createTask(task);

  Future updateTask(TaskObject task) => taskDao.updateTask(task);

  Future deleteTaskById(int id) => taskDao.deleteTask(id);
}