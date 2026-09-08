import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/models/location_model.dart';
import '../../view_models/weather_view_model.dart';

class CitySearchSheet extends StatefulWidget {
  final WeatherViewModel viewModel;

  const CitySearchSheet({super.key, required this.viewModel});

  static Future<void> show(BuildContext context, WeatherViewModel viewModel) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (context) => CitySearchSheet(viewModel: viewModel),
    );
  }

  @override
  State<CitySearchSheet> createState() => _CitySearchSheetState();
}

class _CitySearchSheetState extends State<CitySearchSheet> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      widget.viewModel.searchCities(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isSearching = widget.viewModel.isSearching;
    final results = widget.viewModel.searchResults;
    final favorites = widget.viewModel.favoriteLocations;
    final popular = widget.viewModel.isSearching
        ? <LocationModel>[]
        : [
            const LocationModel(
              name: 'Tokyo',
              country: 'Japan',
              countryCode: 'JP',
              latitude: 35.6762,
              longitude: 139.6503,
            ),
            const LocationModel(
              name: 'Paris',
              country: 'France',
              countryCode: 'FR',
              latitude: 48.8566,
              longitude: 2.3522,
            ),
            const LocationModel(
              name: 'New York',
              country: 'United States',
              countryCode: 'US',
              latitude: 40.7128,
              longitude: -74.0060,
            ),
            const LocationModel(
              name: 'London',
              country: 'United Kingdom',
              countryCode: 'GB',
              latitude: 51.5074,
              longitude: -0.1278,
            ),
            const LocationModel(
              name: 'Nairobi',
              country: 'Kenya',
              countryCode: 'KE',
              latitude: -1.2921,
              longitude: 36.8219,
            ),
            const LocationModel(
              name: 'Dubai',
              country: 'United Arab Emirates',
              countryCode: 'AE',
              latitude: 25.2048,
              longitude: 55.2708,
            ),
          ];

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: mediaQuery.size.height * 0.82,
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 12,
              bottom: mediaQuery.viewInsets.bottom + 20,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF141A29).withValues(alpha: 0.92),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pull Bar Indicator
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Title & Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Locations & Forecast',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        CupertinoIcons.xmark_circle_fill,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        widget.viewModel.clearSearch();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.search,
                        color: Colors.white70,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onChanged: _onSearchChanged,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search city or region...',
                            hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      if (_controller.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(
                            CupertinoIcons.clear_thick_circled,
                            color: Colors.white54,
                            size: 18,
                          ),
                          onPressed: () {
                            _controller.clear();
                            widget.viewModel.clearSearch();
                            setState(() {});
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Current Location Quick Action
                GestureDetector(
                  onTap: () {
                    widget.viewModel.switchToCurrentLocation();
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF1976D2).withValues(alpha: 0.4),
                          const Color(0xFF0D47A1).withValues(alpha: 0.4),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF64B5F6).withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E88E5)
                                .withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            CupertinoIcons.location_fill,
                            color: Color(0xFF90CAF9),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Use Current Location',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                widget.viewModel.currentLocation != null
                                    ? widget
                                          .viewModel
                                          .currentLocation!
                                          .displayName
                                    : 'GPS & Network Geolocation',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.65),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          CupertinoIcons.chevron_right,
                          color: Colors.white54,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Search Results or Favorites + Popular
                Expanded(
                  child: isSearching
                      ? const Center(
                          child: CupertinoActivityIndicator(
                            color: Colors.white,
                            radius: 14,
                          ),
                        )
                      : results.isNotEmpty
                      ? _buildSearchResults(results)
                      : _buildFavoritesAndPopular(favorites, popular),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<LocationModel> results) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: results.length,
      separatorBuilder: (context, index) =>
          Divider(color: Colors.white.withValues(alpha: 0.08)),
      itemBuilder: (context, index) {
        final loc = results[index];
        final isFav = widget.viewModel.isLocationFavorite(loc);

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 2,
          ),
          leading: const Icon(
            CupertinoIcons.placemark,
            color: Color(0xFF90CAF9),
          ),
          title: Text(
            loc.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            loc.displayName,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              isFav ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
              color: isFav ? const Color(0xFFFF5252) : Colors.white54,
              size: 22,
            ),
            onPressed: () => widget.viewModel.toggleFavorite(loc),
          ),
          onTap: () {
            widget.viewModel.selectLocation(loc);
            widget.viewModel.clearSearch();
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Widget _buildFavoritesAndPopular(
    List<LocationModel> favorites,
    List<LocationModel> popular,
  ) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        if (favorites.isNotEmpty) ...[
          Row(
            children: [
              const Icon(
                CupertinoIcons.heart_fill,
                color: Color(0xFFFF5252),
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                'SAVED FAVORITES',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...favorites.map((fav) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              child: ListTile(
                leading: const Icon(
                  CupertinoIcons.building_2_fill,
                  color: Color(0xFF64B5F6),
                  size: 20,
                ),
                title: Text(
                  fav.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  fav.country,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    CupertinoIcons.heart_fill,
                    color: Color(0xFFFF5252),
                    size: 20,
                  ),
                  onPressed: () => widget.viewModel.toggleFavorite(fav),
                ),
                onTap: () {
                  widget.viewModel.selectLocation(fav);
                  Navigator.pop(context);
                },
              ),
            );
          }),
          const SizedBox(height: 16),
        ],

        Row(
          children: [
            const Icon(
              CupertinoIcons.globe,
              color: Color(0xFF81D4FA),
              size: 14,
            ),
            const SizedBox(width: 6),
            Text(
              'POPULAR DESTINATIONS',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: popular.map((city) {
            return ActionChip(
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              avatar: const Icon(
                CupertinoIcons.placemark,
                color: Colors.white70,
                size: 14,
              ),
              label: Text(
                city.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                widget.viewModel.selectLocation(city);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
