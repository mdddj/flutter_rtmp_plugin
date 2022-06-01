import 'logger_level.dart';
import 'play_format.dart';

/// iOS的配置选项
class IosOptions {
  ///  接收/发送数据包超时时间间隔所对应的键值，单位为 s ，默认配置为 10s
  ///  建议设置正数。设置的值小于等于 0 时，表示禁用超时，播放卡住时，将无超时回调。
  ///  该参数仅对 rtmp/flv 直播生效
  final int? timeoutIntervalForMediaPackets;
  ///  一级缓存大小，单位为 ms，默认为 2000ms，增大该值可以减小播放过程中的卡顿率，但会增大弱网环境的最大累积延迟
  ///  该缓存存放的是网络层读取到的数据，为保证实时性，超过该缓存池大小的过期音频数据将被丢弃，视频将加速渲染追上音频
  final int? maxL1BufferDuration;
  ///  默认二级缓存大小，单位为 ms，默认为 300ms，增大该值可以减小播放过程中的卡顿率，但会增大弱网环境的最大累积延迟
  ///  该缓存存放的是解码之后待渲染的数据，如果该缓存池满，则二级缓存将不再接收来自一级缓存的数据
  final int? maxL2BufferDuration;
  ///  是否使用 video toolbox 硬解码。
  ///  使用 video toolbox Player 将尝试硬解码，失败后，将切换回软解码。
  ///  该参数仅对 rtmp/flv 直播生效, 默认不使用。支持 iOS 8.0 及更高版本。
  final bool? videoToolbox;
  ///  用于是否根据最小缓冲时间和最大缓冲时间，使播放速度变慢或变快
  ///  默认 YES ，即底层会自动根据缓存 buffer 调节速率。注意点播播放的时候，需关闭这个参数
  final bool? cacheBufferDurationSpeedAdjust;
  ///  配置 log 级别
  ///  是个枚举,可选参数查看 >> [LoggerLevelIos]
  ///   release 建议使用 warning, debug 建议使用 info.
  final LoggerLevelIos? loggerLevel;
  ///  dns 查询，使用内置 DNS 解析
  ///  NSString 类型，开启 DNS 解析，默认使用系统 API 解析
  ///  该参数仅对 rtmp/flv 直播生效
  final String? dnsManager;
  ///  视频缓存目录, 默认为 nil
  ///  该属性仅对点播 mp4 有效, 当 videoCacheFolderPath 有值时，默认关闭 DNS  解析
  final String? videoCacheFolderPath;
  ///  视频缓存目录名称是否加密，默认不加密
  ///  当 videoCacheFolderPath 有值时，成效
  final bool? videoFileNameEncode;
  ///  视频预设值播放 URL 格式类型
  ///  该参数用于加快首开，提前告知播放器流类型，默认 unKnown
  ///  可选值查看: [PlayFormat]
  final PlayFormat? playFormat;
  ///  视频缓存扩展名
  ///  该属性仅对点播 mp4 有效，需在视频缓存目录 PLPlayerOptionKeyVideoCacheFolderPath 基础上设置
  final String? videoCacheExtensionName;
  ///SDK 设备 ID
  final String? sdkId;
  /// http 的 header
  ///  该参数用于设置 http 的 header
  ///  不可包含 "\n" 或 "\r"，包含"\n" 或 "\r" 则设置无效
  final String? headUserAgent;
  ///  视频回调格式
  //   该参数用于自定义渲染，设置播放器解码回调数据格式
  final String? videoOutputFormat;

  const IosOptions(
      {this.timeoutIntervalForMediaPackets,
      this.maxL1BufferDuration,
      this.maxL2BufferDuration,
      this.videoToolbox,
      this.cacheBufferDurationSpeedAdjust,
      this.loggerLevel,
      this.dnsManager,
      this.videoCacheFolderPath,
      this.videoFileNameEncode,
      this.playFormat,
      this.videoCacheExtensionName,
      this.sdkId,
      this.headUserAgent,
      this.videoOutputFormat});


  /// 转成map
  Map<String,dynamic> toMap() {
    return <String,dynamic>{
      "timeoutIntervalForMediaPackets": timeoutIntervalForMediaPackets,
      "maxL1BufferDuration": maxL1BufferDuration,
      "maxL2BufferDuration": maxL2BufferDuration,
      "videoToolbox": videoToolbox,
      "cacheBufferDurationSpeedAdjust": cacheBufferDurationSpeedAdjust,
      "loggerLevel": loggerLevel,
      "dnsManager": dnsManager,
      "videoCacheFolderPath": videoCacheFolderPath,
      "videoFileNameEncode": videoFileNameEncode,
      "playFormat": playFormat?.intValue,
      "videoCacheExtensionName": videoCacheExtensionName,
      "sdkId": sdkId,
      "headUserAgent": headUserAgent,
      "videoOutputFormat": videoOutputFormat,
    };
  }

}
