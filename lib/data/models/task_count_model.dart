class TaskStatusCountModel {
  final String? sId;
  final int? sum;

  TaskStatusCountModel({this.sId, this.sum});

  factory TaskStatusCountModel.fromJson(Map<String, dynamic> json) {
    return TaskStatusCountModel(
      sId: json['_id'],
      sum: json['sum'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'sum': sum,
    };
  }
}

class TaskCountListModel {
  final String? status;
  final List<TaskStatusCountModel>? statusCountList;

  TaskCountListModel({this.status, this.statusCountList});

  factory TaskCountListModel.fromJson(Map<String, dynamic> json) {
    List<TaskStatusCountModel> list = [];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        list.add(TaskStatusCountModel.fromJson(v));
      });
    }
    return TaskCountListModel(
      status: json['status'],
      statusCountList: list,
    );
  }
}
