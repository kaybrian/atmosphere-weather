import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/models/location_model.dart';
import '../../core/app_theme.dart';

class WeatherRadarCard extends StatefulWidget {
  final LocationModel location;
  final double precipitationVolume;

  const WeatherRadarCard({
    super.key,
    required this.location,
    required this.precipitationVolume,
  });

  @override
  State<WeatherRadarCard> createState() => _WeatherRadarCardState();
}

class _WeatherRadarCardState extends State<WeatherRadarCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sweepController;
  bool _isPlaying = true;
  double _zoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _sweepController.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _sweepController.repeat();
      } else {
        _sweepController.stop();
      }
    });
  }

  void _toggleZoom() {
    setState(() {
      _zoomLevel = _zoomLevel == 1.0 ? 1.4 : 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppTheme.glassContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.map_pin_ellipse,
                    size: 14,
                    color: Color(0xFF64B5F6),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'LIVE PRECIPITATION RADAR',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00E676),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'LIVE SWEEP',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Radar View Container
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF070E1A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Stack(
                children: [
                  // Animated Radar Sweep Canvas
                  AnimatedBuilder(
                    animation: _sweepController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(double.infinity, 200),
                        painter: _RadarCanvasPainter(
                          sweepAngle: _sweepController.value * 2 * math.pi,
                          precipVolume: widget.precipitationVolume,
                          zoomLevel: _zoomLevel,
                        ),
                      );
                    },
                  ),

                  // Center Pin & Location Label
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF29B6F6),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF29B6F6)
                                    .withValues(alpha: 0.8),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.my_location,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.location.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Interactive Controls (Play/Pause & Zoom)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildGlassButton(
                          icon: _isPlaying
                              ? CupertinoIcons.pause_fill
                              : CupertinoIcons.play_fill,
                          onTap: _togglePlayback,
                        ),
                        const SizedBox(width: 6),
                        _buildGlassButton(
                          icon: _zoomLevel == 1.0
                              ? CupertinoIcons.plus_circle
                              : CupertinoIcons.minus_circle,
                          onTap: _toggleZoom,
                        ),
                      ],
                    ),
                  ),

                  // Top Left Range Label
                  Positioned(
                    top: 8,
                    left: 10,
                    child: Text(
                      '${(_zoomLevel == 1.0 ? 50 : 25)} km Radius',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Radar Reflectivity dBZ Legend
          Row(
            children: [
              Text(
                'Light',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF81D4FA), // 10 dBZ Light Cyan
                        Color(0xFF66BB6A), // 25 dBZ Green
                        Color(0xFFFFEE58), // 40 dBZ Yellow
                        Color(0xFFFF7043), // 50 dBZ Orange
                        Color(0xFFE53935), // 60 dBZ Red
                        Color(0xFFAB47BC), // 70 dBZ Purple
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Heavy',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: 14),
      ),
    );
  }
}

class _RadarCanvasPainter extends CustomPainter {
  final double sweepAngle;
  final double precipVolume;
  final double zoomLevel;

  _RadarCanvasPainter({
    required this.sweepAngle,
    required this.precipVolume,
    required this.zoomLevel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = (math.min(size.width, size.height) / 2) * zoomLevel;

    // 1. Grid Rings
    final ringPaint = Paint()
      ..color = const Color(0xFF1E88E5).withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(center, (maxRadius / 3) * i, ringPaint);
    }

    // 2. Crosshair Axis Lines
    final axisPaint = Paint()
      ..color = const Color(0xFF1E88E5).withValues(alpha: 0.15)
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(center.dx, 0),
      Offset(center.dx, size.height),
      axisPaint,
    );
    canvas.drawLine(
      Offset(0, center.dy),
      Offset(size.width, center.dy),
      axisPaint,
    );

    // 3. Simulated Precipitation Cloud Cells
    final cells = [
      Offset(center.dx + 40 * zoomLevel, center.dy - 35 * zoomLevel),
      Offset(center.dx - 55 * zoomLevel, center.dy - 20 * zoomLevel),
      Offset(center.dx + 20 * zoomLevel, center.dy + 45 * zoomLevel),
      Offset(center.dx - 30 * zoomLevel, center.dy + 30 * zoomLevel),
      Offset(center.dx + 65 * zoomLevel, center.dy + 15 * zoomLevel),
    ];

    final baseAlpha = (precipVolume > 0 ? 0.65 : 0.35);

    for (int i = 0; i < cells.length; i++) {
      final cell = cells[i];
      final radius = (20.0 + (i * 7.0)) * zoomLevel;

      final cloudPaint = Paint()
        ..color = i % 2 == 0
            ? const Color(0xFF43A047)
                  .withValues(alpha: baseAlpha * 0.4) // Green rain
            : const Color(0xFF039BE5)
                  .withValues(alpha: baseAlpha * 0.5) // Cyan showers
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);

      canvas.drawCircle(cell, radius, cloudPaint);

      // Core of cell
      final corePaint = Paint()
        ..color = i == 0 && precipVolume > 1.0
            ? const Color(0xFFFFB300)
                  .withValues(alpha: 0.7) // Amber heavier core
            : const Color(0xFF4CAF50).withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(cell, radius * 0.45, corePaint);
    }

    // 4. Rotating Radar Sweep Beam with Phosphor Fade Trail
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: 0,
        endAngle: math.pi / 2,
        colors: [
          const Color(0xFF00E676).withValues(alpha: 0.0),
          const Color(0xFF00E676).withValues(alpha: 0.35),
        ],
        transform: GradientRotation(sweepAngle - math.pi / 2),
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius));

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawCircle(center, maxRadius, sweepPaint);

    // Leading sweep line
    final linePaint = Paint()
      ..color = const Color(0xFF69F0AE)
      ..strokeWidth = 1.8;
    final lineEnd = Offset(
      center.dx + maxRadius * math.cos(sweepAngle),
      center.dy + maxRadius * math.sin(sweepAngle),
    );
    canvas.drawLine(center, lineEnd, linePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _RadarCanvasPainter oldDelegate) =>
      oldDelegate.sweepAngle != sweepAngle ||
      oldDelegate.precipVolume != precipVolume ||
      oldDelegate.zoomLevel != zoomLevel;
}
