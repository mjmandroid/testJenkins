
import 'package:flutter_origin_resources/src/flutter_origin_resources_method_channel.dart';
import 'package:flutter_origin_resources/src/flutter_origin_type.dart';

class FlutterOriginResources {
  FlutterOriginResources._();

  static Future<String?> getPlatformVersion() {
    return MethodChannelFlutterOriginResources.instance.getPlatformVersion();
  }

  static Future<String?> getResourcePath(String name, {FlutterOriginType androidType = FlutterOriginType.androidDrawable, FlutterOriginType iosType = FlutterOriginType.iosAssets}) {
    return MethodChannelFlutterOriginResources.instance.getResourcePath(name,androidType: androidType,iosType: iosType);
  }
}
