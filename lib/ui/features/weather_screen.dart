import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/models/location_model.dart';
import '../core/app_theme.dart';
import '../core/weather_effects.dart';
import '../view_models/weather_view_model.dart';
import 'components/air_quality_card.dart';
import 'components/app_settings_sheet.dart';
import 'components/city_search_sheet.dart';
import 'components/daily_forecast_card.dart';
import 'components/hero_weather_card.dart';
import 'components/hourly_forecast_card.dart';
import 'components/severe_alert_banner.dart';
import 'components/sun_arc_card.dart';
import 'components/weather_metrics_grid.dart';
import 'components/weather_radar_card.dart';

class WeatherScreen extends StatefulWidget {
  final WeatherViewModel viewModel;

  const WeatherScreen({
    super.key,
    required this.viewModel,
  });

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final vm = widget.viewModel;
        final themeType = vm.activeThemeType;
        final gradientColors = AppTheme.getGradientForTheme(themeType);
        final weather = vm.weatherData;
        final location = vm.selectedLocation;
        final isFahrenheit = vm.useFahrenheit;

        final content = SafeArea(
          child: Column(
            children: [
              // Top Custom Navigation Bar
              _buildTopBar(context, vm, location),

              // Severe Weather Alert Banner (if any)
              if (vm.activeAlerts.isNotEmpty)
                SevereAlertBanner(alerts: vm.activeAlerts),

              // Main Content Body
              Expanded(
                child: vm.isLoading && weather == null
                    ? _buildLoadingView()
                    : vm.errorMessage != null && weather == null
                        ? _buildErrorView(vm)
                        : weather != null && location != null
                            ? _buildWeatherContent(vm, weather, location, isFahrenheit)
                            : const SizedBox.shrink(),
              ),
            ],
          ),
        );

