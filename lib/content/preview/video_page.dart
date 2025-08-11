import 'dart:io';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

Future<dynamic> showVideoPage({required String pathUrl}) {
  return showDialog(
    context: CustomNavigatorObserver().navigator!.context,
    builder: (context) {
      return VideoPage(pathUrl);
    },
    barrierDismissible: false,
    barrierColor: Colors.black,
    useSafeArea: false,
  );
}

class VideoPage extends StatefulWidget {
  final String pathUrl;

  const VideoPage(this.pathUrl, {super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> with TickerProviderStateMixin {

  late VideoPlayerController controller;
  // 初始化是否已完成
  bool _isInitialized = false;
  // 是否显示控制器
  bool _showControls = false;
  // 是否播放中
  bool _isPlaying = false;
  // 当前倍速下标
  int _speedIndex = 1;
  // 倍速列表
  final List<double> _speedList = [0.5, 1.0, 1.5, 2.0];
  // 视频总时长
  Duration _duration = Duration.zero;
  // 当前播放进度
  Duration _position = Duration.zero;
  // 缓冲进度
  Duration _buffered = Duration.zero;
  // 缓冲状态
  bool _isBuffering = false;
  // 是否全屏
  bool _isFullScreen = false;
  // 是否为竖屏视频
  bool _isPortraitVideo = false;
  // 是否加载失败
  bool _isLoadFailed = false;
  // 添加缓冲进度动画控制器
  late AnimationController _bufferingAnimationController;

  @override
  void initState() {
    super.initState();
    _bufferingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // 动画周期1.5秒
    )..repeat(); // 循环播放动画

    _initializeVideo();
  }

  // 初始化视频
  _initializeVideo() async {
    try {
      // 判断是否为本地文件路径
      final bool isLocalFile = widget.pathUrl.startsWith('/') || widget.pathUrl.startsWith('file://');
      
      // 根据路径类型创建不同的 VideoPlayerController
      controller = isLocalFile
          ? VideoPlayerController.file(File(widget.pathUrl))
          : VideoPlayerController.networkUrl(Uri.parse(widget.pathUrl));

      await controller.initialize();
      _duration = controller.value.duration;

      // 根据视频宽高比判断是否为竖屏视频
      _isPortraitVideo = controller.value.aspectRatio < 1.0;

      // 添加视频控制器监听
      controller.addListener(_videoListener);
      await controller.play();
      setState(() {
        _isInitialized = true;
        _isPlaying = true;
      }); 
    } catch (e) {
      setState(() {
        _isInitialized = true;
        _isPlaying = false;
        _isLoadFailed = true;
      });
    }
  }

  // 视频控制器监听
  _videoListener() {
    if (!controller.value.isInitialized || !mounted) return;

    setState(() {
      // 更新播放状态
      _isPlaying = controller.value.isPlaying;

      // 更新缓冲状态
      _isBuffering = controller.value.isBuffering;

      // 更新播放进度
      _position = controller.value.position;
      
      // 更新缓冲进度
      if (controller.value.buffered.isNotEmpty) {
        _buffered = controller.value.buffered.last.end;
      }
      
      // 检测播放结束
      if (_position >= _duration) {
        _isPlaying = false;
      }
    });
  }

  // 处理视频旋转
  void _toggleVideoRotation() async {
    setState(() {
      _isFullScreen = !_isFullScreen;
      _showControls = false;
    });
    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      AutoOrientation.landscapeRightMode();
    } else {
      // 退出全屏：恢复系统UI并设置竖屏
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
      );
      SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, 
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      AutoOrientation.portraitUpMode();
    }
  }

  /// 计算视频显示比例
  /// 在全屏和非全屏状态下都保持视频原始比例，避免拉伸
  double _calculateAspectRatio(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final videoRatio = controller.value.aspectRatio;
    final screenRatio = size.width / size.height;
    
    if (_isFullScreen) {
      return videoRatio > screenRatio ? screenRatio : videoRatio;
    } 
    return videoRatio;
  }

  /// 重新加载视频
  Future<void> _reloadVideo() async {
    setState(() {
      _isInitialized = false;
      _isLoadFailed = false;
      _position = Duration.zero;
      _buffered = Duration.zero;
    });

    // 确保先释放旧的controller资源
    if (controller.value.isInitialized) {
      await controller.dispose();
    }

    // 重新初始化视频
    await _initializeVideo();
  }

