import 'package:json_annotation/json_annotation.dart';

part 'sticker_vo.g.dart';

@JsonSerializable()
class StickerVO {
  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'name')
  String? name;
  @JsonKey(name: 'imageUrl')
  String? imageUrl;
  @JsonKey(name: 'price')
  double? price;
  @JsonKey(name: 'discountTotal')
  double? discountTotal;
  @JsonKey(name: 'discountAmount')
  String? discountAmount;
  @JsonKey(name: 'discountType')
  String? discountType;
  @JsonKey(name: 'discountStart')
  String? discountStart;
  @JsonKey(name: 'discountEnd')
  String? discountEnd;
  StickerVO({
    this.id,
    this.name,
    this.imageUrl,
    this.price,
    this.discountTotal,
    this.discountAmount,
    this.discountType,
    this.discountStart,
    this.discountEnd,
  });

  factory StickerVO.fromJson(Map<String, dynamic> json) =>
      _$StickerVOFromJson(json);

  Map<String, dynamic> toJson() => _$StickerVOToJson(this);
}
