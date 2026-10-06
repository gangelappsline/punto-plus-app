import 'package:flutter/material.dart';

import '../../../../core/utils/json.dart';

/// Negocio participante en el programa de fidelidad.
final class BusinessModel {
  const BusinessModel({
    required this.id,
    required this.name,
    this.slug,
    this.description,
    this.logoUrl,
    this.coverUrl,
    this.address,
    this.phone,
    this.latitude,
    this.longitude,
    this.galleryUrls = const <String>[],
    this.openingHours = const <String, String>{},
    this.category,
    this.distanceKm,
    this.isFavorite = false,
    this.isOpenNow,
    this.rating,
    this.ratingCount = 0,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    final dynamic hours = Json.pick(
      json,
      <String>['opening_hours', 'openingHours', 'schedule', 'hours'],
    );

    return BusinessModel(
      id: Json.text(Json.pick(json, <String>['id', 'uuid'])),
      name: Json.text(
        Json.pick(json, <String>['name', 'business_name', 'title']),
        fallback: 'Negocio',
      ),
      slug: Json.textOrNull(json['slug']),
      description: Json.textOrNull(json['description']),
      logoUrl: Json.textOrNull(
        Json.pick(json, <String>['logo_url', 'logoUrl', 'logo']),
      ),
      coverUrl: Json.textOrNull(
        Json.pick(json, <String>['cover_url', 'coverUrl', 'image_url']),
      ),
      address: Json.textOrNull(
        Json.pick(json, <String>['address', 'full_address', 'street']),
      ),
      phone: Json.textOrNull(Json.pick(json, <String>['phone', 'mobile'])),
      latitude: Json.decimalOrNull(
        Json.pick(json, <String>['latitude', 'lat']),
      ),
      longitude: Json.decimalOrNull(
        Json.pick(json, <String>['longitude', 'lng', 'lon']),
      ),
      galleryUrls: Json.strings(
        Json.pick(json, <String>['gallery_urls', 'galleryUrls', 'gallery']),
      ),
      openingHours: _parseHours(hours),
      category: Json.textOrNull(
        Json.pick(json, <String>['category', 'category_slug', 'type']),
      ),
      distanceKm: Json.decimalOrNull(
        Json.pick(json, <String>['distance_km', 'distanceKm', 'distance']),
      ),
      isFavorite: Json.boolean(
        Json.pick(json, <String>['is_favorite', 'isFavorite', 'favorite']),
      ),
      isOpenNow: Json.pick(json, <String>['is_open_now', 'isOpenNow']) == null
          ? null
          : Json.boolean(
              Json.pick(json, <String>['is_open_now', 'isOpenNow']),
            ),
      rating: Json.decimalOrNull(
        Json.pick(json, <String>['rating', 'average_rating']),
      ),
      ratingCount: Json.integer(
        Json.pick(json, <String>['rating_count', 'ratingCount', 'reviews']),
      ),
    );
  }

  final String id;
  final String name;
  final String? slug;
  final String? description;
  final String? logoUrl;
  final String? coverUrl;
  final String? address;
  final String? phone;
  final double? latitude;
  final double? longitude;
  final List<String> galleryUrls;
  final Map<String, String> openingHours;
  final String? category;
  final double? distanceKm;
  final bool isFavorite;
  final bool? isOpenNow;
  final double? rating;
  final int ratingCount;

  bool get hasCoordinates => latitude != null && longitude != null;

  /// Horario del día actual ("09:00 – 18:00") cuando está disponible.
  String? todayHours([DateTime? reference]) {
    if (openingHours.isEmpty) return null;
    final DateTime now = reference ?? DateTime.now();
    const List<String> keys = <String>[
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    final String key = keys[now.weekday - 1];
    final String? value = openingHours[key] ?? openingHours[key.substring(0, 3)];
    if (value == null || value.isEmpty) return null;
    return value.replaceAll('-', ' – ');
  }

  BusinessModel copyWith({
    bool? isFavorite,
    double? distanceKm,
    bool? isOpenNow,
  }) =>
      BusinessModel(
        id: id,
        name: name,
        slug: slug,
        description: description,
        logoUrl: logoUrl,
        coverUrl: coverUrl,
        address: address,
        phone: phone,
        latitude: latitude,
        longitude: longitude,
        galleryUrls: galleryUrls,
        openingHours: openingHours,
        category: category,
        distanceKm: distanceKm ?? this.distanceKm,
        isFavorite: isFavorite ?? this.isFavorite,
        isOpenNow: isOpenNow ?? this.isOpenNow,
        rating: rating,
        ratingCount: ratingCount,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        if (slug != null) 'slug': slug,
        if (description != null) 'description': description,
        if (logoUrl != null) 'logo_url': logoUrl,
        if (coverUrl != null) 'cover_url': coverUrl,
        if (address != null) 'address': address,
        if (phone != null) 'phone': phone,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        'gallery_urls': galleryUrls,
        'opening_hours': openingHours,
        if (category != null) 'category': category,
        if (distanceKm != null) 'distance_km': distanceKm,
        'is_favorite': isFavorite,
        if (isOpenNow != null) 'is_open_now': isOpenNow,
        if (rating != null) 'rating': rating,
        'rating_count': ratingCount,
      };

  static Map<String, String> _parseHours(dynamic value) {
    if (value == null) return const <String, String>{};
    if (value is Map) {
      final Map<String, String> result = <String, String>{};
      value.forEach((dynamic key, dynamic item) {
        final String day = key.toString().toLowerCase();
        if (item is Map) {
          final String open = Json.text(item['open'] ?? item['from']);
          final String close = Json.text(item['close'] ?? item['to']);
          if (open.isNotEmpty || close.isNotEmpty) {
            result[day] = '$open-${close.isEmpty ? '—' : close}';
          }
        } else {
          final String text = item?.toString() ?? '';
          if (text.isNotEmpty) result[day] = text;
        }
      });
      return result;
    }
    return <String, String>{'text': value.toString()};
  }
}

/// Punto de un negocio listo para dibujarse en el mapa o listarse.
@immutable
final class BusinessMarker {
  const BusinessMarker({required this.business, required this.position});

  final BusinessModel business;
  final Offset position;

  bool get isFavorite => business.isFavorite;
}
