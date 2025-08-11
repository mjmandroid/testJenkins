import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:common_utils/common_utils.dart';
import 'package:crypto/crypto.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:desk_cloud/alert/empower_dialog.dart';
import 'package:desk_cloud/alert/normal_dialog.dart';
import 'package:desk_cloud/r.dart';
import 'package:desk_cloud/utils/api.dart';
import 'package:desk_cloud/utils/app_colors.dart';
import 'package:desk_cloud/utils/app_config.dart';
import 'package:desk_cloud/utils/custom_navigator_observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gp_utils/gp_utils.dart';
import 'package:hex/hex.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sprintf/sprintf.dart';
import 'dart:ui' as ui;

import '../widgets/my_gesture_detector.dart';

double safeAreaTop = .0;
double safeAreaBottom = .0;

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

BuildContext get globalContext => CustomNavigatorObserver().navigator!.context;

String getDateByNum(num time, [String? format]) {
  return DateUtil.formatDate(
      DateTime.fromMillisecondsSinceEpoch((time * 1000).toInt()),
      format: format ?? "yyyy-MM-dd HH:mm:ss");
}

Widget spaceH(num value) {
  return SizedBox(
    height: value.w,
  );
}

Widget spaceW(num value) {
  return SizedBox(
    width: value.w,
  );
}

extension MobileFileType on String {
  String get fileIcon {
    final v = toLowerCase();
    var icon = R.assetsTypeUnknown;
    switch (v) {
      case 'png':
      case 'jpg':
      case 'jpeg':
      case 'gif':
        icon = R.assetsImage;
        break;
      case 'avi':
      case 'mp4':
      case 'mov':
      case 'mkv':
        icon = R.assetsVideo;
        break;
      case 'wma':
      case 'wav':
      case 'mp3':
      case 'acc':
        icon = R.assetsTypeAudio;
        break;
      case 'txt':
        icon = R.assetsTypeTxt;
        break;
      case 'doc':
      case 'docx':
        icon = R.assetsTypeWord;
        break;
      case 'pdf':
        icon = R.assetsTypePdf;
        break;
      case 'rar':
      case 'zip':
      case 'tar':
      case '7z':
        icon = R.assetsTypeZip;
        break;
      case 'ppt':
      case 'pptx':
        icon = R.assetsTypePPT;
        break;
      case 'xls':
      case 'xlsx':
      case 'csv':
        icon = R.assetsTypeExcel;
        break;
    }
    return icon;
  }
}

extension MyFileType on int {
  String get fileTypeIcon {
    //文件类型:0=文件夹,1=图片,2=视频,3=音频,4=txt文件,5=word文件,6=pdf,7=excel,8=压缩包,100=其他
    var icon = R.assetsFile;
    switch (this) {
      case 0:
        icon = R.assetsTypeDir;
        break;
      case 1:
        icon = R.assetsImage;
        break;
      case 2:
        icon = R.assetsVideo;
        break;
      case 3:
        // icon = R.assetsTypeAudio;
        break;
      case 4:
        icon = R.assetsTypeTxt;
        break;
      case 5:
        icon = R.assetsTypeWord;
        break;
      case 6:
        icon = R.assetsTypePdf;
        break;
      case 7:
        icon = R.assetsTypeExcel;
        break;
      case 8:
        icon = R.assetsTypeZip;
        break;
      case 9:
        icon = R.assetsTypePPT;
        break;
      default:
        icon = R.assetsFile;
        break;
    }
    return icon;
  }
}

extension MyNumExtension on num {
  Radius get radius => Radius.circular(w);

  BorderRadius get borderRadius => BorderRadius.circular(w);

  String get playDuration {
    final time = toInt();
    final hour = time ~/ (60 * 60 * 1000);
    final min = (time % (60 * 60 * 1000)) ~/ (60 * 1000);
    final sec = (time % (60 * 1000)) ~/ 1000;
    final mills = time % 1000;
    return sprintf('%02d:%02d:%02d,%03d', [hour, min, sec, mills]);
  }

