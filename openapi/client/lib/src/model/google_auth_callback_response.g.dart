// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_auth_callback_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GoogleAuthCallbackResponse extends GoogleAuthCallbackResponse {
  @override
  final String token;
  @override
  final User user;

  factory _$GoogleAuthCallbackResponse(
          [void Function(GoogleAuthCallbackResponseBuilder)? updates]) =>
      (new GoogleAuthCallbackResponseBuilder()..update(updates))._build();

  _$GoogleAuthCallbackResponse._({required this.token, required this.user})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        token, r'GoogleAuthCallbackResponse', 'token');
    BuiltValueNullFieldError.checkNotNull(
        user, r'GoogleAuthCallbackResponse', 'user');
  }

  @override
  GoogleAuthCallbackResponse rebuild(
          void Function(GoogleAuthCallbackResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoogleAuthCallbackResponseBuilder toBuilder() =>
      new GoogleAuthCallbackResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoogleAuthCallbackResponse &&
        token == other.token &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GoogleAuthCallbackResponse')
          ..add('token', token)
          ..add('user', user))
        .toString();
  }
}

class GoogleAuthCallbackResponseBuilder
    implements
        Builder<GoogleAuthCallbackResponse, GoogleAuthCallbackResponseBuilder> {
  _$GoogleAuthCallbackResponse? _$v;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  UserBuilder? _user;
  UserBuilder get user => _$this._user ??= new UserBuilder();
  set user(UserBuilder? user) => _$this._user = user;

  GoogleAuthCallbackResponseBuilder() {
    GoogleAuthCallbackResponse._defaults(this);
  }

  GoogleAuthCallbackResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _token = $v.token;
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoogleAuthCallbackResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GoogleAuthCallbackResponse;
  }

  @override
  void update(void Function(GoogleAuthCallbackResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoogleAuthCallbackResponse build() => _build();

  _$GoogleAuthCallbackResponse _build() {
    _$GoogleAuthCallbackResponse _$result;
    try {
      _$result = _$v ??
          new _$GoogleAuthCallbackResponse._(
            token: BuiltValueNullFieldError.checkNotNull(
                token, r'GoogleAuthCallbackResponse', 'token'),
            user: user.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'GoogleAuthCallbackResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
