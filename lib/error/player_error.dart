

/// 解析原生返回的数据错误码
const PARSE_ERROR = 20002;

/// 处理一些异常
class PlayerError extends Error {

  /// 错误详细信息
  final String message;

  /// 错误码
  final int code;

  PlayerError(this.code,this.message);


  @override
  String toString() {
    return "出现错误:$code,$message";
  }


}