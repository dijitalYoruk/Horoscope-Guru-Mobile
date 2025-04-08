//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/chat_message.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'post_chat_response.g.dart';

/// PostChatResponse
///
/// Properties:
/// * [message] 
@BuiltValue()
abstract class PostChatResponse implements Built<PostChatResponse, PostChatResponseBuilder> {
  @BuiltValueField(wireName: r'message')
  ChatMessage get message;

  PostChatResponse._();

  factory PostChatResponse([void updates(PostChatResponseBuilder b)]) = _$PostChatResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PostChatResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PostChatResponse> get serializer => _$PostChatResponseSerializer();
}

class _$PostChatResponseSerializer implements PrimitiveSerializer<PostChatResponse> {
  @override
  final Iterable<Type> types = const [PostChatResponse, _$PostChatResponse];

  @override
  final String wireName = r'PostChatResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PostChatResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(ChatMessage),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PostChatResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PostChatResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  PostChatResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PostChatResponseBuilder();
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

