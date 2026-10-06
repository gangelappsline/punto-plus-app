import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/platform/location_service.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/models/business.dart';

/// Agrupación de negocios cercanos dentro del mapa.
@immutable
final class MarkerCluster {
  const MarkerCluster({
    required this.position,
    required this.businesses,
  });

  final Offset position;
  final List<BusinessModel> businesses;

  bool get isSingle => businesses.length == 1;

  BusinessModel get first => businesses.first;

  double get minDistanceKm {
    double best = double.infinity;
    for (final BusinessModel business in businesses) {
      final double? distance = business.distanceKm;
      if (distance != null && distance < best) best = distance;
    }
    return best;
  }
}

/// Proyección geográfica → píxeles usada por el mapa sin plugins.
final class MapProjection {
  MapProjection({
    required this.centerLatitude,
    required this.centerLongitude,
    required this.spanLatitude,
    required this.spanLongitude,
  });

  /// Construye la proyección a partir de los puntos que se van a dibujar.
  factory MapProjection.fromBusinesses(
    List<BusinessModel> businesses,
    GeoPoint center,
    double radiusKm,
  ) {
    double minLat = center.latitude;
    double maxLat = center.latitude;
    double minLng = center.longitude;
    double maxLng = center.longitude;
    for (final BusinessModel business in businesses) {
      final double? lat = business.latitude;
      final double? lng = business.longitude;
      if (lat == null || lng == null) continue;
      minLat = math.min(minLat, lat);
      maxLat = math.max(maxLat, lat);
      minLng = math.min(minLng, lng);
      maxLng = math.max(maxLng, lng);
    }
    // El círculo del radio visible define el marco mínimo del mapa.
    final double degreeLat = radiusKm / 111.0;
    final double degreeLng = radiusKm /
        (111.0 * math.max(0.2, math.cos(center.latitude * math.pi / 180)));
    final double spanLat = math.max(
      math.max(maxLat - center.latitude, center.latitude - minLat) * 1.25,
      degreeLat,
    );
    final double spanLng = math.max(
      math.max(maxLng - center.longitude, center.longitude - minLng) * 1.25,
      degreeLng,
    );
    return MapProjection(
      centerLatitude: center.latitude,
      centerLongitude: center.longitude,
      spanLatitude: spanLat * 2,
      spanLongitude: spanLng * 2,
    );
  }

  final double centerLatitude;
  final double centerLongitude;
  final double spanLatitude;
  final double spanLongitude;

  /// Convierte coordenadas geográficas en un punto del lienzo.
  Offset project(
    double latitude,
    double longitude, {
    required Size size,
    double padding = 28,
  }) {
    final double usableWidth = math.max(1, size.width - padding * 2);
    final double usableHeight = math.max(1, size.height - padding * 2);
    final double dx =
        (longitude - (centerLongitude - spanLongitude / 2)) / spanLongitude;
    final double dy =
        ((centerLatitude + spanLatitude / 2) - latitude) / spanLatitude;
    return Offset(
      padding + dx.clamp(-0.2, 1.2) * usableWidth,
      padding + dy.clamp(-0.2, 1.2) * usableHeight,
    );
  }

  /// Kilómetros por píxel, usados por la barra de escala.
  double kilometersPerPixel(Size size) {
    final double usableHeight = math.max(1, size.height - 56);
    return (spanLatitude * 111.0) / usableHeight;
  }
}

/// Mapa ligero dibujado con [CustomPainter] (sin plugins de mapas).
///
/// Cuando se integre `google_maps_flutter`, este widget puede sustituirse
/// conservando la misma API (`markers`, `userPoint`, `radiusKm`).
final class MapCanvas extends StatelessWidget {
  const MapCanvas({
    required this.businesses,
    required this.userPoint,
    required this.radiusKm,
    this.onTapCluster,
    this.clusterRadius = 46,
    super.key,
  });

