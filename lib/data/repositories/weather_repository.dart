import '../models/air_quality_model.dart';
import '../models/location_model.dart';
import '../models/weather_model.dart';
import '../services/geocoding_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../services/weather_api_service.dart';

class WeatherRepository {
  final WeatherApiService _apiService;
  final LocationService _locationService;
  final GeocodingService _geocodingService;
  final StorageService _storageService;

  WeatherRepository({
    WeatherApiService? apiService,
    LocationService? locationService,
    GeocodingService? geocodingService,
    StorageService? storageService,
  })  : _apiService = apiService ?? WeatherApiService(),
        _locationService = locationService ?? LocationService(),
        _geocodingService = geocodingService ?? GeocodingService(),
        _storageService = storageService ?? StorageService();

  Future<LocationModel> getCurrentLocation() async {
    return _locationService.getCurrentLocation();
  }

  Future<WeatherData> getWeather(double latitude, double longitude) async {
    return _apiService.fetchWeather(latitude: latitude, longitude: longitude);
  }

  Future<AirQualityData> getAirQuality(double latitude, double longitude) async {
    return _apiService.fetchAirQuality(latitude: latitude, longitude: longitude);
  }

  Future<List<LocationModel>> searchCities(String query) async {
    return _geocodingService.searchLocations(query);
  }

  List<LocationModel> getPopularCities() {
    return GeocodingService.getPopularCities();
  }

  Future<List<LocationModel>> getFavorites() async {
    return _storageService.loadFavorites();
  }

  Future<void> saveFavorites(List<LocationModel> favorites) async {
    await _storageService.saveFavorites(favorites);
  }

  Future<void> saveLastLocation(LocationModel location) async {
    await _storageService.saveLastLocation(location);
  }

  Future<LocationModel?> getLastLocation() async {
    return _storageService.loadLastLocation();
  }

  Future<bool> getUseFahrenheit() async {
    return _storageService.loadUseFahrenheit();
  }

  Future<void> setUseFahrenheit(bool useFahrenheit) async {
    await _storageService.saveUseFahrenheit(useFahrenheit);
  }

  Future<bool> getParticlesEnabled() async {
    return _storageService.loadParticlesEnabled();
  }

  Future<void> setParticlesEnabled(bool enabled) async {
    await _storageService.saveParticlesEnabled(enabled);
  }

  Future<String> getWindUnit() async {
    return _storageService.loadWindUnit();
  }

  Future<void> setWindUnit(String unit) async {
    await _storageService.saveWindUnit(unit);
  }
}
