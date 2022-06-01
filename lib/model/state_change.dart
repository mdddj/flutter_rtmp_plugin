/// 播放器状态
///
///
///  前缀带 a 表示Android , i 表示 iOS
///
/// @time 2022-05-06 17:37:43
///
/// @auther 梁典典
///
enum PlayerState {
  /// 正常状态,等待用户操作中
  aNormal,

  /// 准备中,播放器正在准备资源中
  aPrepareing,

  /// 播放中
  aPlaying,

  /// 开始缓冲资源中
  aPlayingBufferingStart,

  /// 播放器暂停状态
  aPause,

  /// 播放器自动播放结束
  aAutoComplete,

  /// 获取资源发生错误,也就是不能播放资源
  aError,

  ///正在准备播放所需组件，在调用 -play 方法时出现。
  iPreparing,

  ///播放组件准备完成，准备开始播放，在调用 -play 方法时出现。
  iReady,

  ///播放组件准备完成，准备开始连接
  iOpen,

  /// 缓存数据为空状态。
  /// 特别需要注意的是当推流端停止推流之后，PLPlayer 将出现 caching 状态直到 timeout 后抛出 timeout 的 error 而不是出现 PLPlayerStatusStopped 状态
  /// ，因此在直播场景中，当流停止之后一般做法是使用 IM 服务告知播放器停止播放，以达到即时响应主播断流的目的。
  iCaching,

  ///自动重连的状态
  iAutoReconnecting,

  /// 未知状态
  unknuwn
}

extension PLayerStateExt on int {




  PlayerState get playerStateValue {
    switch (this) {

      /// ------ android
      case 0:
        return PlayerState.aNormal;
      case 1:
        return PlayerState.aPrepareing;
      case 2:
        return PlayerState.aPlaying;
      case 3:
        return PlayerState.aPlayingBufferingStart;
      case 5:
        return PlayerState.aPause;
      case 6:
        return PlayerState.aAutoComplete;
      case 7:
        return PlayerState.aError;

      /// -------ios
      case 11:
        return PlayerState.iPreparing;
      case 12:
        return PlayerState.iReady;
      case 13:
        return PlayerState.iOpen;
      case 14:
        return PlayerState.iCaching;
      case 19:
        return PlayerState.iAutoReconnecting;

      default:
        return PlayerState.unknuwn;
    }
  }
}
