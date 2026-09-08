import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/models/weather_model.dart';
import '../../core/app_theme.dart';

class WeatherMetricsGrid extends StatelessWidget {
  final CurrentWeather current;
  final bool isFahrenheit;
  final String windUnit;

  const WeatherMetricsGrid({
    super.key,
    required this.current,
    required this.isFahrenheit,
    this.windUnit = 'kmh',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Row 1: UV Index & Wind
          Row(
            children: [
              Expanded(child: _buildUvIndexCard()),
              const SizedBox(width: 14),
              Expanded(child: _buildWindCard()),
            ],
          ),
          const SizedBox(height: 14),
          // Row 2: Humidity & Feels Like
          Row(
            children: [
              Expanded(child: _buildHumidityCard()),
              const SizedBox(width: 14),
              Expanded(child: _buildFeelsLikeCard()),
            ],
          ),
          const SizedBox(height: 14),
          // Row 3: Pressure & Precipitation
          Row(
            children: [
              Expanded(child: _buildPressureCard()),
              const SizedBox(width: 14),
              Expanded(child: _buildPrecipitationCard()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required Widget content,
    required String subtitle,
  }) {
    return AppTheme.glassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.65)),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          content,
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 11,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUvIndexCard() {
    final uv = current.uvIndex;
    String category = 'Low';
    Color barColor = const Color(0xFF81C784);

    if (uv >= 11) {
      category = 'Extreme';
      barColor = const Color(0xFFBA68C8);
    } else if (uv >= 8) {
      category = 'Very High';
      barColor = const Color(0xFFE57373);
    } else if (uv >= 6) {
      category = 'High';
      barColor = const Color(0xFFFFB74D);
    } else if (uv >= 3) {
      category = 'Moderate';
      barColor = const Color(0xFFFFD54F);
    }

    return _buildCard(
      icon: CupertinoIcons.sun_max,
      title: 'UV INDEX',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            uv.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            category,
            style: TextStyle(
              color: barColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: (uv / 12.0).clamp(0.05, 1.0),
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
              minHeight: 4,
            ),
          ),
        ],
      ),
      subtitle: uv > 5
          ? 'Sun protection recommended during midday'
          : 'Low risk from UV rays today',
    );
  }

  Widget _buildWindCard() {
    final speed = current.windSpeed;
    final direction = current.windDirection;
    final cardinal = AppTheme.getWindDirection(direction);

    return _buildCard(
      icon: CupertinoIcons.wind,
      title: 'WIND',
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppTheme.formatWindSpeedCustom(speed, windUnit),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                cardinal,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          // Animated / Oriented Compass Dial
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.08),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Center(
              child: Transform.rotate(
                angle: (direction * math.pi / 180),
                child: const Icon(
                  CupertinoIcons.location_north_fill,
                  size: 20,
                  color: Color(0xFF64B5F6),
                ),
              ),
            ),
          ),
        ],
      ),
      subtitle: 'Direction $direction° • $cardinal gusts',
    );
  }

  Widget _buildHumidityCard() {
    final hum = current.relativeHumidity;
    return _buildCard(
      icon: CupertinoIcons.drop,
      title: 'HUMIDITY',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$hum%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: (hum / 100.0).clamp(0.0, 1.0),
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF4FC3F7),
              ),
              minHeight: 4,
            ),
          ),
        ],
      ),
      subtitle: hum > 70
          ? 'Air feels quite humid'
          : hum < 35
          ? 'Air feels rather dry'
          : 'Comfortable moisture levels',
    );
  }

  Widget _buildFeelsLikeCard() {
    final diff = current.apparentTemperature - current.temperature;
    String comment = 'Similar to the actual temperature';
    if (diff.abs() > 1.5) {
      comment = diff > 0
          ? 'Humidity is making it feel warmer'
          : 'Wind is making it feel cooler';
    }

    return _buildCard(
      icon: CupertinoIcons.thermometer,
      title: 'FEELS LIKE',
      content: Text(
        AppTheme.formatTemperature(current.apparentTemperature, isFahrenheit),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: comment,
    );
  }

  Widget _buildPressureCard() {
    final pressure = current.surfacePressure.round();
    return _buildCard(
      icon: CupertinoIcons.gauge,
      title: 'PRESSURE',
      content: Text(
        '$pressure hPa',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: pressure > 1013
          ? 'High barometric pressure'
          : 'Low barometric pressure',
    );
  }

  Widget _buildPrecipitationCard() {
    final precip = current.precipitation;
    return _buildCard(
      icon: CupertinoIcons.cloud_rain,
      title: 'PRECIPITATION',
      content: Text(
        '${precip.toStringAsFixed(1)} mm',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: precip > 0
          ? 'Rainfall detected recently'
          : 'No rain reported currently',
    );
  }
}
