import 'package:flutter_test/flutter_test.dart';
import 'package:todoapp/data/models/air_quality_model.dart';
import 'package:todoapp/data/models/weather_alert_model.dart';
import 'package:todoapp/data/models/weather_model.dart';
import 'package:todoapp/ui/core/app_theme.dart';

void main() {
  group('WeatherCondition WMO Mapping Tests', () {
    test('WMO code 0 maps to Clear Sky', () {
      final dayCondition = WeatherCondition.fromWmoCode(0, isDay: true);
      expect(dayCondition.description, 'Clear Sky');
      expect(dayCondition.themeType, WeatherThemeType.clearDay);

      final nightCondition = WeatherCondition.fromWmoCode(0, isDay: false);
      expect(nightCondition.description, 'Clear Night');
      expect(nightCondition.themeType, WeatherThemeType.clearNight);
    });

    test('WMO code 61 maps to Slight Rain', () {
      final condition = WeatherCondition.fromWmoCode(61);
      expect(condition.description, 'Slight Rain');
      expect(condition.themeType, WeatherThemeType.rainy);
    });

    test('WMO code 71 maps to Slight Snowfall', () {
      final condition = WeatherCondition.fromWmoCode(71);
      expect(condition.description, 'Slight Snowfall');
      expect(condition.themeType, WeatherThemeType.snowy);
    });

    test('WMO code 95 maps to Thunderstorm', () {
      final condition = WeatherCondition.fromWmoCode(95);
      expect(condition.description, 'Thunderstorm');
      expect(condition.themeType, WeatherThemeType.thunderstorm);
    });
  });

  group('WeatherData JSON Deserialization Tests', () {
    test('Successfully parses full Open-Meteo response structure', () {
      final mockJson = {
        'latitude': 51.5,
        'longitude': -0.12,
        'timezone': 'Europe/London',
        'elevation': 25.0,
        'current': {
          'time': '2026-09-08T12:00',
          'temperature_2m': 19.4,
          'relative_humidity_2m': 62,
          'apparent_temperature': 18.9,
          'is_day': 1,
          'precipitation': 0.0,
          'weather_code': 1,
          'surface_pressure': 1015.2,
          'wind_speed_10m': 14.8,
          'wind_direction_10m': 210,
        },
        'hourly': {
          'time': ['2026-09-08T12:00', '2026-09-08T13:00'],
          'temperature_2m': [19.4, 20.1],
          'relative_humidity_2m': [62, 58],
          'precipitation_probability': [10, 20],
          'precipitation': [0.0, 0.0],
          'weather_code': [1, 2],
          'surface_pressure': [1015.2, 1014.8],
          'wind_speed_10m': [14.8, 15.2],
          'uv_index': [4.5, 5.0],
          'is_day': [1, 1],
        },
        'daily': {
          'time': ['2026-09-08', '2026-09-09'],
          'weather_code': [1, 61],
          'temperature_2m_max': [21.5, 18.0],
          'temperature_2m_min': [12.3, 11.0],
          'sunrise': ['2026-09-08T06:22', '2026-09-09T06:24'],
          'sunset': ['2026-09-08T19:35', '2026-09-09T19:33'],
          'uv_index_max': [4.8, 3.2],
          'precipitation_sum': [0.0, 4.2],
          'precipitation_probability_max': [15, 80],
        },
      };

      final data = WeatherData.fromApiResponse(mockJson);

      expect(data.current.temperature, 19.4);
      expect(data.current.apparentTemperature, 18.9);
      expect(data.current.relativeHumidity, 62);
      expect(data.current.condition.description, 'Mainly Clear');
      expect(data.current.uvIndex, 4.5);
      expect(data.hourly.length, 2);
      expect(data.daily.length, 2);
      expect(data.daily.first.maxTemperature, 21.5);
      expect(data.daily.first.minTemperature, 12.3);
      expect(data.weekMinTemp, 11.0);
      expect(data.weekMaxTemp, 21.5);
    });
  });

  group('AirQualityData Tests', () {
    test('AirQuality parsing and categorizing', () {
      final goodJson = {
        'current': {
          'us_aqi': 35,
          'european_aqi': 18,
          'pm2_5': 8.2,
          'pm10': 15.4,
          'nitrogen_dioxide': 12.0,
          'ozone': 48.0,
        }
      };
      final goodAqi = AirQualityData.fromJson(goodJson);
      expect(goodAqi.usAqi, 35);
      expect(goodAqi.categoryName, 'Good');
      expect(goodAqi.pm2_5, 8.2);

      const modAqi = AirQualityData(usAqi: 75);
      expect(modAqi.categoryName, 'Moderate');

      const unhAqi = AirQualityData(usAqi: 165);
      expect(unhAqi.categoryName, 'Unhealthy');

      const hazAqi = AirQualityData(usAqi: 320);
      expect(hazAqi.categoryName, 'Hazardous');
    });
  });

  group('WeatherAlertModel Dynamic Evaluator Tests', () {
    test('Triggers thunderstorm warning on WMO code >= 95', () {
      final current = CurrentWeather(
        time: DateTime.now(),
        temperature: 22.0,
        apparentTemperature: 23.0,
        relativeHumidity: 85,
        isDay: true,
        precipitation: 5.0,
        weatherCode: 95,
        condition: WeatherCondition.fromWmoCode(95),
        surfacePressure: 1008.0,
        windSpeed: 25.0,
        windDirection: 180,
        uvIndex: 2.0,
      );

      final alerts = WeatherAlertModel.evaluateAlerts(current: current);
      expect(alerts.any((a) => a.id == 'thunderstorm_warning'), isTrue);
    });

    test('Triggers high wind advisory when windSpeed >= 38', () {
      final current = CurrentWeather(
        time: DateTime.now(),
        temperature: 15.0,
        apparentTemperature: 12.0,
        relativeHumidity: 60,
        isDay: true,
        precipitation: 0.0,
        weatherCode: 2,
        condition: WeatherCondition.fromWmoCode(2),
        surfacePressure: 1012.0,
        windSpeed: 42.0,
        windDirection: 270,
        uvIndex: 3.0,
      );

      final alerts = WeatherAlertModel.evaluateAlerts(current: current);
      expect(alerts.any((a) => a.id == 'high_wind_advisory'), isTrue);
    });

    test('Triggers AQI health alert when usAqi > 150', () {
      final current = CurrentWeather(
        time: DateTime.now(),
        temperature: 20.0,
        apparentTemperature: 20.0,
        relativeHumidity: 50,
        isDay: true,
        precipitation: 0.0,
        weatherCode: 1,
        condition: WeatherCondition.fromWmoCode(1),
        surfacePressure: 1015.0,
        windSpeed: 10.0,
        windDirection: 90,
        uvIndex: 4.0,
      );

      const badAqi = AirQualityData(usAqi: 175);
      final alerts = WeatherAlertModel.evaluateAlerts(current: current, airQuality: badAqi);
      expect(alerts.any((a) => a.id == 'aqi_health_alert'), isTrue);
    });
  });

  group('AppTheme Formatting Tests', () {
    test('Celsius and Fahrenheit conversions', () {
      expect(AppTheme.formatTemperature(20.0, false), '20°');
      expect(AppTheme.formatTemperature(20.0, true), '68°');
      expect(AppTheme.formatTemperature(0.0, true), '32°');
    });

    test('Wind speed formatting', () {
      expect(AppTheme.formatWindSpeed(10.0, false), '10.0 km/h');
      expect(AppTheme.formatWindSpeed(10.0, true), '6.2 mph');
      expect(AppTheme.formatWindSpeedCustom(36.0, 'kmh'), '36.0 km/h');
      expect(AppTheme.formatWindSpeedCustom(36.0, 'ms'), '10.0 m/s');
    });

    test('Wind compass directions', () {
      expect(AppTheme.getWindDirection(0), 'N');
      expect(AppTheme.getWindDirection(90), 'E');
      expect(AppTheme.getWindDirection(180), 'S');
      expect(AppTheme.getWindDirection(270), 'W');
      expect(AppTheme.getWindDirection(45), 'NE');
      expect(AppTheme.getWindDirection(225), 'SW');
    });
  });
}
