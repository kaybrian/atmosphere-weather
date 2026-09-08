import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/models/weather_model.dart';
import '../../core/app_theme.dart';

class DailyForecastCard extends StatelessWidget {
  final List<DailyForecast> daily;
  final double currentTemp;
  final double weekMinTemp;
  final double weekMaxTemp;
  final bool isFahrenheit;

  const DailyForecastCard({
    super.key,
    required this.daily,
    required this.currentTemp,
    required this.weekMinTemp,
    required this.weekMaxTemp,
    required this.isFahrenheit,
  });

  @override
  Widget build(BuildContext context) {
    if (daily.isEmpty) return const SizedBox.shrink();

    final totalRange = (weekMaxTemp - weekMinTemp).clamp(1.0, 100.0);

    return AppTheme.glassContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.calendar,
                size: 14,
                color: Colors.white.withValues(alpha: 0.65),
              ),
              const SizedBox(width: 6),
              Text(
                '7-DAY FORECAST',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: daily.length.clamp(0, 7),
            separatorBuilder: (context, index) => Divider(
              color: Colors.white.withValues(alpha: 0.1),
              height: 16,
              thickness: 0.8,
            ),
            itemBuilder: (context, index) {
              final item = daily[index];
              final isToday = index == 0;
              final accent = AppTheme.getAccentGlow(item.condition.themeType);

              // Calculate start and end ratios for temperature bar
              final startRatio =
                  ((item.minTemperature - weekMinTemp) / totalRange).clamp(
                    0.0,
                    1.0,
                  );
              final endRatio =
                  ((item.maxTemperature - weekMinTemp) / totalRange).clamp(
                    0.0,
                    1.0,
                  );
              final currentRatio = isToday
                  ? ((currentTemp - weekMinTemp) / totalRange).clamp(0.0, 1.0)
                  : null;

              return Row(
                children: [
                  // Day Label
                  SizedBox(
                    width: 52,
                    child: Text(
                      AppTheme.formatDayOfWeek(item.date),
                      style: TextStyle(
                        color: isToday
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.85),
                        fontSize: 15,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),

                  // Weather Icon + Rain Prob
                  SizedBox(
                    width: 44,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(item.condition.icon, color: accent, size: 22),
                        if (item.precipitationProbability > 15)
                          Text(
                            '${item.precipitationProbability}%',
                            style: const TextStyle(
                              color: Color(0xFF64B5F6),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Min Temp
                  SizedBox(
                    width: 34,
                    child: Text(
                      AppTheme.formatTemperature(
                        item.minTemperature,
                        isFahrenheit,
                      ),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Relative Temperature Span Bar
                  Expanded(
                    child: SizedBox(
                      height: 5,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final barWidth = constraints.maxWidth;
                          final left = startRatio * barWidth;
                          final width = ((endRatio - startRatio) * barWidth)
                              .clamp(6.0, barWidth);

                          return Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              // Background Track
                              Container(
                                width: barWidth,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),

                              // Active Temperature Gradient Bar
                              Positioned(
                                left: left,
                                width: width,
                                child: Container(
                                  height: 5,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF4FC3F7), // Cool Cyan
                                        Color(0xFF81C784), // Mild Green
                                        Color(0xFFFFB74D), // Warm Amber
                                        Color(0xFFFF7043), // Hot Coral
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),

                              // Current Temperature Dot (for Today)
                              if (currentRatio != null)
                                Positioned(
                                  left: (currentRatio * barWidth - 4).clamp(
                                    0.0,
                                    barWidth - 8,
                                  ),
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.black.withValues(
                                          alpha: 0.5,
                                        ),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withValues(
                                            alpha: 0.8,
                                          ),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Max Temp
                  SizedBox(
                    width: 34,
                    child: Text(
                      AppTheme.formatTemperature(
                        item.maxTemperature,
                        isFahrenheit,
                      ),
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
