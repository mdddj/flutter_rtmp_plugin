import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'flutter_rtmp_player.dart';
import 'error/player_error.dart';
import 'model/change_manager_model.dart';
import 'model/logger_level.dart';
import 'model/options_android.dart';
import 'model/options_ios.dart';
import 'model/result.dart';
import 'model/state_change.dart';
import 'service/status_listener.dart';
import 'util/methed.dart';

/// 播放器视图
///
/// 梁典典制作
class VideoPlayerWidget extends StatefulWidget {
  /// 操作组件的控制器类
  final PlayerController? controller;

  /// Android 初始化配置
  ///
  /// 可选配置查看[AndroidOption]
  final AndroidOption androidConfig;

  /// ios 端配置
  ///
  /// 详情查看 >> [IosOptions]
  final IosOptions? iosOptions;

  /// 播放的URL,如果设置了这个参数,会提前准备资源
  ///
  /// 也可以不设置,后面也可以使用[PlayerController] 来控制播放器播放
  final String? url;

  /// 是否自动开始播放,默认true
  ///
  /// 如果设置了false, 可以使用[PlayerController]来控制播放
  final bool autoPlay;

  /// 组件是否初始化
  final VoidCallback? onCreate;

  /// 配置是否在播放中自动隐藏UI控制器
  final bool? autoHideUi;

  const VideoPlayerWidget(
      {Key? key,
      this.controller,
      this.androidConfig = defaultOption,
      this.iosOptions,
      this.url,
      this.autoPlay = true,
      this.onCreate,
      this.autoHideUi})
      : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  /// flutter 测接入原生能力
  FlutterRtmpPlugin? flutterRtmpPlugin;

  /// 播放器状态回调
  PlayerStateListener? listener;

  @override
  void initState() {
    super.initState();
    _bindController();
  }

  /// 初始化配置
  void _initOptions() {
    flutterRtmpPlugin?.setOptions(androidOption: widget.androidConfig, iosOptions: widget.iosOptions);
  }

  /// 绑定控制器类
  void _bindController() {
    widget.controller?.bind(this);
  }

  ///开始监听播放状态
  void _initListen() {
    flutterRtmpPlugin?.stream.listen((event) {
      try {
        final result = IResult.formMap(jsonDecode(event.toString()));
        if (result.type == "state-change") {
          final stateVal = (result.value as int).playerStateValue;
          _stateHandle(stateVal);
        }
      } catch (_) {
        throw PlayerError(PARSE_ERROR, "解析结果错误,请联系作者qq413153189, 或者提交ISSIS");
      }
    });
  }

  /// 处理播放器状态回调
  void _stateHandle(PlayerState playerState) {
    switch (playerState) {
      case PlayerState.aNormal:
        listener?.noramlStateHandle();
        break;
      case PlayerState.aPrepareing:
        listener?.prepareingStateHandle();
        break;
      case PlayerState.aPlaying:
        listener?.playingStateHandle();
        if (widget.autoHideUi == true) {
          flutterRtmpPlugin?.hideUi();
        }
        break;
      case PlayerState.aPlayingBufferingStart:
        listener?.playingBufferingStartStateHandle();
        break;
      case PlayerState.aPause:
        listener?.pauseStateHandle();
        break;
      case PlayerState.aAutoComplete:
        listener?.autoCompleteStateHandle();
        break;
      case PlayerState.aError:
        listener?.errorStateHandle();
        break;
      case PlayerState.iAutoReconnecting:
        listener?.autoReconnectingStateHandle();
        break;
      case PlayerState.iCaching:
        listener?.cachingStateHandle();
        break;
      case PlayerState.iOpen:
        listener?.openStateHandle();
        break;
      case PlayerState.iReady:
        listener?.readyStateHandle();
        break;
      case PlayerState.iPreparing:
        listener?.preparingStateHandle();
        break;
      default:
        listener?.unknuwnStateHandle();
        break;
    }
  }

