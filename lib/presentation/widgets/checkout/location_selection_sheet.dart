import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:mirrors_app/core/utils/app_colors.dart';
import 'package:mirrors_app/core/utils/app_styles.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';

enum LocationSelectionResultType { address, openMap }

class LocationSelectionSheet extends StatefulWidget {
  final bool showMapOption;

  const LocationSelectionSheet({super.key, this.showMapOption = false});

  static Future<dynamic> show(
    BuildContext context, {
    bool showMapOption = false,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LocationSelectionSheet(showMapOption: showMapOption),
    );
  }

  @override
  State<LocationSelectionSheet> createState() => _LocationSelectionSheetState();
}

class _LocationSelectionSheetState extends State<LocationSelectionSheet> {
  bool _isLoadingCurrentLocation = false;

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleCurrentLocation(AppLocalizations l10n) async {
    setState(() => _isLoadingCurrentLocation = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showMessage(l10n.gpsDisabledError);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showMessage(l10n.permissionDeniedError);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showMessage(l10n.permissionPermanentlyDeniedError);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final geocoding = geo.Geocoding();
      final placemarks = await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      if (placemarks.isEmpty) {
        _showMessage(l10n.unableToDetermineLocation);
        return;
      }

      final p = placemarks.first;
      final addressParts =
          <String?>[p.street, p.subLocality, p.locality, p.administrativeArea]
              .whereType<String>()
              .where((String e) => e.trim().isNotEmpty)
              .toSet()
              .toList();

      Navigator.pop(context, addressParts.join(', '));
    } catch (_) {
      _showMessage(l10n.unableToDetermineLocation);
    } finally {
      if (mounted) {
        setState(() => _isLoadingCurrentLocation = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final secondaryText = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on_rounded,
                size: 38,
                color: scheme.primary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              l10n.deliveryLocationTitle,
              textAlign: TextAlign.center,
              style: AppStyles.bold18(context),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.deliveryLocationSubtitle,
              textAlign: TextAlign.center,
              style: AppStyles.regular14(
                context,
              ).copyWith(color: secondaryText, height: 1.4),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: scheme.primary.withValues(
                    alpha: 0.6,
                  ),
                  disabledForegroundColor: Colors.white70,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: _isLoadingCurrentLocation
                    ? null
                    : () => _handleCurrentLocation(l10n),
                icon: _isLoadingCurrentLocation
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.my_location_rounded, size: 20),
                label: Text(
                  _isLoadingCurrentLocation
                      ? l10n.locatingCurrentPosition
                      : l10n.useCurrentLocation,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            if (widget.showMapOption) ...[
              // Secondary action: pick on the map (tonal).
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.primary.withValues(alpha: 0.12),
                    foregroundColor: scheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isLoadingCurrentLocation
                      ? null
                      : () => Navigator.pop(
                          context,
                          LocationSelectionResultType.openMap,
                        ),
                  icon: const Icon(Icons.map_outlined, size: 20),
                  label: Text(
                    l10n.setFromMap,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

          
          ],
        ),
      ),
    );
  }
}
