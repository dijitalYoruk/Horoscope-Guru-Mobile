// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_chat_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostChatRequest _$PostChatRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PostChatRequest',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['message'],
        );
        final val = PostChatRequest(
          initialMessage: $checkedConvert(
              'initialMessage',
              (v) => v == null
                  ? null
                  : ChatMessage.fromJson(v as Map<String, dynamic>)),
          chatId: $checkedConvert('chatId', (v) => v as String?),
          message: $checkedConvert('message', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$PostChatRequestToJson(PostChatRequest instance) =>
    <String, dynamic>{
      if (instance.initialMessage?.toJson() case final value?)
        'initialMessage': value,
      if (instance.chatId case final value?) 'chatId': value,
      'message': instance.message,
    };
