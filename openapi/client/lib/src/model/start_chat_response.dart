//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/chat_message.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'start_chat_response.g.dart';

/// StartChatResponse
///
/// Properties:
/// * [chatId] 
/// * [message] 
@BuiltValue()
abstract class StartChatResponse implements Built<StartChatResponse, StartChatResponseBuilder> {
  @BuiltValueField(wireName: r'chatId')
  String get chatId;

  @BuiltValueField(wireName: r'message')
  ChatMessage get message;

  StartChatResponse._();

  factory StartChatResponse([void updates(StartChatResponseBuilder b)]) = _$StartChatResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StartChatResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StartChatResponse> get serializer => _$StartChatResponseSerializer();
}

class _$StartChatResponseSerializer implements PrimitiveSerializer<StartChatResponse> {
  @override
  final Iterable<Type> types = const [StartChatResponse, _$StartChatResponse];

  @override
  final String wireName = r'StartChatResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StartChatResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'chatId';
    yield serializers.serialize(
      object.chatId,
      specifiedType: const FullType(String),
    );
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(ChatMessage),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StartChatResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StartChatResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'chatId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.chatId = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ChatMessage),
          ) as ChatMessage;
          result.message.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StartChatResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StartChatResponseBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

