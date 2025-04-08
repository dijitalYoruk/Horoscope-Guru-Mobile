// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_role.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ChatMessageRole _$assistant = const ChatMessageRole._('assistant');
const ChatMessageRole _$system = const ChatMessageRole._('system');
const ChatMessageRole _$user = const ChatMessageRole._('user');

ChatMessageRole _$valueOf(String name) {
  switch (name) {
    case 'assistant':
      return _$assistant;
    case 'system':
      return _$system;
    case 'user':
      return _$user;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<ChatMessageRole> _$values =
    new BuiltSet<ChatMessageRole>(const <ChatMessageRole>[
  _$assistant,
  _$system,
  _$user,
]);

class _$ChatMessageRoleMeta {
  const _$ChatMessageRoleMeta();
  ChatMessageRole get assistant => _$assistant;
  ChatMessageRole get system => _$system;
  ChatMessageRole get user => _$user;
  ChatMessageRole valueOf(String name) => _$valueOf(name);
  BuiltSet<ChatMessageRole> get values => _$values;
}

abstract class _$ChatMessageRoleMixin {
  // ignore: non_constant_identifier_names
  _$ChatMessageRoleMeta get ChatMessageRole => const _$ChatMessageRoleMeta();
}

Serializer<ChatMessageRole> _$chatMessageRoleSerializer =
    new _$ChatMessageRoleSerializer();

class _$ChatMessageRoleSerializer
    implements PrimitiveSerializer<ChatMessageRole> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'assistant': 'assistant',
    'system': 'system',
    'user': 'user',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'assistant': 'assistant',
    'system': 'system',
    'user': 'user',
  };

  @override
  final Iterable<Type> types = const <Type>[ChatMessageRole];
  @override
  final String wireName = 'ChatMessageRole';

  @override
  Object serialize(Serializers serializers, ChatMessageRole object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ChatMessageRole deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ChatMessageRole.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
