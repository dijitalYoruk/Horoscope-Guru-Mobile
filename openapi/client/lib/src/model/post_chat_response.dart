//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/chat_message.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_chat_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PostChatResponse {
  /// Returns a new [PostChatResponse] instance.
  PostChatResponse({

    required  this.chatId,

    required  this.message,
  });

  @JsonKey(
    
    name: r'chatId',
    required: true,
    includeIfNull: false,
  )


  final String chatId;



  @JsonKey(
    
    name: r'message',
    required: true,
    includeIfNull: false,
  )


  final ChatMessage message;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PostChatResponse &&
      other.chatId == chatId &&
      other.message == message;

    @override
    int get hashCode =>
        chatId.hashCode +
        message.hashCode;

  factory PostChatResponse.fromJson(Map<String, dynamic> json) => _$PostChatResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PostChatResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