  String get fileSize {
    if (this < 1024) {
      return '${num2Price(this, pointNumber: 2)}B';
    } else if (this >= 1024 && this < 1024 * 1024) {
      return '${num2Price(this / 1024, pointNumber: 2)}KB';
    } else if (this >= 1024 * 1024 && this < 1024 * 1024 * 1024) {
      return '${num2Price(this / (1024 * 1024), pointNumber: 2)}MB';
    } else {
      return '${num2Price(this / (1024 * 1024 * 1024), pointNumber: 2)}GB';
    }
  }
}

String chatTime(int time) {
  //今日0点
  var todayZero =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  var day = DateTime.fromMillisecondsSinceEpoch(time);
  var zeroTime = todayZero.millisecondsSinceEpoch;

  if (time >= zeroTime) {
    //代表今天
    return DateUtil.formatDate(day, format: 'HH:mm');
  }
  var sub = zeroTime - time;
  if (sub < 24 * 3600 * 1000) {
    //一天内
    return DateUtil.formatDate(day, format: '昨天 HH:mm');
  }
  if (sub < 48 * 3600 * 1000) {
    return DateUtil.formatDate(day, format: '前天 HH:mm');
  }
  if (todayZero.year == day.year && todayZero.month == day.month) {
    //同一月
    return DateUtil.formatDate(day, format: 'MM-dd HH:mm');
  }
  if (todayZero.year == day.year) {
    //同一年
    return DateUtil.formatDate(day, format: 'MM-dd HH:mm');
  }
  return DateUtil.formatDate(day, format: 'yyyy-MM-dd HH:mm');
}

String num2Price(num? value, {int pointNumber = 3}) {
  if (value == null) {
    return "0";
  }
  if (value == 0) {
    return "0";
  }
  String v = sprintf("%.${pointNumber}f", [value.toDouble()]);
  while (v.contains(".") && v.endsWith("0")) {
    v = v.replaceRange(v.length - 1, v.length, "");
    if (v.endsWith(".")) {
      v = v.replaceAll(".", "");
    }
  }
  return v;
}

String hideString(String? str, int start, int end) {
  if (str == null) {
    return '';
  }
  if (str.length < start + end) {
    return str;
  }
  str = str.replaceRange(start, str.length - end, "****");
  return str;
}

String count2Str(num? count) {
  if (count == null) return '0';
  if (count < 1000) {
    return num2Price(count, pointNumber: 0);
  }
  return '${num2Price(count / 1000, pointNumber: 1)}k';
}

//--------------输入框---------------

class MyTextField extends TextField {
  MyTextField(
      {Key? key,
      TextEditingController? controller,
      TextStyle? style,
      InputDecoration? decoration,
      String? hintText,
      TextStyle? hintStyle,
      int? maxLength,
      int? maxLines,
      int? minLines,
      ValueChanged<String>? onSubmitted,
      VoidCallback? onEditingComplete,
      VoidCallback? onTap,
      ValueChanged<String>? onChanged,
      bool? obscureText,
      bool? enabled,
      TextAlign? align,
      FocusNode? focusNode,
      EdgeInsets? contentPadding,
      TextInputType? keyboardType,
      TextInputAction? textInputAction,
      List<TextInputFormatter>? inputFormatters})
      : super(
            key: key,
            style: style ??
                TextStyle(
                    fontSize: 14.sp, color: k3(), fontWeight: FontWeight.w600),
            controller: controller,
            obscureText: obscureText ?? false,
            enabled: enabled ?? true,
            textAlign: align ?? TextAlign.start,
            keyboardType: keyboardType,
            focusNode: focusNode,
            textInputAction: textInputAction,
            decoration: decoration ??
                InputDecoration(
                  contentPadding:
                      contentPadding ?? EdgeInsets.only(top: 5.w, bottom: 4.w),
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintStyle: hintStyle ??
                      TextStyle(
                          fontSize: 14.sp,
                          color: kC(),
                          fontWeight: FontWeight.w600),
                  hintText: hintText,
                ),
            inputFormatters: inputFormatters ??
                ((maxLength ?? 0) == 0
                    ? []
                    : [LengthLimitingTextInputFormatter(maxLength)]),
            maxLines: maxLines ?? 1,
            minLines: minLines ?? 1,
            onTap: onTap,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            onEditingComplete: onEditingComplete);
}

