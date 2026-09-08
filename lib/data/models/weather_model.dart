import 'package:flutter/cupertino.dart';

enum WeatherThemeType {
  clearDay,
  clearNight,
  cloudyDay,
  cloudyNight,
  rainy,
  thunderstorm,
  snowy,
  foggy,
}

class WeatherCondition {
  final int code;
  final String description;
  final IconData icon;
  final WeatherThemeType themeType;
  final bool isDay;

  const WeatherCondition({
    required this.code,
    required this.description,
    required this.icon,
    required this.themeType,
    required this.isDay,
  });

  factory WeatherCondition.fromWmoCode(int code, {bool isDay = true}) {
    switch (code) {
      case 0:
        return WeatherCondition(
          code: code,
          description: isDay ? 'Clear Sky' : 'Clear Night',
          icon: isDay ? CupertinoIcons.sun_max_fill : CupertinoIcons.moon_stars_fill,
          themeType: isDay ? WeatherThemeType.clearDay : WeatherThemeType.clearNight,
          isDay: isDay,
        );
      case 1:
        return WeatherCondition(
          code: code,
          description: isDay ? 'Mainly Clear' : 'Mostly Clear',
          icon: isDay ? CupertinoIcons.sun_min_fill : CupertinoIcons.moon_fill,
          themeType: isDay ? WeatherThemeType.clearDay : WeatherThemeType.clearNight,
          isDay: isDay,
        );
      case 2:
        return WeatherCondition(
          code: code,
          description: 'Partly Cloudy',
          icon: isDay ? CupertinoIcons.cloud_sun_fill : CupertinoIcons.cloud_moon_fill,
          themeType: isDay ? WeatherThemeType.cloudyDay : WeatherThemeType.cloudyNight,
          isDay: isDay,
        );
      case 3:
        return WeatherCondition(
          code: code,
          description: 'Overcast',
          icon: CupertinoIcons.cloud_fill,
          themeType: isDay ? WeatherThemeType.cloudyDay : WeatherThemeType.cloudyNight,
          isDay: isDay,
        );
      case 45:
        return WeatherCondition(
          code: code,
          description: 'Foggy',
          icon: CupertinoIcons.cloud_fog_fill,
          themeType: WeatherThemeType.foggy,
          isDay: isDay,
        );
      case 48:
        return WeatherCondition(
          code: code,
          description: 'Depositing Rime Fog',
          icon: CupertinoIcons.cloud_fog_fill,
          themeType: WeatherThemeType.foggy,
          isDay: isDay,
        );
      case 51:
      case 53:
      case 55:
        return WeatherCondition(
          code: code,
          description: code == 51
              ? 'Light Drizzle'
              : code == 53
                  ? 'Moderate Drizzle'
                  : 'Dense Drizzle',
          icon: CupertinoIcons.cloud_drizzle_fill,
          themeType: WeatherThemeType.rainy,
          isDay: isDay,
        );
      case 56:
      case 57:
        return WeatherCondition(
          code: code,
          description: 'Freezing Drizzle',
          icon: CupertinoIcons.cloud_sleet_fill,
          themeType: WeatherThemeType.rainy,
          isDay: isDay,
        );
      case 61:
        return WeatherCondition(
          code: code,
          description: 'Slight Rain',
          icon: CupertinoIcons.cloud_rain_fill,
          themeType: WeatherThemeType.rainy,
          isDay: isDay,
        );
      case 63:
        return WeatherCondition(
          code: code,
          description: 'Moderate Rain',
          icon: CupertinoIcons.cloud_rain_fill,
          themeType: WeatherThemeType.rainy,
          isDay: isDay,
        );
      case 65:
        return WeatherCondition(
          code: code,
          description: 'Heavy Rain',
          icon: CupertinoIcons.cloud_heavyrain_fill,
          themeType: WeatherThemeType.rainy,
          isDay: isDay,
        );
      case 66:
      case 67:
        return WeatherCondition(
          code: code,
          description: 'Freezing Rain',
          icon: CupertinoIcons.cloud_sleet_fill,
          themeType: WeatherThemeType.rainy,
          isDay: isDay,
        );
      case 71:
      case 73:
      case 75:
      case 77:
        return WeatherCondition(
          code: code,
          description: code == 71
              ? 'Slight Snowfall'
              : code == 73
                  ? 'Moderate Snowfall'
                  : code == 75
                      ? 'Heavy Snowfall'
                      : 'Snow Grains',
          icon: CupertinoIcons.snow,
          themeType: WeatherThemeType.snowy,
          isDay: isDay,
        );
      case 80:
      case 81:
      case 82:
        return WeatherCondition(
          code: code,
          description: code == 80
              ? 'Slight Rain Showers'
              : code == 81
                  ? 'Moderate Rain Showers'
                  : 'Violent Rain Showers',
          icon: CupertinoIcons.cloud_rain_fill,
          themeType: WeatherThemeType.rainy,
          isDay: isDay,
        );
      case 85:
      case 86:
        return WeatherCondition(
          code: code,
          description: 'Snow Showers',
          icon: CupertinoIcons.cloud_snow_fill,
          themeType: WeatherThemeType.snowy,
          isDay: isDay,
        );
      case 95:
        return WeatherCondition(
          code: code,
          description: 'Thunderstorm',
          icon: CupertinoIcons.cloud_bolt_rain_fill,
          themeType: WeatherThemeType.thunderstorm,
          isDay: isDay,
        );
      case 96:
      case 99:
        return WeatherCondition(
          code: code,
          description: 'Thunderstorm with Hail',
          icon: CupertinoIcons.cloud_bolt_rain_fill,
          themeType: WeatherThemeType.thunderstorm,
          isDay: isDay,
        );
      default:
        return WeatherCondition(
          code: code,
          description: 'Clear',
          icon: isDay ? CupertinoIcons.sun_max_fill : CupertinoIcons.moon_fill,
          themeType: isDay ? WeatherThemeType.clearDay : WeatherThemeType.clearNight,
          isDay: isDay,
        );
    }
  }
}