        return Scaffold(
          extendBodyBehindAppBar: true,
          body: AnimatedContainer(
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors,
              ),
            ),
            child: vm.particlesEnabled
                ? WeatherAtmosphereEffect(
                    themeType: themeType,
                    child: content,
                  )
                : content,
          ),
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context, WeatherViewModel vm, LocationModel? location) {
    final isFavorite = location != null && vm.isLocationFavorite(location);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Current Location Fast Button
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.12),
              shape: const CircleBorder(),
            ),
            icon: Icon(
              vm.isCurrentSelected
                  ? CupertinoIcons.location_fill
                  : CupertinoIcons.location,
              color: vm.isCurrentSelected ? const Color(0xFF64B5F6) : Colors.white,
              size: 20,
            ),
            tooltip: 'My Live Location',
            onPressed: () => vm.switchToCurrentLocation(),
          ),

          // Center: City Chips / Favorites quick scroll
          if (vm.favoriteLocations.isNotEmpty)
            Expanded(
              child: SizedBox(
                height: 34,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  children: [
                    if (vm.currentLocation != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          avatar: const Icon(CupertinoIcons.location_fill, size: 12, color: Colors.white),
                          label: const Text('Local'),
                          selected: vm.isCurrentSelected,
                          selectedColor: Colors.white.withValues(alpha: 0.3),
                          backgroundColor: Colors.white.withValues(alpha: 0.08),
                          labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                          side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                          onSelected: (_) => vm.switchToCurrentLocation(),
                        ),
                      ),
                    ...vm.favoriteLocations.map((fav) {
                      final isSelected = location?.name == fav.name;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text(fav.name),
                          selected: isSelected,
                          selectedColor: Colors.white.withValues(alpha: 0.3),
                          backgroundColor: Colors.white.withValues(alpha: 0.08),
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                          onSelected: (_) => vm.selectLocation(fav),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            )
          else
            const Spacer(),

          // Right: Favorite heart + Unit toggle + Search + Settings
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (location != null && !location.isCurrentLocation)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.12),
                    shape: const CircleBorder(),
                  ),
                  icon: Icon(
                    isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                    color: isFavorite ? const Color(0xFFFF5252) : Colors.white,
                    size: 17,
                  ),
                  tooltip: isFavorite ? 'Remove Favorite' : 'Save Favorite',
                  onPressed: () => vm.toggleFavorite(location),
                ),
              const SizedBox(width: 4),

              // Unit Switcher (°C / °F)
              GestureDetector(
                onTap: () => vm.toggleUnit(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    vm.useFahrenheit ? '°F' : '°C',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),

              // Search Button
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.12),
                  shape: const CircleBorder(),
                ),
                icon: const Icon(CupertinoIcons.search, color: Colors.white, size: 18),
                tooltip: 'Search Cities',
                onPressed: () => CitySearchSheet.show(context, vm),
              ),
              const SizedBox(width: 4),

              // Settings Button
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.12),
                  shape: const CircleBorder(),
                ),
                icon: const Icon(CupertinoIcons.gear_alt, color: Colors.white, size: 18),
                tooltip: 'Preferences',
                onPressed: () => AppSettingsSheet.show(context, vm),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherContent(
    WeatherViewModel vm,
    dynamic weather,
    LocationModel location,
    bool isFahrenheit,
  ) {
    return RefreshIndicator(
      onRefresh: () => vm.refreshWeather(),
      color: Colors.white,
      backgroundColor: const Color(0xFF1976D2),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 8),

                // 1. Hero Weather Presentation
                HeroWeatherCard(
                  weather: weather,
                  location: location,
                  isFahrenheit: isFahrenheit,
                  onLocationTap: () => CitySearchSheet.show(context, vm),
                  onCurrentLocationTap: () => vm.switchToCurrentLocation(),
                ),

                const SizedBox(height: 24),

                // 2. 24-Hour Hourly Forecast
                HourlyForecastCard(
                  hourly: weather.hourly,
                  isFahrenheit: isFahrenheit,
                ),

                const SizedBox(height: 16),

                // 3. 7-Day Forecast with relative temperature bars
                DailyForecastCard(
                  daily: weather.daily,
                  currentTemp: weather.current.temperature,
                  weekMinTemp: weather.weekMinTemp,
                  weekMaxTemp: weather.weekMaxTemp,
                  isFahrenheit: isFahrenheit,
                ),

                const SizedBox(height: 16),

                // 4. Live Precipitation Radar Map
                WeatherRadarCard(
                  location: location,
                  precipitationVolume: weather.current.precipitation,
                ),

                const SizedBox(height: 16),

                // 5. Air Quality Index Card
                AirQualityCard(
                  airQuality: vm.airQuality,
                ),

                const SizedBox(height: 16),

                // 6. Comprehensive Atmospheric Metrics Grid
                WeatherMetricsGrid(
                  current: weather.current,
                  isFahrenheit: isFahrenheit,
                  windUnit: vm.windUnit,
                ),

                const SizedBox(height: 16),

                // 7. Sun Arc & Celestial Progression
                SunArcCard(
                  todayForecast: weather.daily.isNotEmpty ? weather.daily.first : null,
                ),

                const SizedBox(height: 24),

                // Footer Info
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.cloud_sun, size: 14, color: Colors.white.withValues(alpha: 0.4)),
                          const SizedBox(width: 6),
                          Text(
                            'Open-Meteo Weather & Air Quality API',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.45),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pull down to refresh anytime',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.35),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: const CupertinoActivityIndicator(color: Colors.white, radius: 18),
          ),
          const SizedBox(height: 20),
          const Text(
            'Fetching Local Atmosphere...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Determining coordinates, radar & air quality',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(WeatherViewModel vm) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(CupertinoIcons.wifi_exclamationmark, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 20),
            const Text(
              'Weather Unavailable',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              vm.errorMessage ?? 'Unable to fetch weather data at this moment.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0D47A1),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              icon: const Icon(CupertinoIcons.refresh),
              label: const Text('Try Again', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () => vm.init(),
            ),
          ],
        ),
      ),
    );
  }
}
