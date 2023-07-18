import 'package:json_annotation/json_annotation.dart';
import 'package:teatalk/model/profile.dart';

part 'notification_res.g.dart';

@JsonSerializable(explicitToJson: true)
class NotificationRes {
  bool? status;
  String? msg;
  NotificationData? data;

  NotificationRes(this.status, this.msg, this.data);

  factory NotificationRes.fromJson(Map<String, dynamic> json) =>
      _$NotificationResFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationResToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NotificationData {
  int unreadCount;
  List<NotificationModel>? notifications;

  NotificationData(this.unreadCount, this.notifications);

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);

  int getNewNotiCount() {
    int newNoti = 0;
    if (notifications != null) {
      for (NotificationModel noti in notifications!) {
        if (noti.isRead == 1) {
          newNoti++;
        }
      }
    }

    return newNoti;
  }
}

@JsonSerializable(explicitToJson: true)
class NotificationModel {
  int id;
  String notiableType;
  int? notiableId;
  int? sourceId;
  int? targetId;
  int? isRead;
  String title;
  String message;
  String createdAt;
  @JsonKey(name: 'SourceUser')
  SourceUser? sourceUser;

  NotificationModel(
      this.id,
      this.notiableType,
      this.notiableId,
      this.sourceId,
      this.targetId,
      this.isRead,
      this.title,
      this.message,
      this.createdAt,
      this.sourceUser);

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SourceUser {
  int id;
  String nickName;
  @JsonKey(name: 'Profile')
  ProfileModel? profile;

  SourceUser(this.id, this.nickName, this.profile);

  factory SourceUser.fromJson(Map<String, dynamic> json) =>
      _$SourceUserFromJson(json);

  Map<String, dynamic> toJson() => _$SourceUserToJson(this);
}
