import 'dart:io';
import 'package:dio/dio.dart';

// ---------------------- MODELS ----------------------

class GoogleSignInResponse {
  final String token;
  final User user;

  GoogleSignInResponse({required this.token, required this.user});

  factory GoogleSignInResponse.fromJson(Map<String, dynamic> json) =>
      GoogleSignInResponse(
        token: json['token'],
        user: User.fromJson(json['user']),
      );
}

class User {
  final String id;
  final String email;
  final String name;
  final String surname;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.surname,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    email: json['email'],
    name: json['name'],
    surname: json['surname'],
  );
}

class StartChatRequest {
  Map<String, dynamic> toJson() => {};
}

class StartChatResponse {
  final String? chatId;
  final ChatMessage message;

  StartChatResponse({required this.chatId, required this.message});

  factory StartChatResponse.fromJson(Map<String, dynamic> json) =>
      StartChatResponse(
        chatId: json['chatId'],
        message: ChatMessage.fromJson(json['message']),
      );
}

class PostChatRequest {
  final String message;
  final String? chatId;
  final ChatMessage? initialMessage;

  PostChatRequest({required this.message, this.chatId, this.initialMessage});

  Map<String, dynamic> toJson() => {
    if (chatId != null) 'chatId': chatId,
    'message': message,
    if (initialMessage != null) 'initialMessage': initialMessage!.toJson(),
  };
}

class PostChatResponse {
  final String chatId;
  final ChatMessage message;

  PostChatResponse({required this.chatId, required this.message});

  factory PostChatResponse.fromJson(Map<String, dynamic> json) =>
      PostChatResponse(
        chatId: json['chatId'],
        message: ChatMessage.fromJson(json['message']),
      );
}

class GenerateChatTitleResponse {
  final String title;

  GenerateChatTitleResponse({required this.title});

  factory GenerateChatTitleResponse.fromJson(Map<String, dynamic> json) =>
      GenerateChatTitleResponse(title: json['title']);
}

class GetAllUserChatsResponse {
  final List<Chat> chats;

  GetAllUserChatsResponse({required this.chats});

  factory GetAllUserChatsResponse.fromJson(Map<String, dynamic> json) =>
      GetAllUserChatsResponse(
        chats: List<Chat>.from(
          json['chats'].map((chat) => Chat.fromJson(chat)),
        ),
      );
}

class Chat {
  final String chatId;
  final String? chatTitle;
  final DateTime createdAt;
  final DateTime updatedAt;

  Chat({
    required this.chatId,
    this.chatTitle,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    chatId: json['chatId'],
    chatTitle: json['chatTitle'],
    createdAt: HttpDate.parse(json['createdAt']),
    updatedAt: HttpDate.parse(json['updatedAt']),
  );
}

class ChatMessage {
  final ChatMessageRole role;
  final String content;
  final DateTime updatedAt;

  ChatMessage({
    required this.role,
    required this.content,
    required this.updatedAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    role: ChatMessageRoleExtension.fromString(json['role']),
    content: json['content'],
    updatedAt: HttpDate.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    'role': role.name,
    'content': content,
    'updatedAt': updatedAt.toIso8601String(),
  };
}

enum ChatMessageRole { assistant, system, user }

extension ChatMessageRoleExtension on ChatMessageRole {
  static ChatMessageRole fromString(String role) {
    switch (role) {
      case 'assistant':
        return ChatMessageRole.assistant;
      case 'system':
        return ChatMessageRole.system;
      case 'user':
        return ChatMessageRole.user;
      default:
        throw Exception('Invalid ChatMessageRole: $role');
    }
  }
}

// ---------------------- API SERVICE ----------------------

class Api {
  static final Api _instance = Api._internal();
  final Dio _dio;

  factory Api() {
    return _instance;
  }

  Api._internal()
      : _dio = Dio(
    BaseOptions(baseUrl: 'http://10.0.2.2:8080'),
  );

  Future<GoogleSignInResponse> signInWithGoogle(String idToken) async {
    final response = await _dio.get(
      '/auth/google/sign-in',
      queryParameters: {'idToken': idToken},
    );
    return GoogleSignInResponse.fromJson(response.data);
  }

  Future<StartChatResponse> startChat(String token) async {
    final response = await _dio.post(
      '/chat/start',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
      data: StartChatRequest().toJson(),
    );
    return StartChatResponse.fromJson(response.data);
  }

  Future<PostChatResponse> sendMessageToChat(
      String token, PostChatRequest request) async {
    final response = await _dio.post(
      '/chat',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
      data: request.toJson(),
    );
    return PostChatResponse.fromJson(response.data);
  }

  Future<GetAllUserChatsResponse> getAllUserChats(String token) async {
    final response = await _dio.get(
      '/chat',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return GetAllUserChatsResponse.fromJson(response.data);
  }

  Future<GenerateChatTitleResponse> generateChatTitle(
      String token, String chatId) async {
    final response = await _dio.get(
      '/chat/$chatId/generate/title',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return GenerateChatTitleResponse.fromJson(response.data);
  }
}