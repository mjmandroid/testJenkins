import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:desk_cloud/alert/limited_time_offer_dialog.dart';
import 'package:desk_cloud/alert/normal_dialog.dart';
import 'package:desk_cloud/alert/open_member_sheet.dart';
import 'package:desk_cloud/content/file/file_home_sub_logic.dart';
import 'package:desk_cloud/content/preview/video_page.dart';
import 'package:desk_cloud/content/tabs/tab_command_logic.dart';
import 'package:desk_cloud/content/user/oss_logic.dart';
import 'package:desk_cloud/database/file_io_record.dart';
import 'package:desk_cloud/entity/disk_file_entity.dart';
import 'package:desk_cloud/entity/notice_entity.dart';
import 'package:desk_cloud/entity/option_entity.dart';
import 'package:desk_cloud/entity/preview_entity.dart';
import 'package:desk_cloud/entity/share_code_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/widgets/file_option/file_option_container.dart';
import 'package:desk_cloud/widgets/io_option/io_option_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_handler/share_handler.dart';

class TabParentLogic extends BaseLogic {
  FileOptionController? optionC;
  IoOptionController? ioOption;
  final tabs = [
    OptionEntity()
      ..title = '口令'
      ..icon = R.assetsTabCommandN
      ..activeIcon = R.assetsTabCommandY,
    OptionEntity()
      ..title = '文件'
      ..icon = R.assetsTabFileN
      ..activeIcon = R.assetsTabFileY,
    OptionEntity()
      ..title = '传输'
      ..icon = R.assetsTabIoN
      ..activeIcon = R.assetsTabIoY,
    OptionEntity()
      ..title = '会员'
      ..icon = R.assetsTabMemberN
      ..activeIcon = R.assetsTabMemberY
      ..activeColor = k924B05()
  ].obs;
  final currentIndex = 0.obs;
  final pageController = PageController();
  /// 是否已展示优惠弹窗
  bool isShowLimitedTimeOfferDialog = false;

  AnimationController? productController;
  Animation<double>? productAnimation;
  var isShowProductsAnimation = false.obs;
  // 添加节流控制变量
  DateTime? _lastGetUserVipTime;

  initProductAnimation(TickerProvider vsync, double targetPrice) {
    // 如果已经存在控制器，先释放
    productController?.dispose();

    productController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: vsync,
    );

