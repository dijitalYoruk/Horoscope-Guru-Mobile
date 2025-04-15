// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => $checkedCreate(
      'ChatMessage',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['role', 'content', 'updatedAt'],
        );
        final val = ChatMessage(
          role: $checkedConvert(
              'role', (v) => $enumDecode(_$ChatMessageRoleEnumMap, v)),
          content: $checkedConvert('content', (v) => v as String),
          updatedAt:
              $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'role': _$ChatMessageRoleEnumMap[instance.role]!,
      'content': instance.content,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ChatMessageRoleEnumMap = {
  ChatMessageRole.assistant: 'assistant',
  ChatMessageRole.system: 'system',
  ChatMessageRole.user: 'user',
};
