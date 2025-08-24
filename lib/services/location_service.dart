import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:horoscopeguruapp/utils/environment_keys.dart';

class PlacePrediction {
  final String placeId;
  final String description;
  final String mainText;
  final String secondaryText;

  PlacePrediction({
    required this.placeId,
    required this.description,
    required this.mainText,
    required this.secondaryText,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    final structuredFormatting =
        json['structured_formatting'] as Map<String, dynamic>?;
    return PlacePrediction(
      placeId: json['place_id'] ?? '',
      description: json['description'] ?? '',
      mainText: structuredFormatting?['main_text'] ?? '',
      secondaryText: structuredFormatting?['secondary_text'] ?? '',
    );
  }
}

class LocationService {
  static const String _apiKey = EnvironmentKeys.GooglePlacesApiKey;
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place';

  static Future<List<PlacePrediction>> searchPlaces(String input) async {
    try {
      if (input.isEmpty) return [];

      final url = Uri.parse(
          '$_baseUrl/autocomplete/json?input=${Uri.encodeComponent(input)}&types=(cities)&key=$_apiKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final predictions = data['predictions'] as List;
          return predictions
              .map((prediction) => PlacePrediction.fromJson(prediction))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error searching places: $e');
      return [];
    }
  }

  static String getFormattedAddress(PlacePrediction prediction) {
    // Return the main text (city) or description if main text is not available
    return prediction.mainText.isNotEmpty
        ? prediction.mainText
        : prediction.description;
  }

  static String getFullAddress(PlacePrediction prediction) {
    // Return the full description (city, state, country)
    return prediction.description;
  }
}
