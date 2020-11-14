import 'package:flutter/material.dart';
import 'dart:math';
import 'package:todo/model/ColorChoice.dart';
import 'TaskObject.dart';

enum TodoCardSettings { edit_color, delete }

class TodoObject {
  TodoObject(int id, String title, IconData icon) {
    this.title = title;
    this.icon = icon;
    ColorChoice choice = ColorChoices.choices[Random().nextInt(ColorChoices.choices.length)];
    this.color = choice.primary;
    this.gradient = LinearGradient(colors: choice.gradient, begin: Alignment.bottomCenter, end: Alignment.topCenter);
    this.id = id;
  }

  int id;
  int sortID;
  String title;
  Color color;
  LinearGradient gradient;
  IconData icon;
  List<TaskObject> tasks = [];

  int taskAmount() {
    int amount = 0;
    amount = tasks.length;
    return amount;
  }

  //List<TaskObject> tasks;

  double percentComplete() {
    if (tasks.isEmpty) {
      return 0;
    }
    int completed = 0;
    int amount = 0;
    amount = tasks.length;
    tasks.forEach((task) {
      if (task.isCompleted()) {
        completed++;
      }
    });
    return completed / amount;
  }
}