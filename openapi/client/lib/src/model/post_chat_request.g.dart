// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_chat_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PostChatRequest extends PostChatRequest {
  @override
  final String chatId;
  @override
  final String message;

  factory _$PostChatRequest([void Function(PostChatRequestBuilder)? updates]) =>
      (new PostChatRequestBuilder()..update(updates))._build();

  _$PostChatRequest._({required this.chatId, required this.message})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(chatId, r'PostChatRequest', 'chatId');
    BuiltValueNullFieldError.checkNotNull(
        message, r'PostChatRequest', 'message');
  }

  @override
  PostChatRequest rebuild(void Function(PostChatRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PostChatRequestBuilder toBuilder() =>
      new PostChatRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PostChatRequest &&
        chatId == other.chatId &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, chatId.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PostChatRequest')
          ..add('chatId', chatId)
          ..add('message', message))
        .toString();
  }
}

class PostChatRequestBuilder
    implements Builder<PostChatRequest, PostChatRequestBuilder> {
  _$PostChatRequest? _$v;

  String? _chatId;
  String? get chatId => _$this._chatId;
  set chatId(String? chatId) => _$this._chatId = chatId;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  PostChatRequestBuilder() {
    PostChatRequest._defaults(this);
  }

  PostChatRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _chatId = $v.chatId;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PostChatRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PostChatRequest;
  }

  @override
  void update(void Function(PostChatRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PostChatRequest build() => _build();

  _$PostChatRequest _build() {
    final _$result = _$v ??
        new _$PostChatRequest._(
          chatId: BuiltValueNullFieldError.checkNotNull(
              chatId, r'PostChatRequest', 'chatId'),
          message: BuiltValueNullFieldError.checkNotNull(
              message, r'PostChatRequest', 'message'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
