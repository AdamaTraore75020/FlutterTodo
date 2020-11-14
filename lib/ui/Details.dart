import 'package:flutter/material.dart';
import 'package:todo/bloc/taskBloc.dart';
import 'package:todo/model/TaskObject.dart';
import 'package:todo/model/TodoObject.dart';
import 'package:todo/CustomCheckboxTile.dart';

class DetailPage extends StatefulWidget {
  DetailPage({@required this.todoObject, Key key}) : super(key: key);

  final TodoObject todoObject;
  final TaskBloc taskBloc = TaskBloc();
  final DismissDirection _dismissDirection = DismissDirection.horizontal;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  double percentComplete;
  AnimationController animationBar;
  double barPercent = 0.0;
  Tween<double> animT;
  AnimationController scaleAnimation;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    scaleAnimation = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1000),
        lowerBound: 0.0,
        upperBound: 1.0);

    percentComplete = widget.todoObject.percentComplete();
    barPercent = percentComplete;
    animationBar =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100))
          ..addListener(() {
            setState(() {
              barPercent = animT.transform(animationBar.value);
            });
          });
    animT = Tween<double>(begin: percentComplete, end: percentComplete);
    scaleAnimation.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationBar.dispose();
    scaleAnimation.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  void updateBarPercent() async {
    double newPercentComplete = widget.todoObject.percentComplete();
    if (animationBar.status == AnimationStatus.forward ||
        animationBar.status == AnimationStatus.completed) {
      animT.begin = newPercentComplete;
      await animationBar.reverse();
    } else {
      animT.end = newPercentComplete;
      await animationBar.forward();
    }
    percentComplete = newPercentComplete;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Hero(
          tag: widget.todoObject.id.toString() + "_background",
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(0.0),
            ),
          ),
        ),
        Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: Hero(
              tag: widget.todoObject.id.toString() + "_backIcon",
              child: Material(
                color: Colors.transparent,
                type: MaterialType.transparency,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.grey,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            actions: <Widget>[
              Hero(
                tag: widget.todoObject.id.toString() + "_more_vert",
                child: Material(
                  color: Colors.transparent,
                  type: MaterialType.transparency,
                  child: PopupMenuButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.grey,
                    ),
                    itemBuilder: (context) =>
                        <PopupMenuEntry<TodoCardSettings>>[
                      PopupMenuItem(
                        child: Text("Edit Color"),
                        value: TodoCardSettings.edit_color,
                      ),
                      PopupMenuItem(
                        child: Text("Delete"),
                        value: TodoCardSettings.delete,
                      ),
                    ],
                    onSelected: (setting) {
                      switch (setting) {
                        case TodoCardSettings.edit_color:
                          print("edit color clicked");
                          break;
                        case TodoCardSettings.delete:
                          print("delete clicked");
                          break;
                      }
                    },
                  ),
                ),
              )
            ],
          ),
          body: Padding(
            padding: EdgeInsets.only(left: 40.0, right: 40.0, top: 35.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Hero(
                      tag: widget.todoObject.id.toString() + "_icon",
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.grey.withAlpha(70),
                              style: BorderStyle.solid,
                              width: 1.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            widget.todoObject.icon,
                            color: widget.todoObject.color,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Hero(
                      tag: widget.todoObject.id.toString() + "_number_of_tasks",
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          widget.todoObject.taskAmount().toString() + " Tasks",
                          style: TextStyle(),
                          softWrap: false,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Hero(
                      tag: widget.todoObject.id.toString() + "_title",
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          widget.todoObject.title,
                          style: TextStyle(fontSize: 30.0),
                          softWrap: false,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Hero(
                      tag: widget.todoObject.id.toString() + "_progress_bar",
                      child: Material(
                        color: Colors.transparent,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: LinearProgressIndicator(
                                value: barPercent,
                                backgroundColor: Colors.grey.withAlpha(50),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    widget.todoObject.color),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Text(
                                  (barPercent * 100).round().toString() + "%"),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Hero(
                    tag: widget.todoObject.id.toString() + "_just_a_test",
                    child: Material(
                      type: MaterialType.transparency,
                      child: FadeTransition(
                        opacity: scaleAnimation,
                        child: ScaleTransition(
                            scale: scaleAnimation,
                            child: Container(
                              child: getTasksWidget(),
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 25),
            child: FloatingActionButton(
              elevation: 5.0,
              onPressed: () {
                showAddTaskSheet(context);
              },
              backgroundColor: Colors.white,
              child: Icon(
                Icons.add,
                size: 32,
                color: Colors.indigoAccent,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getTasksWidget() {
    return StreamBuilder(
      stream: widget.taskBloc.tasks,
      builder:
          (BuildContext context, AsyncSnapshot<List<TaskObject>> snapshot) {
        return getTaskCardWidget(snapshot);
      },
    );
  }

  Widget getTaskCardWidget(AsyncSnapshot<List<TaskObject>> snapshot) {
    //at the initial state of the operation there will be no stream so we need to handle the empty state
    if (snapshot.hasData) {
      List<TaskObject> filteredSnapshot = snapshot.data.where((item) => item.idTodo == widget.todoObject.id).toList();
      return filteredSnapshot.length > 0
          ? ListView.builder(
              padding: EdgeInsets.all(0.0),
              itemBuilder: (BuildContext context, int index) {
                List<Widget> tasks = [];
                filteredSnapshot.forEach((task) {
                  tasks.add(Dismissible(
                    key: Key(task.id.toString()),
                    direction: widget._dismissDirection,
                    onDismissed: (direction) {
                      widget.taskBloc.deleteTaskById(task.id);

                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("Tâche supprimée")));
                    },
                    child: CustomCheckboxListTile(
                      activeColor: widget.todoObject.color,
                      value: task.isCompleted(),
                      onChanged: (value) {
                        setState(() {
                          task.isComplete = value;
                          widget.taskBloc.updateTask(task);
                          updateBarPercent();
                        });
                      },
                      title: Text(task.task),
                    ),
                  ));
                });
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: tasks,
                );
              },
              itemCount: filteredSnapshot.length,
            )
          : Container(
              child: Center(
                child: noTaskMessageWidget(),
              ),
            );
    } else {
      return Center(
        child: noTaskMessageWidget(),
      );
    }
  }

  Widget noTaskMessageWidget() {
    return Column(
      children: [
        Container(
          child: Text(
            "Start adding Todo...",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        )
      ],
    );
  }

  saveTask(String text) {
    TaskObject task =
        TaskObject(idTodo: widget.todoObject.id, task: text, isComplete: false);
    widget.taskBloc.addTask(task);
  }

  void showAddTaskSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: new Container(
              color: Colors.transparent,
              child: new Container(
                height: 230,
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 15, top: 25.0, right: 15, bottom: 30),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: _textEditingController,
                              textInputAction: TextInputAction.newline,
                              maxLines: 4,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                              autofocus: true,
                              decoration: const InputDecoration(
                                  hintText: 'Je dois...',
                                  labelText: 'Nouvelle Tâche',
                                  hintStyle: TextStyle(
                                      fontSize: 16,),
                                  labelStyle: TextStyle(
                                      fontSize: 16,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500)),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'description vide!';
                                }
                                return value.contains('')
                                    ? 'N\'utilisez pas de @.'
                                    : null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5, top: 15),
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 18,
                              child: IconButton(
                                icon: Icon(
                                  Icons.add,
                                  size: 22,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  final newTask = TaskObject(
                                      task: _textEditingController.value.text, isComplete: false, idTodo: widget.todoObject.id);
                                  if (newTask.task.isNotEmpty) {
                                    widget.taskBloc.addTask(newTask);

                                    //dismisses the bottomsheet
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
