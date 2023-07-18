import 'package:json_annotation/json_annotation.dart';

part 'location_res.g.dart';

@JsonSerializable(explicitToJson: true)
class LocationRes {
  bool? status;
  String? msg;
  List<LocationData>? data;

  LocationRes(this.status, this.msg, this.data);

  factory LocationRes.fromJson(json) => _$LocationResFromJson(json);

  Map<String, dynamic> toJson() => _$LocationResToJson(this);
}

@JsonSerializable()
class LocationData {
  int id;
  int? parentId;
  String? name;
  String? createdAt, updatedAt, deletedAt;

  LocationData(this.id, this.parentId, this.name, this.createdAt,
      this.updatedAt, this.deletedAt);

  factory LocationData.fromJson(json) => _$LocationDataFromJson(json);

  Map<String, dynamic> toJson() => _$LocationDataToJson(this);
}
