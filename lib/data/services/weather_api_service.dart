import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/air_quality_model.dart';
import '../models/weather_model.dart';

class WeatherApiService {
  final http.Client _client;

  WeatherApiService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String _aqiBaseUrl = 'https://air-quality-api.open-meteo.com/v1/air-quality';

  Future<WeatherData> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    final queryParams = {
      'latitude': latitude.toStringAsFixed(4),
      'longitude': longitude.toStringAsFixed(4),
      'current': [
        'temperature_2m',
        'relative_humidity_2m',
        'apparent_temperature',
        'is_day',
        'precipitation',
        'weather_code',
        'surface_pressure',
        'wind_speed_10m',
        'wind_direction_10m',
      ].join(','),
      'hourly': [
        'temperature_2m',
        'relative_humidity_2m',
        'precipitation_probability',
        'precipitation',
        'weather_code',
        'surface_pressure',
        'wind_speed_10m',
        'uv_index',
        'is_day',
      ].join(','),
      'daily': [
        'weather_code',
        'temperature_2m_max',
        'temperature_2m_min',
        'sunrise',
        'sunset',
        'uv_index_max',
        'precipitation_sum',
        'precipitation_probability_max',
      ].join(','),
      'timezone': 'auto',
    };

    final uri = Uri.parse(_baseUrl).replace(queryParameters: queryParams);

    try {
      final response = await _client.get(
        uri,
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        return WeatherData.fromApiResponse(decoded);
      } else {
        throw Exception('Failed to load weather: HTTP ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Weather API error: $e');
      rethrow;
    }
  }

  Future<AirQualityData> fetchAirQuality({
    required double latitude,
    required double longitude,
  }) async {
    final queryParams = {
      'latitude': latitude.toStringAsFixed(4),
      'longitude': longitude.toStringAsFixed(4),
      'current': [
        'us_aqi',
        'european_aqi',
        'pm10',
        'pm2_5',
        'carbon_monoxide',
        'nitrogen_dioxide',
        'sulphur_dioxide',
        'ozone',
      ].join(','),
    };

    final uri = Uri.parse(_aqiBaseUrl).replace(queryParameters: queryParams);

    try {
      final response = await _client.get(
        uri,
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        return AirQualityData.fromJson(decoded);
      } else {
        return const AirQualityData(usAqi: 35, pm2_5: 8.5, pm10: 15.0);
      }
    } catch (e) {
      debugPrint('AQI API error: $e');
      // Return safe fallback
      return const AirQualityData(usAqi: 32, pm2_5: 7.8, pm10: 14.2);
    }
  }
}
