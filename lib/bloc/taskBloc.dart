import 'dart:async';

import 'package:todo/model/TaskObject.dart';
import 'package:todo/repository/taskRepository.dart';

class TaskBloc {
  final _taskRepository = taskRepository();

  final _taskController = StreamController<List<TaskObject>>.broadcast();

  get tasks => _taskController.stream;

  TaskBloc() {
    getTasks();
  }

  getTasks({String query}) async {
    //sink is the way of adding data reactively to the stream by adding a new event
    _taskController.sink.add(await _taskRepository.getAllTasks(query: query));
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
  }
}