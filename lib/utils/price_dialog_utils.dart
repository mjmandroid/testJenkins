import 'dart:async';
import 'api.dart';
import 'api_net.dart';

// 定义回调函数类型
typedef CountdownCallback = void Function();

class PopupManager {
  // 私有构造函数
  PopupManager._internal();

  // 单例实例
  static final PopupManager _instance = PopupManager._internal();

  // 工厂构造函数，返回单例实例
  factory PopupManager() => _instance;

  // 弹窗间隔时间（秒）
  int _intervalSeconds = 0;

  // 上次弹窗时间
  DateTime? _lastPopupTime;

  // 手动调用弹窗
  Function(String)? _neeShowCallback;

  // 初始化的 Completer，用于确保初始化只执行一次
  Completer<void>? _initCompleter;

  // 倒计时计时器
  Timer? _countdownTimer;

  // 当前倒计时剩余秒数
  int _remainingSeconds = 0;

  // 界面是否在展示的标志
  bool _isInterfaceVisible = false;

  // 弹窗是否正在展示的标志
  bool _isPopupShowing = false;

  // 设置界面可见性状态
  void setInterfaceVisibility(bool isVisible) {
    _isInterfaceVisible = isVisible;
  }

  // 获取界面可见性状态
  bool isInterfaceVisible() {
    return _isInterfaceVisible;
  }

  // 设置弹窗展示状态
  void setPopupShowing(bool isShowing) {
    _isPopupShowing = isShowing;
  }

  // 获取弹窗展示状态
  bool isPopupShowing() {
    return _isPopupShowing;
  }

  /// 初始化方法：从接口获取弹窗间隔时间（秒）
  Future<void> initialize() async {
    // 如果已经在初始化，等待其完成
    if (_initCompleter != null) {
      return _initCompleter!.future;
    }

    _initCompleter = Completer<void>();

    try {
      final response = await ApiNet.request(Api.getBulletTime);
      if (response.code == 200) {
        final data = response.data;
        int? bulletFrameTime = int.tryParse(data['bullet_frame_time']);
        if (bulletFrameTime != null) {
          _intervalSeconds = bulletFrameTime;
        } else {
          _intervalSeconds = 60;
        }
      } else {
        _intervalSeconds = 60; // 默认间隔时间
      }
      _initCompleter!.complete();
    } catch (e) {
      _intervalSeconds = 60; // 默认间隔时间
      _initCompleter!.completeError(e);
    }
  }

  void setNeedShowCallback(Function(String) neeShowCallback) {
    _neeShowCallback = neeShowCallback;
  }

  void showPriceAlert(){
    Future.delayed(Duration(seconds: 1), () {
      _neeShowCallback?.call("");
    });
}

  /// 判断是否可以显示弹窗
  bool canShowPopup() {
    // 如果弹窗正在展示，则不允许再次弹出
    if (_isPopupShowing) {
      return false;
    }

    final now = DateTime.now();
    if (_lastPopupTime == null) {
      _lastPopupTime = now;
      return true;
    }

    final elapsed = now.difference(_lastPopupTime!).inSeconds;
    if (elapsed >= _intervalSeconds) {
      _lastPopupTime = now;
      return true;
    } else {
      return false;
    }
  }

  /// 开始倒计时，并在倒计时结束时执行回调
  void startCountdown(CountdownCallback? onCountdownComplete) {
    // 取消已有的倒计时
    _countdownTimer?.cancel();

    // 设置倒计时初始值为间隔时间
    _remainingSeconds = _intervalSeconds;

    // 创建新的倒计时
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingSeconds--;

      // 倒计时结束
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _countdownTimer = null;

        // 执行回调前检查界面是否在展示且弹窗未在展示
        if (onCountdownComplete != null && _isInterfaceVisible && !_isPopupShowing) {
          onCountdownComplete();
        }
      }
    });
  }

  /// 获取当前倒计时剩余秒数
  int getRemainingSeconds() {
    return _remainingSeconds;
  }

  /// 取消倒计时
  void cancelCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _remainingSeconds = 0;
  }
}
