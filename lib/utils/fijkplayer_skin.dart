import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:desk_cloud/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fijkplayer/fijkplayer.dart';

/// 将时长转换为字符串格式
String _duration2String(Duration duration) {
  if (duration.inMilliseconds < 0) return "-: negtive";

  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  int inHours = duration.inHours;
  return inHours > 0
      ? "$inHours:$twoDigitMinutes:$twoDigitSeconds"
      : "$twoDigitMinutes:$twoDigitSeconds";
}

/// 自定义视频播放器控制面板
class CustomFijkPanel extends StatefulWidget {
  final FijkPlayer player;
  final BuildContext buildContext;
  final Size viewSize;
  final Rect texturePos;
  final BuildContext? pageContent;
  final String? playerTitle;
  final bool isShowSpeed;

  const CustomFijkPanel({
    super.key,
    required this.player,
    required this.buildContext,
    required this.viewSize,
    required this.texturePos,
    this.pageContent,
    this.playerTitle,
    this.isShowSpeed = true,
  });

  @override
  State<CustomFijkPanel> createState() => _CustomFijkPanelState();
}

class _CustomFijkPanelState extends State<CustomFijkPanel> {
  FijkPlayer get player => widget.player;

  Duration _duration = const Duration();
  Duration _currentPos = const Duration();
  Duration _bufferPos = const Duration();
  Duration _dargPos = const Duration();

  bool _isTouch = false;
  bool _playing = false;
  bool _prepared = false;
  String? _exception;

  num? startPosX;
  num? startPosY;
  Size? playerBoxSize;

  double _seekPos = -1.0;

  StreamSubscription? _currentPosSubs;
  StreamSubscription? _bufferPosSubs;

  Timer? _hideTimer;
  bool _hideStuff = true;
  final bool _lockStuff = true;

  final double barHeight = 50.0;
  
  // 添加倍速相关变量
  final List<double> _playbackRates = [1.0, 1.25, 1.5, 2.0, 0.5, 0.75];
  double _currentRate = 1.0;

  @override
  void initState() {
    super.initState();

    _duration = player.value.duration;
    _currentPos = player.currentPos;
    _bufferPos = player.bufferPos;
    _prepared = player.state.index >= FijkState.prepared.index;
    _playing = player.state == FijkState.started;
    _exception = player.value.exception.message;

    player.addListener(_playerValueChanged);

    _currentPosSubs = player.onCurrentPosUpdate.listen((v) {
      setState(() {
        _currentPos = v;
      });
    });

    _bufferPosSubs = player.onBufferPosUpdate.listen((v) {
      setState(() {
        _bufferPos = v;
      });
    });

    // 初始化播放速度
    player.setSpeed(_currentRate);
  }

  void _playerValueChanged() {
    FijkValue value = player.value;
    if (value.duration != _duration) {
      setState(() {
        _duration = value.duration;
      });
    }

    bool playing = (value.state == FijkState.started);
    bool prepared = value.prepared;
    String? exception = value.exception.message;
    if (playing != _playing ||
        prepared != _prepared ||
        exception != _exception) {
      setState(() {
        _playing = playing;
        _prepared = prepared;
        _exception = exception;
      });
    }
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    startPosX = details.globalPosition.dx;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _isTouch = true;
    num curXpost = details.globalPosition.dx;
    
    if (curXpost < 0) {
      return;
    }
    
    double screenWidth = MediaQuery.of(context).size.width;
    double dragPercent = (curXpost - (startPosX ?? 0)) / screenWidth;
    double dragRange = _currentPos.inSeconds + (dragPercent * _duration.inSeconds);
    
    dragRange = dragRange.clamp(0, _duration.inSeconds.toDouble());
    _dargPos = Duration(seconds: dragRange.toInt());
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    player.seekTo(_dargPos.inMilliseconds);
    _isTouch = false;
  }

  void _playOrPause() {
    if (_playing == true) {
      player.pause();
    } else {
      player.start();
    }
  }

  // 简化倍速切换方法
  void _switchPlaybackSpeed() {
    int currentIndex = _playbackRates.indexOf(_currentRate);
    int nextIndex = (currentIndex + 1) % _playbackRates.length;
    
    setState(() {
      _currentRate = _playbackRates[nextIndex];
      player.setSpeed(_currentRate);
    });
    _startHideTimer();
  }

  // 添加判断视频方向的方法
  bool _isLandscapeVideo() {
    Size? videoSize = player.value.size;
    if (videoSize == null) return false;
    
    // 获取视频的宽高比
    double videoRatio = videoSize.width / videoSize.height;
    return videoRatio > 1.0; // 宽高比大于1表示横向视频
  }