Widget appLeading(
    {Widget? leadingWidget,
    Function()? onTap,
    Color iconColor = Colors.white}) {
  return leadingWidget != null
      ? MyGestureDetector(
          onTap: onTap ??
              () {
                pop();
              },
          child: leadingWidget,
        )
      : IconButton(
          onPressed: onTap ??
              () {
                pop();
              },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: iconColor,
            size: 28.w,
          ));
}

class MyAppBar extends AppBar {
  MyAppBar(
      {super.key,
      Widget? leading,
      VoidCallback? onLeadingTap,
      super.automaticallyImplyLeading = true,
      super.title,
      super.actions,
      super.flexibleSpace,
      super.bottom,
      super.elevation,
      super.scrolledUnderElevation,
      super.notificationPredicate = defaultScrollNotificationPredicate,
      super.shadowColor,
      super.surfaceTintColor,
      super.shape,
      super.backgroundColor,
      super.foregroundColor,
      super.iconTheme,
      super.actionsIconTheme,
      super.primary = true,
      super.centerTitle,
      super.excludeHeaderSemantics = false,
      super.titleSpacing,
      super.toolbarOpacity = 1.0,
      super.bottomOpacity = 1.0,
      super.toolbarHeight,
      super.leadingWidth,
      super.toolbarTextStyle,
      super.titleTextStyle,
      super.systemOverlayStyle,
      super.forceMaterialTransparency = false,
      super.clipBehavior})
      : super(
            leading: leading ??
                IconButton(
                    onPressed: () {
                      if (onLeadingTap == null) {
                        pop();
                      } else {
                        onLeadingTap.call();
                      }
                    },
                    icon: Image.asset(
                      R.assetsNavBack,
                      width: 24.w,
                      height: 24.w,
                    )));
}

//--------------文本---------------

class MyText extends Text {
  MyText(String data,
      {super.key,
      double? size,
      Color? color,
      bool? bold,
      FontWeight? weight,
      TextOverflow? overflow,
      TextAlign? textAlign,
      int? maxLines,
      TextDecoration? decoration,
      double? lineHeight,
      String? fontFamily})
      : super(
          data,
          overflow: overflow,
          style: TextStyle(
              decoration: decoration,
              fontSize: size ?? 14.sp,
              color: color ?? k3(),
              fontWeight:
                  weight ?? (bold == true ? FontWeight.bold : FontWeight.w600),
              fontFamily: fontFamily),
          textAlign: textAlign,
          maxLines: maxLines,
          strutStyle: lineHeight == null
              ? null
              : StrutStyle(forceStrutHeight: true, height: lineHeight),
        );
}

//--------------字符串拓展---------------

extension StringMyExtension on String {
  int toInt() => int.tryParse(this) ?? 0;

  double toDouble() => double.tryParse(this) ?? 0.0;

  String toApiUrl() {
    // String path = Api.host;
    String path = AppConfig.apiHost;
    if (isEmpty) return path;
    if (startsWith('http://') || startsWith("https://")) return this;
    return path + this;
  }

  void toClipboard([String? memo]) {
    if (isNotEmpty != true) {
      showShortToast("数据为空,无需复制");
      return;
    }
    Clipboard.setData(ClipboardData(text: this));
    showShortToast(memo ?? "已复制到剪贴板");
  }

  String add(String value) {
    return "$this$value";
  }

  String toSecret() {
    if (isNotEmpty != true) {
      return "";
    }
    if (length < 7) {
      return this;
    }
    return replaceRange(3, 7, "****");
  }

  String get toMd5 {
    var content = (const Utf8Encoder()).convert(this);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return HEX.encode(digest.bytes);
  }
}

//--------------集合拓展---------------

extension ListMyExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;

  T? get lastOrNull => isEmpty ? null : last;

  T? lastOrNullWhere(bool Function(T element) f) {
    if (isEmpty) {
      return null;
    }
    var list = toList().reversed.toList();
    for (var i in list) {
      if (f(i)) {
        return i;
      }
    }
    return null;
  }

  T? firstOrNullWhere(bool Function(T element) f) {
    if (isEmpty) {
      return null;
    }
    var list = toList();
    for (var i in list) {
      if (f(i)) {
        return i;
      }
    }
    return null;
  }
}

//--------------状态loading---------------

Timer? _loadingTimer;
bool isShowLoading = false;

