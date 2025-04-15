//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';


enum ChatMessageRole {
      @JsonValue(r'assistant')
      assistant(r'assistant'),
      @JsonValue(r'system')
      system(r'system'),
      @JsonValue(r'user')
      user(r'user');

  const ChatMessageRole(this.value);

  final String value;

  @override
  String toString() => value;
}
