//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'generate_chat_title_response.g.dart';

/// GenerateChatTitleResponse
///
/// Properties:
/// * [title] 
@BuiltValue()
abstract class GenerateChatTitleResponse implements Built<GenerateChatTitleResponse, GenerateChatTitleResponseBuilder> {
  @BuiltValueField(wireName: r'title')
  String get title;

  GenerateChatTitleResponse._();

  factory GenerateChatTitleResponse([void updates(GenerateChatTitleResponseBuilder b)]) = _$GenerateChatTitleResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GenerateChatTitleResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GenerateChatTitleResponse> get serializer => _$GenerateChatTitleResponseSerializer();
}

class _$GenerateChatTitleResponseSerializer implements PrimitiveSerializer<GenerateChatTitleResponse> {
  @override
  final Iterable<Type> types = const [GenerateChatTitleResponse, _$GenerateChatTitleResponse];

  @override
  final String wireName = r'GenerateChatTitleResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GenerateChatTitleResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GenerateChatTitleResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GenerateChatTitleResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GenerateChatTitleResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GenerateChatTitleResponseBuilder();
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

