import 'package:flutter/material.dart';

// /// 初始化环境配置
// class AppConfig extends InheritedWidget {

//   /// BaseUrl
//   static String apiHost = '';
  
//   AppConfig(Widget child, {required String apiHost}): super(child: child) {
//     AppConfig.apiHost = apiHost;
//   }
//   static AppConfig? of(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<AppConfig>();
//   }
//   @override
//   bool updateShouldNotify(InheritedWidget oldWidget) => false;
// }


class AppConfig extends InheritedWidget {

  /// BaseUrl
  static String apiHost = '';

  static bool beta = false;

  static bool needRsa = false;
  
  AppConfig({
    super.key, 
    required super.child,
    required String appUrl, 
    required bool appBeta,
    required bool appNeedRsa,
  }) {
    AppConfig.apiHost = appUrl;
    AppConfig.beta = appBeta;
    AppConfig.needRsa = appNeedRsa;
  }

  static AppConfig?of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

}