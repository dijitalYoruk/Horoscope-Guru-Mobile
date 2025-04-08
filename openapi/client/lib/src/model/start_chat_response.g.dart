// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_chat_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StartChatResponse extends StartChatResponse {
  @override
  final String chatId;
  @override
  final ChatMessage message;

  factory _$StartChatResponse(
          [void Function(StartChatResponseBuilder)? updates]) =>
      (new StartChatResponseBuilder()..update(updates))._build();

  _$StartChatResponse._({required this.chatId, required this.message})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        chatId, r'StartChatResponse', 'chatId');
    BuiltValueNullFieldError.checkNotNull(
        message, r'StartChatResponse', 'message');
  }

  @override
  StartChatResponse rebuild(void Function(StartChatResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StartChatResponseBuilder toBuilder() =>
      new StartChatResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StartChatResponse &&
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
    return (newBuiltValueToStringHelper(r'StartChatResponse')
          ..add('chatId', chatId)
          ..add('message', message))
        .toString();
  }
}

class StartChatResponseBuilder
    implements Builder<StartChatResponse, StartChatResponseBuilder> {
  _$StartChatResponse? _$v;

  String? _chatId;
  String? get chatId => _$this._chatId;
  set chatId(String? chatId) => _$this._chatId = chatId;

  ChatMessageBuilder? _message;
  ChatMessageBuilder get message =>
      _$this._message ??= new ChatMessageBuilder();
  set message(ChatMessageBuilder? message) => _$this._message = message;

  StartChatResponseBuilder() {
    StartChatResponse._defaults(this);
  }

  StartChatResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _chatId = $v.chatId;
      _message = $v.message.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StartChatResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$StartChatResponse;
  }

  @override
  void update(void Function(StartChatResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StartChatResponse build() => _build();

  _$StartChatResponse _build() {
    _$StartChatResponse _$result;
    try {
      _$result = _$v ??
          new _$StartChatResponse._(
            chatId: BuiltValueNullFieldError.checkNotNull(
                chatId, r'StartChatResponse', 'chatId'),
            message: message.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'message';
        message.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'StartChatResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
