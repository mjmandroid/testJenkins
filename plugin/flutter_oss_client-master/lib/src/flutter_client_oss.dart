
import 'dart:async';

import 'package:flutter_client_oss/src/entity/task_result.dart';

import 'entity/client_config.dart';
import 'entity/client_sts.dart';
import 'entity/task_progress.dart';
import 'flutter_client_oss_platform_interface.dart';

class FlutterClientOss {
  Future<dynamic> initSdk({required ClientSts sts,required String endPoint,ClientConfig? config}) {
    return FlutterClientOssPlatform.instance.initSdk(sts: sts, endPoint: endPoint,config: config);
  }

  Future<dynamic> upload({required String bucketName,required String ossFileName,required String filePath,required String recordDir}){
    return FlutterClientOssPlatform.instance.upload(bucketName: bucketName, ossFileName: ossFileName, filePath: filePath, recordDir: recordDir);
  }

  Future<dynamic> download({required String bucketName,required String ossFileName,required String filePath,required String recordFile}){
    return FlutterClientOssPlatform.instance.download(bucketName: bucketName, ossFileName: ossFileName, filePath: filePath, recordFile: recordFile);
  }

  Future<void> setSpeedLimit(int limit){
    return FlutterClientOssPlatform.instance.setSpeedLimit(limit);
  }

  Future<dynamic> checkFile({required String bucketName,required String fileName}){
    return FlutterClientOssPlatform.instance.checkFile(bucketName: bucketName, fileName: fileName);
  }

  Future<dynamic> getSignUrl({required String bucketName,required String fileName}){
    return FlutterClientOssPlatform.instance.getSignUrl(bucketName: bucketName, fileName: fileName);
  }

  Future<dynamic> cancelTask({required String taskId}){
    return FlutterClientOssPlatform.instance.cancelTask(taskId: taskId);
  }

  Future<dynamic> cancelAllTask(){
    return FlutterClientOssPlatform.instance.cancelAllTask();
  }

  StreamController<TaskProgress> get progressStream => FlutterClientOssPlatform.instance.getClientListener().taskProgressStreamController;

  StreamController<TaskResult> get resultStream => FlutterClientOssPlatform.instance.getClientListener().taskResultSteamController;
}
