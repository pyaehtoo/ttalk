import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfileModel {
  String? birthDate,
      bio,
      gender,
      profileImageUrl,
      coverImageUrl,
      maritalStatus,
      phone,
      name,
      nickName,
      firstName,
      lastName,
      email,
      uniqueName,
      imsAccountId;
  int? city, hometown, accountId, postCount, friendCount;
  @JsonKey(name: 'relationship_status')
  String? relationshipStatus;
  int? userId;

  UserProfileModel(
      this.birthDate,
      this.bio,
      this.gender,
      this.profileImageUrl,
      this.coverImageUrl,
      this.maritalStatus,
      this.phone,
      this.name,
      this.nickName,
      this.firstName,
      this.lastName,
      this.email,
      this.uniqueName,
      this.imsAccountId,
      this.city,
      this.hometown,
      this.accountId,
      this.postCount,
      this.friendCount,
      this.relationshipStatus);

  factory UserProfileModel.fromJson(json) => _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);

  @override
  String toString() => 'UserProfileModel(friendCount: $friendCount, relationshipStatus: $relationshipStatus, userId: $userId)';
}
