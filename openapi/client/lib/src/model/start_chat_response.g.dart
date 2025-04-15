// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_chat_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StartChatResponse _$StartChatResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'StartChatResponse',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['message'],
        );
        final val = StartChatResponse(
          message: $checkedConvert('message',
              (v) => ChatMessage.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$StartChatResponseToJson(StartChatResponse instance) =>
    <String, dynamic>{
      'message': instance.message.toJson(),
    };
