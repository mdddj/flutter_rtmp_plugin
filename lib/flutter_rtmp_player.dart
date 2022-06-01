import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'model/change_manager_model.dart';
import 'model/logger_level.dart';
import 'model/options_android.dart';
import 'model/options_ios.dart';
import 'model/state_change.dart';
import 'util/methed.dart';

/// 播放器组件
///
/// 方法上如果出现Android则是安卓端都有的,ios则是iOS端独有的, 两者都有则是通用

class FlutterRtmpPlugin {
  final int viewId;

  FlutterRtmpPlugin._(this.viewId);

  factory FlutterRtmpPlugin(int viewId) => FlutterRtmpPlugin._(viewId);

  MethodChannel get _channel => MethodChannel('flutter_rtmp_plugin_$viewId');

  ///监听播放状态
  EventChannel get _eventChannel => EventChannel("play-status-channel-$viewId");

  /// 获取监听流,播放器事件返回的
  Stream get stream => _eventChannel.receiveBroadcastStream();

  Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// ios && android
  ///
  /// 初始化配置
  /// [androidOption] -- Android 配置
  Future<void> setOptions({AndroidOption? androidOption, IosOptions? iosOptions}) async {
    const methodName = "set-option";
    if (androidOption != null || iosOptions != null) {
      exec(androidCall: () async {
        await _channel.invokeMapMethod(methodName, androidOption?.toMap());
      }, iosCall: () async {
        await _channel.invokeMapMethod(methodName, iosOptions?.toMap());
      });
    } else {
      await _channel.invokeMethod(methodName);
    }
  }

  ///android
  ///
  /// 设置日志等级
  Future<void> setLoggerLevel(LoggerLevel loggerLevel) async {
    await _channel.invokeMapMethod("debug", <String, dynamic>{"mode": loggerLevel.intValue});
  }

  /// android && ios
  ///
  /// 设置播放url
  ///
  Future<void> setPlayUrl(String url) async {
    exec(androidCall: () async {
      await _channel.invokeMapMethod("change-play-url", <String, dynamic>{"url": url});
    }, iosCall: () async {
      await init(url);
    });
  }

  /// ios
  ///
  /// 执行播放
  ///
  /// [playerUrl] -- 播放链接
  Future<void> init(String playerUrl) async {
    var map = <String, dynamic>{};
    map['playerUrl'] = playerUrl;
    await _channel.invokeMapMethod("init-player", map);
  }

  /// android
  ///
  /// 重新开始播放
  ///
  Future<void> resetPlay() async {
    await _channel.invokeMethod("reset");
  }

  /// ios
  ///
  /// 开始播放
  Future<void> start() async {
    await _channel.invokeMethod("play");
  }

  /// android
  ///
  /// 修改播放器引擎
  Future<void> changeVideoManager(ManagerModel model) async {
    await _channel.invokeMapMethod("change-manager", <String, dynamic>{"mode": model.index});
  }

  /// ios
  ///
  /// 结束播放
  Future<void> stop() async {
    await _channel.invokeMethod("stop");
  }

  /// ios
  ///
  /// 暂停
  Future<void> pause() async {
    await _channel.invokeMethod("pause");
  }

  /// ios
  ///
  /// 继续播放
  Future<void> resume() async {
    await _channel.invokeMethod("resume");
  }

  /// ios && android
  ///
  /// 改变尺寸
  Future<void> resetSize(Size size) async {
    final params = <String, dynamic>{"width": size.width.round(), "height": size.height.round()};
    print(params);
    await _channel.invokeMapMethod("size-change", params);
  }

  /// android
  /// 隐藏Android播放器的UI控制器
  Future<void> hideUi() async {
    exec(
        androidCall: () {
          _channel.invokeMethod('hideUi');
        },
        iosCall: () {});
  }

  /// android
  /// 禁用系统锁屏
  Future<void> disableScreenCapture() async {
    exec(
        androidCall: () {
          _channel.invokeMethod('disableScreenCapture');
        },
        iosCall: () {});
  }

  /// android
  ///
  /// 获取播放器当时的状态
  Future<PlayerState> currentState() async {
    try {
      final stateIntValue = await _channel.invokeMethod("get-current-state");
      return (stateIntValue as int).playerStateValue;
    } catch (_) {
      return PlayerState.unknuwn;
    }
  }
}
