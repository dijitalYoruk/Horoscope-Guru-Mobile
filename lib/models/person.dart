import 'package:flutter/material.dart';
import 'relationship_data.dart';

class Person {
  final String id;
  final String? name;
  final DateTime birthDate;
  final String birthPlace;
  final TimeOfDay? birthTime;
  final DateTime createdAt;

  const Person({
    required this.id,
    this.name,
    required this.birthDate,
    required this.birthPlace,
    this.birthTime,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'birthDate':
          "${birthDate.year}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}",
      'birthPlace': birthPlace,
      'birthTime': birthTime != null
          ? '${birthTime!.hour.toString().padLeft(2, '0')}:${birthTime!.minute.toString().padLeft(2, '0')}'
          : null,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'],
      birthDate: DateTime.parse(json['birthDate']),
      birthPlace: json['birthPlace'],
      birthTime:
          json['birthTime'] != null ? _parseTimeOfDay(json['birthTime']) : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  static TimeOfDay? _parseTimeOfDay(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length == 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      // Return null if parsing fails
    }
    return null;
  }

  String get displayName => name?.isNotEmpty == true ? name! : 'Unknown Person';

  String get birthDateFormatted {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[birthDate.month - 1]} ${birthDate.day}, ${birthDate.year}';
  }

  String get birthTimeFormatted {
    if (birthTime == null) return 'Not specified';
    return '${birthTime!.hour.toString().padLeft(2, '0')}:${birthTime!.minute.toString().padLeft(2, '0')}';
  }

  // Convert to RelationshipData for compatibility with existing chat system
  RelationshipData toRelationshipData() {
    return RelationshipData(
      partnerName: name,
      partnerBirthDate: birthDate,
      partnerBirthPlace: birthPlace,
      partnerBirthTime: birthTime,
    );
  }
}
