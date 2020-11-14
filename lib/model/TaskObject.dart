
class TaskObject {
  int id;
  DateTime date;
  String task;
  bool isComplete = false;
  int idTodo;

  TaskObject({this.id, this.date, this.task, this.isComplete, this.idTodo});

  void setComplete(bool value) {
    isComplete = value;
  }

  isCompleted() => isComplete;

  factory TaskObject.fromDatabaseJson(Map<String, dynamic> data) => TaskObject(
    //Used to convert Json Object that are coming from database
    id: data['id'],
    task: data['task'],
    isComplete: data['is_complete'] == 0 ? false : true,
    idTodo: data['id_todo']
  );

  Map<String, dynamic> toDatabaseJson() => {
    //Used to convert object that will be stored in database
    "id": this.id,
    "task": this.task,
    "is_complete": this.isComplete == false ? 0 : 1,
    "id_todo": this.idTodo
  };

}
