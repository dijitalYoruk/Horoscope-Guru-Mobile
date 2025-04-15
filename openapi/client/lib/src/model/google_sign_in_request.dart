//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'google_sign_in_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GoogleSignInRequest {
  /// Returns a new [GoogleSignInRequest] instance.
  GoogleSignInRequest({

    required  this.idToken,
  });

  @JsonKey(
    
    name: r'idToken',
    required: true,
    includeIfNull: false,
  )


  final String idToken;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GoogleSignInRequest &&
      other.idToken == idToken;

    @override
    int get hashCode =>
        idToken.hashCode;

  factory GoogleSignInRequest.fromJson(Map<String, dynamic> json) => _$GoogleSignInRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleSignInRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

