// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_chat_title_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GenerateChatTitleResponse extends GenerateChatTitleResponse {
  @override
  final String title;

  factory _$GenerateChatTitleResponse(
          [void Function(GenerateChatTitleResponseBuilder)? updates]) =>
      (new GenerateChatTitleResponseBuilder()..update(updates))._build();

  _$GenerateChatTitleResponse._({required this.title}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        title, r'GenerateChatTitleResponse', 'title');
  }

  @override
  GenerateChatTitleResponse rebuild(
          void Function(GenerateChatTitleResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GenerateChatTitleResponseBuilder toBuilder() =>
      new GenerateChatTitleResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GenerateChatTitleResponse && title == other.title;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GenerateChatTitleResponse')
          ..add('title', title))
        .toString();
  }
}

class GenerateChatTitleResponseBuilder
    implements
        Builder<GenerateChatTitleResponse, GenerateChatTitleResponseBuilder> {
  _$GenerateChatTitleResponse? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  GenerateChatTitleResponseBuilder() {
    GenerateChatTitleResponse._defaults(this);
  }

  GenerateChatTitleResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GenerateChatTitleResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GenerateChatTitleResponse;
  }

  @override
  void update(void Function(GenerateChatTitleResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GenerateChatTitleResponse build() => _build();

  _$GenerateChatTitleResponse _build() {
    final _$result = _$v ??
        new _$GenerateChatTitleResponse._(
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'GenerateChatTitleResponse', 'title'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
