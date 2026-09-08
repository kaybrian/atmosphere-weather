import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/models/weather_model.dart';
import '../../core/app_theme.dart';

class HourlyForecastCard extends StatelessWidget {
  final List<HourlyForecast> hourly;
  final bool isFahrenheit;

  const HourlyForecastCard({
    super.key,
    required this.hourly,
    required this.isFahrenheit,
  });

  @override
  Widget build(BuildContext context) {
    if (hourly.isEmpty) return const SizedBox.shrink();

    return AppTheme.glassContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.clock_fill,
                size: 14,
                color: Colors.white.withValues(alpha: 0.65),
              ),
              const SizedBox(width: 6),
              Text(
                '24-HOUR FORECAST',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 124,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: hourly.length.clamp(0, 24),
              separatorBuilder: (context, index) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final item = hourly[index];
                final isFirst = index == 0;
                final timeLabel = isFirst
                    ? 'Now'
                    : AppTheme.formatTime(item.time);
                final accent = AppTheme.getAccentGlow(item.condition.themeType);

                return Container(
                  width: 64,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isFirst
                        ? Colors.white.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: isFirst
                        ? Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                            width: 1,
                          )
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeLabel,
                        style: TextStyle(
                          color: isFirst
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.8),
                          fontSize: 13,
                          fontWeight: isFirst
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                      ),
                      Icon(item.condition.icon, color: accent, size: 26),
                      if (item.precipitationProbability > 0)
                        Text(
                          '${item.precipitationProbability}%',
                          style: const TextStyle(
                            color: Color(0xFF64B5F6),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      else
                        const SizedBox(height: 14),
                      Text(
                        AppTheme.formatTemperature(
                          item.temperature,
                          isFahrenheit,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
