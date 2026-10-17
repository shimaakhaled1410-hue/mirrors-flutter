import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mirrors_app/data/services/google_places_service.dart';

/// Autocomplete logic: debounce, stale-response protection and the billing
/// session. The UI only listens to the three notifiers.
class PlaceSearchController {
  PlaceSearchController({
    required this.bias,
    required this.languageCode,
    GooglePlacesService? places,
  }) : _places = places ?? GooglePlacesService();

  /// Where the user is looking right now; results near it rank higher.
  final ValueGetter<({double lat, double lng})> bias;
  final ValueGetter<String> languageCode;
  final GooglePlacesService _places;

  final ValueNotifier<List<PlacePrediction>> predictions =
      ValueNotifier<List<PlacePrediction>>(const []);
  final ValueNotifier<bool> searching = ValueNotifier<bool>(false);
  final ValueNotifier<bool> noResults = ValueNotifier<bool>(false);

  static const int _minChars = 3;

  Timer? _debounce;
  int _requestId = 0;
  String _sessionToken = GooglePlacesService.newSessionToken();

  /// Call on every keystroke.
  void onChanged(String text) {
    _debounce?.cancel();
    final query = text.trim();

    if (query.length < _minChars) {
      clearResults();
      return;
    }
    _debounce = Timer(
      const Duration(milliseconds: 350),
      () => _search(query),
    );
  }

  /// Search right away (keyboard "search" key).
  void submit(String text) {
    _debounce?.cancel();
    final query = text.trim();
    if (query.length >= _minChars) _search(query);
  }

  /// Hide suggestions and ignore any request still in flight.
  void clearResults() {
    _debounce?.cancel();
    _requestId++;
    searching.value = false;
    noResults.value = false;
    if (predictions.value.isNotEmpty) predictions.value = const [];
  }

  Future<void> _search(String query) async {
    final id = ++_requestId;
    searching.value = true;
    noResults.value = false;

    final center = bias();
    final results = await _places.getAutocompletePredictions(
      query,
      sessionToken: _sessionToken,
      biasLat: center.lat,
      biasLng: center.lng,
      languageCode: languageCode(),
    );

    if (id != _requestId) return; // a newer search (or a clear) replaced this
    predictions.value = results;
    noResults.value = results.isEmpty;
    searching.value = false;
  }

  /// The user picked a suggestion: fetch its coordinates.
  Future<PlaceCoordinates?> select(PlacePrediction prediction) async {
    clearResults();
    final coordinates = await _places.getPlaceCoordinates(
      prediction.placeId,
      sessionToken: _sessionToken,
    );
    // The details call closes the billing session; start a new one.
    _sessionToken = GooglePlacesService.newSessionToken();
    return coordinates;
  }

  void dispose() {
    _debounce?.cancel();
    _places.dispose();
    predictions.dispose();
    searching.dispose();
    noResults.dispose();
  }
}