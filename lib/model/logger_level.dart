
/// 日志输出等级
enum LoggerLevel {

  ///未知
  unknown,

  ///默认的
  defaultLevel,

  ///完整的
  verbose,

  ///调试
  debug,

  ///基本输出
  info,

  ///警告
  warn,

  /// 异常
  error,

  /// 致命的
  fatal,

  /// 不输出
  silent
}

extension LoggerLevelExt on LoggerLevel {
  int get intValue {
    switch(this){
      case LoggerLevel.unknown:
        return 0;
      case LoggerLevel.defaultLevel:
        return 1;
      case LoggerLevel.verbose:
        return 2;
      case LoggerLevel.debug:
        return 3;
      case LoggerLevel.info:
        return 4;
      case LoggerLevel.warn:
        return 5;
      case LoggerLevel.error:
        return 6;
      case LoggerLevel.fatal:
        return 7;
      case LoggerLevel.silent:
        return 8;
      default:
        return 0;
    }
  }
}




/// 设置控制台 log 的级别，log 级别在 kPLLogInfo 及以上，则会缓存日志文件，
//  日志文件存放的位置为 APP Container/Library/Caches/Pili/PlayerLogs
enum LoggerLevelIos {

  ///没有日志
  none,

  ///错误
  error,

  ///警告和错误
  warning,

  ///错误,警告和基本信息
  info,

  /// 错误,警告,基本信息和开发日志
  debug,

  ///错误,警告,基本信息,开发日志和各种详细信息
  verbose

}