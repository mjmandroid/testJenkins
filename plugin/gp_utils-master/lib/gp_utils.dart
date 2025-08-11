
import 'dart:async';

import 'package:flutter/services.dart';

class GpUtils {
  static const MethodChannel _channel =
      const MethodChannel('gp_utils');

  /*
  case "androidId":
        result.success(DeviceUtils.getAndroidID());
        break;
      case "macAddress":
        result.success(DeviceUtils.getMacAddress());
        break;
      case "uniqueDeviceId":
        result.success(DeviceUtils.getUniqueDeviceId());
        break;
      case "ipAddress":
        result.success(getIP());
        break;
      case "metaValue":
        result.success(getMetaValue(params.get("key")));
        break;
      case "version":
        result.success(AppUtils.getAppVersionName());
      case "versionCode":
        result.success(AppUtils.getAppVersionCode());
   */
  static Future<dynamic> getAndroidMetaValue(String key){
    return _channel.invokeMethod("metaValue", {"key":key});
  }
  static Future<dynamic> getIosInfoValue(String key){
    return _channel.invokeMethod("bundleInfo", {"key":key});
  }
  static Future<dynamic> getAndroidId(){
    print('-----------22222222');
    return _channel.invokeMethod("androidId");
  }
  static Future<dynamic> getMacAddress(){
    return _channel.invokeMethod("macAddress");
  }
  static Future<dynamic> getIdfa(){
    return _channel.invokeMethod("idfa");
  }
  static Future<dynamic> getOaid(){
    return _channel.invokeMethod("oaid");
  }
  static Future<dynamic> getUniqueDeviceId(){
    print('-----------33333333');
    return _channel.invokeMethod("uniqueDeviceId");
  }
  static Future<dynamic> getIpAddress(){
    return _channel.invokeMethod("ipAddress");
  }
  static Future<dynamic> getAppVersion(){
    return _channel.invokeMethod("version");
  }
  static Future<dynamic> getAppVersionCode(){
    return _channel.invokeMethod("versionCode");
  }
  static Future<dynamic> getAssetsByName(String name){
    return _channel.invokeMethod("assets",{"file":name});
  }
  static Future<dynamic> getDeviceType(){
    return _channel.invokeMethod("deviceType");
  }
  //获取穿山甲分包渠道
  static Future<dynamic> getHumeChannel(){
    return _channel.invokeMethod("hume");
  }
  //获取广点通分包渠道
  static Future<dynamic> getTencentChannel(){
    return _channel.invokeMethod("tencentChannel");
  }
  //获取快手分包渠道
  static Future<dynamic> getKsChannel(){
    return _channel.invokeMethod("ksChannel");
  }

  static Future<dynamic> getSourceDir(){
    return _channel.invokeMethod("sourceDir");
  }
  static Future<dynamic> getAppName(){
    return _channel.invokeMethod("appName");
  }

  static Future<dynamic> installApk(String path){
    return _channel.invokeMethod("installApk",{"path":path});
  }

  static Future<dynamic> openAppSetting(){
    return _channel.invokeMethod("openAppSetting");
  }

  static Future<dynamic> getSdkVersion(){
    return _channel.invokeMethod("sdkVersion");
  }
  
  static Future<void> initOaidSdk(){
    return _channel.invokeMethod("initOaid");
  }
  
  static Future<dynamic> getMetrics(){
    return _channel.invokeMethod('metrics');
  }
}
