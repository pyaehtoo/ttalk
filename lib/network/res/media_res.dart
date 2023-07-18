import 'package:json_annotation/json_annotation.dart';

part 'media_res.g.dart';

@JsonSerializable(explicitToJson: true)
class MediaRes {
  bool? status;
  String? msg;
  MediaData? data;

  MediaRes(this.status, this.msg, this.data);

  factory MediaRes.fromJson(json) => _$MediaResFromJson(json);

  Map<String, dynamic> toJson() => _$MediaResToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MediaData {
  List<MediaRawData>? postMedias;
  List<MediaRawData>? profileMedias;
  List<MediaRawData>? coverMedias;
  List<MediaRawData>? videoMedias;

  MediaData(
      this.postMedias, this.profileMedias, this.coverMedias, this.videoMedias);

  factory MediaData.fromJson(json) => _$MediaDataFromJson(json);

  Map<String, dynamic> toJson() => _$MediaDataToJson(this);
}

@JsonSerializable()
class MediaRawData {
  int? postId;
  String? filePath;
  int? userId;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? heroPrefix;

  MediaRawData(this.postId, this.filePath, this.userId);

  factory MediaRawData.fromJson(json) => _$MediaRawDataFromJson(json);

  Map<String, dynamic> toJson() => _$MediaRawDataToJson(this);
}
