import 'package:json_annotation/json_annotation.dart';

part 'ice_count_res.g.dart';

@JsonSerializable()
class IceCubeCountRes {
  @JsonKey(name: 'status')
  bool? status;
  @JsonKey(name: 'msg')
  String? msg;
  @JsonKey(name: 'data')
  Map<String, dynamic>? data;
  IceCubeCountRes({
    this.status,
    this.msg,
    this.data,
  });

  factory IceCubeCountRes.fromJson(Map<String, dynamic> json) =>
      _$IceCubeCountResFromJson(json);

  Map<String, dynamic> toJson() => _$IceCubeCountResToJson(this);

  double getIceCount() {
    if (data != null) {
      if (data!['iceBalance'] != null) {
        return data!['iceBalance'];
      } else {
        return 0;
      }
    }
    return 0;
  }

  @override
  String toString() =>
      'IceCubeCountRes(status: $status, msg: $msg, data: $data)';
}
