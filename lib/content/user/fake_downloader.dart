import 'dart:async';
import 'dart:math';

import 'package:desk_cloud/content/tabs/tab_io_logic.dart';
import 'package:desk_cloud/content/user/oss_logic.dart';
import 'package:desk_cloud/content/user/user_logic.dart';
import 'package:desk_cloud/entity/task_event.dart';
import 'package:desk_cloud/utils/api.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/utils/logutil.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_client_oss/flutter_client_oss.dart';
import 'package:get/get.dart';

class FakeDownloader {
  final FlutterClientOss _client;
  final _random = Random();
  final Map<String, _FakeDownloadTask> _fakeTasks = {};
  final Map<String, String> _realTaskMapping =
      {}; // Maps fake taskId to real taskId

  // 使用PublishSubject替代StreamController获得更好的广播能力
  final _progressController = StreamController<TaskProgress>.broadcast();
  final _resultController = StreamController<TaskResult>.broadcast();

  // Subscriptions for real client streams
  StreamSubscription? _realProgressSub;
  StreamSubscription? _realResultSub;

  // 确保监听能够在添加事件之前建立
  late final Stream<TaskProgress> progressStream;
  late final Stream<TaskResult> resultStream;

  // 进度更新的时间间隔，参考OssLogic中的设置
  final Duration progressUpdateDuration = const Duration(seconds: 1); // 设置为1分钟

  // 记录每个任务的最后更新时间
  final Map<String, DateTime> _lastProgressUpdateTimes = {};

  FakeDownloader(this._client) {
    progressStream = _progressController.stream.asBroadcastStream();
    resultStream = _resultController.stream.asBroadcastStream();
    _initRealClientListeners();
    logger.i('FakeDownloader initialized');
  }

  void _initRealClientListeners() {
    _realProgressSub = _client.progressStream.stream.listen((event) {
      // Find the fake task ID corresponding to this real task
      String? mappedFakeTaskId;

      for (final entry in _realTaskMapping.entries) {
        if (entry.value == event.taskId.toString()) {
          mappedFakeTaskId = entry.key;
          break;
        }
      }

      final String? fakeTaskId = mappedFakeTaskId;

      if (fakeTaskId != null && _fakeTasks.containsKey(fakeTaskId)) {
        final fakeTask = _fakeTasks[fakeTaskId]!;

        // 检查是否需要更新进度（间隔至少为progressUpdateDuration）
        // 或者是最后一个进度更新（当前进度等于总进度）
        DateTime lastUpdate = _lastProgressUpdateTimes[fakeTaskId] ??
            DateTime.fromMillisecondsSinceEpoch(0);
        bool shouldUpdate =
            DateTime.now().difference(lastUpdate) >= progressUpdateDuration;
        bool isLastProgress = false;

        if (fakeTask.isVip) {
          isLastProgress = event.current == event.total;
        } else if (fakeTask.realDownloadStarted) {
          double realProgress = event.current / event.total;
          isLastProgress = realProgress >= 0.99; // 99% 视为最后进度
        }

        if (shouldUpdate || isLastProgress) {
          _lastProgressUpdateTimes[fakeTaskId] = DateTime.now();

          // Calculate the adjusted progress based on real download
          if (fakeTask.isVip) {
            // For VIP users, pass through the real progress directly
            final progress = TaskProgress(
                taskId: fakeTaskId,
                current: event.current,
                total: event.total,
                upload: event.upload,
                realCurrent: event.current,
                realTotal: event.total);
            _progressController.add(progress);
          } else if (fakeTask.realDownloadStarted) {
            // For non-VIP users who reached 80% with fake download
            // Each 1% of real progress translates to 0.2% of total progress
            // The range is from 80% to 100% of total progress
            double realProgress = event.current / event.total;

            int adjustedCurrent =
                (fakeTask.fakeTotal * (0.8 + (realProgress * 0.2))).toInt();

            final progress = TaskProgress(
                taskId: fakeTaskId,
                current: adjustedCurrent,
                total: fakeTask.fakeTotal,
                upload: event.upload,
                realCurrent: event.current,
                realTotal: event.total);
            if (shouldUpdate) {
              _progressController.add(progress);
            }
          }
        }
      } else {
        // 对于非跟踪的任务，也应用相同的节流逻辑
        DateTime lastUpdate = _lastProgressUpdateTimes[event.taskId] ??
            DateTime.fromMillisecondsSinceEpoch(0);
        bool shouldUpdate =
            DateTime.now().difference(lastUpdate) >= progressUpdateDuration;
        bool isLastProgress = event.current == event.total;

        if (shouldUpdate || isLastProgress) {
          _lastProgressUpdateTimes[event.taskId] = DateTime.now();

          // Pass through real progress events for tasks we're not tracking
          final progress = TaskProgress(
              taskId: event.taskId.toString(),
              current: event.current,
              total: event.total,
              upload: event.upload,
              realCurrent: event.current,
              realTotal: event.total);
          _progressController.add(progress);
        }
      }
    });

    _realResultSub = _client.resultStream.stream.listen((event) {
      // Find the fake task ID corresponding to this real task
      String? mappedFakeTaskId;

      for (final entry in _realTaskMapping.entries) {
        if (entry.value == event.taskId.toString()) {
          mappedFakeTaskId = entry.key;
          break;
        }
      }

      final String? fakeTaskId = mappedFakeTaskId;

      if (fakeTaskId != null) {
        // Create a new result event with the fake task ID
        final result = TaskResult(
          taskId: fakeTaskId,
          success: event.success,
          message: event.message,
          upload: event.upload,
          cancel: event.cancel,
        );
        _resultController.add(result);
        logger
            .d('Real result for task: $fakeTaskId - success: ${event.success}');

        // Clean up task data
        _fakeTasks.remove(fakeTaskId);
        _realTaskMapping.remove(fakeTaskId);
        _lastProgressUpdateTimes.remove(fakeTaskId);
      } else {
        // Pass through real result events for tasks we're not tracking
        final result = TaskResult(
          taskId: event.taskId.toString(),
          success: event.success,
          message: event.message,
          upload: event.upload,
          cancel: event.cancel,
        );
        _resultController.add(result);

        // Clean up
        _lastProgressUpdateTimes.remove(event.taskId);
      }
    });

    logger.i('Real client listeners initialized');
  }

