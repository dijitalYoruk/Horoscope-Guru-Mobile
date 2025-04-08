//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:openapi/src/date_serializer.dart';
import 'package:openapi/src/model/date.dart';

import 'package:openapi/src/model/chat_message.dart';
import 'package:openapi/src/model/chat_message_role.dart';
import 'package:openapi/src/model/generate_chat_title_response.dart';
import 'package:openapi/src/model/google_auth_callback_request.dart';
import 'package:openapi/src/model/google_auth_callback_response.dart';
import 'package:openapi/src/model/post_chat_request.dart';
import 'package:openapi/src/model/post_chat_response.dart';
import 'package:openapi/src/model/start_chat_response.dart';
import 'package:openapi/src/model/user.dart';

part 'serializers.g.dart';

@SerializersFor([
  ChatMessage,
  ChatMessageRole,
  GenerateChatTitleResponse,
  GoogleAuthCallbackRequest,
  GoogleAuthCallbackResponse,
  PostChatRequest,
  PostChatResponse,
  StartChatResponse,
  User,
])
Serializers serializers = (_$serializers.toBuilder()
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer()))
    .build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
