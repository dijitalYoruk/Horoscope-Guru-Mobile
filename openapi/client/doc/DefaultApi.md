# openapi.api.DefaultApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**chat**](DefaultApi.md#chat) | **POST** /chat | Sends a user message and retrieves the new assistant message.
[**chatChatIdGenerateTitleGet**](DefaultApi.md#chatchatidgeneratetitleget) | **GET** /chat/{chatId}/generate/title | 
[**googleAuthCallback**](DefaultApi.md#googleauthcallback) | **GET** /auth/google/callback | Google OAuth callback endpoint
[**initiateGoogleAuth**](DefaultApi.md#initiategoogleauth) | **GET** /auth/google | Initiates Google OAuth authentication
[**startChat**](DefaultApi.md#startchat) | **POST** /chat/start | Starts a chat and saves it to the db.


# **chat**
> PostChatResponse chat(postChatRequest)

Sends a user message and retrieves the new assistant message.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final PostChatRequest postChatRequest = ; // PostChatRequest | 

try {
    final response = api.chat(postChatRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->chat: $e\n');
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

# **googleAuthCallback**
> GoogleAuthCallbackResponse googleAuthCallback(code, scope, authuser, prompt)

Google OAuth callback endpoint

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final String code = code_example; // String | 
final String scope = scope_example; // String | 
final String authuser = authuser_example; // String | 
final String prompt = prompt_example; // String | 

try {
    final response = api.googleAuthCallback(code, scope, authuser, prompt);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->googleAuthCallback: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **code** | **String**|  | 
 **scope** | **String**|  | 
 **authuser** | **String**|  | 
 **prompt** | **String**|  | 

### Return type

[**GoogleAuthCallbackResponse**](GoogleAuthCallbackResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **initiateGoogleAuth**
> initiateGoogleAuth()

Initiates Google OAuth authentication

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();

try {
    api.initiateGoogleAuth();
} catch on DioException (e) {
    print('Exception when calling DefaultApi->initiateGoogleAuth: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **startChat**
> StartChatResponse startChat(body)

Starts a chat and saves it to the db.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final JsonObject body = Object; // JsonObject | 

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
 **body** | **JsonObject**|  | [optional] 

### Return type

[**StartChatResponse**](StartChatResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

