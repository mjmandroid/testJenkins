import 'dart:io';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

/// 显示视频预览对话框
Future<dynamic> showVideoPreviewTempSheet({required String videoPath}) {
  // 先隐藏系统UI
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [], // 清空所有系统UI
  );
  
  return showDialog(
    context: CustomNavigatorObserver().navigator!.context,
    barrierDismissible: true, // 点击外部不关闭
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero, // 移除默认内边距
        child: VideoPreviewTemp(videoPath),
      );
    },
  );
}

/// 视频预览页面组件
class VideoPreviewTemp extends StatefulWidget {
  const VideoPreviewTemp(this.videoPath, {
    super.key,
    this.autoPlay = false,
  });

  /// 视频文件路径
  final String videoPath;
  
  /// 是否自动播放
  final bool autoPlay;

  @override
  State<VideoPreviewTemp> createState() => _VideoPreviewTempState();
}

class _VideoPreviewTempState extends State<VideoPreviewTemp> {
  /// 视频控制器
  VideoPlayerController? _controller;
  
  /// 控制器是否已初始化
  bool _hasLoaded = false;
  
  /// 初始化是否发生错误
  bool _hasError = false;

  /// 播放状态监听器
  final ValueNotifier<bool> _isPlaying = ValueNotifier<bool>(false);
  
  /// 控制器是否显示
  final ValueNotifier<bool> _showControls = ValueNotifier<bool>(true);
  
  /// 视频进度
  final ValueNotifier<Duration> _position = ValueNotifier<Duration>(Duration.zero);

  /// 是否全屏
  final ValueNotifier<bool> _isFullScreen = ValueNotifier<bool>(false);

  /// 播放速度选项
  final List<double> _speedRates = [1.0, 1.25, 1.5, 2.0, 0.5, 0.75];
  
  /// 当前播放速度索引
  int _currentSpeedIndex = 0;