  @override
  Widget build(BuildContext context) {  
    if (!_isInitialized) {
      return Stack(
        children: [
          const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            )
          ),
          Positioned(
            top: safeAreaTop,
            left: 0,
            child: IconButton(
              onPressed: () {
                if (_isFullScreen) {
                  _toggleVideoRotation();
                } else {
                  pop();
                }
              }, 
              icon: Image.asset(R.assetsNavBack, width: 24.w, height: 24.w, color: Colors.white)
            ),
          )
        ],
      );
    }
    if (_isLoadFailed) {
      return Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 48.w, color: Colors.white),
                spaceH(12),
                MyButton(
                  title: '点击重新加载',
                  width: 132.w,
                  height: 54.w,
                  onTap: _reloadVideo,
                )
              ],
            ),
          ),
          Positioned(
            top: safeAreaTop,
            left: 0,
            child: IconButton(
              onPressed: () {
                if (_isFullScreen) {
                  _toggleVideoRotation();
                } else {
                  pop();
                }
              }, 
              icon: Image.asset(R.assetsNavBack, width: 24.w, height: 24.w, color: Colors.white)
            ),
          )
        ],
      );
    }
    return WillPopScope(
      onWillPop: () async {
        if (_isFullScreen) {
          _toggleVideoRotation();
          return false;
        }
        await controller.pause();
        return true;
      },
      child: GestureDetector(
        onDoubleTap: () {
          if (_isPlaying) {
            controller.pause();
          } else {
            controller.play();
          }
        },
        onTap: () {
          setState(() {
            _showControls = !_showControls;
          });
        },
        child: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: _calculateAspectRatio(context),
                child: VideoPlayer(controller),
              ),
            ),
            // 顶部返回按钮
            _showControls ? Positioned(
              top: _isFullScreen ? 0 : safeAreaTop,
              left: _isFullScreen ? 12.w : 0,
              child: AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: IconButton(
                  onPressed: () {
                    if (_isFullScreen) {
                      _toggleVideoRotation();
                    } else {
                      pop();
                    }
                  }, 
                  icon: Image.asset(R.assetsNavBack, width: 24.w, height: 24.w, color: Colors.white)
                ),
              ),
            ) : const SizedBox.shrink(),
            // 底部播放按钮、进度条、倍数
            _showControls ? Positioned(
              bottom: _isFullScreen ? 6.w : 24.w,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity, // 指定容器宽度
                color: Colors.black54, // 添加背景色提升可读性
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_isPlaying) {
                          controller.pause();
                        } else {
                          controller.play();
                        }
                      }, 
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow)
                    ),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          // 缓冲进度条
                          if (_isBuffering)
                            // 使用AnimatedBuilder来构建动画效果
                            AnimatedBuilder(
                              animation: _bufferingAnimationController,
                              builder: (context, child) {
                                return Container(
                                  width: double.infinity,
                                  height: 2.0,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: const [
                                        Colors.transparent,
                                        Colors.white24,
                                        Colors.white38,
                                        Colors.white24,
                                        Colors.transparent,
                                      ],
                                      stops: [
                                        0.0,
                                        (_bufferingAnimationController.value - 0.2).clamp(0.0, 1.0),
                                        _bufferingAnimationController.value,
                                        (_bufferingAnimationController.value + 0.2).clamp(0.0, 1.0),
                                        1.0,
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          else
                            // 正常的缓冲进度显示
                            Container(
                              width: MediaQuery.of(context).size.width * 
                                (_buffered.inMilliseconds / _duration.inMilliseconds),
                              height: 2.0,
                              color: Colors.white24,
                            ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 2.0, // 设置轨道高度
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6.0, // 设置滑块大小
                              ),
                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 12.0, // 设置点击时的涟漪效果大小
                              ),
                              trackShape: const CustomTrackShape(), // 使用自定义轨道形状
                            ),
                            child: Slider(
                              value: _position.inMilliseconds.toDouble(),
                              min: 0,
                              max: _duration.inMilliseconds.toDouble(),
                              activeColor: Colors.white,
                              inactiveColor: Colors.white12,
                              onChangeStart: (value) {
                                // 开始拖动时暂停视频
                                controller.pause();
                              },
                              onChanged: (value) {
                                setState(() {
                                  _position = Duration(milliseconds: value.toInt());
                                });
                              },
                              onChangeEnd: (value) {
                                // 拖动结束时跳转并继续播放
                                controller.seekTo(Duration(milliseconds: value.toInt()));
                                controller.play();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    spaceW(8),
                    MyButton(
                      width: _isFullScreen ? 22.w : 32.w,
                      height: _isFullScreen ? 12.w : 24.w,
                      decoration: BoxDecoration(
                        borderRadius: _isFullScreen ? 10.borderRadius : 12.borderRadius,
                        color: Colors.white12
                      ),
                      child: MyText(
                        _speedList[_speedIndex].toString(),
                        size: _isFullScreen ? 8.sp : 12.sp,
                        weight: FontWeight.normal,
                        color: Colors.white,
                      ),
                      onTap: () async {
                        setState(() {
                          _speedIndex = (_speedIndex + 1) % _speedList.length;
                        });
                        await controller.setPlaybackSpeed(_speedList[_speedIndex]);
                      },
                    ),
                    spaceW(6),
                    MyText(
                      '${_formatDuration(_position)}/${_formatDuration(_duration)}',
                      size: _isFullScreen ? 8.sp : 12.sp,
                      weight: FontWeight.normal,
                      color: Colors.white,
                    ),
                    spaceW(6),
                    if (!_isPortraitVideo) 
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: _toggleVideoRotation, 
                        icon: Icon(_isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen)
                      )
                  ],
                ),
              ),
            ) : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.removeListener(_videoListener);
    controller.pause();
    controller.dispose();
    _bufferingAnimationController.dispose();
    // // 退出全屏：恢复系统UI并设置竖屏
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
    AutoOrientation.portraitUpMode();
    super.dispose();
  }
}

/// 格式化时间为 时:分:秒
String _formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String hours = duration.inHours > 0 ? '${twoDigits(duration.inHours)}:' : '';
  String minutes = twoDigits(duration.inMinutes.remainder(60));
  String seconds = twoDigits(duration.inSeconds.remainder(60));
  return '$hours$minutes:$seconds';
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  const CustomTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 2.0;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