  // Download method that handles both fake and real downloads
  Future<String> download({
    required String bucketName,
    required String ossFileName,
    required String filePath,
    required String recordFile,
    int? initialProgress = 0,
    int? totalSize,
    String? existingTaskId,
    Future Function()? checkOsstime,
  }) async {
    // Use existing taskId or generate a new one
    final taskId = existingTaskId ?? _generateTaskId();
    logger.i(
        'Starting download with taskId: $taskId, initialProgress: $initialProgress, totalSize: $totalSize');

    // Check if user is VIP
    final isVip = user.memberEquity.value?.vipStatus == 1;
    logger.i('User is VIP: $isVip');

    if (isVip) {
      // For VIP users, directly use the real OSS download
      logger.i('VIP user - using real download');
      final realTaskId = await _client.download(
        bucketName: bucketName,
        ossFileName: ossFileName,
        filePath: filePath,
        recordFile: recordFile,
      );

      // Store the mapping between our task ID and the real task ID
      _realTaskMapping[taskId] = realTaskId.toString();
      _fakeTasks[taskId] = _FakeDownloadTask(
        taskId: taskId,
        realTaskId: realTaskId.toString(),
        filePath: filePath,
        ossFileName: ossFileName,
        isVip: true,
        fakeTotal: totalSize ?? 0, // Use provided total size if available
        fakeProgress: initialProgress ?? 0,
      );

      // 初始化最后更新时间
      _lastProgressUpdateTimes[taskId] = DateTime.now();

      logger.i('Real download started with realTaskId: $realTaskId');
      return taskId;
    } else {
      // Create and start a fake download task
      final task = _FakeDownloadTask(
        taskId: taskId,
        realTaskId: '',
        filePath: filePath,
        ossFileName: ossFileName,
        isVip: false,
        fakeTotal: totalSize!,
        fakeProgress: initialProgress ?? 0, // Use initial progress if provided
        bucketName: bucketName,
        recordFile: recordFile,
      );

      _fakeTasks[taskId] = task;

      // 初始化最后更新时间
      _lastProgressUpdateTimes[taskId] = DateTime.now();

      logger.i(
          'Non-VIP user - starting fake download with size: $totalSize, initial progress: ${initialProgress ?? 0}');

      // Emit initial progress immediately
      if (initialProgress != null && initialProgress > 0) {
        _progressController.add(TaskProgress(
            taskId: taskId,
            current: initialProgress,
            total: totalSize,
            upload: false,
            realCurrent: 0,
            realTotal: 0));
      }
      // Start the fake download from the current progress
      _startFakeDownload(task,checkOsstime);

      return taskId;
    }
  }

