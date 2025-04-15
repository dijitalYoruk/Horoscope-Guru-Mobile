// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_sign_in_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleSignInRequest _$GoogleSignInRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'GoogleSignInRequest',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['idToken'],
        );
        final val = GoogleSignInRequest(
          idToken: $checkedConvert('idToken', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$GoogleSignInRequestToJson(
        GoogleSignInRequest instance) =>
    <String, dynamic>{
      'idToken': instance.idToken,
    };
