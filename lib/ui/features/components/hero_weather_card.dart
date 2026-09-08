import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/models/location_model.dart';
import '../../../data/models/weather_model.dart';
import '../../core/app_theme.dart';

class HeroWeatherCard extends StatelessWidget {
  final WeatherData weather;
  final LocationModel location;
  final bool isFahrenheit;
  final VoidCallback onLocationTap;
  final VoidCallback onCurrentLocationTap;

  const HeroWeatherCard({
    super.key,
    required this.weather,
    required this.location,
    required this.isFahrenheit,
    required this.onLocationTap,
    required this.onCurrentLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    final current = weather.current;
    final today = weather.daily.isNotEmpty ? weather.daily.first : null;
    final accent = AppTheme.getAccentGlow(current.condition.themeType);

    return Column(
      children: [
        // Location Selector Header
        GestureDetector(
          onTap: onLocationTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  location.isCurrentLocation ? CupertinoIcons.location_fill : CupertinoIcons.placemark_fill,
                  size: 16,
                  color: location.isCurrentLocation ? const Color(0xFF64B5F6) : Colors.white70,
                ),
                const SizedBox(width: 8),
                Text(
                  location.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                if (location.countryCode != null && location.countryCode!.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      location.countryCode!.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: 6),
                const Icon(CupertinoIcons.chevron_down, size: 14, color: Colors.white70),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Live Location status badge
        if (location.isCurrentLocation)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Live Location',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

        const SizedBox(height: 8),

        // Hero Temperature Display with Ambient Glow
        Stack(
          alignment: Alignment.center,
          children: [
            // Soft Radial Glow behind temperature
            Container(
              width: 220,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.18),
                    blurRadius: 90,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${isFahrenheit ? (current.temperature * 9 / 5 + 32).round() : current.temperature.round()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 92,
                    fontWeight: FontWeight.w200,
                    height: 1.0,
                    letterSpacing: -2.0,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    '°',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Condition Badge & Icon
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                current.condition.icon,
                color: accent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                current.condition.description,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // High / Low & Feels Like Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (today != null) ...[
              Text(
                'H: ${AppTheme.formatTemperature(today.maxTemperature, isFahrenheit)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'L: ${AppTheme.formatTemperature(today.minTemperature, isFahrenheit)}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 14),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Colors.white38,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 14),
            ],
            Text(
              'Feels like ${AppTheme.formatTemperature(current.apparentTemperature, isFahrenheit)}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