  // Cancel a specific task
  Future<void> cancelTask({required String taskId}) async {
    logger.i('Canceling task: $taskId');
    final task = _fakeTasks[taskId];
    if (task != null) {
      // Cancel the timer for the fake download
      task.timer?.cancel();

      // If real download has started, cancel that too
      if (task.realTaskId.isNotEmpty) {
        logger.i('Canceling real task: ${task.realTaskId}');
        await _client.cancelTask(taskId: task.realTaskId);
      }

      // Emit a cancel event
      final result = TaskResult(
        taskId: taskId,
        success: false,
        message: 'Canceled by user',
        upload: false,
        cancel: true,
      );
      _resultController.add(result);
      logger.i('Emitted cancel event for task: $taskId');

      // Clean up
      _fakeTasks.remove(taskId);
      _realTaskMapping.remove(taskId);
      _lastProgressUpdateTimes.remove(taskId);
    } else {
      // If we don't have it in our fake tasks, try to cancel on the real client
      logger
          .i('Task not found in fake tasks, canceling on real client: $taskId');
      await _client.cancelTask(taskId: taskId);
    }
  }

  // Cancel all tasks
  Future<void> cancelAllTask() async {
    logger.i('Canceling all tasks');
    // Cancel all fake tasks
    for (final taskId in _fakeTasks.keys.toList()) {
      await cancelTask(taskId: taskId);
    }

    // Clean up all tracking
    _lastProgressUpdateTimes.clear();

    // Cancel all real tasks
    await _client.cancelAllTask();
  }

  DateTime? lastInternalProgressUpdate = null;

  // Start or continue fake download progress
  void _startFakeDownload(_FakeDownloadTask task,Future Function()? checkOsstime) {
    // Random speed between 90-110 KB/s
    final maxProcess = 0.5;
    final baseSpeedKBps = 100; // 100KB/s
    logger.i(
        'Starting fake download for task: ${task.taskId} from progress: ${task.fakeProgress}/${task.fakeTotal}');

    // 如果已经达到80%，直接开始真实下载
    if (task.fakeProgress >= task.fakeTotal * 0.8) {
      logger.i(
          'Initial progress already at or beyond 80%, switching directly to real download');
      // _switchToRealDownload(task);
      // return;
    }

    // 用于跟踪假下载的内部进度更新
    // DateTime lastInternalProgressUpdate = DateTime.now();
    String coolTime = SP.coolDown;
    task.timer = Timer.periodic(const Duration(milliseconds: 100), (timer) async{
      // Check if user became VIP mid-download
      if (user.memberEquity.value?.vipStatus == 1 && !task.isVip) {
        logger.i(
            'User upgraded to VIP during fake download. Switching to real download.');
        task.isVip = true;
        _switchToRealDownload(task);
        timer.cancel();
        return;
      }

      // Calculate progress increment for this tick (100ms)
      int speedVariation = _random.nextInt(41); // 0 to 30 KB/s variation
      int currentSpeedKBps = speedVariation;
      int bytesThisTick =
          ((currentSpeedKBps * 1024) / 10).toInt(); // KB/s * 0.1 seconds
      if(task.fakeProgress >= task.fakeTotal * maxProcess){
        logger.i('已经到最大进度了，等待升级vip  coolTime=$coolTime');
        bytesThisTick = 0;
        lastInternalProgressUpdate ??= DateTime.now();
        if(coolTime.isNotEmpty){
          int duration = int.parse(coolTime) * 60 * 60 * 1000;
          DateTime current = DateTime.now();
          if(current.millisecondsSinceEpoch > (duration + lastInternalProgressUpdate!.millisecondsSinceEpoch)){
            timer.cancel();
            logger.i('后台解禁时间到了，切换到真实下载');
            if(checkOsstime != null){
              await checkOsstime.call();
            }
            _pauseDownload();
            return;
            // _switchToRealDownload(task);
          }
        } else{
          timer.cancel();
          if(checkOsstime != null){
            await checkOsstime.call();
          }
          _switchToRealDownload(task);
        }
      }
      task.fakeProgress += bytesThisTick;

      // Cap at 80% for non-VIP users
      // if (task.fakeProgress >= task.fakeTotal * 0.8 &&
      //     !task.realDownloadStarted) {
      //   task.fakeProgress = (task.fakeTotal * 0.8).toInt();
      //   // Start the real download in the background when we reach 80%
      //   timer.cancel();
      //   _switchToRealDownload(task);
      //   return;
      // }

      // 检查是否需要更新进度（间隔至少为progressUpdateDuration）
      // 或者是最后一个进度更新（当前进度达到80%）
      DateTime lastUpdate = _lastProgressUpdateTimes[task.taskId] ??
          DateTime.fromMillisecondsSinceEpoch(0);
      bool shouldUpdate =
          DateTime.now().difference(lastUpdate) >= progressUpdateDuration;
      bool isLastProgress =
          task.fakeProgress >= task.fakeTotal * 0.8; // 80% 是假下载的最大进度

      if (shouldUpdate || isLastProgress) {
        _lastProgressUpdateTimes[task.taskId] = DateTime.now();

        // Emit progress event
        final progress = TaskProgress(
            taskId: task.taskId,
            current: task.fakeProgress,
            total: task.fakeTotal,
            upload: false,
            realCurrent: 0,
            realTotal: 0);

        try {
          _progressController.add(progress);
        } catch (e) {
          logger.e('Error emitting progress event: $e');
        }
      }

      logger.i('进度更新  fakeProgress = ${task.fakeProgress} fakeTotal= ${task.fakeTotal} coolTime=${coolTime}');
    });
  }

