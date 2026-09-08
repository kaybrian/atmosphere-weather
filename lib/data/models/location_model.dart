class LocationModel {
  final String name;
  final String? adminArea;
  final String country;
  final String? countryCode;
  final double latitude;
  final double longitude;
  final bool isCurrentLocation;

  const LocationModel({
    required this.name,
    this.adminArea,
    required this.country,
    this.countryCode,
    required this.latitude,
    required this.longitude,
    this.isCurrentLocation = false,
  });

  String get displayName {
    if (adminArea != null && adminArea!.isNotEmpty && adminArea != name) {
      return '$name, $adminArea';
    }
    if (country.isNotEmpty) {
      return '$name, $country';
    }
    return name;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'adminArea': adminArea,
      'country': country,
      'countryCode': countryCode,
      'latitude': latitude,
      'longitude': longitude,
      'isCurrentLocation': isCurrentLocation,
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'] as String? ?? 'Unknown',
      adminArea: json['adminArea'] as String?,
      country: json['country'] as String? ?? '',
      countryCode: json['countryCode'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      isCurrentLocation: json['isCurrentLocation'] as bool? ?? false,
    );
  }

  LocationModel copyWith({
    String? name,
    String? adminArea,
    String? country,
    String? countryCode,
    double? latitude,
    double? longitude,
    bool? isCurrentLocation,
  }) {
    return LocationModel(
      name: name ?? this.name,
      adminArea: adminArea ?? this.adminArea,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isCurrentLocation: isCurrentLocation ?? this.isCurrentLocation,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationModel &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          name == other.name;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode ^ name.hashCode;
}
