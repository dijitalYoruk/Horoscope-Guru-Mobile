// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_chat_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PostChatResponse extends PostChatResponse {
  @override
  final ChatMessage message;

  factory _$PostChatResponse(
          [void Function(PostChatResponseBuilder)? updates]) =>
      (new PostChatResponseBuilder()..update(updates))._build();

  _$PostChatResponse._({required this.message}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        message, r'PostChatResponse', 'message');
  }

  @override
  PostChatResponse rebuild(void Function(PostChatResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PostChatResponseBuilder toBuilder() =>
      new PostChatResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PostChatResponse && message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PostChatResponse')
          ..add('message', message))
        .toString();
  }
}

class PostChatResponseBuilder
    implements Builder<PostChatResponse, PostChatResponseBuilder> {
  _$PostChatResponse? _$v;

  ChatMessageBuilder? _message;
  ChatMessageBuilder get message =>
      _$this._message ??= new ChatMessageBuilder();
  set message(ChatMessageBuilder? message) => _$this._message = message;

  PostChatResponseBuilder() {
    PostChatResponse._defaults(this);
  }

  PostChatResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _message = $v.message.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PostChatResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PostChatResponse;
  }

  @override
  void update(void Function(PostChatResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PostChatResponse build() => _build();

  _$PostChatResponse _build() {
    _$PostChatResponse _$result;
    try {
      _$result = _$v ??
          new _$PostChatResponse._(
            message: message.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'message';
        message.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'PostChatResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
