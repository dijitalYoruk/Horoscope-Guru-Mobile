# openapi.api.DefaultApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**chatChatIdGenerateTitleGet**](DefaultApi.md#chatchatidgeneratetitleget) | **GET** /chat/{chatId}/generate/title | 
[**sendMessageToChat**](DefaultApi.md#sendmessagetochat) | **POST** /chat | Sends a user message and retrieves the new assistant message.
[**signInGoogle**](DefaultApi.md#signingoogle) | **GET** /auth/google/sign-in | Google OAuth callback endpoint
[**startChat**](DefaultApi.md#startchat) | **POST** /chat/start | Starts a chat and saves it to the db.


# **chatChatIdGenerateTitleGet**
> GenerateChatTitleResponse chatChatIdGenerateTitleGet(chatId)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final String chatId = chatId_example; // String | 

try {
    final response = api.chatChatIdGenerateTitleGet(chatId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->chatChatIdGenerateTitleGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **chatId** | **String**|  | 

### Return type

[**GenerateChatTitleResponse**](GenerateChatTitleResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sendMessageToChat**
> PostChatResponse sendMessageToChat(postChatRequest)

Sends a user message and retrieves the new assistant message.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final PostChatRequest postChatRequest = ; // PostChatRequest | 

try {
    final response = api.sendMessageToChat(postChatRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->sendMessageToChat: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **postChatRequest** | [**PostChatRequest**](PostChatRequest.md)|  | [optional] 

### Return type

[**PostChatResponse**](PostChatResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **signInGoogle**
> GoogleSignInResponse signInGoogle(idToken)

Google OAuth callback endpoint

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final String idToken = idToken_example; // String | 

try {
    final response = api.signInGoogle(idToken);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->signInGoogle: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idToken** | **String**|  | 

### Return type

[**GoogleSignInResponse**](GoogleSignInResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **startChat**
> StartChatResponse startChat(body)

Starts a chat and saves it to the db.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final Object body = Object; // Object | 

try {
    final response = api.startChat(body);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->startChat: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | **Object**|  | [optional] 

### Return type

[**StartChatResponse**](StartChatResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

