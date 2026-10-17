import 'package:geolocator/geolocator.dart';

enum DeviceLocationFailure { serviceDisabled, denied, deniedForever, unavailable }

class DeviceLocationException implements Exception {
  final DeviceLocationFailure failure;
  const DeviceLocationException(this.failure);
}

class DeviceLocationService {
  const DeviceLocationService();

    Future<Position?> lastKnownIfPermitted() async {
    try {
      final permission = await Geolocator.checkPermission();
      final granted = permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
      if (!granted) return null;
      return await Geolocator.getLastKnownPosition();
    } catch (_) {
      return null;
    }
  }

  /// Throws [DeviceLocationException] with the reason on failure.
  Future<Position> currentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const DeviceLocationException(DeviceLocationFailure.serviceDisabled);
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const DeviceLocationException(DeviceLocationFailure.denied);
    }
    if (permission == LocationPermission.deniedForever) {
      throw const DeviceLocationException(DeviceLocationFailure.deniedForever);
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 12),
        ),
      );
    } catch (_) {
      throw const DeviceLocationException(DeviceLocationFailure.unavailable);
    }
  }
}