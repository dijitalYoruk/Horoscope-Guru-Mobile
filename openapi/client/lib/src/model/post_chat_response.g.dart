// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_chat_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostChatResponse _$PostChatResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PostChatResponse',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['chatId', 'message'],
        );
        final val = PostChatResponse(
          chatId: $checkedConvert('chatId', (v) => v as String),
          message: $checkedConvert('message',
              (v) => ChatMessage.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$PostChatResponseToJson(PostChatResponse instance) =>
    <String, dynamic>{
      'chatId': instance.chatId,
      'message': instance.message.toJson(),
    };
