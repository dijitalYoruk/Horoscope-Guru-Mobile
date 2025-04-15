openapi-generator generate -i openapi.yaml -g dart-dio -o client  --additional-properties=serializationLibrary=json_serializable
cd client
flutter pub run build_runner build --delete-conflicting-outputs