import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:desk_cloud/alert/open_member_sheet.dart';
import 'package:desk_cloud/content/user/fake_downloader.dart';
import 'package:desk_cloud/content/user/local_notifications_logic.dart';
import 'package:desk_cloud/content/user/oss_logic.dart';
import 'package:desk_cloud/content/user/user_logic.dart';
import 'package:desk_cloud/database/file_io_record.dart';
import 'package:desk_cloud/entity/disk_file_entity.dart';
import 'package:desk_cloud/entity/task_event.dart';
import 'package:desk_cloud/utils/api.dart';
import 'package:desk_cloud/utils/api_net.dart';
import 'package:desk_cloud/utils/extension.dart';
import 'package:desk_cloud/utils/logutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';

import '../../utils/price_dialog_utils.dart';

/// This class extends OssLogic to override the download methods
/// to use FakeDownloader instead of direct OSS for non-VIP users
class FakeOssLogic extends OssLogic {
  late FakeDownloader _fakeDownloader;
  StreamSubscription? _fakeProgressSub;
  StreamSubscription? _fakeTaskSub;
  
  @override
  void onInit() {
    super.onInit();
    _setupFakeDownloader();
  }
  
  void _setupFakeDownloader() {
    logger.i('Setting up FakeDownloader in FakeOssLogic');
    _fakeDownloader = FakeDownloader(client);
    
    // 确保任何已有的订阅被取消
    _fakeProgressSub?.cancel();
    _fakeTaskSub?.cancel();
    
    // 先添加测试事件，确认监听器是否能够工作
    Future.delayed(const Duration(seconds: 1), () {
      logger.i('Testing event emission');
      _fakeDownloader.testProgressEmission();
    });
    
    // 设置进度事件监听
    _fakeProgressSub = _fakeDownloader.progressStream.listen(
      (event) {
        // 只处理下载事件
        if (!event.upload) {
          _handleProgressEvent(event);
        }
      },
      onError: (error) {
        logger.e('Error in progressStream: $error');
      },
    );
    
    // 设置结果事件监听
    _fakeTaskSub = _fakeDownloader.resultStream.listen(
      (event) {
        _handleResultEvent(event);
      },
      onError: (error) {
        logger.e('Error in resultStream: $error');
      },
    );
    
    logger.i('FakeDownloader setup complete');
  }
  
  // 处理进度事件
  void _handleProgressEvent(TaskProgress event) {

    logger.i('问题排查-------- 处理进度事件: ${event.taskId}, 当前进度: ${event.current}/${event.total} 文件总大小 total: ${event.total}');

    // 查找相关的下载任务
    final results = realm.query<FileIoDataRM>(r'taskId == $0', [event.taskId]);
    if (results.isEmpty) {
      logger.w('No task found for taskId: ${event.taskId}');
      return;
    }
    
    // 检查是否是VIP用户
    final bool isVip = user.memberEquity.value?.vipStatus == 1;
    
    // 更新任务状态和进度
    realm.writeAsync(() {
      var time = DateTime.now().millisecondsSinceEpoch;
      for (var value in results) {
        int lastTime = value.endTime ?? time;
        int lastProgress = value.current ?? 0;
        int timeDiff = time - lastTime;
        
        // 确保不会除以零
        if (timeDiff > 0) {
          // 计算下载速度（字节/秒）
          int rawSpeed = ((event.current - lastProgress) * 1000) ~/ timeDiff;
          if (value.current != null && value.total != null &&
              (value.current! / value.total!) >= 0.5 && !isVip) {
            // 检查非VIP用户是否在50%以后的阶段,限制在1k 以内
            rawSpeed = Random().nextInt(1000);
            logger.i('Random Speed: $rawSpeed');
          }
          // 检查非VIP用户是否在80%以后的阶段（实际下载中）
          // 这时需要调整显示的速度，因为实际进度被映射到20%的显示区间
          if (value.current != null && value.total != null && 
              (value.current! / value.total!) >= 0.8 && !isVip) {
            // 如果是实际下载阶段，实际下载速度需要除以0.2来反映在UI上
            // 因为从80%到100%的20%进度区间对应100%的实际下载
            rawSpeed = (rawSpeed / 0.2).toInt();
          }
          logger.i('rawSpeed: $rawSpeed');
          value.speed = rawSpeed;
        }

        value.current = event.current;
        value.total = event.total;
        value.endTime = time;
        value.status = 1; // 下载中状态
      }
    }).then((_) {
      downloadTaskList.refresh();
    }).catchError((error) {
      logger.e('Error updating task record: $error');
    });
  }
  
