import 'dart:async';

import 'package:flutter/material.dart';

typedef TaskEventFunction = Future Function();

typedef TaskConditionFunction = FutureOr<bool> Function();

class TaskQueue{
  /// 任务编号队列
  final _actionQueue = <String>[];

  bool dealing = false;

  /// 任务条件
  final _actionCondition = <String, TaskConditionFunction>{};

  /// 总条件
  TaskConditionFunction? _condition;

  /// 任务队列
  final _actionMap = <String, TaskEventFunction>{};

  /// 指定taskId 为 -1 则不用去重
  String add(TaskEventFunction task, {
    String? taskId,
    TaskConditionFunction? condition,
  }) {
    String? id = taskId;
    id ??= task.hashCode.toString();
    bool isContains = false;
    if (condition != null && !_actionCondition.containsKey(id)) {
      _actionCondition[id] = condition;
    }
    if (taskId != '-1') {
      isContains = _actionQueue.contains(id);
    } else {
      id = task.hashCode.toString();
    }
    if (!isContains) {
      _actionQueue.add(id);
      _actionMap[id] = task;
    }
    return id;
  }

  /// 这里需注意，add的时taskId为-1，那就直接把task传入，add时有返回，可以对应
  bool remove(TaskEventFunction task, {String? taskId}) {
    String? id = taskId;
    id ??= task.hashCode.toString();
    if (_actionQueue.contains(id)) {
      _actionMap.remove(id);
      return _actionQueue.remove(id);
    }
    return false;
  }

  /// 是否队列中包含该任务
  /// [task] 与 [taskId] 应该只传一个
  bool containers({TaskEventFunction? task, String? taskId}) {
    assert(task != null || taskId != null);
    String? id = taskId;
    id ??= task.hashCode.toString();
    return _actionQueue.contains(taskId);
  }

  /// 设置允许执行条件
  void setAcceptConditions(TaskConditionFunction condition,
      {String? taskId}) {
    if (taskId == null) {
      _condition = condition;
    } else {
      _actionCondition[taskId] = condition;
    }
  }

  void startLoop() async {
    if (dealing || _actionQueue.isEmpty) {
      return;
    }
    dealing = true;
    String taskId = _actionQueue.first;
    TaskEventFunction? callback = _actionMap[taskId];
    if (callback == null) {
      _actionQueue.remove(taskId);
      return;
    }

    bool canNext = await _nextConditions(taskId);
    if (canNext) {
      try {
        await callback();
      } catch (e) {
        debugPrint('_actionQueue 出错 $e');
      } finally {
        _actionQueue.remove(taskId);
        _actionMap.remove(taskId);
        dealing = false;
        if (_actionQueue.isNotEmpty) {
          startLoop();
        }
      }
    } else {
      // 不满足条件一般后续的也不会执行
      dealing = false;
    }
  }

  Future<bool> _nextConditions([String? id]) async {
    String taskId = id ?? _actionQueue.first;
    bool canNext = true;
    var taskCondition = _actionCondition[taskId];
    if (_condition != null) {
      canNext = await _condition!.call();
    }
    if (canNext && taskCondition != null) {
      canNext = await taskCondition();
    }

    return Future.value(canNext);
  }
}