class CurrentWeather {
  final double temperature;
  final double apparentTemperature;
  final int weatherCode;
  final WeatherCondition condition;
  final int relativeHumidity;
  final double windSpeed;
  final int windDirection;
  final double surfacePressure;
  final double uvIndex;
  final double precipitation;
  final bool isDay;
  final DateTime time;

  const CurrentWeather({
    required this.temperature,
    required this.apparentTemperature,
    required this.weatherCode,
    required this.condition,
    required this.relativeHumidity,
    required this.windSpeed,
    required this.windDirection,
    required this.surfacePressure,
    required this.uvIndex,
    required this.precipitation,
    required this.isDay,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'apparentTemperature': apparentTemperature,
      'weatherCode': weatherCode,
      'relativeHumidity': relativeHumidity,
      'windSpeed': windSpeed,
      'windDirection': windDirection,
      'surfacePressure': surfacePressure,
      'uvIndex': uvIndex,
      'precipitation': precipitation,
      'isDay': isDay,
      'time': time.toIso8601String(),
    };
  }

  factory CurrentWeather.fromJson(Map<String, dynamic> current, Map<String, dynamic> hourly) {
    final isDay = (current['is_day'] as num? ?? 1) == 1;
    final code = (current['weather_code'] as num? ?? 0).toInt();
    final timeStr = current['time'] as String? ?? DateTime.now().toIso8601String();
    final time = DateTime.tryParse(timeStr) ?? DateTime.now();

    // Extract first UV index from hourly if present
    double uv = 0.0;
    if (hourly['uv_index'] != null && (hourly['uv_index'] as List).isNotEmpty) {
      uv = ((hourly['uv_index'] as List).first as num? ?? 0.0).toDouble();
    }

    return CurrentWeather(
      temperature: (current['temperature_2m'] as num? ?? 0.0).toDouble(),
      apparentTemperature: (current['apparent_temperature'] as num? ?? current['temperature_2m'] as num? ?? 0.0).toDouble(),
      weatherCode: code,
      condition: WeatherCondition.fromWmoCode(code, isDay: isDay),
      relativeHumidity: (current['relative_humidity_2m'] as num? ?? 50).toInt(),
      windSpeed: (current['wind_speed_10m'] as num? ?? 0.0).toDouble(),
      windDirection: (current['wind_direction_10m'] as num? ?? 0).toInt(),
      surfacePressure: (current['surface_pressure'] as num? ?? 1013.25).toDouble(),
      uvIndex: uv,
      precipitation: (current['precipitation'] as num? ?? 0.0).toDouble(),
      isDay: isDay,
      time: time,
    );
  }
}