  final List<BusinessModel> businesses;
  final GeoPoint userPoint;
  final double radiusKm;
  final ValueChanged<MarkerCluster>? onTapCluster;
  final double clusterRadius;

  List<MarkerCluster> clusters(Size size) {
    if (size.isEmpty) return const <MarkerCluster>[];
    final MapProjection projection = MapProjection.fromBusinesses(
      businesses,
      userPoint,
      radiusKm,
    );
    final List<MarkerCluster> result = <MarkerCluster>[];
    final List<BusinessModel> pending = businesses
        .where((BusinessModel item) => item.hasCoordinates)
        .toList();
    while (pending.isNotEmpty) {
      final BusinessModel seed = pending.removeAt(0);
      final Offset seedPosition = projection.project(
        seed.latitude!,
        seed.longitude!,
        size: size,
      );
      final List<BusinessModel> group = <BusinessModel>[seed];
      pending.removeWhere((BusinessModel candidate) {
        final Offset position = projection.project(
          candidate.latitude!,
          candidate.longitude!,
          size: size,
        );
        if ((position - seedPosition).distance <= clusterRadius) {
          group.add(candidate);
          return true;
        }
        return false;
      });
      result.add(MarkerCluster(position: seedPosition, businesses: group));
    }
    return result;
  }

  /// Encuentra el punto del negocio más cercano a un toque.
  MarkerCluster? hitTest(Offset local, Size size) {
    MarkerCluster? best;
    double bestDistance = 44;
    for (final MarkerCluster cluster in clusters(size)) {
      final double distance = (cluster.position - local).distance;
      if (distance <= bestDistance) {
        best = cluster;
        bestDistance = distance;
      }
    }
    return best;
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size size = Size(constraints.maxWidth, constraints.maxHeight);
        return GestureDetector(
          onTapUp: (TapUpDetails details) {
            final MarkerCluster? cluster = hitTest(details.localPosition, size);
            if (cluster != null) onTapCluster?.call(cluster);
          },
          child: CustomPaint(
            painter: _MapPainter(
              businesses: businesses,
              userPoint: userPoint,
              radiusKm: radiusKm,
              palette: palette,
              clusters: clusters(size),
            ),
            size: size,
          ),
        );
      },
    );
  }
}

final class _MapPainter extends CustomPainter {
  const _MapPainter({
    required this.businesses,
    required this.userPoint,
    required this.radiusKm,
    required this.palette,
    required this.clusters,
  });

  final List<BusinessModel> businesses;
  final GeoPoint userPoint;
  final double radiusKm;
  final AppPalette palette;
  final List<MarkerCluster> clusters;

  @override
  void paint(Canvas canvas, Size size) {
    final MapProjection projection = MapProjection.fromBusinesses(
      businesses,
      userPoint,
      radiusKm,
    );
    _paintBackground(canvas, size, projection);
    final Offset user = projection.project(
      userPoint.latitude,
      userPoint.longitude,
      size: size,
    );
    _paintRadius(canvas, size, projection, user);
    _paintUser(canvas, user);
    for (final MarkerCluster cluster in clusters) {
      _paintCluster(canvas, cluster);
    }
    _paintScale(canvas, size, projection, user);
  }

