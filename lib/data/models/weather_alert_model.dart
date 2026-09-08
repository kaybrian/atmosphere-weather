import 'package:flutter/material.dart';

import 'air_quality_model.dart';
import 'weather_model.dart';

enum AlertSeverity {
  advisory,
  watch,
  warning,
  emergency;

  Color get color {
    switch (this) {
      case AlertSeverity.advisory:
        return const Color(0xFFFFB74D); // Amber
      case AlertSeverity.watch:
        return const Color(0xFFFF7043); // Deep Orange
      case AlertSeverity.warning:
        return const Color(0xFFEF5350); // Red
      case AlertSeverity.emergency:
        return const Color(0xFFD32F2F); // Dark Red
    }
  }

  IconData get icon {
    switch (this) {
      case AlertSeverity.advisory:
        return Icons.info_outline;
      case AlertSeverity.watch:
        return Icons.warning_amber_rounded;
      case AlertSeverity.warning:
        return Icons.report_problem_rounded;
      case AlertSeverity.emergency:
        return Icons.error_rounded;
    }
  }
}

class WeatherAlertModel {
  final String id;
  final String title;
  final AlertSeverity severity;
  final String description;
  final String instructions;
  final String source;
  final DateTime effectiveTime;

  const WeatherAlertModel({
    required this.id,
    required this.title,
    required this.severity,
    required this.description,
    required this.instructions,
    required this.source,
    required this.effectiveTime,
  });

  static List<WeatherAlertModel> evaluateAlerts({
    required CurrentWeather current,
    AirQualityData? airQuality,
  }) {
    final alerts = <WeatherAlertModel>[];
    final now = DateTime.now();

    // 1. Thunderstorm Warning
    if (current.weatherCode >= 95) {
      alerts.add(
        WeatherAlertModel(
          id: 'thunderstorm_warning',
          title: 'Severe Thunderstorm Warning',
          severity: AlertSeverity.warning,
          description: 'Active atmospheric electrical activity and lightning strikes detected in this area.',
          instructions: 'Remain indoors away from windows, corded phones, and electrical appliances. Avoid open water and tall structures.',
          source: 'Meteorological Department',
          effectiveTime: now,
        ),
      );
    }

    // 2. High Wind Advisory
    if (current.windSpeed >= 38.0) {
      alerts.add(
        WeatherAlertModel(
          id: 'high_wind_advisory',
          title: 'High Wind Advisory',
          severity: AlertSeverity.advisory,
          description:
              'Sustained strong winds and gusts reaching ${current.windSpeed.round()} km/h may blow unsecured objects.',
          instructions: 'Secure lightweight outdoor furniture. Drive with caution, especially high-profile vehicles.',
          source: 'National Weather Service',
          effectiveTime: now,
        ),
      );
    }

    // 3. Heavy Rain / Flood Watch
    if (current.weatherCode == 65 || current.weatherCode == 82) {
      alerts.add(
        WeatherAlertModel(
          id: 'flood_watch',
          title: 'Heavy Rainfall & Flood Watch',
          severity: AlertSeverity.watch,
          description: 'Intense precipitation may cause ponding on roads and localized low-lying flooding.',
          instructions: 'Never drive through flooded roadways. Allow extra stopping distance when traveling.',
          source: 'Hydrological Services',
          effectiveTime: now,
        ),
      );
    }

    // 4. Excessive UV Radiation Warning
    if (current.uvIndex >= 8.0) {
      alerts.add(
        WeatherAlertModel(
          id: 'extreme_uv_alert',
          title:
              'Extreme UV Index Alert (${current.uvIndex.toStringAsFixed(1)})',
          severity: AlertSeverity.advisory,
          description: 'Very high solar radiation levels present rapid risk of skin and eye damage.',
          instructions: 'Wear SPF 30+ sunscreen, UV-blocking sunglasses, and wide-brim hats. Seek shade during midday peak hours.',
          source: 'Environmental Radiation Agency',
          effectiveTime: now,
        ),
      );
    }

    // 5. Hazardous Air Quality Alert
    if (airQuality != null && airQuality.usAqi > 150) {
      alerts.add(
        WeatherAlertModel(
          id: 'aqi_health_alert',
          title: 'Air Quality Health Advisory (AQI ${airQuality.usAqi})',
          severity: AlertSeverity.warning,
          description: 'Particulate air pollution levels are unhealthy for general population and sensitive groups.',
          instructions: 'Wear an N95/KF94 mask outdoors. Keep home windows closed and use HEPA air purifiers if available.',
          source: 'Global Air Monitoring Network',
          effectiveTime: now,
        ),
      );
    }

    return alerts;
  }
}
