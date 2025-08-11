import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:desk_cloud/alert/go_to_see_dialog.dart';
import 'package:desk_cloud/alert/mobile_file/mobile_file_sheet.dart';
import 'package:desk_cloud/alert/normal_dialog.dart';
import 'package:desk_cloud/alert/open_member_sheet.dart';
import 'package:desk_cloud/alert/unzip_progress_dialog.dart';
import 'package:desk_cloud/content/io/io_parent_logic.dart';
import 'package:desk_cloud/content/io/uncompress_sub_logic.dart';
import 'package:desk_cloud/content/tab_parent_logic.dart';
import 'package:desk_cloud/content/user/fake_oss_logic.dart';
import 'package:desk_cloud/content/user/local_notifications_logic.dart';
import 'package:desk_cloud/content/user/socket_logic.dart';
import 'package:desk_cloud/content/user/user_logic.dart';
import 'package:desk_cloud/database/file_io_record.dart';
import 'package:desk_cloud/entity/disk_file_entity.dart';
import 'package:desk_cloud/entity/file_normal_search_entity.dart';
import 'package:desk_cloud/entity/file_pre_entity.dart';
import 'package:desk_cloud/entity/sts_entity.dart';
import 'package:desk_cloud/entity/unzip_entity.dart';
import 'package:desk_cloud/utils/api.dart';
import 'package:desk_cloud/utils/api_net.dart';
import 'package:desk_cloud/utils/base_logic.dart';
import 'package:desk_cloud/utils/extension.dart';
import 'package:desk_cloud/utils/logutil.dart';
import 'package:desk_cloud/utils/my_router.dart';
import 'package:desk_cloud/utils/sand_box_manager.dart';
import 'package:desk_cloud/utils/zip_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client_oss/flutter_client_oss.dart';
import 'package:get/get.dart';
import 'package:md5_file_checksum/md5_file_checksum.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:realm/realm.dart';

class OssLogic extends BaseLogic {
  final client = FlutterClientOss();
  StreamSubscription? _progressSub;
  StreamSubscription? _taskSub;
  var _uploadRecordDirPath = '';
  late Realm realm = Realm(Configuration.local(
    [FileIoDataRM.schema],
    schemaVersion: 4,
    migrationCallback: (migration, oldSchemaVersion) async {},
  ));
  late final uploadTaskList = realm.query<FileIoDataRM>(
      r'type == $0 AND userId == $1 SORT(startTime desc)',
      [0, user.memberEquity.value?.id ?? 0]).obs;
  late final downloadTaskList = realm.query<FileIoDataRM>(
      r'type == $0 AND userId == $1 SORT(startTime desc)',
      [1, user.memberEquity.value?.id ?? 0]).obs;
  final uploadSpeed = 0.0.obs;
  final downloadSpeed = 0.0.obs;
  final uploadSuccessCount = 0.obs;
  final uploadTaskCount = 0.obs;
  final uploadPlayingCount = 0.obs;
  final uploadFailCount = 0.obs;
  final downloadSuccessCount = 0.obs;
  final downloadTaskCount = 0.obs;
  final downloadPlayingCount = 0.obs;
  final downloadFailCount = 0.obs;
  String? defaultBucket;

  /// 并行数量限制
  // int parallelQuantity = 2;

  /// 查看所有数据
  void printAllData() {
    // 获取所有 FileIoDataRM 记录
    final allRecords = realm.all<FileIoDataRM>();

    debugPrint('=== 数据库中共有 ${allRecords.length} 条记录 ===');

    for (var record in allRecords) {
      debugPrint('''
      记录ID: ${record.taskId}
      用户ID: ${record.userId}
      文件名: ${record.fileName}
      本地路径: ${record.localPath}
      下载记录路径: ${record.downloadRecordFile}
      上传记录路径: ${record.uploadRecordPath}
      OSS文件名: ${record.ossFileName}
      状态: ${record.status}
      类型: ${record.type}
      文件类型: ${record.fileType}
      文件ID: ${record.fileId}
      当前进度: ${record.current}
      总大小: ${record.total}
      是否有密码: ${record.hasPasswd}
      开始时间: ${DateTime.fromMillisecondsSinceEpoch(record.startTime)}
      结束时间: ${record.endTime != null ? DateTime.fromMillisecondsSinceEpoch(record.endTime!) : '未结束'}
      ==============================
      ''');
    }
  }

  @override
  void onInit() {
    super.onInit();
    ever(uploadTaskList, (callback) {
      uploadTaskCount.value = callback.length;
      uploadFailCount.value = callback.query('status == 4').length;
      uploadPlayingCount.value = callback
          .query('status == 1 || status == 2 || status == 0 || status == 5')
          .length;
      uploadSuccessCount.value = callback.query('status == 3').length;
      var results = callback.query('status == 1');
      if (results.isEmpty) {
        uploadSpeed.value = 0;
      } else {
        var s = 0;
        for (var value in results) {
          s += (value.speed ?? 0);
        }
        uploadSpeed.value = s * 1.0;
      }
    });
    ever(downloadTaskList, (callback) {
      downloadTaskCount.value = callback.length;
      downloadFailCount.value = callback.query('status == 4').length;
      downloadPlayingCount.value = callback
          .query('status == 1 || status == 2 || status == 0 || status == 5')
          .length;
      downloadSuccessCount.value = callback.query('status == 3').length;
      var results = callback.query('status == 1');
      if (results.isEmpty) {
        downloadSpeed.value = 0;
      } else {
        var s = 0;
        for (var value in results) {
          s += (value.speed ?? 0);
        }
        downloadSpeed.value = s * 1.0;
      }
    });
  }

