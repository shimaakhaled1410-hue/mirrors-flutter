import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' show Geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mirrors_app/core/utils/app_colors.dart';
import 'package:mirrors_app/data/services/device_location_service.dart';
import 'package:mirrors_app/data/services/google_places_service.dart'
    show PlacePrediction;
import 'package:mirrors_app/data/services/reverse_geocoding_service.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import 'package:mirrors_app/presentation/widgets/location_picker/map_control_button.dart';
import 'package:mirrors_app/presentation/widgets/location_picker/picker_address_card.dart';
import 'package:mirrors_app/presentation/widgets/location_picker/picker_center_pin.dart';
import 'package:mirrors_app/presentation/widgets/location_picker/place_search_controller.dart';
import 'package:mirrors_app/presentation/widgets/location_picker/picker_predictions_list.dart';
import 'package:mirrors_app/presentation/widgets/location_picker/picker_search_bar.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  static Future<String?> open(BuildContext context) {
    return Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const LocationPickerScreen()),
    );
  }

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  static const LatLng _fallbackCenter = LatLng(30.0444, 31.2357); // Cairo
  static const double _addressRefreshMeters = 15;

  final ReverseGeocodingService _geocoding = ReverseGeocodingService();
  final DeviceLocationService _location = const DeviceLocationService();

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  GoogleMapController? _map;
  LatLng? _initialTarget;
  LatLng _center = _fallbackCenter;
  LatLng? _lastGeocoded;

  MapType _mapType = MapType.normal;
  bool _myLocationEnabled = false;

  final ValueNotifier<String?> _address = ValueNotifier<String?>(null);
  final ValueNotifier<bool> _busy = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _locating = ValueNotifier<bool>(false);

  late final PlaceSearchController _search = PlaceSearchController(
    bias: () => (lat: _center.latitude, lng: _center.longitude),
    languageCode: () => Localizations.localeOf(context).languageCode,
  );

  Timer? _geocodeDebounce;
  int _geocodeId = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialTarget();
  }

  @override
  void dispose() {
    _geocodeDebounce?.cancel();
    _map?.dispose();
    _search.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
    _address.dispose();
    _busy.dispose();
    _locating.dispose();
    super.dispose();
  }

  Future<void> _loadInitialTarget() async {
    final last = await _location.lastKnownIfPermitted();
    if (!mounted) return;
    final target = last != null
        ? LatLng(last.latitude, last.longitude)
        : _fallbackCenter;
    _center = target;
    setState(() => _initialTarget = target);
  }

  void _onMapCreated(GoogleMapController controller) {
    _map = controller;
    _scheduleGeocode(_center);
  }

  void _onCameraMoveStarted() {
    _geocodeDebounce?.cancel();
    _search.clearResults();
    if (_searchFocus.hasFocus) _searchFocus.unfocus();
    _busy.value = true;
  }

  void _onCameraMove(CameraPosition position) => _center = position.target;

  void _onCameraIdle() => _scheduleGeocode(_center);

  void _scheduleGeocode(LatLng target) {
    _geocodeDebounce?.cancel();
    _geocodeDebounce = Timer(
      const Duration(milliseconds: 400),
      () => _resolveAddress(target),
    );
  }

  Future<void> _resolveAddress(LatLng target) async {
    final last = _lastGeocoded;
    if (last != null &&
        Geolocator.distanceBetween(
              last.latitude,
              last.longitude,
              target.latitude,
              target.longitude,
            ) <
            _addressRefreshMeters) {
      _busy.value = false;
      return;
    }

    final id = ++_geocodeId;
    _busy.value = true;

    final text = await _geocoding.addressFor(target.latitude, target.longitude);

    if (!mounted || id != _geocodeId) return;
    _lastGeocoded = target;
    _address.value = text ?? _coordinatesText(target);
    _busy.value = false;
  }

  String _coordinatesText(LatLng p) =>
      '${p.latitude.toStringAsFixed(6)}, ${p.longitude.toStringAsFixed(6)}';

  Future<void> _onPredictionTap(PlacePrediction prediction) async {
    _searchFocus.unfocus();
    _searchController.text = prediction.description;
    _busy.value = true;

    final coordinates = await _search.select(prediction);
    if (!mounted) return;

    if (coordinates == null) {
      _busy.value = false;
      _toast(AppLocalizations.of(context)!.unableToDetermineLocation);
      return;
    }

    final target = LatLng(coordinates.lat, coordinates.lng);

    _lastGeocoded = target;
    _address.value = prediction.description;
    _center = target;
    await _map?.animateCamera(CameraUpdate.newLatLngZoom(target, 17));
    if (mounted) _busy.value = false;
  }

  void _clearSearch() {
    _searchController.clear();
    _search.onChanged('');
  }

  Future<void> _goToMyLocation() async {
    if (_locating.value) return;
    final l10n = AppLocalizations.of(context)!;
    _locating.value = true;

    try {
      final position = await _location.currentPosition();
      if (!mounted) return;

      if (!_myLocationEnabled) setState(() => _myLocationEnabled = true);
      await _map?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          17,
        ),
      );
    } on DeviceLocationException catch (e) {
      _toast(switch (e.failure) {
        DeviceLocationFailure.serviceDisabled => l10n.gpsDisabledError,
        DeviceLocationFailure.denied => l10n.permissionDeniedError,
        DeviceLocationFailure.deniedForever =>
          l10n.permissionPermanentlyDeniedError,
        DeviceLocationFailure.unavailable => l10n.unableToDetermineLocation,
      });
    } catch (_) {
      _toast(l10n.unableToDetermineLocation);
    } finally {
      if (mounted) _locating.value = false;
    }
  }

  void _toggleMapType() {
    setState(() {
      _mapType = _mapType == MapType.normal ? MapType.hybrid : MapType.normal;
    });
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final padding = MediaQuery.paddingOf(context);
    final target = _initialTarget;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: target == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: target,
                    zoom: 16,
                  ),
                  mapType: _mapType,
                  onMapCreated: _onMapCreated,
                  onCameraMoveStarted: _onCameraMoveStarted,
                  onCameraMove: _onCameraMove,
                  onCameraIdle: _onCameraIdle,
                  myLocationEnabled: _myLocationEnabled,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  compassEnabled: false,
                  rotateGesturesEnabled: false,
                  tiltGesturesEnabled: false,
                  trafficEnabled: false,
                  buildingsEnabled: false,
                  indoorViewEnabled: false,
                  minMaxZoomPreference: const MinMaxZoomPreference(4, 19),
                ),

                PickerCenterPin(busy: _busy),

                PositionedDirectional(
                  end: 12,
                  top: padding.top + 72,
                  child: Column(
                    children: [
                      MapControlButton(
                        icon: Icons.layers_outlined,
                        tooltip: l10n.mapTypeTooltip,
                        surface: surface,
                        onPressed: _toggleMapType,
                      ),
                      const SizedBox(height: 10),
                      ValueListenableBuilder<bool>(
                        valueListenable: _locating,
                        builder: (context, locating, _) => MapControlButton(
                          icon: Icons.my_location_rounded,
                          tooltip: l10n.myLocationTooltip,
                          surface: surface,
                          loading: locating,
                          onPressed: _goToMyLocation,
                        ),
                      ),
                    ],
                  ),
                ),

                PositionedDirectional(
                  start: 16,
                  end: 16,
                  bottom: 16 + padding.bottom,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: PickerAddressCard(
                          busy: _busy,
                          address: _address,
                          surface: surface,
                          onConfirm: (address) =>
                              Navigator.of(context).pop(address),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        children: [
                          MapControlButton(
                            icon: Icons.add,
                            surface: surface,
                            onPressed: () =>
                                _map?.animateCamera(CameraUpdate.zoomIn()),
                          ),
                          const SizedBox(height: 10),
                          MapControlButton(
                            icon: Icons.remove,
                            surface: surface,
                            onPressed: () =>
                                _map?.animateCamera(CameraUpdate.zoomOut()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: Column(
                      children: [
                        PickerSearchBar(
                          controller: _searchController,
                          focusNode: _searchFocus,
                          searching: _search.searching,
                          surface: surface,
                          onChanged: _search.onChanged,
                          onSubmitted: _search.submit,
                          onClear: _clearSearch,
                        ),
                        PickerPredictionsList(
                          predictions: _search.predictions,
                          noResults: _search.noResults,
                          surface: surface,
                          onSelected: _onPredictionTap,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