  // 处理结果事件
  void _handleResultEvent(TaskResult event) {
    if (event.upload) {
      logger.d('Ignoring upload event');
      return; // 忽略上传事件
    }
    
    // 查找相关的下载任务
    final results = realm.query<FileIoDataRM>(r'taskId == $0', [event.taskId]);
    if (results.isEmpty) {
      logger.w('No task found for taskId: ${event.taskId}');
      return;
    }
    
    // 更新任务状态
    realm.writeAsync(() {
      for (var value in results) {
        if (event.success) {
          value.status = 3; // 下载成功
          logger.i('Download success: ${event.taskId}');
        } else if (event.cancel) {
          value.status = value.status == 5 ? 5 : 2; // 保持并行暂停状态或设为取消状态
          logger.i('Download canceled: ${event.taskId}');
        } else {
          value.status = 4; // 下载失败
          logger.e('Download failed: ${event.taskId} - ${event.message}');
        }
        
        value.speed = 0;
        
        if (event.success) {
          value.endTime = DateTime.now().millisecondsSinceEpoch;
        }
      }
    }).then((_) {
      downloadTaskList.refresh();
      
      // 处理等待中的任务
      _processWaitingTasks();
      
      // 显示错误消息
      if (event.success == false && event.cancel == false) {
        showShortToast('下载失败，${event.message}');
        showOverlyTest("下载失败，${event.message}");
      }
    }).catchError((error) {
      logger.e('Error updating task record: $error');
    });
  }
  
  // 处理等待中的任务
  void _processWaitingTasks() {
    var downloadingRse = realm.query<FileIoDataRM>(r'type == $0 and status == 1 SORT(startTime desc)', [1]);
    var waitRse = realm.query<FileIoDataRM>(r'type == $0 and status == 5 SORT(startTime desc)', [1]);
    
    if (waitRse.isNotEmpty) {
      int maxTasks = int.tryParse(user.memberEquity.value?.configInfo?.maxTaskDownload ?? '0') ?? 0;
      int availableSlots = maxTasks - downloadingRse.length;
      
      logger.i('Processing waiting tasks - available slots: $availableSlots, waiting tasks: ${waitRse.length}');
      
      if (availableSlots > 0) {
        var tempWaitRes = waitRse.take(availableSlots);
        for (var item in tempWaitRes) {
          logger.i('Resuming waiting task: ${item.taskId}');
          renewDownload(item);
        }
      }
    } else if (downloadingRse.isEmpty) {
      logger.i('No active downloads, canceling notification');
      localNotificationsLogic.cancelNotification(0);
    }
  }
  
