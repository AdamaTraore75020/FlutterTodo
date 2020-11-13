
class TaskObject {
  int id;
  DateTime date;
  String task;
  bool isComplete = false;

  TaskObject({this.id, this.date, this.task, this.isComplete});

  void setComplete(bool value) {
    isComplete = value;
  }

  isCompleted() => isComplete;

  TaskObject.import(String task, DateTime date, bool completed) {
    this.task = task;
    this.date = date;
    this.isComplete = completed;
  }

  factory TaskObject.fromDatabaseJson(Map<String, dynamic> data) => TaskObject(
    //Used to convert Json Object that are coming from database
    id: data['id'],
    task: data['task'],
    isComplete: data['is_complete'] == 0 ? false : true
  );

  Map<String, dynamic> toDatabaseJson() => {
    //Used to convert object that will be stored in database
    "id": this.id,
    "task": this.task,
    "is_complete": this.isComplete == false ? 0 : 1
  };

}
