import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Control de brillo de pantalla (máximo para mostrar el QR).
abstract interface class BrightnessController {
  /// Devuelve `true` si el brillo se pudo ajustar.
  Future<bool> maximize();

  Future<void> restore();
}

/// Implementación sin plugins: informa que el brillo no es controlable.
final class UnsupportedBrightnessController implements BrightnessController {
  const UnsupportedBrightnessController();

  @override
  Future<bool> maximize() async => false;

  @override
  Future<void> restore() async {}
}

/// Imagen elegida por el usuario (archivo local).
@immutable
final class PickedImage {
  const PickedImage({required this.path, this.name});

  final String path;
  final String? name;
}

/// Selector de imágenes (avatar, logo de tarjeta, promociones).
abstract interface class MediaPickerService {
  Future<PickedImage?> pickFromGallery();

  Future<PickedImage?> pickFromCamera();

  bool get isSupported;
}

/// Implementación sin plugins: no hay acceso a la galería.
final class UnsupportedMediaPickerService implements MediaPickerService {
  const UnsupportedMediaPickerService();

  @override
  bool get isSupported => false;

  @override
  Future<PickedImage?> pickFromCamera() async => null;

  @override
  Future<PickedImage?> pickFromGallery() async => null;
}

/// Resultado de compartir un texto.
@immutable
final class ShareResult {
  const ShareResult({required this.copied, this.shared = false});

  final bool copied;
  final bool shared;
}

/// Compartir textos (invitaciones, códigos).
abstract interface class ShareService {
  Future<ShareResult> shareText(String text, {String? subject});
}

/// Implementación sin plugins: copia al portapapeles.
final class ClipboardShareService implements ShareService {
  const ClipboardShareService();

  @override
  Future<ShareResult> shareText(String text, {String? subject}) async {
    await Clipboard.setData(ClipboardData(text: text));
    return const ShareResult(copied: true);
  }
}

/// Capacidad de escanear códigos QR con la cámara.
abstract interface class ScannerService {
  bool get isSupported;
}

/// Implementación sin plugins: solo registro manual del código.
final class UnsupportedScannerService implements ScannerService {
  const UnsupportedScannerService();

  @override
  bool get isSupported => false;
}

/// Notificaciones locales (recordatorios, sellos).
abstract interface class NotificationService {
  Future<bool> requestPermission();

  Future<void> show({
    required int id,
    required String title,
    required String body,
  });

  Future<void> cancelAll();
}

/// Implementación sin plugins: los avisos viven dentro de la app.
final class InAppNotificationService implements NotificationService {
  const InAppNotificationService();

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<void> show({
    required int id,
    required String title,
    required String body,
  }) async {}

  @override
  Future<void> cancelAll() async {}
}

/// Feedback háptico centralizado (usa los servicios del framework).
abstract final class Haptics {
  static Future<void> light() => HapticFeedback.lightImpact();

  static Future<void> medium() => HapticFeedback.mediumImpact();

  static Future<void> success() => HapticFeedback.mediumImpact();

  static Future<void> error() => HapticFeedback.heavyImpact();

  static Future<void> selection() => HapticFeedback.selectionClick();
}
