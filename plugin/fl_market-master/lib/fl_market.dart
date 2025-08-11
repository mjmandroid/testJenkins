
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class FlMarket {
  static const MethodChannel _channel = MethodChannel('fl_market');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// 如果都为空,则会以手机厂商去查找市场，并以获取到的报名来查找详情
  /// 如果是iOS，则appid不能为空
  static startMarket({String? packageName,String? marketPackageName,String? iOSAppId}){
    if (Platform.isIOS){
      _channel.invokeMethod('startMarket',{
        'iOSAppId':iOSAppId
      });
    }else {
      _channel.invokeMethod('startMarket', {
        'packageName': packageName,
        'marketPackageName': marketPackageName
      });
    }
  }
}
