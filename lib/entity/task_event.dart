class TaskProgress {
  final String taskId;
  final int current;
  final int total;
  final bool upload;
  final int realCurrent;
  final int realTotal;

  TaskProgress({
    required this.taskId,
    required this.current,
    required this.total,
    required this.upload,
    required this.realCurrent,
    required this.realTotal
  });
}

class TaskResult {
  final String taskId;
  final bool success;
  final String? message;
  final bool upload;
  final bool cancel;

  TaskResult({
    required this.taskId,
    required this.success,
    this.message,
    required this.upload,
    required this.cancel,
  });
} 