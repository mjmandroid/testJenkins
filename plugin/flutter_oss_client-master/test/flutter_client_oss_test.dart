import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client_oss/src/flutter_client_oss.dart';
import 'package:flutter_client_oss/src/flutter_client_oss_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterClientOssPlatform
    with MockPlatformInterfaceMixin {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  // final FlutterClientOssPlatform initialPlatform = FlutterClientOssPlatform.instance;

  test('$MethodChannelFlutterClientOss is the default instance', () {
    // expect(initialPlatform, isInstanceOf<MethodChannelFlutterClientOss>());
  });

  test('getPlatformVersion', () async {
    // FlutterClientOss flutterClientOssPlugin = FlutterClientOss();
    // MockFlutterClientOssPlatform fakePlatform = MockFlutterClientOssPlatform();
    // FlutterClientOssPlatform.instance = fakePlatform;
    //
    // expect(await flutterClientOssPlugin.getPlatformVersion(), '42');
  });
}
