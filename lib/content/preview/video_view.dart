import 'dart:async';

import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/utils/fijkplayer_skin.dart';
import 'package:flutter/material.dart';
import 'package:fijkplayer/fijkplayer.dart';

Future<dynamic> showVideoViewSheet({required String videoPath}) {
  return showDialog(
    context: CustomNavigatorObserver().navigator!.context,
    barrierDismissible: true, // 点击外部不关闭
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero, // 移除默认内边距
        child: VideoView(videoPath),
      );
    },
  );
}

class VideoView extends StatefulWidget {

  final String videoPath;
  const VideoView(this.videoPath, {super.key});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  
  /// 视频播放器控制器
  final FijkPlayer _player = FijkPlayer();
  
  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  /// 初始化播放器
  Future<void> _initPlayer() async {
    try {
      // 判断是否为网络视频
      final bool isNetwork = widget.videoPath.startsWith('http');
      if (isNetwork) {
        await _player.setDataSource(widget.videoPath, autoPlay: true);
      } else {
        await _player.setDataSource(widget.videoPath, autoPlay: true, showCover: true);
      }
    } catch (e) {
      debugPrint('视频播放器初始化失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: MyAppBar(
      //   title: MyText('视频预览'),
      // ),
      backgroundColor: Colors.black,
      body: FijkView(
        color: Colors.black,
        player: _player,
        // panelBuilder: fijkPanel2Builder(
        //   snapShot: true,
        //   fill: true,
        //   doubleTap: true,
        // ), // 使用默认的控制面板
        // panelBuilder: customPanelBuilder,
        panelBuilder: (player, data, context, viewSize, texturePos) {
          return Obx(() => CustomFijkPanel(
            player: player,
            buildContext: context,
            viewSize: viewSize,
            texturePos: texturePos,
            isShowSpeed: user.memberEquity.value?.vipStatus == 1,
          ));
        },
        fsFit: FijkFit.contain,
      ),
    );
  }

  /// 自定义控制面板构建器
  Widget customPanelBuilder(FijkPlayer player, FijkData data, BuildContext context, Size viewSize, Rect texturePos) {
    return CustomFijkPanel(
      player: player,
      buildContext: context,
      viewSize: viewSize,
      texturePos: texturePos,
    );
  }

  @override
  void dispose() {
    _player.release(); // 释放播放器资源
    super.dispose();
  }
}

