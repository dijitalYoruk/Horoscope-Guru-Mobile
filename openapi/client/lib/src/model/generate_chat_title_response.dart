//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'generate_chat_title_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GenerateChatTitleResponse {
  /// Returns a new [GenerateChatTitleResponse] instance.
  GenerateChatTitleResponse({

    required  this.title,
  });

  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false,
  )


  final String title;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GenerateChatTitleResponse &&
      other.title == title;

    @override
    int get hashCode =>
        title.hashCode;

  factory GenerateChatTitleResponse.fromJson(Map<String, dynamic> json) => _$GenerateChatTitleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GenerateChatTitleResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