  @override
  Future<void> renewDownload(FileIoDataRM record) async {
    logger.i('Renewing download: ${record.taskId}');
    
    // 显示下载通知
    var res = await localNotificationsLogic.showDownloadNotification();
    if (res == null) {
      logger.w('Download notification rejected');
      return;
    } 
    
    await checkOssTime();
    
    if (record.status == 1) {
      logger.w('Task already downloading');
      return;
    }
    
    var downloading = realm.query<FileIoDataRM>(r'type == $0 and status == 1', [1]);
    if (downloading.length >= int.parse(user.memberEquity.value?.configInfo?.maxTaskDownload ?? '0')) {
      // 当超出并行任务时，根据VIP状态处理
      if (user.memberEquity.value?.vipStatus == 1) {
        // 保存所有必要的值，然后删除记录
        logger.i('Task limit reached for VIP user, creating parallel task: ${record.taskId}');
        final savedTaskId = record.taskId;
        final savedUserId = record.userId;
        final savedBucketName = record.bucketName;
        final savedFileName = record.fileName;
        final savedLocalPath = record.localPath;
        final savedDownloadRecordFile = record.downloadRecordFile;
        final savedType = record.type;
        final savedCurrent = record.current;
        final savedOssFileName = record.ossFileName;
        final savedTotal = record.total;
        const savedStatus = 5;
        final savedDirId = record.dirId;
        final savedThumb = record.thumb;
        final savedHasPasswd = record.hasPasswd;
        final savedFileType = record.fileType;
        final savedFileId = record.fileId;

        realm.writeAsync(() {
          final results = realm.query<FileIoDataRM>(r'taskId == $0', [savedTaskId]);
          realm.deleteMany(results);

          realm.add(FileIoDataRM(
            savedTaskId,
            savedUserId,
            savedBucketName,
            DateTime.now().millisecondsSinceEpoch,
            fileName: savedFileName,
            localPath: savedLocalPath,
            downloadRecordFile: savedDownloadRecordFile,
            type: savedType,
            current: savedCurrent,
            ossFileName: savedOssFileName,
            total: savedTotal,
            status: savedStatus,
            dirId: savedDirId,
            endTime: DateTime.now().millisecondsSinceEpoch,
            thumb: savedThumb,
            hasPasswd: savedHasPasswd,
            fileType: savedFileType,
            fileId: savedFileId
          ));
        }).then((value) => downloadTaskList.refresh());
        return;
      } else {
        logger.i('Task limit reached for non-VIP user, showing upgrade prompt');
        showShortToast('已达任务可执行上限，开通会员享受更多权益');
        showOpenMemberSheet(openMemberType: OpenMemberType.downloadTaskCount);
        return;
      }
    }
    if (user.memberEquity.value?.vipStatus != 1){
      // 非vip 弹窗
      PopupManager().showPriceAlert();
    }
       // 获取当前的下载进度和文件总大小
    int currentProgress = record.current ?? 0;
    int totalSize = record.total ?? 0;

    logger.i('Starting download with fake downloader: ${record.ossFileName} with progress: $currentProgress/$totalSize');
    final directory = await getApplicationDocumentsDirectory();
    
    // 使用保存的任务ID、当前进度和总大小进行续传
    var taskId = await _fakeDownloader.download(
      bucketName: record.bucketName, 
      ossFileName: record.ossFileName ?? '', 
      filePath: Platform.isAndroid ? record.localPath ?? '' : '${directory.path}${record.localPath}', 
      recordFile: Platform.isAndroid ? record.downloadRecordFile ?? '' : '${directory.path}${record.downloadRecordFile}',
      initialProgress: currentProgress,
      totalSize: totalSize,
      existingTaskId: record.taskId,
      checkOsstime: () async{
        await checkOssTime2();
      }
    );
    
    logger.i('Download started with taskId: $taskId');
    realm.writeAsync(() {
      record.taskId = taskId;
      record.status = 1;
      record.endTime = DateTime.now().millisecondsSinceEpoch;
      // 不修改current和total值以保留之前的进度
    }).then((value) {
      downloadTaskList.refresh();
      logger.i('Task record updated for: $taskId');
    });
  }
  
