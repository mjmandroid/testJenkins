import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_origin_resources/src/flutter_origin_type.dart';

class MethodChannelFlutterOriginResources{
  final _methodChannel = const MethodChannel('flutter_origin_resources');

  factory MethodChannelFlutterOriginResources() => instance;

  MethodChannelFlutterOriginResources._();

  static final MethodChannelFlutterOriginResources instance = MethodChannelFlutterOriginResources._();

  Future<String?> getPlatformVersion() async {
    final version = await _methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  Future<String?> getResourcePath(String name, {FlutterOriginType androidType = FlutterOriginType.androidDrawable, FlutterOriginType iosType = FlutterOriginType.iosAssets}) {
    if (Platform.isIOS){
      return _methodChannel.invokeMethod('getResourcePath',{
        'name':name,
        'type':iosType.name
      });
    }else{
      return _methodChannel.invokeMethod('getResourcePath',{
        'name':name,
        'type':androidType.name
      });
    }
  }
}
