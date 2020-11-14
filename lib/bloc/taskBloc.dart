import 'dart:async';

import 'package:todo/model/TaskObject.dart';
import 'package:todo/repository/TaskRepository.dart';

class TaskBloc {
  final _taskRepository = TaskRepository();

  final _taskController = StreamController<List<TaskObject>>.broadcast();

  final _tasksControllerByTodoId = StreamController<List<TaskObject>>.broadcast();

  get tasks => _taskController.stream;

  get tasksByTodoId => _tasksControllerByTodoId.stream;

  TaskBloc() {
    getTasks();
    getTasksByIdTodo();
  }

  getTasks({String query}) async {
    //sink is the way of adding data reactively to the stream by adding a new event
    _taskController.sink.add(await _taskRepository.getAllTasks(query: query));
  }

  getTasksByIdTodo({String query}) async {
    _tasksControllerByTodoId.sink.add(await _taskRepository.getTasksByIdTodo(query: query));
  }

  addTask(TaskObject task) async {
    await _taskRepository.insertTask(task);
    getTasks();
  }

  updateTask(TaskObject task) async {
    await _taskRepository.updateTask(task);
    getTasks();
  }

  deleteTaskById(int id) async {
    await _taskRepository.deleteTaskById(id);
    getTasks();
  }

  dispose() {
    _taskController.close();
    _tasksControllerByTodoId.close();
  }
}