  void _paintBackground(
    Canvas canvas,
    Size size,
    MapProjection projection,
  ) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = palette.surfaceAlt,
    );

    final Paint block = Paint()..color = palette.surface;
    final double cell = math.max(46, size.width / 7);
    for (double x = 0; x < size.width; x += cell) {
      for (double y = 0; y < size.height; y += cell) {
        final Rect rect = Rect.fromLTWH(
          x + 5,
          y + 5,
          cell - 12,
          cell - 12,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(7)),
          block,
        );
      }
    }

    final Paint road = Paint()
      ..color = palette.divider
      ..strokeWidth = 3;
    for (double y = cell / 2; y < size.height; y += cell) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), road);
    }
    for (double x = cell / 2; x < size.width; x += cell) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), road);
    }

    final double scale = projection.kilometersPerPixel(size);
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.16),
      math.max(18, 26 * (0.4 / math.max(0.15, scale))),
      Paint()..color = palette.brandSoft.withValues(alpha: 0.5),
    );
  }

  void _paintRadius(
    Canvas canvas,
    Size size,
    MapProjection projection,
    Offset user,
  ) {
    final double radiusPixels =
        (radiusKm / projection.kilometersPerPixel(size)).clamp(20, size.height);
    canvas.drawCircle(
      user,
      radiusPixels,
      Paint()..color = palette.brand.withValues(alpha: 0.08),
    );
    canvas.drawCircle(
      user,
      radiusPixels,
      Paint()
        ..color = palette.brand.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
  }

  void _paintUser(Canvas canvas, Offset user) {
    canvas.drawCircle(
      user,
      16,
      Paint()..color = palette.brand.withValues(alpha: 0.2),
    );
    canvas.drawCircle(user, 7, Paint()..color = palette.brand);
    canvas.drawCircle(
      user,
      7,
      Paint()
        ..color = palette.onBrand
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _paintCluster(Canvas canvas, MarkerCluster cluster) {
    final bool favorite = cluster.businesses.any((BusinessModel b) => b.isFavorite);
    final Color tone = favorite
        ? palette.accent
        : cluster.isSingle
            ? palette.brand
            : palette.brandStrong;
    canvas.drawCircle(
      cluster.position + const Offset(0, 2),
      15,
      Paint()..color = palette.shadow,
    );
    canvas.drawCircle(cluster.position, 14, Paint()..color = tone);
    if (cluster.isSingle) {
      TextPainter(
        text: TextSpan(
          text: (cluster.first.name.isEmpty
                  ? '?'
                  : cluster.first.name.substring(0, 1))
              .toUpperCase(),
          style: TextStyle(
            color: palette.onBrand,
            fontWeight: FontWeight.w900,
            fontSize: 13,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout()
        ..paint(
          canvas,
          cluster.position -
              Offset(
                cluster.first.name.isEmpty ? 3 : 5,
                8,
              ),
        );
    } else {
      TextPainter(
        text: TextSpan(
          text: '${cluster.businesses.length}',
          style: TextStyle(
            color: palette.onBrand,
            fontWeight: FontWeight.w900,
            fontSize: 12,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout()
        ..paint(canvas, cluster.position - const Offset(4, 7));
    }
  }

  void _paintScale(
    Canvas canvas,
    Size size,
    MapProjection projection,
    Offset user,
  ) {
    final double scale = projection.kilometersPerPixel(size);
    final double barPixels = (radiusKm / scale).clamp(24, 96);
    final Offset start = Offset(18, size.height - 22);
    final Paint line = Paint()
      ..color = palette.textMuted
      ..strokeWidth = 2;
    canvas.drawLine(start, start + Offset(barPixels, 0), line);
    canvas.drawLine(start, start - const Offset(0, 5), line);
    canvas.drawLine(
      start + Offset(barPixels, 0),
      start + Offset(barPixels, -5),
      line,
    );
    TextPainter(
      text: TextSpan(
        text: '${radiusKm.toStringAsFixed(0)} km',
        style: TextStyle(
          color: palette.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout()
      ..paint(canvas, start + const Offset(0, 6));

    TextPainter(
      text: TextSpan(
        text: '•',
        style: TextStyle(color: palette.brand, fontSize: 14),
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout()
      ..paint(canvas, user - const Offset(3, 7));
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) =>
      oldDelegate.businesses != businesses ||
      oldDelegate.userPoint != userPoint ||
      oldDelegate.radiusKm != radiusKm ||
      oldDelegate.palette != palette ||
      oldDelegate.clusters.length != clusters.length;
}

/// Contenedor con altura fija que envuelve el mapa ligero.
final class MapPanel extends StatelessWidget {
  const MapPanel({required this.child, this.height = 360, super.key});

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: AppRadius.allLg,
        child: SizedBox(height: height, child: child),
      );
}
