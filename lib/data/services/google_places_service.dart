import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mirrors_app/core/config/app_secrets.dart';

class PlacePrediction {
  final String description;
  final String placeId;

  PlacePrediction({required this.description, required this.placeId});

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      description: json['description'] as String? ?? '',
      placeId: json['place_id'] as String? ?? '',
    );
  }
}

class GooglePlacesService {
  final String _apiKey = AppSecrets.googleMapsApiKey;

  Future<List<PlacePrediction>> getAutocompletePredictions(String input) async {
    final query = input.trim();
    if (query.isEmpty) return [];

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json'
      '?input=${Uri.encodeComponent(query)}'
      '&key=$_apiKey'
      '&components=country:eg'
      '&language=ar',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data['status'] == 'OK' && data['predictions'] != null) {
          final list = data['predictions'] as List;
          return list.map((item) => PlacePrediction.fromJson(item)).toList();
        }
      }
    } catch (_) {
      return [];
    }
    return [];
  }

  Future<Map<String, double>?> getPlaceCoordinates(String placeId) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json'
      '?place_id=$placeId'
      '&fields=geometry'
      '&key=$_apiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data['status'] == 'OK' &&
            data['result']?['geometry']?['location'] != null) {
          final location = data['result']['geometry']['location'];
          return {
            'lat': (location['lat'] as num).toDouble(),
            'lng': (location['lng'] as num).toDouble(),
          };
        }
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}
