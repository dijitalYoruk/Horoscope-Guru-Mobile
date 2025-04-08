// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_auth_callback_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GoogleAuthCallbackRequest extends GoogleAuthCallbackRequest {
  @override
  final User user;

  factory _$GoogleAuthCallbackRequest(
          [void Function(GoogleAuthCallbackRequestBuilder)? updates]) =>
      (new GoogleAuthCallbackRequestBuilder()..update(updates))._build();

  _$GoogleAuthCallbackRequest._({required this.user}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        user, r'GoogleAuthCallbackRequest', 'user');
  }

  @override
  GoogleAuthCallbackRequest rebuild(
          void Function(GoogleAuthCallbackRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoogleAuthCallbackRequestBuilder toBuilder() =>
      new GoogleAuthCallbackRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoogleAuthCallbackRequest && user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GoogleAuthCallbackRequest')
          ..add('user', user))
        .toString();
  }
}

class GoogleAuthCallbackRequestBuilder
    implements
        Builder<GoogleAuthCallbackRequest, GoogleAuthCallbackRequestBuilder> {
  _$GoogleAuthCallbackRequest? _$v;

  UserBuilder? _user;
  UserBuilder get user => _$this._user ??= new UserBuilder();
  set user(UserBuilder? user) => _$this._user = user;

  GoogleAuthCallbackRequestBuilder() {
    GoogleAuthCallbackRequest._defaults(this);
  }

  GoogleAuthCallbackRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoogleAuthCallbackRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GoogleAuthCallbackRequest;
  }

  @override
  void update(void Function(GoogleAuthCallbackRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoogleAuthCallbackRequest build() => _build();

  _$GoogleAuthCallbackRequest _build() {
    _$GoogleAuthCallbackRequest _$result;
    try {
      _$result = _$v ??
          new _$GoogleAuthCallbackRequest._(
            user: user.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'GoogleAuthCallbackRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
