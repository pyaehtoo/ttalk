import 'package:json_annotation/json_annotation.dart';

part 'activities_res.g.dart';

@JsonSerializable(explicitToJson: true)
class ActivitiesRes {
  bool? status;
  String? msg;
  List<ActivityData>? data;

  ActivitiesRes(this.status, this.msg, this.data);

  factory ActivitiesRes.fromJson(json) => _$ActivitiesResFromJson(json);

  Map<String, dynamic> toJson() => _$ActivitiesResToJson(this);
}

@JsonSerializable()
class ActivityData {
  String actionTo;
  String description;
  String createdAt;

  ActivityData(this.actionTo, this.description, this.createdAt);

  factory ActivityData.fromJson(json) => _$ActivityDataFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityDataToJson(this);
}
