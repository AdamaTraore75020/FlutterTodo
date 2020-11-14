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

  @override
  void initState() {
    scaleAnimation = AnimationController(vsync: this, duration: Duration(milliseconds: 1000), lowerBound: 0.0, upperBound: 1.0);

    percentComplete = widget.todoObject.percentComplete();
    barPercent = percentComplete;
    animationBar = AnimationController(vsync: this, duration: Duration(milliseconds: 100))
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
    super.dispose();
    animationBar.dispose();
    scaleAnimation.dispose();
  }

  void updateBarPercent() async {
    double newPercentComplete = widget.todoObject.percentComplete();
    if (animationBar.status == AnimationStatus.forward || animationBar.status == AnimationStatus.completed) {
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
          tag: widget.todoObject.uuid + "_background",
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(0.0),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: Hero(
              tag: widget.todoObject.uuid + "_backIcon",
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
                tag: widget.todoObject.uuid + "_more_vert",
                child: Material(
                  color: Colors.transparent,
                  type: MaterialType.transparency,
                  child: PopupMenuButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.grey,
                    ),
                    itemBuilder: (context) => <PopupMenuEntry<TodoCardSettings>>[
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
                      tag: widget.todoObject.uuid + "_icon",
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.withAlpha(70), style: BorderStyle.solid, width: 1.0),
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
                      tag: widget.todoObject.uuid + "_number_of_tasks",
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
                      tag: widget.todoObject.uuid + "_title",
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
                      tag: widget.todoObject.uuid + "_progress_bar",
                      child: Material(
                        color: Colors.transparent,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: LinearProgressIndicator(
                                value: barPercent,
                                backgroundColor: Colors.grey.withAlpha(50),
                                valueColor: AlwaysStoppedAnimation<Color>(widget.todoObject.color),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Text((barPercent * 100).round().toString() + "%"),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Hero(
                    tag: widget.todoObject.uuid + "_just_a_test",
                    child: Material(
                      type: MaterialType.transparency,
                      child: FadeTransition(
                        opacity: scaleAnimation,
                        child: ScaleTransition(
                          scale: scaleAnimation,
                          child: Container(
                            child: getTasksWidget(),
                          )
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

    Widget getTasksWidget() {
    return StreamBuilder(
      stream: widget.taskBloc.tasks,
      builder: (BuildContext context, AsyncSnapshot<List<TaskObject>> snapshot) {
        return getTaskCardWidget(snapshot);
      },
    );
  }

  Widget getTaskCardWidget(AsyncSnapshot<List<TaskObject>> snapshot) {
    //at the initial state of the operation there will be no stream so we need to handle the empty state
    if (snapshot.hasData) {
      return snapshot.data.length > 0 
      ? ListView.builder(
        padding: EdgeInsets.all(0.0),
        itemBuilder: (BuildContext context, int index) {
          List<Widget> tasks = [];
          snapshot.data.forEach((task) {
            tasks.add(Dismissible(
              key: Key(task.id.toString()),
              direction: widget._dismissDirection,
              onDismissed: (direction) {
                widget.taskBloc.deleteTaskById(task.id);
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
        itemCount: snapshot.data.length,
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
    return Container(
      child: Text(
        "Start adding Todo...",
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
      ),
    );
  }
}
