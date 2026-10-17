import 'package:geocoding/geocoding.dart' as geo;

/// Coordinates -> readable address.
class ReverseGeocodingService {
  // Created lazily: creating it throws on platforms without geocoding (web).
  late final geo.Geocoding? _geocoder = _create();

  geo.Geocoding? _create() {
    try {
      return geo.Geocoding();
    } catch (_) {
      return null;
    }
  }

  /// The address, or null when it can't be determined (offline, unsupported).
  Future<String?> addressFor(double latitude, double longitude) async {
    final geocoder = _geocoder;
    if (geocoder == null) return null;

    try {
      final placemarks = await geocoder
          .placemarkFromCoordinates(latitude, longitude)
          .timeout(const Duration(seconds: 8));
      return _format(placemarks);
    } catch (_) {
      return null;
    }
  }

  String? _format(List<geo.Placemark> placemarks) {
    if (placemarks.isEmpty) return null;
    final p = placemarks.first;
    final parts = <String?>[
      p.street,
      p.subLocality,
      p.locality,
      p.administrativeArea,
    ]
        .whereType<String>()
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
    return parts.isEmpty ? null : parts.join(', ');
  }
}