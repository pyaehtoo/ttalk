import 'package:json_annotation/json_annotation.dart';

part 'video_load_res.g.dart';

@JsonSerializable()
class VideoLoadRes {
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'data')
  VideoLoadVO? data;
  VideoLoadRes({
    this.message,
    this.data,
  });

  factory VideoLoadRes.fromJson(Map<String, dynamic> json) =>
      _$VideoLoadResFromJson(json);

  Map<String, dynamic> toJson() => _$VideoLoadResToJson(this);
}

@JsonSerializable()
class VideoLoadVO {
  @JsonKey(name: 'PlayAuth')
  String? playAuth;
  @JsonKey(name: 'VideoMeta')
  VideoMetaVO? videoMeta;
  @JsonKey(name: 'RequestId')
  String? requestId;
  @JsonKey(name: 'VideoUrl')
  String? videoUrl;

  VideoLoadVO({this.playAuth, this.videoMeta, this.requestId, this.videoUrl});

  factory VideoLoadVO.fromJson(Map<String, dynamic> json) =>
      _$VideoLoadVOFromJson(json);

  Map<String, dynamic> toJson() => _$VideoLoadVOToJson(this);
}

@JsonSerializable()
class VideoMetaVO {
  @JsonKey(name: 'Status')
  String? status;
  @JsonKey(name: 'VideoId')
  String? videoId;
  @JsonKey(name: 'Title')
  String? title;
  @JsonKey(name: 'Duration')
  String? duration;
  @JsonKey(name: 'CoverURL')
  String? coverUrl;
  VideoMetaVO({
    this.status,
    this.videoId,
    this.title,
    this.duration,
    this.coverUrl,
  });

  factory VideoMetaVO.fromJson(Map<String, dynamic> json) =>
      _$VideoMetaVOFromJson(json);

  Map<String, dynamic> toJson() => _$VideoMetaVOToJson(this);
}