    productAnimation = Tween<double>(
      begin: targetPrice + 20,
      end: targetPrice,
    ).animate(CurvedAnimation(
      parent: productController!,
      curve: Curves.easeOut,
    ));
  }

  jumpToPage(int index) async {
    if (index == 3) {
      // 检查是否在3秒内已经调用过
      final now = DateTime.now();
      if (_lastGetUserVipTime == null ||
          now.difference(_lastGetUserVipTime!) > const Duration(seconds: 3)) {
        _lastGetUserVipTime = now;
        user.getUserVip();
      }
    }

    if (currentIndex.value != index) {
      // if (index == 0){
      //   find<TabCommandLogic>()?.getClipboardData();
      // }
      currentIndex.value = index;
      pageController.jumpToPage(index);
      if (index == 3 && !isShowLimitedTimeOfferDialog) {
        isShowLimitedTimeOfferDialog = true;
        await showLimitedTimeOfferDialog();
        await productController?.forward();
        Timer.periodic(const Duration(milliseconds: 2000), (timer) {
          isShowProductsAnimation.value = true;
        });
      }
    }
  }

  getClipboardContext() async {
    // 访问剪贴板的内容。
    ClipboardData? clipboardData =
        await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null &&
        clipboardData.text!.isNotEmpty &&
        clipboardData.text!.length <= 1000) {
      try {
        var base = await ApiNet.request<ShareCodeEntity>(Api.getShareCode,
            data: {'text': clipboardData.text});
        Clipboard.setData(const ClipboardData(text: ''));
        if (base.data!.code!.isNotEmpty && base.data!.pageType! == 2) {
          tabCommandLogic.pickUpAction(shareCode: base.data!.code!);
        }
      } catch (e) {
        // showShortToast(e.toString());
      }
    }
  }

  /// 刷新文件列表
  refreshFileHome() {
    if (Get.isRegistered<FileHomeSubLogic>(tag: 'FileHomeSubLogic_')) {
      FileHomeSubLogic fileHomeSubLogic =
          Get.find<FileHomeSubLogic>(tag: 'FileHomeSubLogic_');
      fileHomeSubLogic.onRefresh();
    }
    if (Get.isRegistered<FileHomeSubLogic>(tag: 'FileHomeSubLogic_1')) {
      FileHomeSubLogic fileHomeSubLogic1 =
          Get.find<FileHomeSubLogic>(tag: 'FileHomeSubLogic_1');
      fileHomeSubLogic1.onRefresh();
    }
    if (Get.isRegistered<FileHomeSubLogic>(tag: 'FileHomeSubLogic_2')) {
      FileHomeSubLogic fileHomeSubLogic2 =
          Get.find<FileHomeSubLogic>(tag: 'FileHomeSubLogic_2');
      fileHomeSubLogic2.onRefresh();
    }
  }

  /// 获取文件预览公链并预览
  getDiskDetail(DiskFileEntity diskFileEntity) async {
    try {
      if (diskFileEntity.fileType == 8) {
        oss.checkFile([diskFileEntity], isShowNormalDialog: true);
        return;
      }
      showLoading();
      var base = await ApiNet.request<PreviewEntity>(Api.aliyunGetUrl, data: {
        'file_id': diskFileEntity.id,
        'type': diskFileEntity.fileType == 1
            ? 'image'
            : diskFileEntity.fileType == 2
                ? 'video'
                : 'pdf'
      });
      dismissLoading();
      showFilePreview(diskFileEntity.fileType, base.data?.url);
    } catch (e) {
      dismissLoading();
      showShortToast(e.toString());
    }
  }

  // 文件公链预览
  showFilePreview(int? fileType, String? url) async {
    switch (fileType) {
      case 1:
        push(MyRouter.imagePreview, args: url ?? '');
        break;
      case 2:
        // push(MyRouter.videoPreview, args: base.data?.url ?? '');
        // showVideoPreviewTempSheet(videoPath: base.data?.url ?? '');
        // showVideoViewSheet(videoPath: base.data?.url ?? '');
        /// 1.0.65+75 修改视频预览
        // push(MyRouter.videoView, args: base.data?.url ?? '');

        // push(MyRouter.videoPage, args: base.data?.url ?? '');
        showVideoPage(pathUrl: url ?? '');

        break;
      case 5:
        push(MyRouter.wordPreview, args: url ?? '');
        break;
      case 6:
        push(MyRouter.pdfPreview, args: url ?? '');
        break;
      default:
        showShortToast('该文件类型不支持在线预览,请下载后再查看');
      // FileOpenerUtil.openWith(url ?? '');
    }
  }

  /// 展示公告队列
  Future<void> showNoticeQueue(List<NoticeEntity> notices) async {
    List<String> noticeRecord = SP.noticeRecord;
    for (var noticeItem in notices) {
      int noticeId = noticeItem.id ?? 0;
      if (noticeRecord.contains('$noticeId')) {
        continue;
      }
      // 使用 await 确保公告按顺序显示
      await showNormalDialog(
        title: noticeItem.title,
        message: noticeItem.content,
        showCancel: false,
        okBtnColor: k4A83FF(),
        okTextColor: kWhite(),
        messageTextAlign: TextAlign.left,
        dismissible: false,
      );
      noticeRecord.add('$noticeId');
      SP.noticeRecord = noticeRecord;
      await .3.delay();

      // // 如果用户点击取消或关闭对话框，终止后续公告显示
      // if (result == null || result == false) {
      //   break;
      // }
    }
  }

  /// 获取公告列表
  getNoticeList() async {
    var base = await ApiNet.request<List<NoticeEntity>>(Api.getNoticeList);
    if (base.data != null && base.data!.isNotEmpty) {
      showNoticeQueue(base.data!);
    }
  }

  SharedMedia? media;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    final handler = ShareHandlerPlatform.instance;
    media = await handler.getInitialSharedMedia();

    handler.sharedMediaStream.listen((SharedMedia media) async {
      List<Map<String, dynamic>> fileList = [];
      for (var item in media.attachments ?? []) {
        if (Platform.isIOS) {
          bool granted = await startAccessing(item.path);
          if (!granted) {
            showShortToast('文件权限不足，暂无法在此文件夹共享文件');
            await stopAccessing(item.path);
            continue;
          }
          String tempFilePath = await copyFileToTemp(item.path);
          await stopAccessing(item.path);
          fileList.add({
            'path': tempFilePath,
            'id': '0',
          });
        } else {
          fileList.add({
            'path': item.path,
            'id': '0',
          });
        }
      }

      ShareHandlerPlatform.instance.resetInitialSharedMedia();
      if (fileList.isNotEmpty) {
        oss.uploadFile(fileList, 0);
      }
    });
  }

  /// 检查 iCloud 文件是否已下载
  Future<bool> checkICloudFileDownloaded(String filePath) async {
    if (!filePath.contains('Mobile Documents/com~apple~CloudDocs')) {
      return true; // 非 iCloud 文件，直接返回 true
    }

    try {
      final bool isDownloaded = await platform
          .invokeMethod('checkFileDownloaded', {'path': filePath});
      return isDownloaded;
    } catch (e) {
      debugPrint("检查文件下载状态失败: $e");
      return false;
    }
  }

  /// 将文件复制到临时文件夹
  /// [filePath] 源文件路径
  /// 返回临时文件路径
  Future<String> copyFileToTemp(String filePath) async {
    try {
      // 创建临时目录
      final tempDir = await Directory.systemTemp.create(recursive: true);
      final fileName = filePath.split('/').last;
      final targetPath = '${tempDir.path}/$fileName';

      // 复制文件
      final file = File(filePath);
      await file.copy(targetPath);

      return targetPath;
    } catch (e) {
      debugPrint('复制文件失败: $e');
      rethrow;
    }
  }

  final platform = const MethodChannel('securityScopedAccess');

  Future<bool> startAccessing(String filePath) async {
    try {
      final bool granted =
          await platform.invokeMethod('startAccessing', {'path': filePath});
      return granted;
    } catch (e) {
      debugPrint("Error accessing file: $e");
      return false;
    }
  }

  Future<void> stopAccessing(String filePath) async {
    try {
      await platform.invokeMethod('stopAccessing', {'path': filePath});
    } catch (e) {
      debugPrint("Error stopping access: $e");
    }
  }

  /// 监听网络变化
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  /// 监听网络变化
  void initConnectivityListener() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      // 检查是否真的能连接到网络
      if (result == ConnectivityResult.none) {
        /// 网络出现波动时，提示，并暂停下载或上传列表
        var taskRes = oss.realm
            .query<FileIoDataRM>(r'status == 0 or status == 1 or status == 5');
        if (taskRes.isNotEmpty) {
          showShortToast('网络波动，将暂停上传、下载任务');
          for (var value in taskRes) {
            oss.cancelTask(value);
          }
        }
      } else {
        // 网络恢复时的操作
      }
    });
  }

  @override
  void onInit() async {
    super.onInit();
    user.initBugly();
    await oss.initSdk();
    user.initWechat();
    user.initQQ();
    user.initWeibo();
    getNoticeList();
    initPlatformState();
    initConnectivityListener();
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }
}

TabParentLogic get tabParentLogic {
  if (Get.isRegistered<TabParentLogic>()) {
    return Get.find<TabParentLogic>();
  }
  return Get.put(TabParentLogic());
}
