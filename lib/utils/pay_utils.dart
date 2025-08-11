import 'dart:async';

import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';
import 'package:tobias/tobias.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum WebPayMode { inAppWebView, externalApplication }

class PayUtils {
  PayUtils._();

  static Future<bool> startPay(dynamic entity) async {
    String payCert = entity.payCert ?? "";
    String referer = entity.transferUrl ?? "";

    if (entity.isSdk == true) {
      switch (entity.payChannelType) {
        case 1: //微信sdk支付，暂时没有，直接false
          return false;
        case 2:
          await Tobias().pay(payCert, evn: AliPayEvn.online);
          return await _checkOrder(entity.orderId);
        default:
          return false;
      }
    } else {
      if (payCert.isNotEmpty && referer.isEmpty) {
        return await startWebPay(
            context: CustomNavigatorObserver().navigator!.context,
            url: payCert,
            referer: referer,
            orderId: entity.orderId,
            mode: WebPayMode.externalApplication);
      } else {
        return await startWebPay(
            context: CustomNavigatorObserver().navigator!.context,
            url: payCert,
            referer: referer,
            orderId: entity.orderId,
            mode: WebPayMode.inAppWebView);
      }
    }
  }

  static Future<bool> startWebPay(
      {required BuildContext context,
      required String url,
      String? referer,
      dynamic orderId,
      WebPayMode mode = WebPayMode.inAppWebView}) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return _WebPayView(
            url,
            referer: referer,
            mode: mode,
            orderId: orderId,
          );
        },
        barrierDismissible: false);
  }

  static Future<bool> _checkOrder(dynamic orderId) async {
    // if (orderId == null) return false;
    // showLoading();
    // var count = 0;
    // var result = false;
    // while(count < 3){
    //   try {
    //     var base =
    //     await ApiNet.request(Api.checkOrder, data: {"orderId": orderId});
    //     if (base.code == 0 && Map.from(base.data)["succ"] == true) {
    //       result = true;
    //     }
    //   } catch (e) {
    //     debugPrint(e.toString());
    //   }
    //   count++;
    //   if (result){
    //     break;
    //   }
    //   //只有在参与循环的时候才delay，查询三次以后不用等待
    //   if (count < 3) {
    //     await 1.delay();
    //   }
    // }
    // dismissLoading();
    // return result;
    return false;
  }
}

class _WebPayView extends StatefulWidget {
  final String url;
  final String? referer;
  final WebPayMode mode;
  final dynamic orderId;
  const _WebPayView(this.url,
      {Key? key,
      this.referer,
      this.mode = WebPayMode.inAppWebView,
      this.orderId})
      : super(key: key);

  @override
  State<_WebPayView> createState() => _WebPayViewState();
}

class _WebPayViewState extends State<_WebPayView> with WidgetsBindingObserver {
  final logic = Get.put(_WebPayLogic());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.mode == WebPayMode.inAppWebView) {
      logic._controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest: (NavigationRequest request) async {
              if (![
                "http",
                "https",
                "file",
                "chrome",
                "data",
                "javascript",
                "about"
              ].contains(Uri.parse(request.url).scheme)) {
                if (await canLaunchUrlString(request.url)) {
                  // Launch the App
                  await launchUrlString(request.url,
                      mode: LaunchMode.externalApplication);
                  // and cancel the request
                  return NavigationDecision.prevent;
                }
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.url), headers: {
          if (widget.referer?.isNotEmpty == true) 'Referer': widget.referer!
        });
    } else if (widget.mode == WebPayMode.externalApplication) {
      startOutPay();
    }
  }

  startOutPay() async {
    logic._completer = Completer();
    launchUrlString(widget.url);
    await logic._completer?.future;
    logic._completer = null;
    var r = await PayUtils._checkOrder(widget.orderId);
    pop(args: r);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: widget.mode == WebPayMode.inAppWebView
          ? Column(
              children: [
                const Spacer(),
                SizedBox(
                  width: 428.w,
                  height: 1.w,
                  child: Opacity(
                    opacity: 0.03,
                    child: WebViewWidget(
                      controller: logic._controller,
                    ),
                  ),
                ),
              ],
            )
          : Container(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    Get.delete<_WebPayLogic>();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
        if (logic._completer != null) {
          //外部支付
          logic._completer?.complete();
        } else if (mounted) {
          //内部浏览器支付
          var r = await PayUtils._checkOrder(widget.orderId);
          pop(args: r);
        }
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }
}

class _WebPayLogic extends GetxController {
  late final WebViewController _controller;
  Completer? _completer;
}
