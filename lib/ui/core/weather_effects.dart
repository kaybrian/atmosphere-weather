import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../data/models/weather_model.dart';

class WeatherAtmosphereEffect extends StatefulWidget {
  final WeatherThemeType themeType;
  final Widget child;

  const WeatherAtmosphereEffect({
    super.key,
    required this.themeType,
    required this.child,
  });

  @override
  State<WeatherAtmosphereEffect> createState() => _WeatherAtmosphereEffectState();
}

class _WeatherAtmosphereEffectState extends State<WeatherAtmosphereEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Particle> _particles = [];
  final math.Random _random = math.Random(42);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _initParticles();
  }

  @override
  void didUpdateWidget(covariant WeatherAtmosphereEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.themeType != widget.themeType) {
      _initParticles();
    }
  }

  void _initParticles() {
    _particles.clear();
    final count = _getParticleCount(widget.themeType);
    for (int i = 0; i < count; i++) {
      _particles.add(_Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        speed: 0.2 + _random.nextDouble() * 0.8,
        size: 1.0 + _random.nextDouble() * 3.5,
        opacity: 0.2 + _random.nextDouble() * 0.8,
        phase: _random.nextDouble() * 2 * math.pi,
      ));
    }
  }

  int _getParticleCount(WeatherThemeType type) {
    switch (type) {
      case WeatherThemeType.rainy:
        return 75;
      case WeatherThemeType.thunderstorm:
        return 90;
      case WeatherThemeType.snowy:
        return 60;
      case WeatherThemeType.clearNight:
        return 65;
      case WeatherThemeType.clearDay:
        return 25;
      case WeatherThemeType.cloudyDay:
      case WeatherThemeType.cloudyNight:
      case WeatherThemeType.foggy:
        return 20;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _AtmospherePainter(
            themeType: widget.themeType,
            particles: _particles,
            progress: _controller.value,
          ),
          child: widget.child,
        );
      },
    );
  }
}

class _Particle {
  double x;
  double y;
  double speed;
  double size;
  double opacity;
  double phase;

  _Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.opacity,
    required this.phase,
  });
}

class _AtmospherePainter extends CustomPainter {
  final WeatherThemeType themeType;
  final List<_Particle> particles;
  final double progress;

  _AtmospherePainter({
    required this.themeType,
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    switch (themeType) {
      case WeatherThemeType.rainy:
        _paintRain(canvas, size);
        break;
      case WeatherThemeType.thunderstorm:
        _paintThunderstorm(canvas, size);
        break;
      case WeatherThemeType.snowy:
        _paintSnow(canvas, size);
        break;
      case WeatherThemeType.clearNight:
        _paintStarfield(canvas, size);
        break;
      case WeatherThemeType.clearDay:
        _paintSunbeams(canvas, size);
        break;
      case WeatherThemeType.cloudyDay:
      case WeatherThemeType.cloudyNight:
      case WeatherThemeType.foggy:
        _paintMist(canvas, size);
        break;
    }
  }

  void _paintRain(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;

    for (final p in particles) {
      final yOffset = ((p.y + progress * (1.8 * p.speed)) % 1.0) * size.height;
      final xOffset = ((p.x - progress * 0.15) % 1.0) * size.width;
      final length = 14.0 * p.speed;

      canvas.drawLine(
        Offset(xOffset, yOffset),
        Offset(xOffset - 3, yOffset + length),
        paint..color = Colors.white.withValues(alpha: p.opacity * 0.5),
      );
    }
  }

  void _paintThunderstorm(Canvas canvas, Size size) {
    _paintRain(canvas, size);

    // Dynamic lightning flash
    final flashCycle = (progress * 5) % 1.0;
    if (flashCycle > 0.94) {
      final flashIntensity = (flashCycle - 0.94) / 0.06;
      final flashAlpha = (math.sin(flashIntensity * math.pi) * 0.35).clamp(0.0, 0.4);
      final flashPaint = Paint()..color = const Color(0xFFE0E5FF).withValues(alpha: flashAlpha);
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), flashPaint);
    }
  }

  void _paintSnow(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      final yOffset = ((p.y + progress * (0.35 * p.speed)) % 1.0) * size.height;
      // Gentle horizontal swaying
      final sway = math.sin(progress * 2 * math.pi + p.phase) * 15;
      final xOffset = ((p.x * size.width) + sway) % size.width;

      paint.color = Colors.white.withValues(alpha: p.opacity * 0.75);
      canvas.drawCircle(Offset(xOffset, yOffset), p.size, paint);
    }
  }

  void _paintStarfield(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      final xOffset = p.x * size.width;
      final yOffset = p.y * (size.height * 0.65); // Keep stars mostly in upper sky

      // Twinkle effect
      final twinkle = (math.sin(progress * 4 * math.pi + p.phase) + 1.0) / 2.0;
      final starOpacity = (p.opacity * twinkle).clamp(0.15, 0.95);

      paint.color = Colors.white.withValues(alpha: starOpacity);
      canvas.drawCircle(Offset(xOffset, yOffset), p.size * 0.8, paint);

      // Subtle star glow for larger stars
      if (p.size > 2.5) {
        paint.color = const Color(0xFFB0C4DE).withValues(alpha: starOpacity * 0.3);
        canvas.drawCircle(Offset(xOffset, yOffset), p.size * 2.0, paint);
      }
    }
  }

  void _paintSunbeams(Canvas canvas, Size size) {
    // Glowing sun aura in top-right
    final sunCenter = Offset(size.width * 0.82, size.height * 0.12);
    final pulse = 0.95 + 0.05 * math.sin(progress * 2 * math.pi);

    final auraPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFE082).withValues(alpha: 0.35 * pulse),
          const Color(0xFFFFB74D).withValues(alpha: 0.15 * pulse),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Rect.fromCircle(center: sunCenter, radius: 180));

    canvas.drawCircle(sunCenter, 180, auraPaint);

    // Floating sun dust motes
    final motePaint = Paint()..style = PaintingStyle.fill;
    for (final p in particles) {
      final yOffset = ((p.y - progress * 0.08 * p.speed) % 1.0) * size.height;
      final xOffset = ((p.x + math.sin(progress * math.pi + p.phase) * 0.04) % 1.0) * size.width;
      final moteOpacity = (0.2 + 0.3 * math.sin(progress * 2 * math.pi + p.phase)).clamp(0.0, 0.4);

      motePaint.color = const Color(0xFFFFF9C4).withValues(alpha: moteOpacity);
      canvas.drawCircle(Offset(xOffset, yOffset), p.size * 0.9, motePaint);
    }
  }

  void _paintMist(Canvas canvas, Size size) {
    // Drifting subtle fog bands
    final drift = (progress * size.width * 0.2) % size.width;
    final fogPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.05),
          Colors.white.withValues(alpha: 0.12),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.save();
    canvas.translate(drift - size.width * 0.2, 0);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.25),
        width: size.width * 1.5,
        height: 180,
      ),
      fogPaint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AtmospherePainter oldDelegate) => true;
}
