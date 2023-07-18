import 'package:json_annotation/json_annotation.dart';

part 'reaction_res.g.dart';

@JsonSerializable(explicitToJson: true)
class ReactionRes {
  bool? status;
  String? msg;
  List<ReactionData>? data;

  ReactionRes(this.status, this.msg, this.data);

  factory ReactionRes.fromJson(json) => _$ReactionResFromJson(json);

  Map<String, dynamic> toJson() => _$ReactionResToJson(this);
}

@JsonSerializable()
class ReactionData {
  String name, key;
  @JsonKey(name: 'icon_gif')
  String iconGif;
  @JsonKey(name: 'icon_svg')
  String iconSvg;

  ReactionData(this.name, this.key, this.iconGif, this.iconSvg);

  factory ReactionData.fromJson(json) => _$ReactionDataFromJson(json);

  Map<String, dynamic> toJson() => _$ReactionDataToJson(this);
}
