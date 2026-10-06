import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import '../utils/extensions.dart';
import 'app_button.dart';

/// Muestra una hoja inferior estándar de la app.
Future<T?> showAppSheet<T>({
  required BuildContext context,
  required Widget child,
  bool isScrollControlled = true,
  bool dismissible = true,
}) {
  final AppPalette palette = context.palette;
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    isDismissible: dismissible,
    enableDrag: dismissible,
    backgroundColor: palette.surface,
    showDragHandle: true,
    builder: (BuildContext sheetContext) => Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        top: AppSpacing.sm,
        bottom: MediaQuery.viewInsetsOf(sheetContext).bottom + AppSpacing.xl,
      ),
      child: child,
    ),
  );
}

/// Diálogo de confirmación con acciones destructivas o de avance.
Future<bool> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? confirmLabel,
  String? cancelLabel,
  bool isDestructive = false,
  IconData? icon,
}) async {
  final AppPalette palette = context.palette;
  final bool? result = await showDialog<bool>(
    context: context,
    builder: (BuildContext dialogContext) => AlertDialog(
      icon: Icon(
        icon ??
            (isDestructive
                ? Icons.warning_amber_rounded
                : Icons.help_outline_rounded),
        color: isDestructive ? palette.error : palette.brand,
      ),
      title: Text(title, textAlign: TextAlign.center),
      content: Text(message, textAlign: TextAlign.center),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(cancelLabel ?? dialogContext.l10n.commonCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: isDestructive ? palette.error : palette.brand,
          ),
          child: Text(confirmLabel ?? dialogContext.l10n.commonAccept),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Selector de fecha con formato local.
Future<DateTime?> pickAppDate({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) =>
    showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime.now().subtract(const Duration(days: 365)),
      lastDate: lastDate ?? DateTime.now().add(const Duration(days: 730)),
      locale: context.l10n.locale,
    );

/// Hoja de acciones simples (editar, eliminar, compartir).
Future<String?> showActionSheet({
  required BuildContext context,
  required String title,
  required List<AppSheetAction> actions,
}) async {
  final AppPalette palette = context.palette;
  return showAppSheet<String>(
    context: context,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        ...actions.map(
          (AppSheetAction action) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: ListTile(
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadius.allMd,
              ),
              tileColor: palette.surfaceAlt,
              leading: Icon(
                action.icon,
                color: action.isDestructive ? palette.error : palette.brand,
              ),
              title: Text(
                action.label,
                style: TextStyle(
                  color:
                      action.isDestructive ? palette.error : palette.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onTap: () => Navigator.of(context).pop(action.value),
            ),
          ),
        ),
      ],
    ),
  );
}

/// Acción mostrada en [showActionSheet].
final class AppSheetAction {
  const AppSheetAction({
    required this.label,
    required this.value,
    required this.icon,
    this.isDestructive = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool isDestructive;
}

/// Botón principal pensado para hojas inferiores.
final class SheetPrimaryButton extends StatelessWidget {
  const SheetPrimaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: AppSpacing.sm),
        child: PrimaryButton(
          label: label,
          onPressed: onPressed,
          isLoading: isLoading,
        ),
      );
}
