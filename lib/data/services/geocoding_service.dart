import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location_model.dart';

class GeocodingService {
  final http.Client _client;

  GeocodingService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://geocoding-api.open-meteo.com/v1/search';

  Future<List<LocationModel>> searchLocations(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'name': trimmed,
      'count': '10',
      'language': 'en',
      'format': 'json',
    });

    try {
      final response = await _client.get(
        uri,
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>?;
        if (results == null) return [];

        return results.map((item) {
          final map = item as Map<String, dynamic>;
          return LocationModel(
            name: map['name'] as String? ?? 'Unknown',
            adminArea: map['admin1'] as String?,
            country: map['country'] as String? ?? '',
            countryCode: map['country_code'] as String?,
            latitude: (map['latitude'] as num).toDouble(),
            longitude: (map['longitude'] as num).toDouble(),
            isCurrentLocation: false,
          );
        }).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static List<LocationModel> getPopularCities() {
    return const [
      LocationModel(
        name: 'London',
        adminArea: 'England',
        country: 'United Kingdom',
        countryCode: 'GB',
        latitude: 51.5074,
        longitude: -0.1278,
      ),
      LocationModel(
        name: 'New York',
        adminArea: 'New York',
        country: 'United States',
        countryCode: 'US',
        latitude: 40.7128,
        longitude: -74.0060,
      ),
      LocationModel(
        name: 'Tokyo',
        adminArea: 'Tokyo',
        country: 'Japan',
        countryCode: 'JP',
        latitude: 35.6762,
        longitude: 139.6503,
      ),
      LocationModel(
        name: 'Paris',
        adminArea: 'Île-de-France',
        country: 'France',
        countryCode: 'FR',
        latitude: 48.8566,
        longitude: 2.3522,
      ),
      LocationModel(
        name: 'Nairobi',
        adminArea: 'Nairobi',
        country: 'Kenya',
        countryCode: 'KE',
        latitude: -1.2921,
        longitude: 36.8219,
      ),
      LocationModel(
        name: 'Dubai',
        adminArea: 'Dubai',
        country: 'United Arab Emirates',
        countryCode: 'AE',
        latitude: 25.2048,
        longitude: 55.2708,
      ),
      LocationModel(
        name: 'Sydney',
        adminArea: 'New South Wales',
        country: 'Australia',
        countryCode: 'AU',
        latitude: -33.8688,
        longitude: 151.2093,
      ),
      LocationModel(
        name: 'San Francisco',
        adminArea: 'California',
        country: 'United States',
        countryCode: 'US',
        latitude: 37.7749,
        longitude: -122.4194,
      ),
    ];
  }
}
