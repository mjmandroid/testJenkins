import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_client_oss/src/entity/client_sts.dart';
import 'package:flutter_client_oss/src/listener/flutter_client_listener.dart';
import 'entity/client_config.dart';
import 'flutter_client_oss_platform_interface.dart';

/// An implementation of [FlutterClientOssPlatform] that uses method channels.
class MethodChannelFlutterClientOss extends FlutterClientOssPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_client_oss');

  final listener = FlutterClientListener();

  @override
  Future<dynamic> initSdk({required ClientSts sts,required String endPoint,ClientConfig? config}) {
    methodChannel.setMethodCallHandler(listener.handler);
    return methodChannel.invokeMethod('initSdk',{
      'sts': sts.toJson(),
      'endPoint': endPoint,
      if (config != null)
        'config': config.toJson()
    });
  }

  @override
  Future<dynamic> upload({required String bucketName,required String ossFileName,required String filePath,required String recordDir}) {
    return methodChannel.invokeMethod('asyncResumableUpload',{
      'bucketName':bucketName,
      'ossFileName':ossFileName,
      'filePath': filePath,
      'recordDir': recordDir
    });
  }

  @override
  Future<dynamic> download({required String bucketName,required String ossFileName,required String filePath,required String recordFile}) {
    return methodChannel.invokeMethod('asyncResumableDownload',{
      'bucketName':bucketName,
      'ossFileName':ossFileName,
      'filePath': filePath,
      'recordFile': recordFile
    });
  }

  @override
  Future<void> setSpeedLimit(int limit){
    return methodChannel.invokeMethod('setSpeedLimit',limit);
  }

  @override
  Future<dynamic> checkFile({required String bucketName,required String fileName}) {
    return methodChannel.invokeMethod('checkFile',{'bucketName':bucketName,'fileName':fileName});
  }

  @override
  Future<dynamic> getSignUrl({required String bucketName, required String fileName}) {
    return methodChannel.invokeMethod('getSignUrl',{'bucketName':bucketName,'fileName':fileName});
  }

  @override
  Future<dynamic> cancelTask({required String taskId}) {
    return methodChannel.invokeMethod('cancelTask',taskId);
  }

  @override
  Future cancelAllTask() {
    return methodChannel.invokeMethod('cancelAllTask');
  }

  @override
  FlutterClientListener getClientListener() {
    return listener;
  }
}
