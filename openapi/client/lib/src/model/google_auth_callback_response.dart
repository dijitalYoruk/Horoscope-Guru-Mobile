//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/user.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'google_auth_callback_response.g.dart';

/// GoogleAuthCallbackResponse
///
/// Properties:
/// * [token] - JWT token for authentication
/// * [user] 
@BuiltValue()
abstract class GoogleAuthCallbackResponse implements Built<GoogleAuthCallbackResponse, GoogleAuthCallbackResponseBuilder> {
  /// JWT token for authentication
  @BuiltValueField(wireName: r'token')
  String get token;

  @BuiltValueField(wireName: r'user')
  User get user;

  GoogleAuthCallbackResponse._();

  factory GoogleAuthCallbackResponse([void updates(GoogleAuthCallbackResponseBuilder b)]) = _$GoogleAuthCallbackResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GoogleAuthCallbackResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GoogleAuthCallbackResponse> get serializer => _$GoogleAuthCallbackResponseSerializer();
}

class _$GoogleAuthCallbackResponseSerializer implements PrimitiveSerializer<GoogleAuthCallbackResponse> {
  @override
  final Iterable<Type> types = const [GoogleAuthCallbackResponse, _$GoogleAuthCallbackResponse];

  @override
  final String wireName = r'GoogleAuthCallbackResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GoogleAuthCallbackResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'token';
    yield serializers.serialize(
      object.token,
      specifiedType: const FullType(String),
    );
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(User),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GoogleAuthCallbackResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GoogleAuthCallbackResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.token = valueDes;
          break;
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(User),
          ) as User;
          result.user.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GoogleAuthCallbackResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GoogleAuthCallbackResponseBuilder();
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

