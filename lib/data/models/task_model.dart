class TaskModel {
  final String? sId;
  final String? title;
  final String? description;
  final String? status;
  final String? createdDate;

  TaskModel({
    this.sId,
    this.title,
    this.description,
    this.status,
    this.createdDate,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      sId: json['_id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      createdDate: json['createdDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'title': title,
      'description': description,
      'status': status,
      'createdDate': createdDate,
    };
  }
}

class TaskListModel {
  final String? status;
  final List<TaskModel>? taskList;

  TaskListModel({this.status, this.taskList});

  factory TaskListModel.fromJson(Map<String, dynamic> json) {
    List<TaskModel> tasks = [];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        tasks.add(TaskModel.fromJson(v));
      });
    }
    return TaskListModel(
      status: json['status'],
      taskList: tasks,
    );
  }
}
