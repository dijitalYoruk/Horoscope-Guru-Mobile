// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_sign_in_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleSignInResponse _$GoogleSignInResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'GoogleSignInResponse',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['token', 'user'],
        );
        final val = GoogleSignInResponse(
          token: $checkedConvert('token', (v) => v as String),
          user: $checkedConvert(
              'user', (v) => User.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$GoogleSignInResponseToJson(
        GoogleSignInResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
      'user': instance.user.toJson(),
    };
