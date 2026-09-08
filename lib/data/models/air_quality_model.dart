import 'package:flutter/material.dart';

class AirQualityData {
  final int usAqi;
  final int? europeanAqi;
  final double? pm2_5;
  final double? pm10;
  final double? nitrogenDioxide;
  final double? sulphurDioxide;
  final double? ozone;
  final double? carbonMonoxide;

  const AirQualityData({
    required this.usAqi,
    this.europeanAqi,
    this.pm2_5,
    this.pm10,
    this.nitrogenDioxide,
    this.sulphurDioxide,
    this.ozone,
    this.carbonMonoxide,
  });

  factory AirQualityData.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>? ?? {};

    return AirQualityData(
      usAqi: (current['us_aqi'] as num?)?.round() ?? 25,
      europeanAqi: (current['european_aqi'] as num?)?.round(),
      pm2_5: (current['pm2_5'] as num?)?.toDouble(),
      pm10: (current['pm10'] as num?)?.toDouble(),
      nitrogenDioxide: (current['nitrogen_dioxide'] as num?)?.toDouble(),
      sulphurDioxide: (current['sulphur_dioxide'] as num?)?.toDouble(),
      ozone: (current['ozone'] as num?)?.toDouble(),
      carbonMonoxide: (current['carbon_monoxide'] as num?)?.toDouble(),
    );
  }

  String get categoryName {
    if (usAqi <= 50) return 'Good';
    if (usAqi <= 100) return 'Moderate';
    if (usAqi <= 150) return 'Unhealthy for Sensitive';
    if (usAqi <= 200) return 'Unhealthy';
    if (usAqi <= 300) return 'Very Unhealthy';
    return 'Hazardous';
  }

  Color get categoryColor {
    if (usAqi <= 50) return const Color(0xFF4CAF50); // Green
    if (usAqi <= 100) return const Color(0xFFFFB300); // Amber
    if (usAqi <= 150) return const Color(0xFFFF7043); // Orange
    if (usAqi <= 200) return const Color(0xFFE53935); // Red
    if (usAqi <= 300) return const Color(0xFF8E24AA); // Purple
    return const Color(0xFF880E4F); // Maroon
  }

  String get healthAdvice {
    if (usAqi <= 50) {
      return 'Air quality is satisfactory and poses little or no risk. Perfect for outdoor activities!';
    }
    if (usAqi <= 100) {
      return 'Air quality is acceptable. Unusually sensitive individuals should consider limiting prolonged outdoor exertion.';
    }
    if (usAqi <= 150) {
      return 'Members of sensitive groups may experience health effects. The general public is less likely to be affected.';
    }
    if (usAqi <= 200) {
      return 'Everyone may begin to experience health effects. Reduce strenuous outdoor exertion.';
    }
    return 'Health alert: serious risk of respiratory symptoms. Avoid outdoor physical activity.';
  }

  double get progressRatio => (usAqi / 300.0).clamp(0.05, 1.0);
}