  void _pauseDownload() async{
    logger.i("暂停下载");
    lastInternalProgressUpdate = DateTime.now();
    final logic = Get.find<TabIoLogic>();
    for (var item in logic.ioDates) {
      await oss.cancelTask(item.item);
    }
  }

  void _switchToRealDownload(_FakeDownloadTask task) async {
    task.realDownloadStarted = true;
    logger.i('Switching to real download for task: ${task.taskId}');
    try {
      // Start the real download
      final realTaskId = await _client.download(
        bucketName: task.bucketName!,
        ossFileName: task.ossFileName,
        filePath: task.filePath,
        recordFile: task.recordFile!,
      );

      task.realTaskId = realTaskId.toString();
      _realTaskMapping[task.taskId] = task.realTaskId;
      logger.i(
          'Real download started with realTaskId: ${task.realTaskId} for fakeTaskId: ${task.taskId}');
    } catch (e) {
      logger.e('Error starting real download: $e');
      // Emit failure event
      final result = TaskResult(
        taskId: task.taskId,
        success: false,
        message: 'Failed to start real download: $e',
        upload: false,
        cancel: false,
      );
      _resultController.add(result);

      _fakeTasks.remove(task.taskId);
      _lastProgressUpdateTimes.remove(task.taskId);
    }
  }

  // Generate a unique task ID
  String _generateTaskId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = _random.nextInt(10000).toString().padLeft(4, '0');
    return '${timestamp}_$random';
  }

  // Dispose to clean up resources
  void dispose() {
    logger.i('Disposing FakeDownloader');
    // Cancel all tasks
    cancelAllTask();

    // Cancel all subscriptions
    _realProgressSub?.cancel();
    _realResultSub?.cancel();

    // Close controllers
    _progressController.close();
    _resultController.close();
  }

  // 用于测试的方法 - 检查监听器是否工作
  void testProgressEmission() {
    final testProgress = TaskProgress(
      taskId: 'test_task_id',
      current: 100,
      total: 1000,
      upload: false,
      realCurrent: 0,
      realTotal: 0,
    );

    try {
      _progressController.add(testProgress);
      logger.i('Emitted test progress event');
    } catch (e) {
      logger.e('Error emitting test progress: $e');
    }
  }
}

// Helper class to track fake download task information
class _FakeDownloadTask {
  final String taskId;
  String realTaskId;
  final String filePath;
  final String ossFileName;
  bool isVip;
  final int fakeTotal;
  int fakeProgress = 0;
  bool realDownloadStarted = false;
  Timer? timer;
  String? bucketName;
  String? recordFile;

  _FakeDownloadTask({
    required this.taskId,
    required this.realTaskId,
    required this.filePath,
    required this.ossFileName,
    required this.isVip,
    required this.fakeTotal,
    this.fakeProgress = 0,
    this.bucketName,
    this.recordFile,
  });
}
