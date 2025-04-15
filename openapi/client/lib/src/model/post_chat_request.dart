//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/chat_message.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_chat_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PostChatRequest {
  /// Returns a new [PostChatRequest] instance.
  PostChatRequest({

     this.initialMessage,

     this.chatId,

    required  this.message,
  });

  @JsonKey(
    
    name: r'initialMessage',
    required: false,
    includeIfNull: false,
  )


  final ChatMessage? initialMessage;



  @JsonKey(
    
    name: r'chatId',
    required: false,
    includeIfNull: false,
  )


  final String? chatId;



  @JsonKey(
    
    name: r'message',
    required: true,
    includeIfNull: false,
  )


  final String message;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PostChatRequest &&
      other.initialMessage == initialMessage &&
      other.chatId == chatId &&
      other.message == message;

    @override
    int get hashCode =>
        (initialMessage == null ? 0 : initialMessage.hashCode) +
        chatId.hashCode +
        message.hashCode;

  factory PostChatRequest.fromJson(Map<String, dynamic> json) => _$PostChatRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PostChatRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

