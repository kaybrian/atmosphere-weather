import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/weather_model.dart';
import '../../core/app_theme.dart';

class SunArcCard extends StatelessWidget {
  final DailyForecast? todayForecast;

  const SunArcCard({super.key, required this.todayForecast});

  @override
  Widget build(BuildContext context) {
    if (todayForecast == null) return const SizedBox.shrink();

    final sunrise = todayForecast!.sunrise;
    final sunset = todayForecast!.sunset;
    final now = DateTime.now();

    final sunriseStr = sunrise != null
        ? DateFormat('h:mm a').format(sunrise)
        : '6:00 AM';
    final sunsetStr = sunset != null
        ? DateFormat('h:mm a').format(sunset)
        : '7:30 PM';

    double progress = 0.5;
    String status = 'Daylight';

    if (sunrise != null && sunset != null) {
      final totalDayMinutes = sunset.difference(sunrise).inMinutes;
      final passedMinutes = now.difference(sunrise).inMinutes;

      if (now.isBefore(sunrise)) {
        progress = 0.0;
        final untilSunrise = sunrise.difference(now);
        status =
            'Sunrise in ${untilSunrise.inHours}h ${untilSunrise.inMinutes % 60}m';
      } else if (now.isAfter(sunset)) {
        progress = 1.0;
        status = 'Sunset passed';
      } else {
        progress = (passedMinutes / (totalDayMinutes > 0 ? totalDayMinutes : 1))
            .clamp(0.0, 1.0);
        final untilSunset = sunset.difference(now);
        status =
            'Sunset in ${untilSunset.inHours}h ${untilSunset.inMinutes % 60}m';
      }
    }

    return AppTheme.glassContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.sun_haze_fill,
                size: 14,
                color: Colors.white.withValues(alpha: 0.65),
              ),
              const SizedBox(width: 6),
              Text(
                'SUNSET & SUNRISE',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Sun Arch Canvas
          SizedBox(
            height: 90,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return CustomPaint(
                  size: Size(constraints.maxWidth, 90),
                  painter: _SunArcPainter(progress: progress),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sunrise',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    sunriseStr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Sunset',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    sunsetStr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SunArcPainter extends CustomPainter {
  final double progress;

  _SunArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final start = Offset(20, size.height - 10);
    final end = Offset(size.width - 20, size.height - 10);
    final control = Offset(size.width / 2, -20);

    // 1. Horizon Line
    final horizonPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(0, size.height - 10),
      Offset(size.width, size.height - 10),
      horizonPaint,
    );

    // 2. Dashed or solid background arc
    final arcPath = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);

    final trackPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawPath(arcPath, trackPaint);

    // 3. Compute current sun position along bezier curve
    final t = progress;
    final x =
        (1 - t) * (1 - t) * start.dx +
        2 * (1 - t) * t * control.dx +
        t * t * end.dx;
    final y =
        (1 - t) * (1 - t) * start.dy +
        2 * (1 - t) * t * control.dy +
        t * t * end.dy;
    final sunCenter = Offset(x, y);

    // Sun Glow
    final glowPaint = Paint()
      ..color = const Color(0xFFFFD54F).withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(sunCenter, 14, glowPaint);

    // Sun Body
    final sunPaint = Paint()..color = const Color(0xFFFFE082);
    canvas.drawCircle(sunCenter, 7, sunPaint);

    // Sun Core
    final corePaint = Paint()..color = Colors.white;
    canvas.drawCircle(sunCenter, 3.5, corePaint);
  }

  @override
  bool shouldRepaint(covariant _SunArcPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
