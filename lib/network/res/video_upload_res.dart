import 'package:json_annotation/json_annotation.dart';

part 'video_upload_res.g.dart';

@JsonSerializable()
class VideoUploadRes {
  @JsonKey(name: 'message')
  String? msg;
  @JsonKey(name: 'data')
  VideoUploadResData? data;
  VideoUploadRes(this.msg, this.data);

  factory VideoUploadRes.fromJson(Map<String, dynamic> json) =>
      _$VideoUploadResFromJson(json);

  Map<String, dynamic> toJson() => _$VideoUploadResToJson(this);

  @override
  String toString() => 'VideoUploadRes(msg: $msg, data: ${data.toString()})';
}

@JsonSerializable()
class VideoUploadResData {
  @JsonKey(name: 'videoId')
  String? videoId;
  VideoUploadResData({
    this.videoId,
  });

  factory VideoUploadResData.fromJson(Map<String, dynamic> json) =>
      _$VideoUploadResDataFromJson(json);

  Map<String, dynamic> toJson() => _$VideoUploadResDataToJson(this);

  @override
  String toString() => 'VideoUploadResData(videoId: $videoId)';
}