class HourlyForecast {
  final DateTime time;
  final double temperature;
  final int weatherCode;
  final WeatherCondition condition;
  final int precipitationProbability;
  final bool isDay;

  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.weatherCode,
    required this.condition,
    required this.precipitationProbability,
    required this.isDay,
  });

  Map<String, dynamic> toJson() {
    return {
      'time': time.toIso8601String(),
      'temperature': temperature,
      'weatherCode': weatherCode,
      'precipitationProbability': precipitationProbability,
      'isDay': isDay,
    };
  }

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    final isDay = json['isDay'] as bool? ?? true;
    final code = (json['weatherCode'] as num? ?? 0).toInt();
    return HourlyForecast(
      time: DateTime.parse(json['time'] as String),
      temperature: (json['temperature'] as num).toDouble(),
      weatherCode: code,
      condition: WeatherCondition.fromWmoCode(code, isDay: isDay),
      precipitationProbability: (json['precipitationProbability'] as num? ?? 0).toInt(),
      isDay: isDay,
    );
  }
}

class DailyForecast {
  final DateTime date;
  final double maxTemperature;
  final double minTemperature;
  final int weatherCode;
  final WeatherCondition condition;
  final int precipitationProbability;
  final double precipitationSum;
  final double uvIndexMax;
  final DateTime? sunrise;
  final DateTime? sunset;

  const DailyForecast({
    required this.date,
    required this.maxTemperature,
    required this.minTemperature,
    required this.weatherCode,
    required this.condition,
    required this.precipitationProbability,
    required this.precipitationSum,
    required this.uvIndexMax,
    this.sunrise,
    this.sunset,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'maxTemperature': maxTemperature,
      'minTemperature': minTemperature,
      'weatherCode': weatherCode,
      'precipitationProbability': precipitationProbability,
      'precipitationSum': precipitationSum,
      'uvIndexMax': uvIndexMax,
      'sunrise': sunrise?.toIso8601String(),
      'sunset': sunset?.toIso8601String(),
    };
  }

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    final code = (json['weatherCode'] as num? ?? 0).toInt();
    return DailyForecast(
      date: DateTime.parse(json['date'] as String),
      maxTemperature: (json['maxTemperature'] as num).toDouble(),
      minTemperature: (json['minTemperature'] as num).toDouble(),
      weatherCode: code,
      condition: WeatherCondition.fromWmoCode(code, isDay: true),
      precipitationProbability: (json['precipitationProbability'] as num? ?? 0).toInt(),
      precipitationSum: (json['precipitationSum'] as num? ?? 0.0).toDouble(),
      uvIndexMax: (json['uvIndexMax'] as num? ?? 0.0).toDouble(),
      sunrise: json['sunrise'] != null ? DateTime.tryParse(json['sunrise'] as String) : null,
      sunset: json['sunset'] != null ? DateTime.tryParse(json['sunset'] as String) : null,
    );
  }
}

class WeatherData {
  final CurrentWeather current;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;
  final String timezone;
  final double elevation;
  final double weekMinTemp;
  final double weekMaxTemp;

  const WeatherData({
    required this.current,
    required this.hourly,
    required this.daily,
    required this.timezone,
    required this.elevation,
    required this.weekMinTemp,
    required this.weekMaxTemp,
  });

  Map<String, dynamic> toJson() {
    return {
      'current': current.toJson(),
      'hourly': hourly.map((e) => e.toJson()).toList(),
      'daily': daily.map((e) => e.toJson()).toList(),
      'timezone': timezone,
      'elevation': elevation,
      'weekMinTemp': weekMinTemp,
      'weekMaxTemp': weekMaxTemp,
    };
  }

