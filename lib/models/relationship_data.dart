import 'package:flutter/material.dart';

class RelationshipData {
  final String? partnerName;
  final DateTime? partnerBirthDate;
  final String? partnerBirthPlace;
  final TimeOfDay? partnerBirthTime;

  const RelationshipData({
    this.partnerName,
    this.partnerBirthDate,
    this.partnerBirthPlace,
    this.partnerBirthTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': partnerName,
      'birthDate': "${partnerBirthDate!.year}-${partnerBirthDate!.month.toString().padLeft(2, '0')}-${partnerBirthDate!.day.toString().padLeft(2, '0')}",
      'birthPlace': partnerBirthPlace,
      'birthTime': partnerBirthTime != null
          ? '${partnerBirthTime!.hour.toString().padLeft(2, '0')}:${partnerBirthTime!.minute.toString().padLeft(2, '0')}'
          : null,
    };
  }

  factory RelationshipData.fromJson(Map<String, dynamic> json) {
    return RelationshipData(
      partnerName: json['partnerName'],
      partnerBirthDate: json['partnerBirthDate'] != null
          ? DateTime.parse(json['partnerBirthDate'])
          : null,
      partnerBirthPlace: json['partnerBirthPlace'],
      partnerBirthTime: json['partnerBirthTime'] != null
          ? _parseTimeOfDay(json['partnerBirthTime'])
          : null,
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

  bool get hasRequiredData =>
      partnerBirthDate != null &&
      partnerBirthPlace != null &&
      partnerBirthPlace!.isNotEmpty;

  String get summary {
    final parts = <String>[];

    if (partnerName != null && partnerName!.isNotEmpty) {
      parts.add('Partner: $partnerName');
    }

    if (partnerBirthDate != null) {
      parts.add('Birth Date: ${_formatDate(partnerBirthDate!)}');
    }

    if (partnerBirthPlace != null && partnerBirthPlace!.isNotEmpty) {
      parts.add('Birth Place: $partnerBirthPlace');
    }

    if (partnerBirthTime != null) {
      parts.add(
          'Birth Time: ${partnerBirthTime!.hour.toString().padLeft(2, '0')}:${partnerBirthTime!.minute.toString().padLeft(2, '0')}');
    }

    return parts.join(', ');
  }

  String _formatDate(DateTime date) {
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
