# 🌦️ Atmosphere Weather

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.24+-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.5+-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Platform-iOS%20|%20Android%20|%20macOS-blue?style=for-the-badge" alt="Platforms" />
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="License" />
  <img src="https://img.shields.io/badge/API-Open--Meteo-FF6F00?style=for-the-badge" alt="Open-Meteo" />
</p>

<p align="center">
  <strong>Atmosphere</strong> is an open-source, visually captivating weather application built with Flutter. It delivers hyper-local real-time weather forecasts, live canvas particle physics, an interactive precipitation radar sweep, real-time Air Quality Index (AQI) telemetry, severe weather advisories, and responsive glassmorphic aesthetics.
</p>

---

## ✨ Features

### 🌪️ Dynamic Atmospheric Particle Physics
- **60fps Custom Canvas Simulation**: Procedural particle engine rendering:
  - 🌧️ **Rain & Drizzle**: Diagonal falling rain streaks with randomized lengths, velocities, and thunder flashes.
  - ❄️ **Snow**: Softly drifting snowflakes with horizontal sinusoidal sway.
  - ✨ **Clear Night**: Twinkling starfield with pulse randomized luminances.
  - ☀️ **Clear Day**: Warm sunray beams and radial atmospheric glow.
  - ☁️ **Cloudy & Fog**: Flowing multi-depth mist layers.
- **Adaptive Ambient Palettes**: Automatically morphs across 6 custom gradient palettes based on local time and WMO weather codes.

### 🎨 Glassmorphic Modern UI
- **Hero Weather Card**: Prominent temperature display, ambient halo glow, condition pill, and live GPS locator badge.
- **24-Hour Hourly Timeline**: Smooth horizontal scroll featuring precipitation probability badges (💧 %) and micro-weather icons.
- **7-Day Forecast with Relative Range Bars**: Visual temperature span bars displaying weekly maximum and minimum ranges with a real-time current temperature dot.
- **Live Animated Weather Radar**:
  - Rotating 360° radar sweep beam with fading phosphorescent trail.
  - Procedural precipitation cloud cells with standard dBZ reflectivity color scale (Cyan ➔ Green ➔ Amber ➔ Red).
  - Play, pause, and zoom range controls (25 km vs 50 km).
- **Air Quality Index (AQI)**:
  - Real-time US AQI score with color category indicators (`Good`, `Moderate`, `Unhealthy`, `Hazardous`).
  - EPA full-spectrum gradient progress bar.
  - Outdoor health advice and pollutant breakdown (**PM2.5**, **PM10**, **NO₂**, **O₃**).
- **Comprehensive Atmospheric Metrics**: UV index gauge, rotating wind compass dial, relative humidity moisture bar, barometric surface pressure, and feels-like temperature.
- **Celestial Solar Arc**: Bezier curve visualizing sunrise, sunset, current solar position, and sunset countdown.
- **Severe Weather Advisories**: Contextual advisory banners with expandable emergency instruction dialogs.
- **Global City Search & Favorites**: Debounced geocoding search, saved bookmarks, and popular destination quick chips.
- **Custom App Preferences**: Custom unit switchers (°C / °F, km/h, mph, m/s) and live particle engine toggles.

---

## 🏛️ Architecture

Built following clean **Model-View-ViewModel (MVVM)** architecture with layered separation:

```
lib/
├── data/
│   ├── models/
│   │   ├── air_quality_model.dart       # AQI models, EPA categories, & health advice
│   │   ├── location_model.dart          # GPS, Geocoding, and IP location models
│   │   ├── weather_alert_model.dart     # Dynamic severe weather condition evaluator
│   │   └── weather_model.dart           # Open-Meteo JSON parser & WMO condition mapping
│   ├── services/
│   │   ├── weather_api_service.dart     # REST client for Weather & Air Quality APIs
│   │   ├── geocoding_service.dart       # Open-Meteo global geocoding search
│   │   ├── location_service.dart        # Hybrid GPS + IP Geolocation fallback
│   │   └── storage_service.dart         # Preferences persistence (units, favorites, particles)
│   └── repositories/
│       └── weather_repository.dart      # Single source of truth orchestrator
├── ui/
│   ├── core/
│   │   ├── app_theme.dart               # Glassmorphism containers, themes, gradients, formatters
│   │   └── weather_effects.dart         # 60fps dynamic canvas atmospheric particle physics
│   ├── features/
│   │   ├── components/
│   │   │   ├── air_quality_card.dart    # AQI card with spectrum bar & pollutant breakdown
│   │   │   ├── app_settings_sheet.dart  # Modal settings for units & particles
│   │   │   ├── city_search_sheet.dart   # City search with autocomplete & favorites
│   │   │   ├── daily_forecast_card.dart # 7-day forecast with weekly temperature range bars
│   │   │   ├── hero_weather_card.dart   # Main hero temperature & condition display
│   │   │   ├── hourly_forecast_card.dart# 24-hour horizontal forecast timeline
│   │   │   ├── severe_alert_banner.dart # Glowing alert banner & expandable details
│   │   │   ├── sun_arc_card.dart        # Real-time solar trajectory arc
│   │   │   ├── weather_metrics_grid.dart# UV, Wind compass, Humidity, Pressure, Feels Like
│   │   │   └── weather_radar_card.dart  # Animated radar sweep & precipitation clusters
│   │   └── weather_screen.dart          # Master screen with pull-to-refresh
│   └── view_models/
│       └── weather_view_model.dart      # State management (ListenableBuilder / ChangeNotifier)
└── main.dart                            # System UI overlays, immersive dark theme
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version `>=3.24.0`)
- [Dart SDK](https://dart.dev/get-dart) (version `>=3.5.0`)
- Xcode (for iOS and macOS development)
- Android Studio / Android SDK (for Android development)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/kaybrian/atmosphere-weather.git
   cd atmosphere-weather
   ```

2. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run tests & static analysis:**
   ```bash
   flutter analyze
   flutter test
   ```

4. **Launch the app:**
   - **On iOS Simulator / Device:**
     ```bash
     flutter run -d ios
     ```
   - **On Android Emulator / Device:**
     ```bash
     flutter run -d android
     ```
   - **On macOS Desktop:**
     ```bash
     flutter run -d macos
     ```

---

## 🛰️ Open Data & Attribution

Atmosphere relies exclusively on free, open, keyless public APIs:
- **[Open-Meteo Weather Forecast API](https://open-meteo.com/)**: High-resolution weather models, hourly timelines, and 7-day forecasts.
- **[Open-Meteo Air Quality API](https://open-meteo.com/en/docs/air-quality-api)**: Real-time AQI, particulate matter (PM2.5, PM10), and atmospheric pollutants.
- **[Open-Meteo Geocoding API](https://open-meteo.com/en/docs/geocoding-api)**: Global city search and coordinate discovery.

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!
Please review our [Contributing Guidelines](CONTRIBUTING.md) and [Code of Conduct](CODE_OF_CONDUCT.md) before submitting pull requests.

---

## 📄 License

This project is licensed under the terms of the [MIT License](LICENSE).
