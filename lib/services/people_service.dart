import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:horoscopeguruapp/models/person.dart';

class PeopleService {
  static const String _storageKey = 'people_data';

  // Get all people
  static Future<List<Person>> getAllPeople() async {
    final prefs = await SharedPreferences.getInstance();
    final peopleJson = prefs.getStringList(_storageKey) ?? [];

    return peopleJson.map((json) => Person.fromJson(jsonDecode(json))).toList()
      ..sort((a, b) => b.createdAt
          .compareTo(a.createdAt)); // Sort by creation date, newest first
  }

  // Add a new person
  static Future<void> addPerson(Person person) async {
    final prefs = await SharedPreferences.getInstance();
    final peopleJson = prefs.getStringList(_storageKey) ?? [];

    // Check if person already exists (by birth date and place)
    final exists = peopleJson.any((json) {
      final existingPerson = Person.fromJson(jsonDecode(json));
      return existingPerson.birthDate.year == person.birthDate.year &&
          existingPerson.birthDate.month == person.birthDate.month &&
          existingPerson.birthDate.day == person.birthDate.day &&
          existingPerson.birthPlace.toLowerCase() ==
              person.birthPlace.toLowerCase();
    });

    if (exists) {
      throw Exception(
          'A person with the same birth date and place already exists');
    }

    peopleJson.add(jsonEncode(person.toJson()));
    await prefs.setStringList(_storageKey, peopleJson);
  }

  // Update a person
  static Future<void> updatePerson(Person person) async {
    final prefs = await SharedPreferences.getInstance();
    final peopleJson = prefs.getStringList(_storageKey) ?? [];

    final index = peopleJson.indexWhere((json) {
      final existingPerson = Person.fromJson(jsonDecode(json));
      return existingPerson.id == person.id;
    });

    if (index != -1) {
      peopleJson[index] = jsonEncode(person.toJson());
      await prefs.setStringList(_storageKey, peopleJson);
    }
  }

  // Delete a person
  static Future<void> deletePerson(String personId) async {
    final prefs = await SharedPreferences.getInstance();
    final peopleJson = prefs.getStringList(_storageKey) ?? [];

    peopleJson.removeWhere((json) {
      final person = Person.fromJson(jsonDecode(json));
      return person.id == personId;
    });

    await prefs.setStringList(_storageKey, peopleJson);
  }

  // Check if person exists
  static Future<bool> personExists(
      DateTime birthDate, String birthPlace) async {
    final prefs = await SharedPreferences.getInstance();
    final peopleJson = prefs.getStringList(_storageKey) ?? [];

    return peopleJson.any((json) {
      final person = Person.fromJson(jsonDecode(json));
      return person.birthDate.year == birthDate.year &&
          person.birthDate.month == birthDate.month &&
          person.birthDate.day == birthDate.day &&
          person.birthPlace.toLowerCase() == birthPlace.toLowerCase();
    });
  }
}
