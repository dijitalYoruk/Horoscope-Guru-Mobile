//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'post_chat_request.g.dart';

/// PostChatRequest
///
/// Properties:
/// * [chatId] 
/// * [message] 
@BuiltValue()
abstract class PostChatRequest implements Built<PostChatRequest, PostChatRequestBuilder> {
  @BuiltValueField(wireName: r'chatId')
  String get chatId;

  @BuiltValueField(wireName: r'message')
  String get message;

  PostChatRequest._();

  factory PostChatRequest([void updates(PostChatRequestBuilder b)]) = _$PostChatRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PostChatRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PostChatRequest> get serializer => _$PostChatRequestSerializer();
}

class _$PostChatRequestSerializer implements PrimitiveSerializer<PostChatRequest> {
  @override
  final Iterable<Type> types = const [PostChatRequest, _$PostChatRequest];

  @override
  final String wireName = r'PostChatRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PostChatRequest object, {
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
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PostChatRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PostChatRequestBuilder result,
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
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PostChatRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PostChatRequestBuilder();
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

