//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_message_role.g.dart';

class ChatMessageRole extends EnumClass {

  @BuiltValueEnumConst(wireName: r'assistant')
  static const ChatMessageRole assistant = _$assistant;
  @BuiltValueEnumConst(wireName: r'system')
  static const ChatMessageRole system = _$system;
  @BuiltValueEnumConst(wireName: r'user')
  static const ChatMessageRole user = _$user;

  static Serializer<ChatMessageRole> get serializer => _$chatMessageRoleSerializer;

  const ChatMessageRole._(String name): super(name);

  static BuiltSet<ChatMessageRole> get values => _$values;
  static ChatMessageRole valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ChatMessageRoleMixin = Object with _$ChatMessageRoleMixin;

