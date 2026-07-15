import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import '../../widgets/location_permission_dialog.dart';
import '../../widgets/location_service_off_dialog.dart';
import 'location_service.dart';

class LocationHelper {
  final LocationService _locationService;

  Position? _cachedPosition;
  DateTime? _lastFetchTime;

  static const _cacheDuration = Duration(minutes: 5);

  LocationHelper({required LocationService locationService})
    : _locationService = locationService;

  bool get _isCacheValid =>
      _cachedPosition != null &&
      _lastFetchTime != null &&
      DateTime.now().difference(_lastFetchTime!) < _cacheDuration;

  Future<Position?> getLocationWithPermission(BuildContext context) async {
    // ── Check service FIRST before cache ──────────────────────────────────
    final serviceEnabled = await _locationService.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _cachedPosition = null;
      _lastFetchTime = null;
      if (context.mounted) await LocationServiceOffDialog.show(context);
      return null;
    }

    // ── Return cache only if service is on ────────────────────────────────
    if (_isCacheValid) return _cachedPosition;

    // ── Check permission ───────────────────────────────────────────────────
    LocationPermission permission = await _locationService.checkPermission();
    if (!context.mounted) return null;

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return _getPosition(context);
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return null;
    }

    if (!context.mounted) return null;
    final userAccepted = await LocationPermissionDialog.show(context);
    if (!userAccepted) return null;

    permission = await _locationService.requestPermission();
    if (!context.mounted) return null;

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    return _getPosition(context);
  }

  Future<Position?> _getPosition(BuildContext context) async {
    // ── Get position ───────────────────────────────────────────────────────
    try {
      // last known position — instant response
      final lastKnown = await _locationService.getLastKnownPosition();
      if (lastKnown != null) {
        _cachedPosition = lastKnown;
        _lastFetchTime = DateTime.now();
        _refreshPositionInBackground();
        return _cachedPosition;
      }

      // no last known — fetch fresh
      final position = await _locationService.getCurrentPosition();
      _cachedPosition = position;
      _lastFetchTime = DateTime.now();
      return _cachedPosition;
    } catch (_) {
      return null;
    }
  }

  void _refreshPositionInBackground() {
    _locationService
        .getCurrentPosition()
        .then((position) {
          _cachedPosition = position;
          _lastFetchTime = DateTime.now();
        })
        .catchError((_) {});
  }

  Future<bool> hasLocationAccess() async {
    final serviceEnabled = await _locationService.isLocationServiceEnabled();
    if (!serviceEnabled) return false;
    final permission = await _locationService.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }
}
