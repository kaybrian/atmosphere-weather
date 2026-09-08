import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_model.dart';

class StorageService {
  static const String _keyFavorites = 'weather_favorites';
  static const String _keyLastLocation = 'weather_last_location';
  static const String _keyUseFahrenheit = 'weather_use_fahrenheit';
  static const String _keyParticlesEnabled = 'weather_particles_enabled';
  static const String _keyWindUnit = 'weather_wind_unit';

  Future<void> saveFavorites(List<LocationModel> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = favorites.map((loc) => jsonEncode(loc.toJson())).toList();
    await prefs.setStringList(_keyFavorites, jsonList);
  }

  Future<List<LocationModel>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_keyFavorites);
    if (jsonList == null || jsonList.isEmpty) {
      return [];
    }
    try {
      return jsonList
          .map((str) => LocationModel.fromJson(jsonDecode(str) as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveLastLocation(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastLocation, jsonEncode(location.toJson()));
  }

  Future<LocationModel?> loadLastLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyLastLocation);
    if (jsonStr == null) return null;
    try {
      return LocationModel.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveUseFahrenheit(bool useFahrenheit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyUseFahrenheit, useFahrenheit);
  }

  Future<bool> loadUseFahrenheit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyUseFahrenheit) ?? false;
  }

  Future<void> saveParticlesEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyParticlesEnabled, enabled);
  }

  Future<bool> loadParticlesEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyParticlesEnabled) ?? true;
  }

  Future<void> saveWindUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyWindUnit, unit);
  }

  Future<String> loadWindUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyWindUnit) ?? 'kmh';
  }
}