  // 处理全屏切换
  void _handleFullScreen() async {
    if (widget.player.value.fullScreen) {
      // 先切换回竖屏，再退出全屏
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      await Future.delayed(const Duration(milliseconds: 100));
      // if (!_isLandscapeVideo() && mounted) {
      //   player.exitFullScreen();
      //   player.stop();
      //   Navigator.pop(context);
      // } else {
      //   if (mounted) {
      //     player.exitFullScreen();
      //   }
      // }     
      if (mounted) {
        player.exitFullScreen();
      }
    } else {
      // 获取视频原始宽高
      int videoWidth = player.value.size?.width.toInt() ?? 0;
      int videoHeight = player.value.size?.height.toInt() ?? 0;
      
      if (videoWidth > videoHeight) {
        // 横向视频先进入全屏再切换方向
        player.enterFullScreen();
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
        ]);
      } else {
        // 竖向视频直接进入全屏
        player.enterFullScreen();
      }
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _hideStuff = true;
      });
    });
  }

  void _cancelAndRestartTimer() {
    if (_hideStuff == true) {
      _startHideTimer();
    }
    setState(() {
      _hideStuff = !_hideStuff;
    });
  }

  Widget _buildPlayStateBtn() {
    return IconButton(
      icon: Icon(_playing ? Icons.pause : Icons.play_arrow),
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: _playOrPause,
    );
  }

  Widget _buildTopBar() {
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 0.8,
      duration: const Duration(milliseconds: 400),
      child: Container(
        height: barHeight + (!_isLandscapeVideo() ? safeAreaTop : 0),
        padding: EdgeInsets.only(top: (!_isLandscapeVideo() ? safeAreaTop : 0)),
        alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            colors: [
              Color.fromRGBO(0, 0, 0, 0.7),
              Color.fromRGBO(0, 0, 0, 0),
            ],
          ),
        ),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              color: Colors.white,
              onPressed: () {
                if (widget.player.value.fullScreen) {
                  // player.exitFullScreen();
                  _handleFullScreen();
                } else {
                  player.stop();
                  Navigator.pop(context);
                }
              },
            ),
            Expanded(
              child: widget.playerTitle != null
                  ? Text(
                      widget.playerTitle!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    )
                  : const SizedBox(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    // 确保 duration 不为 0，避免除以 0 的情况
    double duration = max(0.0, _duration.inMilliseconds.toDouble());
    // 确保 currentValue 是有效值
    double currentValue = _seekPos > 0 ? _seekPos : _currentPos.inMilliseconds.toDouble();
    // 确保值在有效范围内
    if (duration == 0) {
      currentValue = 0;
    } else {
      currentValue = currentValue.clamp(0.0, duration);
    }
    
    // 确保缓冲值也是有效的
    double bufferValue = _bufferPos.inMilliseconds.toDouble();
    if (duration > 0) {
      bufferValue = bufferValue.clamp(0.0, duration);
    } else {
      bufferValue = 0;
    }

    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 0.8,
      duration: const Duration(milliseconds: 400),
      child: Container(
        height: barHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            colors: [
              Color.fromRGBO(0, 0, 0, 0),
              Color.fromRGBO(0, 0, 0, 0.7),
            ],
          ),
        ),
        child: Row(
          children: <Widget>[
            _buildPlayStateBtn(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                _duration2String(_currentPos),
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: FijkSlider(
                  colors: FijkSliderColors(
                    cursorColor: Theme.of(context).colorScheme.secondary,
                    playedColor: Theme.of(context).colorScheme.secondary,
                  ),
                  value: currentValue,
                  cacheValue: bufferValue,
                  min: 0.0,
                  max: duration > 0 ? duration : 1.0, // 确保 max 始终大于 min
                  onChanged: (v) {
                    if (!mounted) return;
                    _startHideTimer();
                    setState(() {
                      _seekPos = v.clamp(0.0, duration);
                    });
                  },
                  onChangeEnd: (v) {
                    if (!mounted) return;
                    setState(() {
                      player.seekTo(v.clamp(0.0, duration).toInt());
                      _currentPos = Duration(milliseconds: _seekPos.toInt());
                      _seekPos = -1;
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                _duration2String(_duration),
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                ),
              ),
            ),
            widget.isShowSpeed ? TextButton(
              onPressed: _switchPlaybackSpeed,
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: Text(
                '${_currentRate}x',
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                ),
              ),
            ) : const SizedBox(),
            Platform.isIOS ? IconButton(
              icon: Icon(widget.player.value.fullScreen
                  ? Icons.fullscreen_exit
                  : Icons.fullscreen),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              color: Colors.white,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: _handleFullScreen,
            ) : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterPlayBtn() {
    return Container(
      color: Colors.transparent,
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: _exception != null
            ? Text(
                _exception!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              )
            : (_prepared || player.state == FijkState.initialized)
                ? AnimatedOpacity(
                    opacity: _hideStuff ? 0.0 : 0.7,
                    duration: const Duration(milliseconds: 400),
                    child: IconButton(
                      iconSize: barHeight * 1.2,
                      icon: Icon(
                        _playing ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      onPressed: _playOrPause,
                    ),
                  )
                : const SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Rect rect = player.value.fullScreen
        ? Rect.fromLTWH(
            0,
            0,
            widget.viewSize.width,
            widget.viewSize.height,
          )
        : Rect.fromLTRB(
            max(0.0, widget.texturePos.left),
            max(0.0, widget.texturePos.top),
            min(widget.viewSize.width, widget.texturePos.right),
            min(widget.viewSize.height, widget.texturePos.bottom),
          );

    return WillPopScope(
      onWillPop: () async {
        if (widget.player.value.fullScreen) {
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);
          await Future.delayed(const Duration(milliseconds: 100));
          if (mounted) {
            player.exitFullScreen();
          }
          return false;
        }
        return true;
      },
      child: Positioned.fromRect(
        rect: rect,
        child: GestureDetector(
          onTap: _cancelAndRestartTimer,
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: _onHorizontalDragStart,
          onHorizontalDragUpdate: _onHorizontalDragUpdate,
          onHorizontalDragEnd: _onHorizontalDragEnd,
          child: AbsorbPointer(
            absorbing: _hideStuff && _lockStuff,
            child: Column(
              children: <Widget>[
                _buildTopBar(),
                Expanded(
                  child: GestureDetector(
                    onTap: _cancelAndRestartTimer,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_isTouch)
                                Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: const Color.fromRGBO(0, 0, 0, 0.8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      '${_duration2String(_dargPos)}/${_duration2String(_duration)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: _buildCenterPlayBtn(),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildBottomBar(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _hideTimer?.cancel();
    player.removeListener(_playerValueChanged);
    _currentPosSubs?.cancel();
    _bufferPosSubs?.cancel();
  }
}