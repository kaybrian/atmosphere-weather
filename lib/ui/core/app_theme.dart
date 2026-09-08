import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/weather_model.dart';

class AppTheme {
  // Theme Background Gradients based on weather condition
  static List<Color> getGradientForTheme(WeatherThemeType themeType) {
    switch (themeType) {
      case WeatherThemeType.clearDay:
        return const [
          Color(0xFF0D47A1), // Deep Sky Blue
          Color(0xFF1976D2), // Radiant Azure
          Color(0xFF42A5F5), // Light Sky
          Color(0xFF81D4FA), // Sunny Horizon
        ];
      case WeatherThemeType.clearNight:
        return const [
          Color(0xFF070B19), // Midnight Space
          Color(0xFF0E1736), // Deep Indigo
          Color(0xFF1B224E), // Twilight Purple
          Color(0xFF231C3E), // Starry Horizon
        ];
      case WeatherThemeType.cloudyDay:
        return const [
          Color(0xFF2C3E50), // Overcast Navy
          Color(0xFF4A6572), // Slate
          Color(0xFF637B85), // Soft Steel
          Color(0xFF90A4AE), // Misty Gray
        ];
      case WeatherThemeType.cloudyNight:
        return const [
          Color(0xFF0F1523), // Dark Obsidian
          Color(0xFF182235), // Heavy Charcoal
          Color(0xFF253347), // Muted Indigo
        ];
      case WeatherThemeType.rainy:
        return const [
          Color(0xFF16222F), // Stormy Dark Blue
          Color(0xFF1E3A53), // Deep Oceanic
          Color(0xFF2C4A6F), // Rainy Slate
          Color(0xFF3B6082), // Soft Drizzle Gray
        ];
      case WeatherThemeType.thunderstorm:
        return const [
          Color(0xFF0D0B18), // Pitch Night Storm
          Color(0xFF1A142E), // Electric Violet Charcoal
          Color(0xFF271C40), // Thunder Violet
          Color(0xFF1B233A), // Lightning Indigo
        ];
      case WeatherThemeType.snowy:
        return const [
          Color(0xFF2A3D4E), // Glacier Navy
          Color(0xFF40576A), // Frosted Steel
          Color(0xFF6B879E), // Cool Polar
          Color(0xFFA1B7C6), // Snow Horizon
        ];
      case WeatherThemeType.foggy:
        return const [
          Color(0xFF2E3842), // Dense Mist
          Color(0xFF42505C), // Slate Fog
          Color(0xFF607280), // Vapor Gray
          Color(0xFF8896A0), // Horizon Fog
        ];
    }
  }

  // Accent glow color for interactive highlights
  static Color getAccentGlow(WeatherThemeType themeType) {
    switch (themeType) {
      case WeatherThemeType.clearDay:
        return const Color(0xFFFFD54F);
      case WeatherThemeType.clearNight:
        return const Color(0xFF90CAF9);
      case WeatherThemeType.cloudyDay:
      case WeatherThemeType.cloudyNight:
      case WeatherThemeType.foggy:
        return const Color(0xFFCFD8DC);
      case WeatherThemeType.rainy:
        return const Color(0xFF4FC3F7);
      case WeatherThemeType.thunderstorm:
        return const Color(0xFFE040FB);
      case WeatherThemeType.snowy:
        return const Color(0xFFE1F5FE);
    }
  }

  // Glassmorphic Card Container
  static Widget glassContainer({
    required Widget child,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double blur = 18.0,
    double opacity = 0.16,
    Color? borderColor,
  }) {
    final radius = borderRadius ?? BorderRadius.circular(24);
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding ?? const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: opacity),
              borderRadius: radius,
              border: Border.all(
                color: borderColor ?? Colors.white.withValues(alpha: 0.22),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  // Formatting helpers
  static String formatTemperature(double celsius, bool isFahrenheit) {
    final value = isFahrenheit ? (celsius * 9 / 5 + 32) : celsius;
    return '${value.round()}°';
  }

  static String formatTemperatureExact(double celsius, bool isFahrenheit) {
    final value = isFahrenheit ? (celsius * 9 / 5 + 32) : celsius;
    return '${value.toStringAsFixed(1)}°';
  }

  static String formatWindSpeed(double kmh, bool isFahrenheit) {
    if (isFahrenheit) {
      final mph = kmh * 0.621371;
      return '${mph.toStringAsFixed(1)} mph';
    }
    return '${kmh.toStringAsFixed(1)} km/h';
  }

  static String formatWindSpeedCustom(double kmh, String unit) {
    switch (unit) {
      case 'mph':
        return '${(kmh * 0.621371).toStringAsFixed(1)} mph';
      case 'ms':
        return '${(kmh / 3.6).toStringAsFixed(1)} m/s';
      case 'kmh':
      default:
        return '${kmh.toStringAsFixed(1)} km/h';
    }
  }

  static String formatTime(DateTime time) {
    return DateFormat('h a').format(time);
  }

  static String formatDayOfWeek(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    }
    return DateFormat('EEE').format(date);
  }

  static String getWindDirection(int degrees) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((degrees + 22.5) % 360 / 45).floor();
    return directions[index];
  }
}
