import 'package:todo/model/ColorChoice.dart';
import 'package:todo/model/TodoObject.dart';
import 'package:flutter/material.dart';

import 'model/TaskObject.dart';

List<TodoObject> todos = [
  TodoObject.import("SOME_RANDOM_UUID", "Custom", 1, ColorChoices.choices[0], Icons.alarm, {
    DateTime(2018, 5, 3): [
      TaskObject(task: "Meet Clients", date: DateTime(2018, 5, 3), isComplete: false),
      TaskObject(task: "Design Sprint", date: DateTime(2018, 5, 3), isComplete: false),
      TaskObject(task: "Icon Set Design for Mobile", date: DateTime(2018, 5, 3), isComplete: false),
      TaskObject(task: "HTML/CSS Study", date: DateTime(2018, 5, 3), isComplete: false),
    ],
    DateTime(2019, 5, 4): [
      TaskObject(task: "Meet Clients", date: DateTime(2019, 5, 4), isComplete: false),
      TaskObject(task: "Design Sprint", date: DateTime(2019, 5, 4), isComplete: false),
      TaskObject(task: "Icon Set Design for Mobile", date: DateTime(2019, 5, 4), isComplete: false),
      TaskObject(task: "HTML/CSS Study", date: DateTime(2019, 5, 4), isComplete: false),
    ]
  }),
  TodoObject("Personal", Icons.person),
  TodoObject("Work", Icons.work),
  TodoObject("Home", Icons.home),
  TodoObject("Shopping", Icons.shopping_basket),
  TodoObject("School", Icons.school),
];
