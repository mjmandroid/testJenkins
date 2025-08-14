import 'dart:io';

// import 'package:desk_cloud/content/user/oss_logic.dart';
import 'package:desk_cloud/utils/app_config.dart';
import 'package:desk_cloud/utils/apple_pay_utils.dart';
import 'package:desk_cloud/utils/chinese_cupertino_localizations.dart';
import 'package:desk_cloud/utils/refresh_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jverify/jverify.dart';
import 'package:get/get.dart';
// import 'package:gp_utils/gp_utils.dart';
// import 'package:log_show/log_show.dart';
import 'package:sp_util/sp_util.dart';

import 'utils/export.dart';

void main() async {
  FlutterBugly.postCatchedException(() async {
    WidgetsFlutterBinding.ensureInitialized();

    var appConfig = AppConfig(
      appUrl: 'https://api.diskyun.com',
      appBeta: false,
      appNeedRsa: true,
      child: const MyApp(),
    );

    ApplePayUtils.init();

    // 隐私合规
    Jverify().setCollectionAuth(false);

    await SpUtil.getInstance();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // if (Platform.isAndroid) {
    //   var value = await GpUtils.getAndroidMetaValue("app_debug");
    //   Api.beta = value.toString() == "1";
    // } else {
    //   var value = await GpUtils.getIosInfoValue("app_debug");
    //   Api.beta = value.toString() == "1";
    // }
    if (Platform.isAndroid) {}

    await MultiAppConfig.setupConfig();
    if (Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
      );
      SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
    runApp(appConfig);
    return true;
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // 1.delay(() {
    //   if (Api.beta) {
    //     showLogView(CustomNavigatorObserver().navigator!.context);
    //   }
    // });
    // oss.initSdk();
    // _initTBS();
  }

  /// 腾讯TBS文件预览服务
  // void _initTBS() async {
  //   await FilePreview.initTBS(license: 'd1BcLoliMtIZJz0QktpPZTmCyd3HK6sb6sVS6KpP3Pi1V0rgOYmX4ZfTPC4HfxKs');
  //   await FilePreview.tbsVersion();
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, c) {
          return RefreshConfiguration(
            // headerBuilder: () => const ClassicHeader(),
            // footerBuilder: () => const ClassicFooter(),
            headerBuilder: () => const MyCustomHeader(),
            footerBuilder: () => const MyCustomFooter(),
            enableScrollWhenRefreshCompleted: true,
            hideFooterWhenNotFull: false,
            enableBallisticLoad: true,
            enableLoadingWhenFailed: true,
            child: MyGestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => closeEdit(),
              child: _buildWidget(),
            ),
          );
        });
  }

  Widget _buildWidget(){
    return GetMaterialApp(
      title: MultiAppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: kWhite(),
          platform: TargetPlatform.iOS,
          primarySwatch: Colors.amber,
          textSelectionTheme:
          TextSelectionThemeData(cursorColor: k4A83FF()),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: ColorScheme.dark(background: kWhite()),
          appBarTheme: AppBarTheme(
              elevation: 0,
              color: kWhite(),
              centerTitle: true,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarBrightness: Brightness.light,
                systemNavigationBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
              ),
              iconTheme: IconThemeData(color: k3(), size: 20.w),
              actionsIconTheme: IconThemeData(color: k3()),
              titleTextStyle: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: k3()))),
      builder: EasyLoading.init(),
      initialRoute: MyRouter.launch,
      navigatorObservers: [CustomNavigatorObserver(), routeObserver],
      onGenerateRoute: (settings) => MyRouter.generateRoute(settings),
      localizationsDelegates: const [
        RefreshLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        ChineseCupertinoLocalizations.delegate, // 自定义的delegate
        DefaultCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback:
          (Locale? locale, Iterable<Locale> supportedLocales) {
        return const Locale("zh", "CN");
      },
    );
  }
}
