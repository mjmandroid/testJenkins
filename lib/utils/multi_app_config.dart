// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';

import 'export.dart';

class MultiAppConfig {
  MultiAppConfig._();

  static Future<void> setupConfig() async {
    var info = await PackageInfo.fromPlatform();
    _packageName = info.packageName;
    _configJson = jsonDecode(await rootBundle.loadString('assets/other/config.json'));
  }

  static String get appName => _getValue('appName');
  static String get appNameEn => _getValue('appNameEn');

  //图片设置
  static String get ossHost => _getValue("ossHost");
  static String get ossDir => _getValue("ossDir");

  //logo和启动图
  static String get icon_logo => _getValue("icon_logo");

  static get robotId => _getValue('robotId');

  static get userLink => _getValue('userLink');
  static get renewLink => _getValue('renewLink');
  static get privacyLink => _getValue('privacyLink');
  static get memberLink => _getValue('memberLink');
  static get buyLink => _getValue('buyLink');
  static get jpushId => _getValue('jpushId');
  static get createLink => _getValue('createLink');


  static get universalLink => _getValue('universalLink');
  static get wxchatId => _getValue('wxchatId');
  static get chargePrivacy => _getValue('chargePrivacy');
  static get accountType => _getValue('accountType');
  static get gromoreAppId => _getValue('gromoreAppId');
  static get reward => apiType == 0 ? _getValue('rewardDev') : _getValue('reward');
  static get splash => _getValue('splash');

  static String _packageName = "com.kawa.AIGenie";
  static Map? _configJson;

  static dynamic _getValue(String key){
    return _configJson?[Platform.isAndroid ? 'android' : 'ios']?[_packageName]?[key];
  }
}
