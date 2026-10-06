import 'package:flutter/material.dart';

/// Coordenadas geográficas simples, independientes del plugin de mapas.
@immutable
final class GeoPoint {
  const GeoPoint(this.latitude, this.longitude);

  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'lat': latitude,
        'lng': longitude,
      };

  static GeoPoint? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final double? lat =
        double.tryParse((json['lat'] ?? json['latitude'] ?? '').toString());
    final double? lng =
        double.tryParse((json['lng'] ?? json['longitude'] ?? '').toString());
    if (lat == null || lng == null) return null;
    return GeoPoint(lat, lng);
  }

  @override
  bool operator ==(Object other) =>
      other is GeoPoint &&
      other.latitude == latitude &&
      other.longitude == longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);
}

/// Zona de referencia usada cuando no hay GPS disponible.
@immutable
final class ReferenceArea {
  const ReferenceArea({
    required this.name,
    required this.point,
  });

  final String name;
  final GeoPoint point;
}

/// Estado del permiso de ubicación.
enum LocationPermissionStatus { granted, denied, permanentlyDenied, unavailable }

/// Puerto de ubicación.
///
/// La implementación incluida ([ManualLocationService]) funciona sin plugins:
/// el usuario elige una zona de referencia que se guarda localmente. Para GPS
/// real se conecta `geolocator` + `permission_handler` siguiendo
/// `docs/plugins.md`.
abstract interface class LocationService {
  Future<LocationPermissionStatus> checkPermission();

  Future<LocationPermissionStatus> requestPermission();

  Future<GeoPoint?> currentPosition();

  Future<void> openSettings();
}

/// Implementación sin plugins basada en zonas de referencia.
final class ManualLocationService implements LocationService {
  ManualLocationService({GeoPoint? fallback})
      : fallback = fallback ?? areas.first.point;

  /// Zonas sugeridas (centros urbanos de México).
  static const List<ReferenceArea> areas = <ReferenceArea>[
    ReferenceArea(name: 'Ciudad de México', point: GeoPoint(19.4326, -99.1332)),
    ReferenceArea(name: 'Guadalajara', point: GeoPoint(20.6597, -103.3496)),
    ReferenceArea(name: 'Monterrey', point: GeoPoint(25.6866, -100.3161)),
    ReferenceArea(name: 'Puebla', point: GeoPoint(19.0414, -98.2063)),
    ReferenceArea(name: 'Querétaro', point: GeoPoint(20.5888, -100.3899)),
    ReferenceArea(name: 'Mérida', point: GeoPoint(20.9674, -89.5926)),
    ReferenceArea(name: 'Tijuana', point: GeoPoint(32.5149, -117.0382)),
    ReferenceArea(name: 'León', point: GeoPoint(21.125, -101.686)),
  ];

  final GeoPoint fallback;

  @override
  Future<LocationPermissionStatus> checkPermission() async =>
      LocationPermissionStatus.unavailable;

  @override
  Future<LocationPermissionStatus> requestPermission() async =>
      LocationPermissionStatus.unavailable;

  @override
  Future<GeoPoint?> currentPosition() async => fallback;

  @override
  Future<void> openSettings() async {}

  static ReferenceArea? areaByName(String? name) {
    if (name == null) return null;
    for (final ReferenceArea area in areas) {
      if (area.name == name) return area;
    }
    return null;
  }
}
