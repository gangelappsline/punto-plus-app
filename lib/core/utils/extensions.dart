import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../errors/app_exception.dart';
import '../theme/app_palette.dart';

/// Accesos cortos a los recursos dependientes del contexto.
extension BuildContextX on BuildContext {
  /// Textos traducidos de la app.
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Paleta del tema activo (claro u oscuro).
  AppPalette get palette => AppPalette.of(this);

  ColorScheme get colors => Theme.of(this).colorScheme;

  TextTheme get texts => Theme.of(this).textTheme;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Size get viewSize => MediaQuery.sizeOf(this);

  bool get isCompact => MediaQuery.sizeOf(this).width < 380;

  void unfocus() => FocusManager.instance.primaryFocus?.unfocus();

  /// Convierte un error en texto traducido.
  ///
  /// Si el error viene de la app y trae clave de catálogo se traduce; si la API
  /// devolvió su propio mensaje se respeta tal cual.
  String localizeError(Object? error) {
    if (error == null) return l10n.commonErrorGenericMessage;
    if (error is AppException && error.messageKey != null) {
      final String translated = l10n.translate(error.messageKey!);
      if (translated != error.messageKey) return translated;
    }
    final String message = error is AppException ? error.message : error.toString();
    return message.isEmpty ? l10n.commonErrorGenericMessage : message;
  }

  /// Muestra un aviso flotante con el color semántico indicado.
  void showSnack(
    String message, {
    AppSnackKind kind = AppSnackKind.neutral,
    SnackBarAction? action,
  }) {
    final ScaffoldMessengerState? messenger = ScaffoldMessenger.maybeOf(this);
    if (messenger == null) return;
    final AppPalette palette = this.palette;
    final Color background = switch (kind) {
      AppSnackKind.neutral => palette.brandStrong,
      AppSnackKind.success => palette.success,
      AppSnackKind.error => palette.error,
    };
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: background,
          content: Row(
            children: <Widget>[
              Icon(
                switch (kind) {
                  AppSnackKind.neutral => Icons.info_outline_rounded,
                  AppSnackKind.success => Icons.check_circle_outline_rounded,
                  AppSnackKind.error => Icons.error_outline_rounded,
                },
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                  ),
                ),
              ),
            ],
          ),
          action: action,
        ),
      );
  }
}

enum AppSnackKind { neutral, success, error }

extension StringX on String {
  String get capitalized =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  String get digitsOnly => replaceAll(RegExp(r'\D'), '');

  bool get isEmail => RegExp(
        r"^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9-]+(?:\.[A-Za-z0-9-]+)+$",
      ).hasMatch(trim());

  bool get isPhone {
    final String digits = digitsOnly;
    return digits.length >= 10 && digits.length <= 15;
  }

  bool get looksLikePhone => RegExp(r'^\+?[\d\s()-]+$').hasMatch(trim());

  /// Iniciales para avatares ("Ana Pérez" -> "AP").
  String get initials {
    final List<String> parts = trim()
        .split(RegExp(r'\s+'))
        .where((String part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  String elide(int maxLength) =>
      length <= maxLength ? this : '${substring(0, maxLength - 1)}…';
}

extension DateTimeX on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);

  bool get isToday {
    final DateTime now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  Duration get sinceNow => DateTime.now().difference(this);
}
