import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:mirrors_app/core/config/app_secrets.dart';

class PlacePrediction {
  final String description;
  final String placeId;

  const PlacePrediction({required this.description, required this.placeId});

  /// Parses one `placePrediction` object from Places API (New).
  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    final text = json['text'];
    return PlacePrediction(
      description: text is Map ? (text['text'] as String? ?? '') : '',
      placeId: json['placeId'] as String? ?? '',
    );
  }
}

class PlaceCoordinates {
  final double lat;
  final double lng;
  const PlaceCoordinates(this.lat, this.lng);
}

/// Places API (New). The legacy Places API can no longer be enabled on new
/// Google Cloud projects, so the old `/maps/api/place/...` endpoints are gone.
///
/// One instance keeps a single HTTP client (connection reuse); call [dispose]
/// when done.
class GooglePlacesService {
  GooglePlacesService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  final String _apiKey = AppSecrets.googleMapsApiKey;

  static const String _host = 'places.googleapis.com';
  static const Duration _timeout = Duration(seconds: 6);

  /// A session groups one autocomplete typing session with the final details
  /// call, so Google bills them as a single session.
  static String newSessionToken() {
    final rnd = Random.secure();
    return List.generate(
      32,
      (_) => rnd.nextInt(16).toRadixString(16),
    ).join();
  }

  Future<List<PlacePrediction>> getAutocompletePredictions(
    String input, {
    String? sessionToken,
    double? biasLat,
    double? biasLng,
    String languageCode = 'ar',
  }) async {
    final query = input.trim();
    if (query.isEmpty || _apiKey.isEmpty) return const [];

    final body = <String, dynamic>{
      'input': query,
      'languageCode': languageCode,
      'includedRegionCodes': ['eg'],
      'sessionToken': ?sessionToken,
      // Prefer results near what the user is looking at on the map.
      if (biasLat != null && biasLng != null)
        'locationBias': {
          'circle': {
            'center': {'latitude': biasLat, 'longitude': biasLng},
            'radius': 30000.0,
          },
        },
    };

    try {
      final response = await _client
          .post(
            Uri.https(_host, '/v1/places:autocomplete'),
            headers: {
              'Content-Type': 'application/json',
              'X-Goog-Api-Key': _apiKey,
            },
            body: jsonEncode(body),
          )
          .timeout(_timeout);
      if (response.statusCode != 200) return const [];

      final data = jsonDecode(utf8.decode(response.bodyBytes))
          as Map<String, dynamic>;
      final suggestions = data['suggestions'] as List? ?? const [];

      return suggestions
          .map((s) => (s as Map<String, dynamic>)['placePrediction'])
          .whereType<Map<String, dynamic>>()
          .map(PlacePrediction.fromJson)
          .where((p) => p.placeId.isNotEmpty && p.description.isNotEmpty)
          .take(5)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<PlaceCoordinates?> getPlaceCoordinates(
    String placeId, {
    String? sessionToken,
  }) async {
    if (placeId.isEmpty || _apiKey.isEmpty) return null;

    try {
      final response = await _client
          .get(
            Uri.https(_host, '/v1/places/$placeId', {
              'sessionToken': ?sessionToken,
            }),
            headers: {
              'X-Goog-Api-Key': _apiKey,
              // Ask only for the location: smaller response, cheaper SKU.
              'X-Goog-FieldMask': 'location',
            },
          )
          .timeout(_timeout);
      if (response.statusCode != 200) return null;

      final data = jsonDecode(utf8.decode(response.bodyBytes))
          as Map<String, dynamic>;
      final location = data['location'];
      if (location is! Map) return null;

      return PlaceCoordinates(
        (location['latitude'] as num).toDouble(),
        (location['longitude'] as num).toDouble(),
      );
    } catch (_) {
      return null;
    }
  }

  void dispose() => _client.close();
}