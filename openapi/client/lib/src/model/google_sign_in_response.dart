//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'google_sign_in_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GoogleSignInResponse {
  /// Returns a new [GoogleSignInResponse] instance.
  GoogleSignInResponse({

    required  this.token,

    required  this.user,
  });

      /// JWT token for authentication
  @JsonKey(
    
    name: r'token',
    required: true,
    includeIfNull: false,
  )


  final String token;



  @JsonKey(
    
    name: r'user',
    required: true,
    includeIfNull: false,
  )


  final User user;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GoogleSignInResponse &&
      other.token == token &&
      other.user == user;

    @override
    int get hashCode =>
        token.hashCode +
        user.hashCode;

  factory GoogleSignInResponse.fromJson(Map<String, dynamic> json) => _$GoogleSignInResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleSignInResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