  initSdk() async {
    uploadTaskList.value = realm.query<FileIoDataRM>(
        r'type == $0 AND userId == $1 SORT(startTime desc)',
        [0, user.memberEquity.value?.id ?? 0]);
    uploadTaskList.refresh();
    downloadTaskList.value = realm.query<FileIoDataRM>(
        r'type == $0 AND userId == $1 SORT(startTime desc)',
        [1, user.memberEquity.value?.id ?? 0]);
    downloadTaskList.refresh();
    _progressSub?.cancel();
    _taskSub?.cancel();
    _uploadRecordDirPath = '/uploadRecord';
    try {
      await reInitOssSDK();
      // client.setSpeedLimit(8 * 1024 * 120);
      // client.setSpeedLimit(819200);
      logger.i(
          '设置限速 ${int.parse(user.memberEquity.value?.configInfo?.maxDownloadSpeed ?? '0')}');
      client.setSpeedLimit(int.parse(
          user.memberEquity.value?.configInfo?.maxDownloadSpeed ?? '0'));
      for (var value in realm.all<FileIoDataRM>()) {
        client.cancelTask(taskId: value.taskId);
      }
      realm.writeAsync(() {
        for (var value in realm.all<FileIoDataRM>()) {
          if (value.status != 3 && value.status != 4) {
            value.status = 2;
          }
          value.speed = 0;
        }
      }).then((value) {
        uploadTaskList.refresh();
        downloadTaskList.refresh();
      });
    } catch (e) {
      showShortToast(e.toString());
    }
  }

  reInitOssSDK() async {
    var base = await ApiNet.request<StsEntity>(Api.stsToken);
    defaultBucket = base.data?.bucket;
    client.initSdk(
        sts: ClientSts(
            accessKeyId: base.data?.accessKeyId ?? '',
            accessKeySecret: base.data?.accessKeySecret ?? '',
            securityToken: base.data?.securityToken ?? ''),
        endPoint: base.data?.endpoint ?? '');
    SP.initOssTime = DateTime.now().millisecondsSinceEpoch;
    _addListener();
  }

  checkOssTime() async {
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    int threshold = 55 * 60 * 1000;
    if (currentTimestamp - SP.initOssTime > threshold) {
      await reInitOssSDK();
    }
  }

  checkOssTime2() async {
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    int threshold = 55 * 60 * 1000;
    if (currentTimestamp - SP.initOssTime > threshold) {
      var base = await ApiNet.request<StsEntity>(Api.stsToken);
      defaultBucket = base.data?.bucket;
      client.initSdk(
          sts: ClientSts(
              accessKeyId: base.data?.accessKeyId ?? '',
              accessKeySecret: base.data?.accessKeySecret ?? '',
              securityToken: base.data?.securityToken ?? ''),
          endPoint: base.data?.endpoint ?? '');
      SP.initOssTime = DateTime.now().millisecondsSinceEpoch;
      _addListener();
    }
  }

  Duration uploadProgressDuration =
      const Duration(milliseconds: 1000); // 上传进度的间隔时间
  Duration downloadProgressDuration =
      const Duration(milliseconds: 1000); // 上传进度的间隔时间
  // Duration uploadStatusDuration = const Duration(milliseconds: 1000); // 上传/下载状态的间隔时间
  // Duration downloadStatusDuration = const Duration(milliseconds: 1000); // 上传/下载状态的间隔时间

  DateTime _lastUploadProgressTrigger = DateTime.now();
  DateTime _lastDownloadProgressTrigger = DateTime.now();
  // DateTime _lastUploadStatusTrigger = DateTime.now();
  // DateTime _lastDownloadStatusTrigger = DateTime.now();

