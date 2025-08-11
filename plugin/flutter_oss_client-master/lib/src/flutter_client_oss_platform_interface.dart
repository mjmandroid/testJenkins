import 'package:flutter_client_oss/src/listener/flutter_client_listener.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'entity/client_config.dart';
import 'entity/client_sts.dart';
import 'flutter_client_oss_method_channel.dart';

abstract class FlutterClientOssPlatform extends PlatformInterface {
  /// Constructs a FlutterClientOssPlatform.
  FlutterClientOssPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterClientOssPlatform _instance = MethodChannelFlutterClientOss();

  /// The default instance of [FlutterClientOssPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterClientOss].
  static FlutterClientOssPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterClientOssPlatform] when
  /// they register themselves.
  static set instance(FlutterClientOssPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future setCallback(double limit){
    throw UnimplementedError('setCallback() has not been implemented.');
  }

  Future<dynamic> initSdk({required ClientSts sts,required String endPoint,ClientConfig? config}){
    throw UnimplementedError('initSdk() has not been implemented.');
  }

  Future<dynamic> upload({required String bucketName,required String ossFileName,required String filePath,required String recordDir}){
    throw UnimplementedError('upload() has not been implemented.');
  }

  Future<dynamic> download({required String bucketName,required String ossFileName,required String filePath,required String recordFile}){
    throw UnimplementedError('download() has not been implemented.');
  }

  Future<void> setSpeedLimit(int limit){
    throw UnimplementedError('setSpeedLimit() has not been implemented.');
  }

  Future<dynamic> checkFile({required String bucketName,required String fileName}){
    throw UnimplementedError('checkFile() has not been implemented.');
  }

  Future<dynamic> getSignUrl({required String bucketName,required String fileName}){
    throw UnimplementedError('getSignUrl() has not been implemented.');
  }

  Future<dynamic> cancelTask({required String taskId}){
    throw UnimplementedError('cancelTask() has not been implemented.');
  }

  Future<dynamic> cancelAllTask(){
    throw UnimplementedError('cancelAllTask() has not been implemented.');
  }

  FlutterClientListener getClientListener(){
    throw UnimplementedError('getClientListener() has not been implemented.');
  }
}
