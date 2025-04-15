import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for DefaultApi
void main() {
  final instance = Openapi().getDefaultApi();

  group(DefaultApi, () {
    //Future<GenerateChatTitleResponse> chatChatIdGenerateTitleGet(String chatId) async
    test('test chatChatIdGenerateTitleGet', () async {
      // TODO
    });

    // Sends a user message and retrieves the new assistant message.
    //
    //Future<PostChatResponse> sendMessageToChat({ PostChatRequest postChatRequest }) async
    test('test sendMessageToChat', () async {
      // TODO
    });

    // Google OAuth callback endpoint
    //
    //Future<GoogleSignInResponse> signInGoogle(String idToken) async
    test('test signInGoogle', () async {
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
