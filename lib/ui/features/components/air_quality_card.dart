import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/models/air_quality_model.dart';
import '../../core/app_theme.dart';

class AirQualityCard extends StatelessWidget {
  final AirQualityData? airQuality;

  const AirQualityCard({
    super.key,
    required this.airQuality,
  });

  @override
  Widget build(BuildContext context) {
    if (airQuality == null) return const SizedBox.shrink();

    final aqi = airQuality!;
    final color = aqi.categoryColor;

    return AppTheme.glassContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    CupertinoIcons.wind,
                    size: 14,
                    color: Colors.white.withValues(alpha: 0.65),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'AIR QUALITY INDEX',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withValues(alpha: 0.6)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      aqi.categoryName,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Big AQI Number + Context
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${aqi.usAqi}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'US AQI',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Multi-color gradient spectrum progress bar
          Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF4CAF50), // 0-50 Good
                      Color(0xFFFFEB3B), // 51-100 Moderate
                      Color(0xFFFF9800), // 101-150 Unhealthy sensitive
                      Color(0xFFF44336), // 151-200 Unhealthy
                      Color(0xFF9C27B0), // 201-300 Very Unhealthy
                      Color(0xFF880E4F), // 301+ Hazardous
                    ],
                  ),
                ),
              ),
              // Indicator pin
              LayoutBuilder(
                builder: (context, constraints) {
                  final left = (aqi.progressRatio * constraints.maxWidth - 4)
                      .clamp(0.0, constraints.maxWidth - 8);
                  return Container(
                    margin: EdgeInsets.only(left: left, top: 0),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Health recommendation text
          Text(
            aqi.healthAdvice,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 13,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 14),
          Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
          const SizedBox(height: 12),

          // Pollutant breakdown chips
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPollutantChip('PM2.5', aqi.pm2_5 != null ? '${aqi.pm2_5!.round()} µg/m³' : '--'),
              _buildPollutantChip('PM10', aqi.pm10 != null ? '${aqi.pm10!.round()} µg/m³' : '--'),
              _buildPollutantChip('NO₂', aqi.nitrogenDioxide != null ? '${aqi.nitrogenDioxide!.round()} µg/m³' : '--'),
              _buildPollutantChip('O₃', aqi.ozone != null ? '${aqi.ozone!.round()} µg/m³' : '--'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPollutantChip(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.55),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