  _addListener() {
    // 上传进度监听器
    _progressSub = client.progressStream.stream.listen((event) {
      if (event.upload == true) {
        // 检查是否需要更新进度
        bool shouldUpdate =
            DateTime.now().difference(_lastUploadProgressTrigger) >=
                uploadProgressDuration;
        // 检查是否为最后一个进度更新（当前进度等于总进度）
        bool isLastProgress = event.current == event.total;

        if (shouldUpdate || isLastProgress) {
          _lastUploadProgressTrigger = DateTime.now();

          // 处理上传进度
          final results =
              realm.query<FileIoDataRM>(r'taskId == $0', [event.taskId]);
          realm.writeAsync(() {
            var time = DateTime.now().millisecondsSinceEpoch;
            for (var value in results) {
              value.speed = (event.current - (value.current ?? 0)) ~/
                  (time - (value.endTime ?? 0)) *
                  1000;
              value.current = event.current;
              value.total = event.total;
              value.endTime = time;
              value.status = 1;
            }
          }).then((value) => uploadTaskList.refresh());
        }
      } else {
        // 检查是否需要更新进度
        bool shouldUpdate =
            DateTime.now().difference(_lastDownloadProgressTrigger) >=
                downloadProgressDuration;
        // 检查是否为最后一个进度更新
        bool isLastProgress = event.current == event.total;

        if (shouldUpdate || isLastProgress) {
          _lastDownloadProgressTrigger = DateTime.now();

          // 处理下载进度
          final results =
              realm.query<FileIoDataRM>(r'taskId == $0', [event.taskId]);
          var time = DateTime.now().millisecondsSinceEpoch;
          var speed = 0;
          for (var value in results) {
            speed = (event.current - (value.current ?? 0)) ~/
                (time - (value.endTime ?? 0)) *
                1000;
          }

          realm.writeAsync(() {
            for (var value in results) {
              value.speed = speed;
              value.current = event.current;
              value.total = event.total;
              value.endTime = time;
              value.status = 1;
            }
          }).then((value) => downloadTaskList.refresh());
        }
      }
      debugPrint(
          '${event.current}--${event.total}--${event.upload}--${event.taskId}');
    });

    // 上传/下载状态监听器
    _taskSub = client.resultStream.stream.listen((event) {
      debugPrint(
          '${event.success}--${event.message}--${event.upload}--${event.cancel}--${event.taskId}');
      if (event.upload == true) {
        // // 只有在过去3秒内没有触发过事件时才处理
        // bool shouldUpdate = DateTime.now().difference(_lastUploadStatusTrigger) >= uploadStatusDuration;
        // bool isImportantStatus = event.success || event.cancel || (!event.success && !event.cancel);

        // if (shouldUpdate || isImportantStatus) {
        //   _lastUploadStatusTrigger = DateTime.now();

        // 处理上传状态
        final results =
            realm.query<FileIoDataRM>(r'taskId == $0', [event.taskId]);
        realm.writeAsync(() {
          for (var value in results) {
            if (event.success) {
              value.status = 3; // 上传成功
            } else if (event.cancel) {
              value.status = value.status == 5 ? 5 : 2; // 上传取消
            } else {
              value.status = 4; // 上传失败
            }
            value.speed = 0;
            if (event.success) {
              value.endTime = DateTime.now().millisecondsSinceEpoch;
            }
          }
        }).then((value) {
          if (event.success) {
            _handleUploadReport(event.taskId);
          }
          if (event.success == true) {
            // 获取正在上传的文件列表
            var uploadingRse = realm.query<FileIoDataRM>(
                r'type == $0 and status == 1 SORT(startTime desc)', [0]);
            // 获取并行暂停上传的文件列表
            var waitRse = realm.query<FileIoDataRM>(
                r'type == $0 and status == 5 SORT(startTime desc)', [0]);
            if (waitRse.isNotEmpty) {
              // 计算可以恢复的任务数量
              int maxTasks = int.tryParse(
                      user.memberEquity.value?.configInfo?.maxTaskUpload ??
                          '0') ??
                  0;
              int availableSlots = maxTasks - uploadingRse.length;

              // 确保 availableSlots 不为负数
              if (availableSlots > 0) {
                var tempWaitRes = waitRse.take(availableSlots);
                for (var item in tempWaitRes) {
                  renewUpload(item);
                }
              }
            } else if (uploadingRse.isEmpty) {
              localNotificationsLogic.cancelNotification(1);
            }
          }
        });
        if (event.success == false && event.cancel == false) {
          var tips = '';
          if (event.message!.contains('Failed to connect to') ||
              event.message!.contains('Unable to resolve host')) {
            tips = '网络连接异常';
          } else {
            tips = '${event.message}';
          }
          // showShortToast('${results.firstOrNull?.fileName}上传失败，$tips');
          showShortToast('上传失败，$tips');
        }

        // }
      } else {
        // bool shouldUpdate = DateTime.now().difference(_lastDownloadStatusTrigger) >= downloadStatusDuration;
        // bool isImportantStatus = event.success || event.cancel || (!event.success && !event.cancel);

        // if (shouldUpdate || isImportantStatus) {
        //   _lastDownloadStatusTrigger = DateTime.now();
        // 处理下载状态
        final results =
            realm.query<FileIoDataRM>(r'taskId == $0', [event.taskId]);
        realm.writeAsync(() {
          for (var value in results) {
            if (event.success) {
              value.status = 3; // 下载成功
            } else if (event.cancel) {
              value.status = value.status == 5 ? 5 : 2; // 下载取消
            } else {
              value.status = 4; // 下载失败
            }
            value.speed = 0;
            if (event.success) {
              value.endTime = DateTime.now().millisecondsSinceEpoch;
            }
          }
        }).then((value) {
          downloadTaskList.refresh();
          // if (event.success == true) {
          // 获取正在下载的文件列表
          var downloadingRse = realm.query<FileIoDataRM>(
              r'type == $0 and status == 1 SORT(startTime desc)', [1]);
          // 获取并行暂停下载的文件列表
          var waitRse = realm.query<FileIoDataRM>(
              r'type == $0 and status == 5 SORT(startTime desc)', [1]);
          if (waitRse.isNotEmpty) {
            // 计算可以恢复的任务数量
            int maxTasks = int.tryParse(
                    user.memberEquity.value?.configInfo?.maxTaskDownload ??
                        '0') ??
                0;
            int availableSlots = maxTasks - downloadingRse.length;

            // 确保 availableSlots 不为负数
            if (availableSlots > 0) {
              var tempWaitRes = waitRse.take(availableSlots);
              for (var item in tempWaitRes) {
                renewDownload(item);
              }
            }
          } else if (downloadingRse.isEmpty) {
            localNotificationsLogic.cancelNotification(0);
          }
          // }
        });
        if (event.success == false && event.cancel == false) {
          // showShortToast('${results.firstOrNull?.fileName}下载失败，${event.message}');
          showShortToast('下载失败，${event.message}');
          return;
        }
      }
      // }
    });
  }

  _handleUploadReport(String taskId) async {
    final results = realm.query<FileIoDataRM>(r'taskId == $0', [taskId]);
    if (results.isEmpty) {
      return;
    }
    try {
      var base = await ApiNet.request<DiskFileEntity>(Api.uploadTask, data: {
        'title': results[0].fileName,
        'dir_id': results[0].dirId,
        "hash": results[0].hashMd5,
        "size": results[0].total,
        "mime": results[0].mime,
        "path": results[0].ossFileName,
        "has_passwd": results[0].hasPasswd
      });
      if (base.code == 200) {
        realm.writeAsync(() {
          for (var value in results) {
            value.fileId = base.data?.id;
            value.fileType = base.data?.dataType;
          }
        }).then((value) {
          uploadTaskList.refresh();
          tabParentLogic.refreshFileHome();
        });
      }
    } catch (e) {
      showShortToast(e.toString());
    }
  }

