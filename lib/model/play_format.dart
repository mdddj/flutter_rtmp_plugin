
/// 预设置播放器播放 URL 类型

enum PlayFormat {

  //未知类型
  unKnown,

  ///m3u8类型
  m3u8,

  ///mp4 类型
  mp4,

  ///flv类型
  flv,

  ///MP3类型,此类型需要提前设置才能播放
  mp3,

  /// aac类型, 此类型需要提前设置才能播放
  aac
}

extension PlayFormatExt on PlayFormat{
  int get intValue {
    switch(this){
      case PlayFormat.unKnown:
        return 0;
      case PlayFormat.m3u8:
        return 1;
      case PlayFormat.mp4:
        return 2;
      case PlayFormat.flv:
        return 3;
      case PlayFormat.mp3:
        return 4;
      case PlayFormat.aac:
        return 5;
      default:
        return 0;
    }
  }
}