  /// 切换播放速度
  Future<void> _togglePlaybackSpeed() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    
    try {
      setState(() {
        _currentSpeedIndex = (_currentSpeedIndex + 1) % _speedRates.length;
      });
      
      final speed = _speedRates[_currentSpeedIndex];
      
      // 如果当前正在播放，先暂停
      final wasPlaying = _controller!.value.isPlaying;
      if (wasPlaying) {
        await _controller!.pause();
      }
      
      // 设置新的播放速度
      await _controller!.setPlaybackSpeed(speed);
      
      // 如果之前在播放，恢复播放
      if (wasPlaying) {
        await _controller!.play();
        // 确保播放速度正确
        await Future.delayed(const Duration(milliseconds: 50));
        await _controller!.setPlaybackSpeed(speed);
      }
      
      debugPrint('切换播放速度: ${speed}x, 实际速度: ${_controller!.value.playbackSpeed}x');
    } catch (e) {
      debugPrint('设置播放速度失败: $e');
    }
  }

  /// 是否为横屏视频
  bool get isLandscapeVideo {
    if (_controller == null) return false;
    final aspectRatio = _controller!.value.aspectRatio;
    return aspectRatio > 1.0; // 宽高比大于1表示横屏视频
  }

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void dispose() {
    // 恢复默认的系统UI设置
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    
    // 恢复竖屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, 
      overlays: SystemUiOverlay.values);
      
    _position.dispose();
    _showControls.dispose();
    _isPlaying.dispose();
    _isFullScreen.dispose();
    _controller?.dispose();
    super.dispose();
  }

  /// 初始化视频播放器
  Future<void> _initializePlayer() async {
    try {
      final isNetwork = widget.videoPath.startsWith('http');
      _controller = isNetwork 
          ? VideoPlayerController.networkUrl(Uri.parse(widget.videoPath))
          : VideoPlayerController.file(File(widget.videoPath));
      
      await _controller!.initialize();
      
      // 确保控制器已经初始化完成后再设置播放速度
      if (_controller!.value.isInitialized) {
        // 设置初始播放速度为 1.0x
        _currentSpeedIndex = 0; // 确保从 1.0x 开始
        await _controller!.setPlaybackSpeed(_speedRates[_currentSpeedIndex]);
        debugPrint('初始化时设置播放速度: ${_speedRates[_currentSpeedIndex]}x');
      }
      
      _hasLoaded = true;
      _controller!.addListener(_videoPlayerListener);
      
      if (widget.autoPlay) {
        await _controller!.play();
      }
      
      setState(() {});
    } catch (e) {
      debugPrint('视频初始化失败: $e');
      _hasError = true;
      setState(() {});
    }
  }


  /// 视频播放器状态监听
  void _videoPlayerListener() {
    if (_controller == null) return;
    
    // 检测播放状态变化
    final isControllerPlaying = _controller!.value.isPlaying;
    if (isControllerPlaying != _isPlaying.value) {
      _isPlaying.value = isControllerPlaying;
      
      // 播放状态改变时，确保播放速度正确
      if (isControllerPlaying) {
        final speed = _speedRates[_currentSpeedIndex];
        _controller!.setPlaybackSpeed(speed).then((_) {
          debugPrint('状态改变后设置速度: ${speed}x');
        });
      }
    }
    
    // 更新进度
    _position.value = _controller!.value.position;
  }

  /// 播放/暂停按钮回调
  Future<void> _onPlayButtonTap() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      if (_isPlaying.value) {
        await _controller?.pause();
        _showControls.value = true;
      } else {
        if (_controller?.value.position == _controller?.value.duration) {
          await _controller?.seekTo(Duration.zero);
        }
        
        // 1. 先开始播放
        await _controller?.play();
        
        // 2. 等待一小段时间确保播放已经开始
        await Future.delayed(const Duration(milliseconds: 50));
        
        // 3. 设置播放速度
        final speed = _speedRates[_currentSpeedIndex];
        await _controller!.setPlaybackSpeed(speed);
        
        // 4. 验证播放速度是否设置成功
        await Future.delayed(const Duration(milliseconds: 50));
        final actualSpeed = _controller!.value.playbackSpeed;
        debugPrint('目标播放速度: ${speed}x, 实际播放速度: ${actualSpeed}x');
        
        // 5. 如果设置失败，重试一次
        if (actualSpeed != speed) {
          debugPrint('播放速度设置未生效，尝试重新设置...');
          await _controller!.setPlaybackSpeed(speed);
        }
        
        _showControls.value = false;
      }
    } catch (e) {
      debugPrint('播放控制失败: $e');
    }
  }

  /// 切换全屏
  Future<void> _toggleFullScreen() async {
    if (!isLandscapeVideo) return;
    
    final isFullScreen = _isFullScreen.value;
    if (isFullScreen) {
      // 退出全屏
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    } else {
      // 进入全屏
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
    _isFullScreen.value = !isFullScreen;
  }

  /// 格式化时长
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0 
        ? '$hours:$minutes:$seconds' 
        : '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const Center(
        child: Text('视频加载失败'),
      );
    }

    if (!_hasLoaded) {
      return const Material(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Material(
      color: Colors.black,
      child: ValueListenableBuilder<bool>(
        valueListenable: _isFullScreen,
        builder: (context, isFullScreen, child) {
          return Stack(
            children: [
              // 视频播放器
              Center(
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              ),

              // 播放控制按钮
              ValueListenableBuilder<bool>(
                valueListenable: _isPlaying,
                builder: (context, isPlaying, _) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _onPlayButtonTap,
                    child: Center(
                      child: AnimatedOpacity(
                        duration: kThemeAnimationDuration,
                        opacity: isPlaying ? 0.0 : 1.0,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            boxShadow: [BoxShadow(color: Colors.black12)],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isPlaying 
                                ? Icons.pause_circle_outline
                                : Icons.play_circle_filled,
                            size: 70.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // 顶部返回栏
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ValueListenableBuilder<bool>(
                  valueListenable: _isPlaying,
                  builder: (context, isPlaying, _) {
                    return AnimatedOpacity(
                      duration: kThemeAnimationDuration,
                      opacity: isPlaying ? 0.0 : 1.0,
                      child: Container(
                        height: 44.w,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black54, Colors.transparent],
                          ),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (isFullScreen) {
                                  _toggleFullScreen();
                                } else {
                                  // 退出时恢复系统UI
                                  SystemChrome.setEnabledSystemUIMode(
                                    SystemUiMode.manual,
                                    overlays: SystemUiOverlay.values,
                                  );
                                  pop();
                                }
                              },
                              icon: Image.asset(
                                R.assetsNavBack,
                                width: 24.w,
                                height: 24.w,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 底部控制栏
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ValueListenableBuilder<bool>(
                  valueListenable: _isPlaying,
                  builder: (context, isPlaying, _) {
                    return AnimatedOpacity(
                      duration: kThemeAnimationDuration,
                      opacity: isPlaying ? 0.0 : 1.0,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black54, Colors.transparent],
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 进度条
                            ValueListenableBuilder<Duration>(
                              valueListenable: _position,
                              builder: (context, position, _) {
                                final duration = _controller?.value.duration ?? Duration.zero;
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                                  child: Row(
                                    children: [
                                      Text(
                                        _formatDuration(position),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: SliderTheme(
                                          data: SliderThemeData(
                                            trackHeight: 2.h,
                                            thumbShape: RoundSliderThumbShape(
                                              enabledThumbRadius: 6.r,
                                            ),
                                            overlayShape: RoundSliderOverlayShape(
                                              overlayRadius: 12.r,
                                            ),
                                            activeTrackColor: Colors.white,
                                            inactiveTrackColor: Colors.white24,
                                            thumbColor: Colors.white,
                                            overlayColor: Colors.white24,
                                          ),
                                          child: Slider(
                                            value: position.inMilliseconds.toDouble(),
                                            min: 0,
                                            max: duration.inMilliseconds.toDouble(),
                                            onChanged: (value) {
                                              _controller?.seekTo(
                                                Duration(milliseconds: value.toInt()),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        _formatDuration(duration),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 16.h),
                            // 底部控制栏
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Row(
                                children: [
                                  // 播放速度按钮
                                  GestureDetector(
                                    onTap: _togglePlaybackSpeed,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 6.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white24,
                                        borderRadius: BorderRadius.circular(16.r),
                                      ),
                                      child: Text(
                                        '${_speedRates[_currentSpeedIndex]}x',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  // 全屏按钮 - 只在横屏视频时显示
                                  if (isLandscapeVideo) ...[
                                    GestureDetector(
                                      onTap: _toggleFullScreen,
                                      child: Icon(
                                        isFullScreen 
                                            ? Icons.fullscreen_exit
                                            : Icons.fullscreen,
                                        color: Colors.white,
                                        size: 24.w,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}