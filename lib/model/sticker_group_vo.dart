import 'package:json_annotation/json_annotation.dart';

import 'package:teatalk/model/sticker_vo.dart';

part 'sticker_group_vo.g.dart';

@JsonSerializable()
class StickerGroupVO {
  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'name')
  String? name;
  @JsonKey(name: 'minAge')
  int? minAge;
  @JsonKey(name: 'maxAge')
  int? maxAge;
  @JsonKey(name: 'fromDate')
  String? fromDate;
  @JsonKey(name: 'toDate')
  String? toDate;
  @JsonKey(name: 'remark')
  String? remark;
  @JsonKey(name: 'Stickers')
  List<StickerVO>? stickers;
  StickerGroupVO({
    this.id,
    this.name,
    this.minAge,
    this.maxAge,
    this.fromDate,
    this.toDate,
    this.remark,
    this.stickers,
  });

  factory StickerGroupVO.fromJson(Map<String, dynamic> json) =>
      _$StickerGroupVOFromJson(json);

  Map<String, dynamic> toJson() => _$StickerGroupVOToJson(this);
}
