import 'package:flutter/foundation.dart';
import '../../data/models/air_quality_model.dart';
import '../../data/models/location_model.dart';
import '../../data/models/weather_alert_model.dart';
import '../../data/models/weather_model.dart';
import '../../data/repositories/weather_repository.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherRepository _repository;

  WeatherViewModel({WeatherRepository? repository})
      : _repository = repository ?? WeatherRepository();

  WeatherData? _weatherData;
  WeatherData? get weatherData => _weatherData;

  AirQualityData? _airQuality;
  AirQualityData? get airQuality => _airQuality;

  List<WeatherAlertModel> _activeAlerts = [];
  List<WeatherAlertModel> get activeAlerts => _activeAlerts;

  LocationModel? _currentLocation;
  LocationModel? get currentLocation => _currentLocation;

  LocationModel? _selectedLocation;
  LocationModel? get selectedLocation => _selectedLocation;

  List<LocationModel> _favoriteLocations = [];
  List<LocationModel> get favoriteLocations => _favoriteLocations;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isRefreshing = false;
  bool get isRefreshing => _isRefreshing;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _useFahrenheit = false;
  bool get useFahrenheit => _useFahrenheit;

  bool _particlesEnabled = true;
  bool get particlesEnabled => _particlesEnabled;

  String _windUnit = 'kmh'; // 'kmh', 'mph', 'ms'
  String get windUnit => _windUnit;

  List<LocationModel> _searchResults = [];
  List<LocationModel> get searchResults => _searchResults;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  WeatherThemeType get activeThemeType {
    if (_weatherData == null) {
      final hour = DateTime.now().hour;
      final isNight = hour < 6 || hour > 19;
      return isNight ? WeatherThemeType.clearNight : WeatherThemeType.clearDay;
    }
    return _weatherData!.current.condition.themeType;
  }

  bool get isCurrentSelected {
    return _selectedLocation?.isCurrentLocation == true ||
        (_currentLocation != null && _selectedLocation == _currentLocation);
  }

  bool isLocationFavorite(LocationModel location) {
    return _favoriteLocations.any((loc) =>
        (loc.latitude - location.latitude).abs() < 0.05 &&
        (loc.longitude - location.longitude).abs() < 0.05);
  }

  Future<void> init() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _useFahrenheit = await _repository.getUseFahrenheit();
      _particlesEnabled = await _repository.getParticlesEnabled();
      _windUnit = await _repository.getWindUnit();
      _favoriteLocations = await _repository.getFavorites();

      // Seed with London & Tokyo if favorites is empty
      if (_favoriteLocations.isEmpty) {
        final popular = _repository.getPopularCities();
        if (popular.length >= 2) {
          _favoriteLocations = [popular[0], popular[2]];
          await _repository.saveFavorites(_favoriteLocations);
        }
      }

      // 1. Detect live GPS/IP location
      try {
        _currentLocation = await _repository.getCurrentLocation();
      } catch (e) {
        debugPrint('Failed to get current location: $e');
      }

      final savedLast = await _repository.getLastLocation();
      _selectedLocation = savedLast ?? _currentLocation ?? _repository.getPopularCities().first;

      await _fetchWeatherAndAqiForSelected();
    } catch (e) {
      _errorMessage = 'Unable to load weather data. Please check your internet connection.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectLocation(LocationModel location) async {
    _selectedLocation = location;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await _repository.saveLastLocation(location);
    await _fetchWeatherAndAqiForSelected();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> switchToCurrentLocation() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentLocation = await _repository.getCurrentLocation();
      _selectedLocation = _currentLocation;
      if (_selectedLocation != null) {
        await _repository.saveLastLocation(_selectedLocation!);
      }
      await _fetchWeatherAndAqiForSelected();
    } catch (e) {
      _errorMessage = 'Could not access your location. Please check permissions or network.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshWeather() async {
    if (_selectedLocation == null) return;
    _isRefreshing = true;
    notifyListeners();

    await _fetchWeatherAndAqiForSelected();

    _isRefreshing = false;
    notifyListeners();
  }

  Future<void> _fetchWeatherAndAqiForSelected() async {
    if (_selectedLocation == null) return;
    final lat = _selectedLocation!.latitude;
    final lon = _selectedLocation!.longitude;

    try {
      // Concurrently fetch Weather and Air Quality
      final weatherFuture = _repository.getWeather(lat, lon);
      final aqiFuture = _repository.getAirQuality(lat, lon);

      final results = await Future.wait([weatherFuture, aqiFuture]);
      _weatherData = results[0] as WeatherData;
      _airQuality = results[1] as AirQualityData;

      // Evaluate active alerts
      _activeAlerts = WeatherAlertModel.evaluateAlerts(
        current: _weatherData!.current,
        airQuality: _airQuality,
      );

      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to update weather: $e';
    }
  }

  Future<void> toggleUnit() async {
    _useFahrenheit = !_useFahrenheit;
    await _repository.setUseFahrenheit(_useFahrenheit);
    notifyListeners();
  }

  Future<void> setParticlesEnabled(bool enabled) async {
    _particlesEnabled = enabled;
    await _repository.setParticlesEnabled(enabled);
    notifyListeners();
  }

  Future<void> setWindUnit(String unit) async {
    _windUnit = unit;
    await _repository.setWindUnit(unit);
    notifyListeners();
  }

  Future<void> toggleFavorite(LocationModel location) async {
    final existingIndex = _favoriteLocations.indexWhere((loc) =>
        (loc.latitude - location.latitude).abs() < 0.05 &&
        (loc.longitude - location.longitude).abs() < 0.05);

    if (existingIndex >= 0) {
      _favoriteLocations.removeAt(existingIndex);
    } else {
      _favoriteLocations.add(location.copyWith(isCurrentLocation: false));
    }
    await _repository.saveFavorites(_favoriteLocations);
    notifyListeners();
  }

  Future<void> searchCities(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _isSearching = false;
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    try {
      _searchResults = await _repository.searchCities(query);
    } catch (e) {
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchResults = [];
    _isSearching = false;
    notifyListeners();
  }
}
