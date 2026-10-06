import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import 'extensions.dart';

/// Formatos de fecha, número y distancia para México (es-MX / en-US).
abstract final class AppFormatters {
  static const List<String> _monthsEs = <String>[
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];

  static const List<String> _monthsShortEs = <String>[
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic',
  ];

  static const List<String> _monthsEn = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const List<String> _monthsShortEn = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const List<String> _weekdaysEs = <String>[
    'lunes',
    'martes',
    'miércoles',
    'jueves',
    'viernes',
    'sábado',
    'domingo',
  ];

  static const List<String> _weekdaysEn = <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static bool _isEnglish(BuildContext context) =>
      context.l10n.locale.languageCode == 'en';

  /// Fecha larga: "12 de marzo de 2026" / "March 12, 2026".
  static String longDate(BuildContext context, DateTime? value) {
    if (value == null) return '';
    final DateTime date = value.toLocal();
    if (_isEnglish(context)) {
      return '${_monthsEn[date.month - 1]} ${date.day}, ${date.year}';
    }
    return '${date.day} de ${_monthsEs[date.month - 1]} de ${date.year}';
  }

  /// Fecha corta: "12 mar 2026" / "Mar 12, 2026".
  static String shortDate(BuildContext context, DateTime? value) {
    if (value == null) return '';
    final DateTime date = value.toLocal();
    if (_isEnglish(context)) {
      return '${_monthsShortEn[date.month - 1]} ${date.day}, ${date.year}';
    }
    return '${date.day} ${_monthsShortEs[date.month - 1]} ${date.year}';
  }

  /// Día y mes: "12 mar" / "Mar 12".
  static String dayMonth(BuildContext context, DateTime? value) {
    if (value == null) return '';
    final DateTime date = value.toLocal();
    if (_isEnglish(context)) {
      return '${_monthsShortEn[date.month - 1]} ${date.day}';
    }
    return '${date.day} ${_monthsShortEs[date.month - 1]}';
  }

  /// Hora en formato 24 h: "14:05".
  static String time(BuildContext context, DateTime? value) {
    if (value == null) return '';
    final DateTime date = value.toLocal();
    final String hour = date.hour.toString().padLeft(2, '0');
    final String minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Fecha y hora: "12 mar 2026 · 14:05".
  static String dateTime(BuildContext context, DateTime? value) {
    if (value == null) return '';
    return '${shortDate(context, value)} · ${time(context, value)}';
  }

  static String weekday(BuildContext context, DateTime value) {
    final int index = value.toLocal().weekday - 1;
    return _isEnglish(context) ? _weekdaysEn[index] : _weekdaysEs[index];
  }

  /// Tiempo relativo: "Hace 5 min", "Hoy", "12 mar 2026".
  static String relative(BuildContext context, DateTime? value) {
    if (value == null) return '';
    final Duration difference = DateTime.now().difference(value.toLocal());
    if (difference.inSeconds < 60) return context.l10n.timeJustNow;
    if (difference.inMinutes < 60) {
      return context.l10n.timeMinutesAgo(difference.inMinutes);
    }
    if (difference.inHours < 24) {
      return context.l10n.timeHoursAgo(difference.inHours);
    }
    if (difference.inDays == 1) return context.l10n.timeYesterday;
    if (difference.inDays < 7) {
      return context.l10n.timeDaysAgo(difference.inDays);
    }
    if (difference.inDays < 30) {
      return context.l10n.timeWeeksAgo((difference.inDays / 7).floor());
    }
    return shortDate(context, value);
  }

  /// Cuenta regresiva "02:45" (minutos:segundos).
  static String countdown(Duration remaining) {
    final int total = remaining.inSeconds.clamp(0, 86399);
    final String minutes = (total ~/ 60).toString().padLeft(2, '0');
    final String seconds = (total % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Números con separador de miles: 1,250.
  static String number(num value) {
    final String raw = value.round().abs().toString();
    final StringBuffer buffer = StringBuffer();
    for (int index = 0; index < raw.length; index++) {
      if (index > 0 && (raw.length - index) % 3 == 0) buffer.write(',');
      buffer.write(raw[index]);
    }
    return '${value < 0 ? '-' : ''}$buffer';
  }

  /// Versión compacta: 1250 -> 1.2k.
  static String compact(num value) {
    if (value.abs() < 1000) return number(value);
    if (value.abs() < 1000000) {
      return '${(value / 1000).toStringAsFixed(value.abs() < 10000 ? 1 : 0)}k';
    }
    return '${(value / 1000000).toStringAsFixed(1)}M';
  }

  /// Distancia legible: "850 m" o "1.4 km".
  static String distance(double? kilometers) {
    if (kilometers == null) return '';
    if (kilometers < 1) return '${(kilometers * 1000).round()} m';
    return '${kilometers.toStringAsFixed(kilometers < 10 ? 1 : 0)} km';
  }

  /// Porcentaje entero: 0.42 -> "42%".
  static String percent(double fraction) =>
      '${(fraction.clamp(0, 1) * 100).round()}%';

  /// Teléfono presentable: "+52 55 1234 5678".
  static String phone(String? value) {
    if (value == null || value.isEmpty) return '';
    final String digits = value.digitsOnly;
    if (digits.length == 10) {
      return '${digits.substring(0, 2)} ${digits.substring(2, 6)} '
          '${digits.substring(6)}';
    }
    return value;
  }

  /// Convierte un color a hexadecimal `#RRGGBB`.
  static String hexCode(Color color) {
    final int value = color.toARGB32() & 0xFFFFFF;
    return '#${value.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  /// Convierte `#RRGGBB`, `#AARRGGBB` o nombres vacíos en un color.
  static Color? colorFromHex(String? value) {
    if (value == null || value.isEmpty) return null;
    final String cleaned = value.replaceAll('#', '').trim();
    if (cleaned.length != 6 && cleaned.length != 8) return null;
    final int? parsed = int.tryParse(cleaned, radix: 16);
    if (parsed == null) return null;
    return Color(cleaned.length == 6 ? 0xFF000000 | parsed : parsed);
  }

  /// Horas de atención: "09:00 – 18:00".
  static String openingHours(String? opensAt, String? closesAt) {
    if (opensAt == null && closesAt == null) return '';
    if (opensAt == null) return closesAt!;
    if (closesAt == null) return opensAt;
    return '$opensAt – $closesAt';
  }
}

/// Etiqueta con la distancia a un negocio, respetando el idioma activo.
String distanceLabel(BuildContext context, double? kilometers) {
  if (kilometers == null) return '';
  return context.l10n.commonKmAway(AppFormatters.distance(kilometers));
}

/// Espacio vertical reutilizable en listas.
const Widget listGap = SizedBox(height: AppSpacing.md);
