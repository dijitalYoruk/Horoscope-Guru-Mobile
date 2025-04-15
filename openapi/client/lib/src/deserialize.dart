import 'package:openapi/src/model/chat_message.dart';
import 'package:openapi/src/model/generate_chat_title_response.dart';
import 'package:openapi/src/model/google_sign_in_request.dart';
import 'package:openapi/src/model/google_sign_in_response.dart';
import 'package:openapi/src/model/post_chat_request.dart';
import 'package:openapi/src/model/post_chat_response.dart';
import 'package:openapi/src/model/start_chat_response.dart';
import 'package:openapi/src/model/user.dart';

final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

  ReturnType deserialize<ReturnType, BaseType>(dynamic value, String targetType, {bool growable= true}) {
      switch (targetType) {
        case 'String':
          return '$value' as ReturnType;
        case 'int':
          return (value is int ? value : int.parse('$value')) as ReturnType;
        case 'bool':
          if (value is bool) {
            return value as ReturnType;
          }
          final valueString = '$value'.toLowerCase();
          return (valueString == 'true' || valueString == '1') as ReturnType;
        case 'double':
          return (value is double ? value : double.parse('$value')) as ReturnType;
        case 'ChatMessage':
          return ChatMessage.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ChatMessageRole':
          
          
        case 'GenerateChatTitleResponse':
          return GenerateChatTitleResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GoogleSignInRequest':
          return GoogleSignInRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GoogleSignInResponse':
          return GoogleSignInResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PostChatRequest':
          return PostChatRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PostChatResponse':
          return PostChatResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StartChatResponse':
          return StartChatResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'User':
          return User.fromJson(value as Map<String, dynamic>) as ReturnType;
        default:
          RegExpMatch? match;

          if (value is List && (match = _regList.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toList(growable: growable) as ReturnType;
          }
          if (value is Set && (match = _regSet.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toSet() as ReturnType;
          }
          if (value is Map && (match = _regMap.firstMatch(targetType)) != null) {
            targetType = match![1]!.trim(); // ignore: parameter_assignments
            return Map<String, BaseType>.fromIterables(
              value.keys as Iterable<String>,
              value.values.map((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable)),
            ) as ReturnType;
          }
          break;
    }
    throw Exception('Cannot deserialize');
  }