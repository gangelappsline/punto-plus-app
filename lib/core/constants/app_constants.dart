import 'package:flutter/material.dart';

/// Constantes de producto compartidas entre features.
abstract final class AppConstants {
  /// Radios ofrecidos en el mapa (km).
  static const List<double> radiusOptions = <double>[1, 5, 10];

  static const double defaultRadiusKm = 5;

  /// Longitud del código OTP enviado por el backend.
  static const int otpLength = 6;

  /// Segundos antes de permitir reenviar el código.
  static const int otpResendSeconds = 60;

  /// Cada cuánto se regenera el QR del cliente.
  static const Duration qrRefreshInterval = Duration(minutes: 5);

  /// Sellos necesarios por omisión al crear una tarjeta.
  static const int defaultRequiredStamps = 10;

  static const int minRequiredStamps = 2;
  static const int maxRequiredStamps = 30;

  /// Clave de almacenamiento del código de referido en la caché local.
  static const String referralCodeKey = 'referral.code';

  /// Colores sugeridos para nuevas tarjetas de fidelidad.
  static const List<String> cardColorPresets = <String>[
    '#007D8D',
    '#003F60',
    '#6C5CE7',
    '#E17055',
    '#1B9C6B',
    '#C33B43',
    '#D98A00',
    '#2D3436',
  ];

  /// Categorías usadas por el filtro del mapa.
  static const List<String> categorySlugs = <String>[
    'cafe',
    'restaurante',
    'panaderia',
    'estetica',
    'tienda',
    'servicios',
  ];

  static const Duration debounce = Duration(milliseconds: 350);
  static const Duration splashMinimum = Duration(milliseconds: 900);
}

/// Iconos asociados a cada categoría del mapa.
IconData iconForCategory(String slug) {
  switch (slug) {
    case 'cafe':
      return Icons.local_cafe_outlined;
    case 'restaurante':
      return Icons.restaurant_outlined;
    case 'panaderia':
      return Icons.bakery_dining_outlined;
    case 'estetica':
      return Icons.content_cut_outlined;
    case 'tienda':
      return Icons.storefront_outlined;
    case 'servicios':
      return Icons.handyman_outlined;
    default:
      return Icons.place_outlined;
  }
}
