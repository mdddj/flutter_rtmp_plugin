const  defaultOption = AndroidOption();

///安卓端配置文件
class AndroidOption {
  /// 是否可以滑动界面改变进度，声音等 默认true
  final bool isTouchWidget;

  /// 是否开启自动旋转
  final bool rotateViewAuto;

  /// 一全屏就锁屏横屏，默认false 竖屏，可配合setRotateViewAuto使用
  final bool lockLand;

  ///是否根据视频尺寸，自动选择竖屏全屏或者横屏全屏，注意，这时候默认旋转无效
  final bool autoFullWithSize;

  ///是否使用全屏动画效果
  final bool showFullAnimation;

  ///是否需要全屏锁定屏幕功能 如果单独使用请设置setIfCurrentIsFullscreen为true
  final bool needLockFull;

  /// 是否边缓存，m3u8等无效 默认false
  final bool cacheWithPlay;

  /// 视频标题
  final String videoTitle;

  ///是否需要旋转的 OrientationUtils 默认false
  final bool needOrientationUtils;


  const AndroidOption(
      {this.isTouchWidget = true,
      this.rotateViewAuto = false,
      this.lockLand = false,
      this.autoFullWithSize = false,
      this.showFullAnimation = false,
      this.needLockFull = true,
      this.cacheWithPlay = false,
      this.videoTitle = "",
      this.needOrientationUtils = false});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "isTouchWidget": isTouchWidget,
      "rotateViewAuto": rotateViewAuto,
      "lockLand": lockLand,
      "autoFullWithSize": autoFullWithSize,
      "showFullAnimation": showFullAnimation,
      "needLockFull": needLockFull,
      "cacheWithPlay": cacheWithPlay,
      "videoTitle": videoTitle,
      "needOrientationUtils": needOrientationUtils
    };
  }
}