showLoading(
    [String? text,
    Duration? duration,
    bool? dismissOnTap,
    EasyLoadingMaskType? maskType]) {
  // _loadingTimer = Timer(duration ?? const Duration(seconds: 40), () {
  //   dismissLoading();
  // });
  EasyLoading.show(
          status: text,
          dismissOnTap: dismissOnTap ?? false,
          maskType: maskType ?? EasyLoadingMaskType.none)
      .then((value) => isShowLoading = true);
}

dismissLoading() {
  _loadingTimer?.cancel();
  EasyLoading.dismiss().then((value) => isShowLoading = false);
}

//--------------打印---------------

dprint(dynamic data, [bool needAll = false]) {
  const bool inProduction = bool.fromEnvironment("dart.vm.product");
  if (!inProduction) {
    var message = data?.toString() ?? "";
    if (needAll) {
      int maxLength = 800;
      while (message.length > maxLength) {
        debugPrint(message.substring(0, maxLength));
        message = message.substring(maxLength);
      }
    }
    debugPrint(message);
  }
}

OverlayEntry? _overlayEntry;
showOverlyTest(String message){
  // _removeOverlay();
  // BuildContext context = CustomNavigatorObserver().navigator!.context;
  // _overlayEntry = OverlayEntry(builder: (context){
  //   return Stack(children: [
  //     Positioned(child: Text(message,style: TextStyle(color: Colors.red),),bottom: 50,)
  //   ],);
  // });
  // if(context.mounted){
  //   Overlay.of(context).insert(_overlayEntry!);
  // }
}

void _removeOverlay() {
  _overlayEntry?.remove();
  _overlayEntry = null;
}

//--------------吐司---------------

FToast? fToast;

showShortToast([
  String msg = "",
  ToastGravity? gravity,
  Positioned? positioned,
]) {
  fToast ??= FToast()..init(CustomNavigatorObserver().navigator!.context);
  fToast?.showToast(
      gravity: gravity ?? ToastGravity.CENTER,
      child: Container(
        padding:
            EdgeInsets.only(left: 13.w, right: 13.w, top: 7.5.w, bottom: 8.w),
        margin: EdgeInsets.symmetric(horizontal: 30.w),
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(10.w)),
        child: MyText(
          msg,
          size: 12.sp,
          color: Colors.white,
          weight: FontWeight.normal,
        ),
      ),
      fadeDuration: const Duration(milliseconds: 200),
      positionedToastBuilder: positioned == null
          ? null
          : (context, child) {
              return positioned;
            });
}

//--------------路由---------------
Future<dynamic> pushAndRemove(String newRouteName,
    {RoutePredicate? predicate, Object? args, BuildContext? context}) {
  return _getNavigator(context).pushNamedAndRemoveUntil(
      newRouteName, predicate ?? (_) => false,
      arguments: args);
}

Future<dynamic> pushNoAnima(Widget page, {BuildContext? context}) {
  return _getNavigator(context).push(PageRouteBuilder(
      pageBuilder: (context, a1, a2) {
        return page;
      },
      transitionDuration: Duration.zero));
}

Future<dynamic> popAndPush(String newRouteName,
    {Object? args, BuildContext? context}) {
  return _getNavigator(context).popAndPushNamed(newRouteName, arguments: args);
}

void pop({Object? args, BuildContext? context}) async {
  _getNavigator(context).pop(args);
}

void popTo(RoutePredicate? predicate, {BuildContext? context}) {
  _getNavigator(context).popUntil(predicate ?? (_) => false);
}

Future<dynamic> push(String newRouteName,
    {dynamic args, BuildContext? context}) {
  return _getNavigator(context).pushNamed(newRouteName, arguments: args);
}

Future<dynamic> pushReplace(String newRouteName,
    {dynamic args, dynamic result, BuildContext? context}) {
  return _getNavigator(context)
      .pushReplacementNamed(newRouteName, arguments: args, result: result);
}

NavigatorState _getNavigator(BuildContext? context) {
  if (context != null) {
    return Navigator.of(context);
  }
  return CustomNavigatorObserver().navigator!;
}

//--------------隐藏输入法---------------

void closeEdit() {
  FocusManager.instance.primaryFocus?.unfocus();
}

//1 正式Api 0 测试Api
int get apiType => AppConfig.beta ? SP.hostType : 1;