  factory WeatherData.fromApiResponse(Map<String, dynamic> json) {
    final currentMap = json['current'] as Map<String, dynamic>? ?? {};
    final hourlyMap = json['hourly'] as Map<String, dynamic>? ?? {};
    final dailyMap = json['daily'] as Map<String, dynamic>? ?? {};

    final currentWeather = CurrentWeather.fromJson(currentMap, hourlyMap);

    // Parse Hourly (up to 48 hours)
    final hourlyTimes = (hourlyMap['time'] as List<dynamic>? ?? []).cast<String>();
    final hourlyTemps = (hourlyMap['temperature_2m'] as List<dynamic>? ?? []).cast<num>();
    final hourlyCodes = (hourlyMap['weather_code'] as List<dynamic>? ?? []).cast<num>();
    final hourlyIsDay = (hourlyMap['is_day'] as List<dynamic>? ?? []).cast<num>();
    final hourlyPrecipProb = (hourlyMap['precipitation_probability'] as List<dynamic>? ?? []).cast<num>();

    final List<HourlyForecast> hourlyList = [];
    final int countHourly = hourlyTimes.length.clamp(0, 48);

    for (int i = 0; i < countHourly; i++) {
      final time = DateTime.tryParse(hourlyTimes[i]) ?? DateTime.now();
      final isDay = i < hourlyIsDay.length ? (hourlyIsDay[i] == 1) : true;
      final code = i < hourlyCodes.length ? hourlyCodes[i].toInt() : 0;
      final temp = i < hourlyTemps.length ? hourlyTemps[i].toDouble() : 0.0;
      final precipProb = i < hourlyPrecipProb.length ? hourlyPrecipProb[i].toInt() : 0;

      hourlyList.add(HourlyForecast(
        time: time,
        temperature: temp,
        weatherCode: code,
        condition: WeatherCondition.fromWmoCode(code, isDay: isDay),
        precipitationProbability: precipProb,
        isDay: isDay,
      ));
    }

    // Parse Daily (up to 7-10 days)
    final dailyTimes = (dailyMap['time'] as List<dynamic>? ?? []).cast<String>();
    final dailyMaxTemps = (dailyMap['temperature_2m_max'] as List<dynamic>? ?? []).cast<num>();
    final dailyMinTemps = (dailyMap['temperature_2m_min'] as List<dynamic>? ?? []).cast<num>();
    final dailyCodes = (dailyMap['weather_code'] as List<dynamic>? ?? []).cast<num>();
    final dailyPrecipProb = (dailyMap['precipitation_probability_max'] as List<dynamic>? ?? []).cast<num>();
    final dailyPrecipSum = (dailyMap['precipitation_sum'] as List<dynamic>? ?? []).cast<num>();
    final dailyUvMax = (dailyMap['uv_index_max'] as List<dynamic>? ?? []).cast<num>();
    final dailySunrises = (dailyMap['sunrise'] as List<dynamic>? ?? []).cast<String>();
    final dailySunsets = (dailyMap['sunset'] as List<dynamic>? ?? []).cast<String>();

    final List<DailyForecast> dailyList = [];
    final int countDaily = dailyTimes.length.clamp(0, 10);
    double minWeek = 100.0;
    double maxWeek = -100.0;

    for (int i = 0; i < countDaily; i++) {
      final date = DateTime.tryParse(dailyTimes[i]) ?? DateTime.now();
      final minTemp = i < dailyMinTemps.length ? dailyMinTemps[i].toDouble() : 0.0;
      final maxTemp = i < dailyMaxTemps.length ? dailyMaxTemps[i].toDouble() : 0.0;
      final code = i < dailyCodes.length ? dailyCodes[i].toInt() : 0;
      final precipProb = i < dailyPrecipProb.length ? dailyPrecipProb[i].toInt() : 0;
      final precipSum = i < dailyPrecipSum.length ? dailyPrecipSum[i].toDouble() : 0.0;
      final uvMax = i < dailyUvMax.length ? dailyUvMax[i].toDouble() : 0.0;
      final sunrise = i < dailySunrises.length ? DateTime.tryParse(dailySunrises[i]) : null;
      final sunset = i < dailySunsets.length ? DateTime.tryParse(dailySunsets[i]) : null;

      if (minTemp < minWeek) minWeek = minTemp;
      if (maxTemp > maxWeek) maxWeek = maxTemp;

      dailyList.add(DailyForecast(
        date: date,
        minTemperature: minTemp,
        maxTemperature: maxTemp,
        weatherCode: code,
        condition: WeatherCondition.fromWmoCode(code, isDay: true),
        precipitationProbability: precipProb,
        precipitationSum: precipSum,
        uvIndexMax: uvMax,
        sunrise: sunrise,
        sunset: sunset,
      ));
    }

    if (minWeek > maxWeek) {
      minWeek = 0.0;
      maxWeek = 30.0;
    }

    return WeatherData(
      current: currentWeather,
      hourly: hourlyList,
      daily: dailyList,
      timezone: json['timezone'] as String? ?? 'UTC',
      elevation: (json['elevation'] as num? ?? 0.0).toDouble(),
      weekMinTemp: minWeek,
      weekMaxTemp: maxWeek,
    );
  }
}
