import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../view_models/weather_view_model.dart';

class AppSettingsSheet extends StatelessWidget {
  final WeatherViewModel viewModel;

  const AppSettingsSheet({
    super.key,
    required this.viewModel,
  });

  static Future<void> show(BuildContext context, WeatherViewModel viewModel) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppSettingsSheet(viewModel: viewModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF141926).withValues(alpha: 0.94),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Grab handle
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title and Close
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'App Preferences',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(CupertinoIcons.xmark_circle_fill, color: Colors.white54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // 1. Temperature Unit Option
              _buildSettingSection(
                title: 'TEMPERATURE UNIT',
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSegmentButton(
                        label: 'Celsius (°C)',
                        isSelected: !viewModel.useFahrenheit,
                        onTap: () {
                          if (viewModel.useFahrenheit) viewModel.toggleUnit();
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildSegmentButton(
                        label: 'Fahrenheit (°F)',
                        isSelected: viewModel.useFahrenheit,
                        onTap: () {
                          if (!viewModel.useFahrenheit) viewModel.toggleUnit();
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // 2. Wind Unit Option
              _buildSettingSection(
                title: 'WIND SPEED UNIT',
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSegmentButton(
                        label: 'km/h',
                        isSelected: viewModel.windUnit == 'kmh',
                        onTap: () => viewModel.setWindUnit('kmh'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSegmentButton(
                        label: 'mph',
                        isSelected: viewModel.windUnit == 'mph',
                        onTap: () => viewModel.setWindUnit('mph'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSegmentButton(
                        label: 'm/s',
                        isSelected: viewModel.windUnit == 'ms',
                        onTap: () => viewModel.setWindUnit('ms'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // 3. Dynamic Weather Particles Toggle
              _buildSettingSection(
                title: 'ATMOSPHERE & PARTICLES',
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Live Particle Canvas',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Rain streaks, snow drifts, sun rays & stars',
                            style: TextStyle(color: Colors.white54, fontSize: 11),
                          ),
                        ],
                      ),
                      CupertinoSwitch(
                        value: viewModel.particlesEnabled,
                        activeTrackColor: const Color(0xFF1976D2),
                        onChanged: (val) => viewModel.setParticlesEnabled(val),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // About & Data Source
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Text(
                      'Atmosphere Weather v1.2.0',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'High-precision forecasts powered by Open-Meteo API\nAir Quality monitoring by Open-Meteo AQI',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.45),
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.65),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildSegmentButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1976D2).withValues(alpha: 0.75) : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF64B5F6) : Colors.white.withValues(alpha: 0.12),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.7),
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