  @override
  Future<bool> download(int fileId) async {
    logger.i('Download requested for fileId: $fileId');
    await checkOssTime();
    
    DiskFileEntity? file;
    try {
      var base = await ApiNet.request<DiskFileEntity>(Api.diskDetail, data: {
        'file_id': fileId
      });
      file = base.data;
      logger.i('File details retrieved: ${file?.title}');
    } catch(e) {
      logger.e('Error retrieving file details: $e');
      showShortToast(e.toString());
      return false;
    }
    
    if (file == null) {
      logger.e('File not found');
      showShortToast('文件不存在');
      return false;
    }

    var localDirPath = await _getDownloadPath();
    final directory = await getApplicationDocumentsDirectory();
    String localPath;
    String recordDirPath;
    
    try {
      if (Platform.isAndroid) {
        final dir = Directory(localDirPath);
        if (!await dir.exists()) {
          await dir.create(recursive: true);
          logger.i('Created download directory: ${dir.path}');
        }

        // 生成唯一文件名
        final uniqueTitle = await _generateUniqueFileName(
          dir.path,
          file.title ?? 'unknown'
        );
        logger.i('Generated unique filename: $uniqueTitle');
        
        // 更新file.title为新的唯一文件名
        file = file.copyWith(title: uniqueTitle);
        
        localPath = '${dir.path}/$uniqueTitle';
        recordDirPath = '${dir.path}/downloadRecord';
        var recordDir = Directory(recordDirPath);
        if (!(await recordDir.exists())) {
          await recordDir.create();
          logger.i('Created record directory: ${recordDir.path}');
        }
      } else {
        final dir = Directory('${directory.path}$localDirPath');
        if (!await dir.exists()) {
          await dir.create(recursive: true);
          logger.i('Created download directory: ${dir.path}');
        }

        // 生成唯一文件名
        final uniqueTitle = await _generateUniqueFileName(
          dir.path,
          file.title ?? 'unknown'
        );
        logger.i('Generated unique filename: $uniqueTitle');
        
        // 更新file.title为新的唯一文件名
        file = file.copyWith(title: uniqueTitle);

        localPath = '$localDirPath/$uniqueTitle';
        recordDirPath = '$localDirPath/downloadRecord';
        var recordDir = Directory('${directory.path}$recordDirPath');
        if (!(await recordDir.exists())) {
          await recordDir.create();
          logger.i('Created record directory: ${recordDir.path}');
        }
      }

      // 确定下载状态和是否需要取消
      int status = await _determineDownloadStatus();
      var taskId = generateTaskId();
      logger.i('Initial download status: $status, generated taskId: $taskId');
      
      if (await _shouldCancelDownload()) {
        status = 5;
        logger.i('Download should be queued for later (status 5)');
      } else {
        logger.i('Starting download with fake downloader: ${file.title}');
        // 使用FakeDownloader而不是直接OSS客户端
        taskId = await _fakeDownloader.download(
          bucketName: file.bucket ?? '', 
          ossFileName: file.path ?? '', 
          filePath: Platform.isAndroid ? localPath : '${directory.path}$localPath', 
          recordFile: Platform.isAndroid ? recordDirPath : '${directory.path}$recordDirPath',
          totalSize: file.sizeBt,
          checkOsstime: () async{
            await checkOssTime2();
          },
        );
        logger.i('Download started with taskId: $taskId');
      }

      // 添加下载记录
      await realm.writeAsync(() {
        realm.add(
          FileIoDataRM(
            taskId, 
            user.memberEquity.value?.id ?? 0, 
            file?.bucket ?? '', 
            DateTime.now().millisecondsSinceEpoch,
            fileName: file?.title,
            localPath: localPath,
            downloadRecordFile: recordDirPath,
            type: 1,
            current: 0,
            ossFileName: file?.path,
            total: file?.sizeBt ?? 1,
            status: status,
            dirId: file?.id,
            endTime: DateTime.now().millisecondsSinceEpoch,
            thumb: file?.thumb,
            hasPasswd: file?.hasPwd ?? 0,
            fileType: file?.dataType ?? 100,
            fileId: file?.id ?? 0
          )
        );
      }).then((_) {
        downloadTaskList.refresh();
        logger.i('Download record created for taskId: $taskId');
      });
      
      return true;
    } catch (e) {
      logger.e('Error during download process: $e');
      return false;
    }
  }
  
