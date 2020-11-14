import 'package:todo/dao/taskDao.dart';
import 'package:todo/model/TaskObject.dart';

class TaskRepository {
  final taskDao = TaskDao();

  Future getAllTasks({String query}) => taskDao.getAllTasks(query: query);

  Future getTasksByIdTodo({String query}) => taskDao.getTasksByIdTodo(query: query);

  Future insertTask(TaskObject task) => taskDao.createTask(task);

  Future updateTask(TaskObject task) => taskDao.updateTask(task);

  Future deleteTaskById(int id) => taskDao.deleteTask(id);
}