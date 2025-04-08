import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for DefaultApi
void main() {
  final instance = Openapi().getDefaultApi();

  group(DefaultApi, () {
    // Sends a user message and retrieves the new assistant message.
    //
    //Future<PostChatResponse> chat({ PostChatRequest postChatRequest }) async
    test('test chat', () async {
      // TODO
    });

    //Future<GenerateChatTitleResponse> chatChatIdGenerateTitleGet(String chatId) async
    test('test chatChatIdGenerateTitleGet', () async {
      // TODO
    });

    // Google OAuth callback endpoint
    //
    //Future<GoogleAuthCallbackResponse> googleAuthCallback(String code, String scope, String authuser, String prompt) async
    test('test googleAuthCallback', () async {
      // TODO
    });

    // Initiates Google OAuth authentication
    //
    //Future initiateGoogleAuth() async
    test('test initiateGoogleAuth', () async {
      // TODO
    });

    // Starts a chat and saves it to the db.
    //
    //Future<StartChatResponse> startChat({ JsonObject body }) async
    test('test startChat', () async {
      // TODO
    });

  });
}