//widget转图片
Future<Uint8List?> captureToImage(GlobalKey key,
    {Color? backgroundColor}) async {
  var boundary =
      key.currentContext?.findRenderObject() as RenderRepaintBoundary;
  var dpr = ui.window.devicePixelRatio;
  var image = await boundary.toImage(pixelRatio: dpr);
  if (backgroundColor != null) {
    var paint = Paint();
    paint.color = backgroundColor;
    var recorder = ui.PictureRecorder();
    var canvas = Canvas(recorder);
    canvas.drawRect(
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        paint);
    canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        paint);
    var img = await recorder.endRecording().toImage(image.width, image.height);
    return (await img.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  } else {
    var data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data?.buffer.asUint8List();
  }
}

Future saveFileByUrl(String url) async {
  var canSave = false;
  if (Platform.isAndroid) {
    canSave = await requestPhotosPermission(
        toast: '需要您同意相册存取权限，便于您使用该功能保存图片/视频到您的相册中');
  } else {
    canSave = await Permission.photosAddOnly.request().isGranted;
  }
  if (!canSave) {
    showShortToast("未授权，无法保存");
    return;
  }
  showLoading(null, const Duration(minutes: 30));
  try {
    var r = await DefaultCacheManager().getSingleFile(url);
    await ImageGallerySaver.saveFile(r.path);
    dismissLoading();
    showShortToast("保存成功，请前往相册查看");
  } catch (e) {
    dismissLoading();
    showShortToast('保存出错');
  }
}

Future saveImageByUrl(String url) async {
  showLoading();
  try {
    var r = await DefaultCacheManager().getSingleFile(url);
    dismissLoading();
    await saveImage(await r.readAsBytes());
  } catch (e) {
    dismissLoading();
    showShortToast('保存图片出错');
  }
}

//保存图片
Future saveImage(Uint8List? image) async {
  if (image != null) {
    var canSave = false;
    if (Platform.isAndroid) {
      canSave = await requestPhotosPermission(
          toast: '需要您同意相册存取权限，便于您使用该功能保存图片/视频到您的相册中');
    } else {
      canSave = await Permission.photosAddOnly.request().isGranted;
    }
    if (canSave) {
      await ImageGallerySaver.saveImage(image);
      showShortToast("保存成功，请前往相册查看");
    } else {
      showShortToast("未授权，无法保存");
    }
  } else {
    showShortToast('图片不存在');
  }
}

String toMd5(String value) {
  var data = const Utf8Encoder().convert(value);
  var digest = md5.convert(data);
  return digest.toString();
}

Future<String> cacheByteToFile(Uint8List byteData, {String? fileName}) async {
  final directory = await getApplicationCacheDirectory();
  var name = '';
  if (fileName?.isNotEmpty == true) {
    name = fileName!;
  } else {
    name =
        '${toMd5(DateTime.now().microsecondsSinceEpoch.toString() + Random().nextInt(10000).toString())}.png';
  }
  final dirPath = '${directory.path}/crop_cache';
  if (!(await Directory(dirPath).exists())) {
    await Directory(dirPath).create();
  }
  final filePath = '${directory.path}/crop_cache/$name';
  final file = File(filePath);
  await file.writeAsBytes(byteData);
  return filePath;
}

Widget defaultPopView(
    {required double width,
    required double height,
    required String content,
    required Widget child,
    PreferredPosition position = PreferredPosition.top}) {
  return CustomPopupMenu(
    menuBuilder: () {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.w), color: kWhite()),
        alignment: Alignment.center,
        child: MyText(
          content,
          color: kWhite(),
          size: 14.sp,
        ),
      );
    },
    pressType: PressType.singleClick,
    arrowColor: kWhite(),
    arrowSize: 8.w,
    verticalMargin: 0,
    position: position,
    barrierColor: Colors.transparent,
    child: child,
  );
}