  renewUpload(FileIoDataRM record) async {
    await checkOssTime();
    if (record.status == 1) return;
    var uploading =
        realm.query<FileIoDataRM>(r'type == $0 and status == 1', [0]);
    if (uploading.length >=
        int.parse(user.memberEquity.value?.configInfo?.maxTaskUpload ?? '0')) {
      /// 当超出并行任务时，按照会员状态给出提示
      if (user.memberEquity.value?.vipStatus == 1) {
        showShortToast('已达任务可执行上限');
        return;
      } else {
        showShortToast('已达任务可执行上限，开通会员享受更多权益');
        showOpenMemberSheet(openMemberType: OpenMemberType.uploadTaskCount);
        return;
      }
    }
    File file = File(record.localPath ?? '');
    if (!file.existsSync()) {
      if (Platform.isIOS) {
        file =
            File(await SandboxManager.updateSandboxIds(record.localPath ?? ''));
        if (!file.existsSync()) {
          showShortToast('文件不存在，请重新上传');
          return;
        } else {
          realm.write(() {
            record.localPath = file.path;
          });
          uploadTaskList.refresh();
        }
      } else {
        showShortToast('文件不存在，请重新上传');
        return;
      }
    }
    var taskId = await client.upload(
        bucketName: record.bucketName,
        ossFileName: record.ossFileName ?? '',
        filePath: record.localPath ?? '',
        recordDir:
            '${(await getApplicationDocumentsDirectory()).path}${record.uploadRecordPath ?? ''}');
    realm.writeAsync(() {
      record.taskId = '$taskId';
      record.status = 1;
      record.endTime = DateTime.now().millisecondsSinceEpoch;
    }).then((value) => uploadTaskList.refresh());
  }

  cancelTask(FileIoDataRM record) async {
    try {
      showLoading();
      await checkOssTime();
      await client.cancelTask(taskId: record.taskId);
      realm.writeAsync(() {
        record.status = 2;
        record.speed = 0;
      }).then((value) {
        if (record.type == 0) {
          uploadTaskList.refresh();
        } else {
          downloadTaskList.refresh();
        }
      });
      dismissLoading();
    } catch (e) {
      dismissLoading();
      showShortToast(e.toString());
    }
  }

  renewDownload(FileIoDataRM record) async {
    // 显示下载通知
    var res = await localNotificationsLogic.showDownloadNotification();
    if (res == null) {
      return;
    }
    await checkOssTime();
    if (record.status == 1) return;
    var downloading =
        realm.query<FileIoDataRM>(r'type == $0 and status == 1', [1]);
    if (downloading.length >=
        int.parse(
            user.memberEquity.value?.configInfo?.maxTaskDownload ?? '0')) {
      /// 当超出并行任务时，按照会员状态给出提示
      if (user.memberEquity.value?.vipStatus == 1) {
        // 在删除前保存所需的所有值
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
        // final savedStatus = record.status;
        const savedStatus = 5;
        final savedDirId = record.dirId;
        final savedThumb = record.thumb;
        final savedHasPasswd = record.hasPasswd;
        final savedFileType = record.fileType;
        final savedFileId = record.fileId;

        realm.writeAsync(() {
          final results =
              realm.query<FileIoDataRM>(r'taskId == $0', [savedTaskId]);
          realm.deleteMany(results);

          realm.add(FileIoDataRM(savedTaskId, savedUserId, savedBucketName,
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
              fileId: savedFileId));
        }).then((value) => downloadTaskList.refresh());
        return;
      } else {
        showShortToast('已达任务可执行上限，开通会员享受更多权益');
        showOpenMemberSheet(openMemberType: OpenMemberType.downloadTaskCount);
        return;
      }
    }
    logger.i(
        '设置限速 ${int.parse(user.memberEquity.value?.configInfo?.maxDownloadSpeed ?? '0')}');
    client.setSpeedLimit(int.parse(
        user.memberEquity.value?.configInfo?.maxDownloadSpeed ?? '0'));
    final directory = await getApplicationDocumentsDirectory();
    var taskId = await client.download(
        bucketName: record.bucketName,
        ossFileName: record.ossFileName ?? '',
        filePath: Platform.isAndroid
            ? record.localPath ?? ''
            : '${directory.path}${record.localPath}',
        recordFile: Platform.isAndroid
            ? record.downloadRecordFile ?? ''
            : '${directory.path}${record.downloadRecordFile}');
    realm.writeAsync(() {
      record.taskId = taskId;
      record.status = 1;
      record.endTime = DateTime.now().millisecondsSinceEpoch;
    }).then((value) => downloadTaskList.refresh());
  }

