import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

abstract class LocationService {
  Future<bool> isLocationServiceEnabled();
  Future<LocationPermission> checkPermission();
  Future<LocationPermission> requestPermission();
  Future<Position> getCurrentPosition();
  Future<Position?> getLastKnownPosition();
  Future<String?> getGovernorate(double lat, double lng);
}

class LocationServiceImpl implements LocationService {
  @override
  Future<bool> isLocationServiceEnabled() =>
      Geolocator.isLocationServiceEnabled();

  @override
  Future<LocationPermission> checkPermission() => Geolocator.checkPermission();

  @override
  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();

  @override
  Future<Position> getCurrentPosition() => Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.medium,
      timeLimit: Duration(seconds: 10),
    ),
  );

  @override
  Future<Position?> getLastKnownPosition() => Geolocator.getLastKnownPosition();

  @override
  Future<String?> getGovernorate(double lat, double lng) async {
    try {
      await setLocaleIdentifier('ar_EG');
      final placeMarks = await placemarkFromCoordinates(lat, lng);
      return placeMarks.first.administrativeArea;
    } catch (_) {
      return null; // never blocks — report saves without it
    }
  }
}