  // 获取下载路径
  Future<String> _getDownloadPath() async {
    if (Platform.isAndroid) {
      final downloadDir = Directory('/storage/emulated/0/Download/KuaiTuDownloads/CloudDrive');
      return downloadDir.path;
    } else {
      return '/KuaiTuDownloads/CloudDrive';
    }
  }

  // 生成唯一文件名
  Future<String> _generateUniqueFileName(String dirPath, String fileName) async {
    // 处理文件名中的特殊字符
    String safeName = fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
    
    // 分离文件名和扩展名
    String extension = '';
    String nameWithoutExt = safeName;
    final lastDotIndex = safeName.lastIndexOf('.');
    
    if (lastDotIndex != -1) {
      extension = safeName.substring(lastDotIndex);
      nameWithoutExt = safeName.substring(0, lastDotIndex);
    }

    String finalName = safeName;
    int counter = 1;
    
    // 检查文件是否存在或正在下载
    while (await File('$dirPath/$finalName').exists() || _isFileDownloading(finalName)) {
      finalName = '$nameWithoutExt($counter)$extension';
      counter++;
    }
    
    return finalName;
  }

  // 检查文件是否正在下载
  bool _isFileDownloading(String fileName) {
    // 查询所有正在下载的任务（状态为0-创建、1-下载中、5-并行暂停）
    var downloadingFiles = realm.query<FileIoDataRM>(
      r'type == $0 AND fileName == $1',
      [1, fileName]
    );
    
    return downloadingFiles.isNotEmpty;
  }

  // 确定下载状态
  Future<int> _determineDownloadStatus() async {
    var downloadingRse = realm.query<FileIoDataRM>(r'type == $0 and status == 1', [1]);
    return downloadingRse.length >= int.parse(user.memberEquity.value?.configInfo?.maxTaskDownload ?? '0') ? 0 : 1;
  }

  // 检查是否应该取消下载
  Future<bool> _shouldCancelDownload() async {
    var downloading = realm.query<FileIoDataRM>(r'type == $0 and status == 1', [1]);
    int maxTasks = int.parse(user.memberEquity.value?.configInfo?.maxTaskDownload ?? '0');
    return downloading.length >= maxTasks;
  }
  
  @override
  Future<void> cancelTask(FileIoDataRM record) async {
    logger.i('Canceling task: ${record.taskId}');
    try {
      showLoading();
      await checkOssTime();
      
      // 使用_fakeDownloader替代client
      await _fakeDownloader.cancelTask(taskId: record.taskId);
      logger.i('Task canceled successfully: ${record.taskId}');
      
      realm.writeAsync(() {
        record.status = 2;
        record.speed = 0;
      }).then((value) {
        if (record.type == 0) {
          uploadTaskList.refresh();
        } else {
          downloadTaskList.refresh();
        }
        logger.i('Task record updated as canceled: ${record.taskId}');
      }); 
      dismissLoading();
    } catch (e) {
      logger.e('Error canceling task: $e');
      dismissLoading();
      showShortToast(e.toString());
    }
  }
  
  @override
  Future<void> reInitOssSDK() async {
    logger.i('Reinitializing OSS SDK');
    await super.reInitOssSDK();
    // 使用新的OSS客户端重新创建fake downloader
    _fakeDownloader.dispose();
    _fakeProgressSub?.cancel();
    _fakeTaskSub?.cancel();
    _setupFakeDownloader();
  }
  
  @override
  void dispose() {
    logger.i('Disposing FakeOssLogic');
    _fakeDownloader.dispose();
    _fakeProgressSub?.cancel();
    _fakeTaskSub?.cancel();
    super.dispose();
  }
  
  // 生成唯一任务ID
  String generateTaskId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(10000).toString().padLeft(4, '0');
    return '${timestamp}_$random';
  }
} 