Future<bool> requestPhotosPermission(
    {required String toast, Permission? androidPermission}) async {
  Permission permission;
  if (Platform.isAndroid) {
    // var sdkVersion = await GpUtils.getSdkVersion();
    // if (sdkVersion >= 33) {
    //   permission = androidPermission ?? Permission.photos;
    // } else {
    permission = Permission.storage;
    // }
  } else {
    permission = Permission.photos;
  }
  final status = await permission.status;
  switch (status) {
    case PermissionStatus.permanentlyDenied: //永久拒绝
    case PermissionStatus.restricted: //ios 操作系统拒绝访问，可能是父母控制等
      showShortToast('权限获取已拒绝，请前往应用设置中修改');
      return false;
    case PermissionStatus.granted: //已授权
    case PermissionStatus.limited: //受限
    case PermissionStatus.provisional: //临时的
      return true;
    case PermissionStatus.denied: //拒绝
      break;
  }
  if (SP.photoPermissionRequested) {
    showShortToast('权限获取已拒绝，请前往应用设置中修改');
    return false;
  }
  if (Platform.isAndroid) {
    // ignore: use_build_context_synchronously
    // var r = await showNormalDialog(title: '温馨提示', message: toast);
    // if (r != true) {
    //   return false;
    // }
  }
  final nextStatus = await permission.request();
  SP.photoPermissionRequested = true;
  switch (nextStatus) {
    case PermissionStatus.permanentlyDenied: //永久拒绝
    case PermissionStatus.restricted: //ios 操作系统拒绝访问，可能是父母控制等
    case PermissionStatus.denied: //拒绝
      showShortToast('权限获取已拒绝，请前往应用设置中修改');
      return false;
    case PermissionStatus.granted: //已授权
    case PermissionStatus.limited: //受限
    case PermissionStatus.provisional: //临时的
      return true;
  }
}

Future<bool> requestMyPhotosPermission(
    {Permission? androidPermission, String? title, String? message}) async {
  Permission permission;
  if (Platform.isAndroid) {
    var sdkVersion = await GpUtils.getSdkVersion();
    if (sdkVersion >= 33) {
      permission = androidPermission ?? Permission.photos;
      // permission = Permission.manageExternalStorage;
    } else {
      permission = Permission.storage;
    }
  } else {
    permission = Permission.photos;
  }
  final status = await permission.status;
  switch (status) {
    case PermissionStatus.permanentlyDenied: //永久拒绝
    case PermissionStatus.restricted: //ios 操作系统拒绝访问，可能是父母控制等
      showEmpowerDialog(permission: permission, title: title, message: message);
      return false;
    case PermissionStatus.granted: //已授权
    case PermissionStatus.limited: //受限
    case PermissionStatus.provisional: //临时的
      return true;
    case PermissionStatus.denied: //拒绝
      break;
  }

  // 记录权限数据
  Map<String, dynamic> permissionMap =
      SP.permissionStr.isEmpty ? {} : jsonDecode(SP.permissionStr);
  if (permissionMap[permission.toString()] == true) {
    showEmpowerDialog(permission: permission, title: title, message: message);
    return false;
  }

  if (Platform.isAndroid) {
    showNormalDialog(
        title: '权限提示',
        message: '存储空间/照片权限说明：用于上传头像、意见反馈、文件上传、文件保存等场景中读取和写入相册和文件内容',
        ok: '确定',
        showCancel: false);
  }
  final nextStatus = await permission.request();
  if (Platform.isAndroid) {
    pop();
  }
  permissionMap[permission.toString()] = true;
  SP.permissionStr = jsonEncode(permissionMap);

  switch (nextStatus) {
    case PermissionStatus.permanentlyDenied: //永久拒绝
    case PermissionStatus.restricted: //ios 操作系统拒绝访问，可能是父母控制等
    case PermissionStatus.denied: //拒绝
      showEmpowerDialog(permission: permission, title: title, message: message);
      return false;
    case PermissionStatus.granted: //已授权
    case PermissionStatus.limited: //受限
    case PermissionStatus.provisional: //临时的
      return true;
  }
}

