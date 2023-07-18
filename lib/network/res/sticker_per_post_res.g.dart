// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sticker_per_post_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StickerPerPostRes _$StickerPerPostResFromJson(Map<String, dynamic> json) =>
    StickerPerPostRes(
      status: json['status'] as bool?,
      msg: json['msg'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => StickerPerPost.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StickerPerPostResToJson(StickerPerPostRes instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'data': instance.data,
    };

StickerPerPost _$StickerPerPostFromJson(Map<String, dynamic> json) =>
    StickerPerPost(
      sentBy: json['sentBy'] as int?,
      postId: json['postId'] as int?,
      stickerId: json['stickerId'] as int?,
      stickerUrl: json['stickerUrl'] as String?,
      stickerAmount: json['stickerAmount'] as int?,
      createAt: json['createdAt'] as String?,
      sentUser:
          json['SentBy'] == null ? null : PostByModel.fromJson(json['SentBy']),
    );

Map<String, dynamic> _$StickerPerPostToJson(StickerPerPost instance) =>
    <String, dynamic>{
      'sentBy': instance.sentBy,
      'postId': instance.postId,
      'stickerId': instance.stickerId,
      'stickerUrl': instance.stickerUrl,
      'stickerAmount': instance.stickerAmount,
      'createdAt': instance.createAt,
      'SentBy': instance.sentUser,
    };
