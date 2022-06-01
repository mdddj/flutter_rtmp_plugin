/// 返回结果
class IResult {
  final String type;
  final dynamic json;
  final dynamic value;

  IResult({required this.type, this.json, this.value});

  factory IResult.formMap(Map<String,dynamic> v) {
    return IResult(type: v["type"],json: v['json'],value: v['value']);
  }

}