/// 获取通知权限, 此处返回值为 null 时，表示用户未授权权限并且跳转设置页面
Future<dynamic> requestNotificationPermission() async {
  Permission permission = Permission.notification;
  final status = await permission.status;
  switch (status) {
    case PermissionStatus.permanentlyDenied: //永久拒绝
    case PermissionStatus.restricted: //ios 操作系统拒绝访问，可能是父母控制等
      return await openNotificationPermissionDialog();
    case PermissionStatus.granted: //已授权
    case PermissionStatus.limited: //受限
    case PermissionStatus.provisional: //临时的
      return true;
    case PermissionStatus.denied: //拒绝
      break;
  }

  // 记录权限数据
  Map<String, dynamic> permissionMap =
      SP.permissionStr.isEmpty ? {} : jsonDecode(SP.permissionStr);
  if (permissionMap[permission.toString()] == true) {
    return await openNotificationPermissionDialog();
  }

  final nextStatus = await permission.request();
  permissionMap[permission.toString()] = true;
  SP.permissionStr = jsonEncode(permissionMap);

  switch (nextStatus) {
    case PermissionStatus.permanentlyDenied: //永久拒绝
    case PermissionStatus.restricted: //ios 操作系统拒绝访问，可能是父母控制等
    case PermissionStatus.denied: //拒绝
      return await openNotificationPermissionDialog();
    case PermissionStatus.granted: //已授权
    case PermissionStatus.limited: //受限
    case PermissionStatus.provisional: //临时的
      return true;
  }
}

/// 打开通知权限提示对话框
openNotificationPermissionDialog() async {
  var r = await showNormalDialog(
      title: '权限提示',
      message: '请授权通知权限，用于保持文件传输，若不授权权限会导致文件传输中断，是否授予权限？',
      ok: '去授权',
      cancel: '取消',
      dismissible: false);
  if (r) {
    await openAppSettings();
    return null;
  }
  return false;
}

// Future<bool> requestPermissions() async {
//   // 请求照片库权限
//   PermissionState permissionState = await PhotoManager.requestPermissionExtend();
//   if (!permissionState.isAuth && PermissionState.limited != permissionState) {
//     showEmpowerDialog();
//     return false;
//   }
//   return permissionState.isAuth ? permissionState.isAuth : PermissionState.limited == permissionState;
// }

Widget maskText(
    {required Widget widget,
    required List<Color> colors,
    Axis axis = Axis.horizontal}) {
  return ShaderMask(
    shaderCallback: (Rect bounds) {
      return LinearGradient(
              colors: colors,
              tileMode: TileMode.mirror,
              begin: axis == Axis.horizontal
                  ? Alignment.centerLeft
                  : Alignment.topCenter,
              end: axis == Axis.horizontal
                  ? Alignment.centerRight
                  : Alignment.bottomCenter)
          .createShader(bounds);
    },
    blendMode: BlendMode.srcATop,
    child: Center(
      child: widget,
    ),
  );
}

/// 压缩GIF图片(未完成)
Future<File> compressGif(File file) async {
  // List<int> imageBytes = await file.readAsBytes();

  // // 将 List<int> 转换为 Uint8List
  // Uint8List uint8List = Uint8List.fromList(imageBytes);
  // // 使用flutter_image_compress进行GIF压缩
  // final compressedData = await FlutterImageCompress.compressWithList(
  //   uint8List,
  //   quality: 50,
  // );
  // print('compressedData GIF ${compressedData.length / 1024} KB');
  // String fileName = file.uri.pathSegments.last;
  // // 将 Uint8List 转换为 File
  // final tempDir = await getTemporaryDirectory();
  // final tempPath = '${tempDir.path}/$fileName';  // 临时文件路径
  // final tempFile = File(tempPath);

  // // 将 Uint8List 数据写入文件
  // await tempFile.writeAsBytes(compressedData);

  // // return tempFile;  // 返回 File 类型
  // print('GIF: ${await file.length() / 1024} KB');
  return file;
}

// 压缩JPEG或PNG图片
Future<File> compressImage(File file) async {
  List<int> imageBytes = await file.readAsBytes();

  final Uint8List originalImageData = Uint8List.fromList(imageBytes);
  // 进行图片压缩，这里可以设置压缩参数，比如质量等
  final compressedImageData = await FlutterImageCompress.compressWithList(
    originalImageData,
    quality: 50, // 压缩质量，取值0-100，可按需调整
  );

  String fileName = file.uri.pathSegments.last;
  // 将 Uint8List 转换为 File
  final tempDir = await getTemporaryDirectory();
  final tempPath = '${tempDir.path}/$fileName'; // 临时文件路径
  final tempFile = File(tempPath);

  // 将 Uint8List 数据写入文件
  await tempFile.writeAsBytes(compressedImageData);

  return tempFile; // 返回 File 类型
}
