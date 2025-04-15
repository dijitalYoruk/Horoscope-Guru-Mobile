// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_chat_title_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerateChatTitleResponse _$GenerateChatTitleResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'GenerateChatTitleResponse',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['title'],
        );
        final val = GenerateChatTitleResponse(
          title: $checkedConvert('title', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$GenerateChatTitleResponseToJson(
        GenerateChatTitleResponse instance) =>
    <String, dynamic>{
      'title': instance.title,
    };
