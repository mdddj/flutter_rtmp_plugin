

/// 播放器状态监听
/// @auther 梁典典
/// @time 2022-05-06 17:45:03
///
abstract class PlayerStateListener {

  /// 播放器已就绪回调
  void noramlStateHandle();

  /// 播放器正在拉取资源回调
  void prepareingStateHandle();

  /// [ios,android]
  /// 播放器正在播放中回调
  ///
  /// (当网络不好的情况下,可能会回调多次)
  ///
  void playingStateHandle();


  /// 开始缓冲回调
  ///
  /// (当网络不好的情况下,可能会回调多次)
  ///
  void playingBufferingStartStateHandle();

  /// [ios,android]
  ///
  /// 暂停回调函数
  ///
  void pauseStateHandle();


  /// [ios,android]
  ///
  /// 自动播放结束回调
  void autoCompleteStateHandle();

  /// [ios,android]
  ///
  /// 出现错误回调
  void errorStateHandle();

  /// unknuwn 未知状态回调
  void unknuwnStateHandle();

  /// [ios]
  ///
  /// 正在准备播放所需组件，在调用 -play 方法时出现。
  void preparingStateHandle();

  /// [ios]
  ///
  /// 播放组件准备完成，准备开始播放，在调用 -play 方法时出现。
  void readyStateHandle();

  /// [ios]
  ///
  /// 播放组件准备完成，准备开始连接
  ///
  /// [warn] - 请勿在此状态时，调用切换 URL 操作
  void openStateHandle();

  /// [ios]
  ///
  /// 缓存数据为空状态。
  ///
  /// 特别需要注意的是当推流端停止推流之后，PLPlayer 将出现 caching 状态直到 timeout 后抛出 timeout 的 error 而不是出现 PLPlayerStatusStopped 状态，
  /// 因此在直播场景中，当流停止之后一般做法是使用 IM 服务告知播放器停止播放，以达到即时响应主播断流的目的。
  void cachingStateHandle();


  /// [ios]
  /// 自动重连的状态
  void autoReconnectingStateHandle();
}