# Changelog

All notable changes to the Atmosphere Weather project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.2.0] - 2026-09-08

### Added
- **Air Quality Index (AQI)**: Real-time telemetry via Open-Meteo Air Quality API with US AQI rating, EPA spectrum bar, and PM2.5, PM10, NO₂, and O₃ breakdown.
- **Live Weather Radar Map**: 60fps rotating radar sweep beam with simulated cloud precipitation cells across the dBZ reflectivity scale, play/pause controls, and zoom toggles.
- **Severe Weather Advisories**: Dynamic condition evaluator generating alerts for severe thunderstorms, gale winds, excessive heat/UV, flash floods, and hazardous air quality.
- **App Preferences & Settings Sheet**: Customizer modal for temperature units (°C/°F), wind speed units (km/h, mph, m/s), and particle physics toggles.
- **Physical iOS Device Deployment**: Full support for running natively on physical iPhones with Apple Metal hardware acceleration via Impeller.

### Changed
- Refactored color system to Flutter 3.24+ standards (`withValues(alpha: ...)`).
- Enhanced TopBar layout and visual density for compact mobile devices.

---

## [1.0.0] - 2026-09-08

### Added
- Initial release of Atmosphere Weather.
- 60fps dynamic atmospheric canvas effects (rain streaks, snowflakes, starfields, sunbeams, fog).
- Hero weather presentation card with ambient radial glows and live GPS indicator.
- 24-hour horizontal forecast timeline.
- 7-day daily forecast with relative temperature gradient range bars.
- Comprehensive atmospheric metrics grid (UV index, wind speed with rotating compass dial, humidity, feels-like, and pressure).
- Celestial solar arc curve tracking sunrise and sunset.
- Global city search with debounced autocomplete and favorite bookmarking.
- Hybrid Geolocation with GPS and automatic IP fallback.
