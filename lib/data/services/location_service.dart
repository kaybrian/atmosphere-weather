import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../models/location_model.dart';

class LocationService {
  final http.Client _client;

  LocationService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches the user's current location via GPS if permitted,
  /// or falls back cleanly to IP-based geolocation.
  Future<LocationModel> getCurrentLocation() async {
    try {
      final gpsLocation = await _tryGetGpsLocation();
      if (gpsLocation != null) {
        return gpsLocation;
      }
    } catch (e) {
      debugPrint(
        'GPS location attempt failed: $e. Falling back to IP location.',
      );
    }

    try {
      final ipLocation = await _getIpLocation();
      if (ipLocation != null) {
        return ipLocation;
      }
    } catch (e) {
      debugPrint('IP location attempt failed: $e. Using default city.');
    }

    // Final fallback: London
    return const LocationModel(
      name: 'London',
      adminArea: 'England',
      country: 'United Kingdom',
      countryCode: 'GB',
      latitude: 51.5074,
      longitude: -0.1278,
      isCurrentLocation: true,
    );
  }

  Future<LocationModel?> _tryGetGpsLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 8),
      ),
    );

    // Attempt reverse geocode to get city name
    final resolvedName = await _reverseGeocode(
      position.latitude,
      position.longitude,
    );

    return LocationModel(
      name: resolvedName?.name ?? 'My Location',
      adminArea: resolvedName?.adminArea,
      country: resolvedName?.country ?? '',
      countryCode: resolvedName?.countryCode,
      latitude: position.latitude,
      longitude: position.longitude,
      isCurrentLocation: true,
    );
  }

  Future<LocationModel?> _reverseGeocode(double lat, double lon) async {
    try {
      final uri = Uri.parse(
        'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$lat&longitude=$lon&localityLanguage=en',
      );
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 6));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final city =
            data['city'] as String? ??
            data['locality'] as String? ??
            data['principalSubdivision'] as String? ??
            'Current Location';
        final admin = data['principalSubdivision'] as String?;
        final country = data['countryName'] as String? ?? '';
        final countryCode = data['countryCode'] as String?;

        return LocationModel(
          name: city,
          adminArea: admin,
          country: country,
          countryCode: countryCode,
          latitude: lat,
          longitude: lon,
          isCurrentLocation: true,
        );
      }
    } catch (_) {}
    return null;
  }

  Future<LocationModel?> _getIpLocation() async {
    // Try ipapi.co
    try {
      final uri = Uri.parse('https://ipapi.co/json/');
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 6));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['latitude'] != null && data['longitude'] != null) {
          return LocationModel(
            name: data['city'] as String? ?? 'Local Area',
            adminArea: data['region'] as String?,
            country: data['country_name'] as String? ?? '',
            countryCode: data['country_code'] as String?,
            latitude: (data['latitude'] as num).toDouble(),
            longitude: (data['longitude'] as num).toDouble(),
            isCurrentLocation: true,
          );
        }
      }
    } catch (_) {}

    // Fallback IP provider: freeipapi.com
    try {
      final uri = Uri.parse('https://freeipapi.com/api/json');
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 6));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['latitude'] != null && data['longitude'] != null) {
          return LocationModel(
            name: data['cityName'] as String? ?? 'Local Area',
            adminArea: data['regionName'] as String?,
            country: data['countryName'] as String? ?? '',
            countryCode: data['countryCode'] as String?,
            latitude: (data['latitude'] as num).toDouble(),
            longitude: (data['longitude'] as num).toDouble(),
            isCurrentLocation: true,
          );
        }
      }
    } catch (_) {}

    return null;
  }
}
