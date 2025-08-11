class TaskProgress{
  final String taskId;
  final int current;
  final int total;
  bool upload = true;
  TaskProgress(this.taskId,this.current,this.total);

  static TaskProgress fromJson(Map data){
    return TaskProgress(data['taskId'], data['current'], data['total']);
  }
}