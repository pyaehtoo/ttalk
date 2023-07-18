import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class ProfileModel {
  int? userId;
  int? id;
  String? nickName;
  String? bio;
  String? profileImageUrl;
  String? coverImageUrl;

  ProfileModel(this.id, this.nickName, this.bio, this.profileImageUrl,
      this.coverImageUrl, this.userId);

  factory ProfileModel.fromJson(json) => _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  @override
  String toString() {
    return 'ProfileModel(userId: $userId, id: $id, nickName: $nickName, bio: $bio, profileImageUrl: $profileImageUrl, coverImageUrl: $coverImageUrl)';
  }
}