  // uploadFile(List<Map<String, dynamic>> fileList,int dirId)async{
  //   await checkOssTime();
  //   bool showDialogExecuted = false;  // 标志位，确保 showGoToSeeDialog 只执行一次
  //   for (var fileItem in fileList) {
  //     var path = fileItem['path'];
  //     var fileId = fileItem['id'];
  //     var file = File(path);
  //     var data = await file.readAsBytes();
  //     var length = data.length;
  //     var md5Value = md5.convert(data).toString();
  //     var mimeType = lookupMimeType(path) ?? '';
  //     var title = path.split("/").last;
  //     FilePreEntity? filePre;
  //     try{
  //       var base = await ApiNet.request<FilePreEntity>(Api.preUpload,data: {
  //         'title': title,
  //         'dir_id': dirId,
  //         'hash': md5Value,
  //         'size': length,
  //         'mime': mimeType,
  //         'path': 'user_${user.memberEquity.value?.id}/${path.split('/').last}'
  //       });
  //       filePre = base.data;
  //       if (base.data?.quick == 1) {
  //         _instantTransmission(
  //           logId: base.data?.logId ?? '0',
  //           bucket: filePre?.bucket ?? '',
  //           md5Value: md5Value,
  //           title: title,
  //           path: path,
  //           ossName: filePre!.ossName ?? '',
  //           length: length,
  //           dirId: dirId,
  //           mimeType: mimeType,
  //           fileId: fileId
  //         );
  //         // 只执行一次对话框
  //         if (!showDialogExecuted) {
  //           showGoToSeeDialog(type: 1);
  //           showDialogExecuted = true; // 标记对话框已经执行
  //         }
  //         continue;
  //       }
  //     }catch(e){
  //       showShortToast(e.toString());
  //     }
  //     if (filePre == null){
  //       break;
  //     }
  //     //开始上报开始
  //     try{
  //       await ApiNet.request(Api.startTask,data: {
  //         'log_id': filePre.logId,
  //         'type': 1
  //       });
  //     }catch(e){
  //       showShortToast(e.toString());
  //       break;
  //     }

  //     // 下载前检查是否有已下载中的文件：如果没有下载中的文件，那状态就设置成1（下载中），否侧，设置成0（创建）
  //     int status = 1;
  //     var uploadingRse = realm.query<FileIoDataRM>(r'type == $0 and status == 1',[0]);
  //     if (uploadingRse.length >= int.parse(user.memberEquity.value?.configInfo?.maxTaskUpload ?? '0')) {
  //       status = 0;
  //     }
  //     var taskId = await client.upload(bucketName: filePre.bucket ?? '', ossFileName: filePre.ossName ?? '', filePath: path, recordDir: _uploadRecordDirPath);
  //     var uploading = realm.query<FileIoDataRM>(r'type == $0 and status == 1',[0]);
  //     if (uploading.length >= int.parse(user.memberEquity.value?.configInfo?.maxTaskUpload ?? '0')) {
  //       /// 当超出并行任务时，取消任务，并设置状态==5，后续恢复下载
  //       status = 5;
  //       await client.cancelTask(taskId: taskId);
  //     }

  //     realm.writeAsync(() {
  //       realm.add(
  //           FileIoDataRM(
  //           taskId, user.memberEquity.value?.id ?? 0, filePre?.bucket ?? '', DateTime.now().millisecondsSinceEpoch,
  //           hashMd5: md5Value,
  //           fileName: title,
  //           localPath: path,
  //           uploadRecordPath: _uploadRecordDirPath,
  //           type: 0,
  //           current: 0,
  //           ossFileName: filePre!.ossName,
  //           total: length,
  //           status: status,
  //           dirId: dirId,
  //           mime: mimeType,
  //           endTime: DateTime.now().millisecondsSinceEpoch,
  //           thumb: fileId
  //         )
  //       );
  //     }).then((value) {
  //       uploadTaskList.refresh();
  //     });

  //     // 只执行一次对话框
  //     if (!showDialogExecuted) {
  //       showGoToSeeDialog(type: 1);
  //       showDialogExecuted = true; // 标记对话框已经执行
  //     }
  //   }
  // }

  /// 上传文件
  Future<void> uploadFile(
      List<Map<String, dynamic>> fileList, int dirId) async {
    // 显示上传通知
    var res = await localNotificationsLogic.showUploadNotification();
    if (res == null) {
      return;
    }
    showLoading();
    await checkOssTime();
    for (var entry in fileList.asMap().entries) {
      var index = entry.key;
      var fileItem = entry.value;
      var path = fileItem['path'];
      var fileId = fileItem['id'];
      var file = File(path);

      // 优化1：直接获取文件大小，不读取文件内容
      var length = await file.length();
      var title = path.split('/').last;
      if (length <= 0) {
        showShortToast('$title 文件异常');
        if (index == fileList.length - 1) {
          dismissLoading();
        }
        continue;
      }
      // 优化2：使用流式处理计算 MD5
      var md5Value = await _calculateFileMd5(file);
      var mimeType = lookupMimeType(path) ?? '';

      /// 检查文件是否加密
      final hasPasswd = await isZipEncrypted(file);

      FilePreEntity? filePre;
      try {
        var base = await ApiNet.request<FilePreEntity>(Api.preUpload, data: {
          'title': title,
          'dir_id': dirId,
          'hash': md5Value,
          'size': length,
          'mime': mimeType,
          'path': 'user_${user.memberEquity.value?.id}/$title'
        });
        // base.data?.quick = 0;
        filePre = base.data;

        // 处理秒传逻辑
        if (base.data?.quick == 1) {
          await _handleQuickTransmission(
              base.data?.logId ?? '0',
              filePre,
              md5Value,
              title,
              path,
              length,
              dirId,
              mimeType,
              fileId,
              hasPasswd);
        } else {
          if (filePre == null) continue;
          // 处理正常上传逻辑
          if (!await _handleNormalUpload(filePre, path, md5Value, title, length,
              dirId, mimeType, fileId, hasPasswd)) {
            continue;
          }
        }
      } catch (e) {
        dismissLoading();
        showShortToast(e.toString());
        break;
      }
      if (index == fileList.length - 1) {
        dismissLoading();
        showGoToSeeDialog(type: 1);
      }
    }
  }

