class TaskResult{
  final bool success;
  final bool cancel;
  final String taskId;
  final String? message;
  bool upload = true;
  TaskResult(this.taskId,this.success,this.cancel,this.message);

  static TaskResult fromJson(dynamic data){
    return TaskResult(data?['taskId'], data?['success'] == 1 ? true : false, data?['cancel'] == 1 ? true : false, data?['message']);
  }
}