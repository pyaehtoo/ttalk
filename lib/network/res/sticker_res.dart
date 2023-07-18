import 'package:json_annotation/json_annotation.dart';
import 'package:teatalk/model/sticker_group_vo.dart';

part 'sticker_res.g.dart';

@JsonSerializable()
class StickerRes {
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'data')
  List<StickerGroupVO>? data;

  StickerRes({
    this.message,
    this.data,
  });

  factory StickerRes.fromJson(Map<String, dynamic> json) => _$StickerResFromJson(json);

  Map<String, dynamic> toJson() => _$StickerResToJson(this);
}