  /// 使用 md5_file_checksum 计算文件 MD5
  Future<String> _calculateFileMd5(File file) async {
    try {
      final md5Hash =
          await Md5FileChecksum.getFileChecksum(filePath: file.path);
      return md5Hash;
    } catch (e) {
      debugPrint('计算MD5出错: $e');
      rethrow;
    }
  }

  /// 处理秒传逻辑
  Future<void> _handleQuickTransmission(
      String logId,
      FilePreEntity? filePre,
      String md5Value,
      String title,
      String path,
      int length,
      int dirId,
      String mimeType,
      String fileId,
      int hasPasswd) async {
    await _instantTransmission(
        logId: logId,
        bucket: filePre?.bucket ?? '',
        md5Value: md5Value,
        title: title,
        path: path,
        ossName: filePre!.ossName ?? '',
        length: length,
        dirId: dirId,
        mimeType: mimeType,
        fileId: fileId,
        hasPasswd: hasPasswd);
  }

  /// 生成任务ID 使用时间戳+随机数
  String generateTaskId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(10000).toString().padLeft(4, '0');
    return '${timestamp}_$random';
  }

  /// 处理正常上传逻辑
  Future<bool> _handleNormalUpload(
      FilePreEntity filePre,
      String path,
      String md5Value,
      String title,
      int length,
      int dirId,
      String mimeType,
      String fileId,
      int hasPasswd) async {
    try {
      await ApiNet.request(Api.startTask,
          data: {'log_id': filePre.logId, 'type': 1});
    } catch (e) {
      showShortToast(e.toString());
      return false;
    }

    // 检查上传状态
    int status = await _determineUploadStatus();
    var taskId = generateTaskId();
    // 检查是否需要取消任务
    if (await _shouldCancelUpload()) {
      status = 5;
      // await client.cancelTask(taskId: taskId);
    } else {
      // 执行上传任务
      taskId = await client.upload(
          bucketName: filePre.bucket ?? '',
          ossFileName: filePre.ossName ?? '',
          filePath: path,
          recordDir:
              '${(await getApplicationDocumentsDirectory()).path}$_uploadRecordDirPath');
    }

    // 添加上传记录
    await _addUploadRecord(taskId, filePre, md5Value, title, path, length,
        dirId, mimeType, status, fileId, hasPasswd);

    return true;
  }

  /// 确定上传状态
  Future<int> _determineUploadStatus() async {
    var uploadingRse =
        realm.query<FileIoDataRM>(r'type == $0 and status == 1', [0]);
    return uploadingRse.length >=
            int.parse(user.memberEquity.value?.configInfo?.maxTaskUpload ?? '0')
        ? 0
        : 1;
  }

  /// 检查是否应该取消上传
  Future<bool> _shouldCancelUpload() async {
    var uploading =
        realm.query<FileIoDataRM>(r'type == $0 and status == 1', [0]);
    return uploading.length >=
        int.parse(user.memberEquity.value?.configInfo?.maxTaskUpload ?? '0');
  }

  /// 添加上传记录
  Future<void> _addUploadRecord(
      String taskId,
      FilePreEntity filePre,
      String md5Value,
      String title,
      String path,
      int length,
      int dirId,
      String mimeType,
      int status,
      String fileId,
      int hasPasswd) async {
    await realm.writeAsync(() {
      realm.add(FileIoDataRM(taskId, user.memberEquity.value?.id ?? 0,
          filePre.bucket ?? '', DateTime.now().millisecondsSinceEpoch,
          hashMd5: md5Value,
          fileName: title,
          localPath: path,
          uploadRecordPath: _uploadRecordDirPath,
          type: 0,
          current: 0,
          ossFileName: filePre.ossName,
          total: length,
          status: status,
          dirId: dirId,
          mime: mimeType,
          endTime: DateTime.now().millisecondsSinceEpoch,
          thumb: fileId,
          hasPasswd: hasPasswd));
    });
    uploadTaskList.refresh();
  }

  /// 秒传（文件已上传过时走秒传流程，不走OSS）
  _instantTransmission(
      {required String logId,
      required String bucket,
      required String md5Value,
      required String title,
      required String path,
      required String ossName,
      required int length,
      required int dirId,
      required String? mimeType,
      required String fileId,
      required int hasPasswd}) {
    realm.writeAsync(() {
      realm.add(FileIoDataRM(logId, user.memberEquity.value?.id ?? 0, bucket,
          DateTime.now().millisecondsSinceEpoch,
          hashMd5: md5Value,
          fileName: title,
          localPath: path,
          uploadRecordPath: _uploadRecordDirPath,
          type: 0,
          current: 0,
          ossFileName: ossName,
          total: length,
          status: 3,
          dirId: dirId,
          mime: mimeType,
          endTime: DateTime.now().millisecondsSinceEpoch,
          thumb: fileId,
          hasPasswd: hasPasswd));
    }).then((value) {
      uploadTaskList.refresh();
      _handleUploadReport(logId);
    });
  }

  download(int fileId) async {
    // showLoading();
    await checkOssTime();
    DiskFileEntity? file;
    try {
      var base = await ApiNet.request<DiskFileEntity>(Api.diskDetail,
          data: {'file_id': fileId});
      file = base.data;
    } catch (e) {
      dismissLoading();
      showShortToast(e.toString());
      return false;
    }
    if (file == null) {
      dismissLoading();
      showShortToast('文件不存在');
      return false;
    }

    // // 获取应用文档目录
    // final appDocDir = await getApplicationDocumentsDirectory();
    // var localDirPath = '${appDocDir.path}/download';
    // var dir =  Directory(localDirPath);
    // if (!(await dir.exists())){
    //   await dir.create();
    // }

    var localDirPath = await _getDownloadPath();
    final directory = await getApplicationDocumentsDirectory();
    String localPath;
    String recordDirPath;
    if (Platform.isAndroid) {
      final dir = Directory(localDirPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      // 检查目录下是否有同名文件并生成新的文件名
      final uniqueTitle =
          await _generateUniqueFileName(dir.path, file.title ?? 'unknown');

      // 更新 file.title 为新的唯一文件名
      file = file.copyWith(title: uniqueTitle);

      localPath = '${dir.path}/$uniqueTitle';
      recordDirPath = '${dir.path}/downloadRecord';
      var recordDir = Directory(recordDirPath);
      if (!(await recordDir.exists())) {
        await recordDir.create();
      }
    } else {
      final dir = Directory('${directory.path}$localDirPath');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      // 检查目录下是否有同名文件并生成新的文件名
      final uniqueTitle =
          await _generateUniqueFileName(dir.path, file.title ?? 'unknown');

      // 更新 file.title 为新的唯一文件名
      file = file.copyWith(title: uniqueTitle);

      localPath = '$localDirPath/$uniqueTitle';
      recordDirPath = '$localDirPath/downloadRecord';
      var recordDir = Directory('${directory.path}$recordDirPath');
      if (!(await recordDir.exists())) {
        await recordDir.create();
      }
    }

    // // 下载前检查是否有已下载中的文件：如果没有下载中的文件，那状态就设置成1（下载中），否侧，设置成0（创建）
    // int status = 1;
    // var downloadingRse = realm.query<FileIoDataRM>(r'type == $0 and status == 1',[1]);
    // if (downloadingRse.length >= int.parse(user.memberEquity.value?.configInfo?.maxTaskDownload ?? '0')) {
    //   status = 0;
    // }

    try {
      // int maxTasks = int.parse(user.memberEquity.value?.configInfo?.maxTaskDownload ?? '0');
      // var downloading = realm.query<FileIoDataRM>(r'type == $0 and status == 1',[1]);
      // if (downloading.length >= maxTasks) {
      //   /// 当超出并行任务时，取消任务，并设置状态==5，后续恢复下载
      //   status = 5;
      // }
      // client.setSpeedLimit(int.parse(user.memberEquity.value?.configInfo?.maxDownloadSpeed ?? '0'));
      // var taskId = await client.download(
      //   bucketName: file.bucket ?? '',
      //   ossFileName: file.path ?? '',
      //   filePath: Platform.isAndroid ? localPath : '${directory.path}$localPath' ,
      //   recordFile: Platform.isAndroid ? recordDirPath : '${directory.path}$recordDirPath'
      // );
      // // 如果超出限制，立即取消任务
      // if (status == 5) {
      //   await client.cancelTask(taskId: taskId);
      // }
      int status = await _determineDownloadStatus();
      var taskId = generateTaskId();
      if (await _shouldCancelDownload()) {
        status = 5;
      } else {
        logger.i(
            '设置限速 ${int.parse(user.memberEquity.value?.configInfo?.maxDownloadSpeed ?? '0')}');
        client.setSpeedLimit(int.parse(
            user.memberEquity.value?.configInfo?.maxDownloadSpeed ?? '0'));
        taskId = await client.download(
            bucketName: file.bucket ?? '',
            ossFileName: file.path ?? '',
            filePath:
                Platform.isAndroid ? localPath : '${directory.path}$localPath',
            recordFile: Platform.isAndroid
                ? recordDirPath
                : '${directory.path}$recordDirPath');
      }

      await realm.writeAsync(() {
        realm.add(FileIoDataRM(taskId, user.memberEquity.value?.id ?? 0,
            file?.bucket ?? '', DateTime.now().millisecondsSinceEpoch,
            fileName: file?.title,
            localPath: localPath,
            downloadRecordFile: recordDirPath,
            type: 1,
            current: 0,
            ossFileName: file?.path,
            total: 1,
            status: status,
            dirId: file?.id,
            endTime: DateTime.now().millisecondsSinceEpoch,
            thumb: file?.thumb,
            hasPasswd: file?.hasPwd ?? 0,
            fileType: file?.dataType ?? 100,
            fileId: file?.id ?? 0));
      }).then((value) {
        downloadTaskList.refresh();
      });
    } catch (e) {
      return false;
    }
    return true;
  }

  // 确定下载状态
  Future<int> _determineDownloadStatus() async {
    var downloadingRse =
        realm.query<FileIoDataRM>(r'type == $0 and status == 1', [1]);
    return downloadingRse.length >=
            int.parse(
                user.memberEquity.value?.configInfo?.maxTaskDownload ?? '0')
        ? 0
        : 1;
  }

  // 检查是否应该取消下载
  Future<bool> _shouldCancelDownload() async {
    var downloading =
        realm.query<FileIoDataRM>(r'type == $0 and status == 1', [1]);
    int maxTasks =
        int.parse(user.memberEquity.value?.configInfo?.maxTaskDownload ?? '0');
    return downloading.length >= maxTasks;
  }

  // 获取下载路径
  Future<String> _getDownloadPath() async {
    if (Platform.isAndroid) {
      final downloadDir =
          Directory('/storage/emulated/0/Download/KuaiTuDownloads/CloudDrive');
      return downloadDir.path;
    } else {
      // iOS 设备使用应用文档目录
      // final directory = await getApplicationDocumentsDirectory();
      // return '${directory.path}/Downloads/CloudDrive';
      return '/KuaiTuDownloads/CloudDrive';
    }
  }

  /// 生成不重复的文件名（不包含路径）
  Future<String> _generateUniqueFileName(
      String dirPath, String fileName) async {
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

    // 检查文件是否存在或是否有正在下载的同名文件
    while (await File('$dirPath/$finalName').exists() ||
        _isFileDownloading(finalName)) {
      finalName = '$nameWithoutExt($counter)$extension';
      counter++;
    }

    return finalName;
  }

  /// 检查是否有同名文件正在下载
  bool _isFileDownloading(String fileName) {
    // 查询所有正在下载的任务（状态为 0-创建、1-下载中、5-并行暂停的任务）
    var downloadingFiles = realm
        .query<FileIoDataRM>(r'type == $0 AND fileName == $1', [1, fileName]);

    return downloadingFiles.isNotEmpty;
  }

  /// 解压前检查
  checkFile(List<DiskFileEntity> dataList,
      {bool isShowNormalDialog = false}) async {
    try {
      showLoading();
      var zipFileDetail = await ApiNet.request<DiskFileEntity>(Api.diskDetail,
          data: {'file_id': dataList[0].id});
      dismissLoading();
      if (zipFileDetail.data?.relationDirId != null &&
          zipFileDetail.data?.relationDirId != 0) {
        push(MyRouter.fileListNormal,
            args: FileNormalSearchEntity(
                DiskFileEntity()
                  ..id = zipFileDetail.data?.relationDirId
                  ..title = zipFileDetail.data?.title,
                searchMap: {}));
        return;
      }
      if (isShowNormalDialog) {
        var r = await showNormalDialog(title: '文件解压', message: '是否解压此文件');
        if (r == true) {
          unzip(dataList[0]);
        }
      } else {
        unzip(dataList[0]);
      }
      // var base = await ApiNet.request<CheckFileEntity>(Api.aliyunCheckFile, data: {'object': dataList[0].id, 'type': 1});
      // dismissLoading();
      // if (!base.data!.exist!) {
      //   unzip(dataList[0]);
      // } else {
      //   var res = await showNormalDialog(title: '已存在同名文件', message: '存在同名的已解压文件，是否覆盖已有文件', ok: '确认覆盖');
      //   if (!res) return;
      //   unzip(dataList[0]);
      // }
    } catch (e) {
      dismissLoading();
      showShortToast(e.toString());
    }
  }

  /// 解压
  unzip(DiskFileEntity diskFileEntity) async {
    try {
      showLoading();
      await socketLogic.initSocket();
      var base = await ApiNet.request<UnzipEntity>(Api.aliyunUnzipTask,
          data: {'file_id': diskFileEntity.id});
      dismissLoading();
      UnzipEntity unzipEntity = base.data!;
      showUnzipProgressDialog(taskId: unzipEntity.taskId ?? '');
      if (base.code == 200) {
        if (Get.isRegistered<IoParentLogic>(tag: 'IoParentLogic_2')) {
          IoParentLogic ioParentLogic =
              Get.find<IoParentLogic>(tag: 'IoParentLogic_2');
          ioParentLogic.uncompressIsEmpty.value = false;
        }
        refreshUnzipList();
      }
    } catch (e) {
      showShortToast(e.toString());
      dismissLoading();
    }
  }

  /// 刷新解压列表
  refreshUnzipList() {
    if (Get.isRegistered<UncompressSubPartLogic>(
        tag: 'UncompressSubPartLogic_0')) {
      UncompressSubPartLogic uncompressSubPartLogic =
          Get.find<UncompressSubPartLogic>(tag: 'UncompressSubPartLogic_0');
      uncompressSubPartLogic.onRefresh();
    }
    if (Get.isRegistered<UncompressSubPartLogic>(
        tag: 'UncompressSubPartLogic_1')) {
      UncompressSubPartLogic uncompressSubPartLogic =
          Get.find<UncompressSubPartLogic>(tag: 'UncompressSubPartLogic_1');
      uncompressSubPartLogic.onRefresh();
    }
    if (Get.isRegistered<UncompressSubPartLogic>(
        tag: 'UncompressSubPartLogic_2')) {
      UncompressSubPartLogic uncompressSubPartLogic =
          Get.find<UncompressSubPartLogic>(tag: 'UncompressSubPartLogic_2');
      uncompressSubPartLogic.onRefresh();
    }
    if (Get.isRegistered<UncompressSubPartLogic>(
        tag: 'UncompressSubPartLogic_3')) {
      UncompressSubPartLogic uncompressSubPartLogic =
          Get.find<UncompressSubPartLogic>(tag: 'UncompressSubPartLogic_3');
      uncompressSubPartLogic.onRefresh();
    }
  }

  /// 选择文件统一处理方式
  fileSelectedAciont() async {
    if (Platform.isAndroid) {
      var res = await requestMyPhotosPermission(
          androidPermission: Permission.manageExternalStorage);
      if (!res) return;
      showMobileFileSheet();
    } else {
      final result = await FilePicker.platform.pickFiles();
      if (result == null) return;
      var fileList = result.files.map((e) {
        return {
          'path': e.path ?? '', // 文件路径
          'id': '0', // 文件的 ID，如果没有则默认 0
        };
      }).toList();
      uploadFile(fileList, 0);
    }
  }
}

// 真
// OssLogic get oss {
//   if (Get.isRegistered<OssLogic>()){
//     return Get.find<OssLogic>();
//   }
//   return Get.put(OssLogic());
// }

// 假
FakeOssLogic get oss {
  if (Get.isRegistered<FakeOssLogic>()) {
    return Get.find<FakeOssLogic>();
  }
  return Get.put(FakeOssLogic());
}
