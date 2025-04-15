//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/chat_message.dart';
import 'package:json_annotation/json_annotation.dart';

part 'start_chat_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StartChatResponse {
  /// Returns a new [StartChatResponse] instance.
  StartChatResponse({

    required  this.message,
  });

  @JsonKey(
    
    name: r'message',
    required: true,
    includeIfNull: false,
  )


  final ChatMessage message;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StartChatResponse &&
      other.message == message;

    @override
    int get hashCode =>
        message.hashCode;

  factory StartChatResponse.fromJson(Map<String, dynamic> json) => _$StartChatResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StartChatResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