  ///视图创建完毕,初始化
  void _viewCreated(int viewId) {
    flutterRtmpPlugin = FlutterRtmpPlugin(viewId);
    _initListen();
    _initOptions();
    if (widget.url?.isNotEmpty == true) {
      flutterRtmpPlugin?.setPlayUrl(widget.url!);
      if (widget.autoPlay) {
        ///设置了自动播放
        flutterRtmpPlugin?.start();
      }
    }
    widget.onCreate?.call();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // flutterRtmpPlugin?.resetSize(Size(constraints.minWidth, constraints.minHeight));

        if (Platform.isAndroid) {
          return AndroidView(
            viewType: "FlutterRtmpPluginAndroidView",
            onPlatformViewCreated: _viewCreated,
          );
        }
        return UiKitView(
          viewType: "RtplPlayView",
          onPlatformViewCreated: _viewCreated,
          creationParams: <String, dynamic>{"width": constraints.maxWidth, "height": constraints.maxHeight},
          creationParamsCodec: const StandardMessageCodec(),
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _bindController();
    }
  }
}

/// 控制器类
class PlayerController {
  _VideoPlayerWidgetState? _state;

  void bind(_VideoPlayerWidgetState _videoPlayerWidgetState) {
    _state = _videoPlayerWidgetState;
  }

  ///
  /// android && ios
  ///
  /// 播放器的状态回调
  ///
  void addStateChangeListener(PlayerStateListener listener) {
    _state?.listener = listener;
  }

  /// 暂停播放
  Future<void> pause() async {
    await _state?.flutterRtmpPlugin?.pause();
  }

  /// 暂停之后,恢复播放
  Future<void> resume() async {
    await _state?.flutterRtmpPlugin?.resume();
  }

  /// 停止播放
  ///
  /// android 停止后,会走部分状态回调,状态回调参考:[PlayerStateListener]
  ///
  Future<void> stop() async {
    await _state?.flutterRtmpPlugin?.stop();
  }

  ///
  /// ⚠️ 此方法仅在Android有效
  ///
  /// 修改播放器内核
  ///
  /// 可选的值有:
  /// 1.[ManagerModel.ijkPlayerManager] - bilibili内核
  /// 2.[ManagerModel.systemPlayerManager] - 系统自带内核
  /// 3.[ManagerModel.exo2PlayerManager] - exo内核
  ///
  ///  如果需要播放[rtmp]格式的源,需要切换成[ManagerModel.exo2PlayerManager] 内核,否则会无法播放
  ///  如果需要播放[m3u8]格式的视频,需要切换成[ManagerModel.ijkPlayerManager] 内核
  ///
  ///  梁典典暂时只测试了这两种格式,其他格式需要自行测试,如果有问题,提交issis,并提供视频源
  ///
  Future<void> setPlayManager(ManagerModel managerModel) async {
    await _state?.flutterRtmpPlugin?.changeVideoManager(managerModel);
  }

  ///
  /// 切换播放的URL
  ///
  Future<void> setPlayUrl(String url) async {
    exec(androidCall: () async {
      await _state?.flutterRtmpPlugin?.setPlayUrl(url);
    }, iosCall: () async {
      await _state?.flutterRtmpPlugin?.init(url);
    });
  }

  /// 是否已经初始化
  bool get isInit => _state?.flutterRtmpPlugin != null;

  /// 切换日志等级
  Future<void> changeLoggerLevler({LoggerLevel? loggerLevel}) async {
    if (loggerLevel != null) {
      _state?.flutterRtmpPlugin?.setLoggerLevel(loggerLevel);
    }
  }

  /// android
  /// 下有效,隐藏控制器端UI
  Future<void> hideUi() async {
    _state?.flutterRtmpPlugin?.hideUi();
  }

  /// android
  /// 禁用系统锁屏
  Future<void> disableScreenCapture() async {
    await _state?.flutterRtmpPlugin?.disableScreenCapture();
  }

  /// adnroid
  /// 获取当前播放状态
  Future<PlayerState> getCurrentState() async {
    return await _state?.flutterRtmpPlugin?.currentState() ?? PlayerState.unknuwn;
  }
}
