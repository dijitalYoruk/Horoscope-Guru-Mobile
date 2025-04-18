// import 'package:json_annotation/json_annotation.dart';
// part 'api.g.dart';

import 'package:dio/dio.dart';

class GoogleSignInResponse {
  final String token;
  final User user;

  GoogleSignInResponse({
    required this.token,
    required this.user,
  });

  factory GoogleSignInResponse.fromJson(Map<String, dynamic> json) {
    return GoogleSignInResponse(
      token: json['token'],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
    };
  }
}

class GoogleSignInRequest {
  final String idToken;

  GoogleSignInRequest({
    required this.idToken,
  });

  factory GoogleSignInRequest.fromJson(Map<String, dynamic> json) {
    return GoogleSignInRequest(
      idToken: json['idToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idToken': idToken,
    };
  }
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      surname: json['surname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'surname': surname,
    };
  }
}

class PostChatRequest {
  final ChatMessage? initialMessage;
  final String? chatId;
  final String message;

  PostChatRequest({
    this.initialMessage,
    this.chatId,
    required this.message,
  });

  factory PostChatRequest.fromJson(Map<String, dynamic> json) {
    return PostChatRequest(
      initialMessage: json['initialMessage'] != null
          ? ChatMessage.fromJson(json['initialMessage'])
          : null,
      chatId: json['chatId'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'initialMessage': initialMessage?.toJson(),
      'chatId': chatId,
      'message': message,
    };
  }
}

class PostChatResponse {
  final String chatId;
  final ChatMessage message;

  PostChatResponse({
    required this.chatId,
    required this.message,
  });

  factory PostChatResponse.fromJson(Map<String, dynamic> json) {
    return PostChatResponse(
      chatId: json['chatId'],
      message: ChatMessage.fromJson(json['message']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'message': message.toJson(),
    };
  }
}

class GenerateChatTitleResponse {
  final String title;

  GenerateChatTitleResponse({
    required this.title,
  });

  factory GenerateChatTitleResponse.fromJson(Map<String, dynamic> json) {
    return GenerateChatTitleResponse(
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
    };
  }
}

class StartChatRequest {
  StartChatRequest();

  factory StartChatRequest.fromJson(Map<String, dynamic> json) {
    return StartChatRequest();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}

class StartChatResponse {
  final String chatId;
  final ChatMessage message;

  StartChatResponse({
    required this.chatId,
    required this.message,
  });

  factory StartChatResponse.fromJson(Map<String, dynamic> json) {
    return StartChatResponse(
      chatId: json['chatId'],
      message: ChatMessage.fromJson(json['message']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'message': message.toJson(),
    };
  }
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

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: ChatMessageRole.values
          .firstWhere((e) => e.toString() == 'ChatMessageRole.' + json['role']),
      content: json['content'],
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role.toString().split('.').last,
      'content': content,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

enum ChatMessageRole {
  assistant,
  system,
  user,
}

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://yourapi.com'));

  Future<GoogleSignInResponse> signInWithGoogle(String idToken) async {
    final response = await _dio
        .get('/auth/google/sign-in', queryParameters: {'idToken': idToken});
    if (response.statusCode == 200) {
      return GoogleSignInResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to sign in with Google');
    }
  }

  Future<PostChatResponse> sendMessageToChat(PostChatRequest request) async {
    final response = await _dio.post('/chat', data: request.toJson());
    if (response.statusCode == 200) {
      return PostChatResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to send message to chat');
    }
  }

  // Add more methods for other endpoints as needed...
}
