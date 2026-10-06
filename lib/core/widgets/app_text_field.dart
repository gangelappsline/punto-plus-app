import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import '../utils/extensions.dart';

/// Campo de texto con etiqueta, sufijo opcional y validación.
final class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.label,
    required this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffix,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.onToggleObscure,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.helperText,
    this.focusNode,
    this.autofocus = false,
    this.required = false,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final int maxLines;
  final int? maxLength;
  final String? helperText;
  final FocusNode? focusNode;
  final bool autofocus;

  /// Marca la etiqueta con un asterisco cuando el campo es obligatorio.
  final bool required;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Row(
            children: <Widget>[
              Text(
                label,
                style: TextStyle(
                  color: palette.textMuted,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (required)
                Text(
                  ' *',
                  style: TextStyle(color: palette.error, fontSize: 12.5),
                ),
            ],
          ),
        ),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          autofocus: autofocus,
          enabled: enabled,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          maxLines: obscureText ? 1 : maxLines,
          maxLength: maxLength,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          cursorColor: palette.brand,
          style: TextStyle(
            color: palette.text,
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            helperText: helperText,
            counterText: '',
            isDense: true,
            prefixIcon: prefixIcon == null
                ? null
                : Icon(prefixIcon, size: 20, color: palette.textMuted),
            suffixIcon: onToggleObscure != null
                ? IconButton(
                    onPressed: onToggleObscure,
                    icon: Icon(
                      obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                      color: palette.textMuted,
                    ),
                  )
                : suffix,
          ),
        ),
      ],
    );
  }
}

/// Campo de 6 dígitos para el código de verificación (OTP).
final class OtpField extends StatelessWidget {
  const OtpField({
    required this.controller,
    this.length = 6,
    this.onCompleted,
    this.hasError = false,
    this.autofocus = true,
    super.key,
  });

  final TextEditingController controller;
  final int length;
  final ValueChanged<String>? onCompleted;
  final bool hasError;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          controller: controller,
          autofocus: autofocus,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: length,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (String value) {
            if (value.length == length) onCompleted?.call(value);
          },
          cursorColor: palette.brand,
          style: TextStyle(
            color: palette.text,
            fontSize: 26,
            fontWeight: FontWeight.w900,
            letterSpacing: 12,
          ),
          decoration: InputDecoration(
            counterText: '',
            hintText: '0' * length,
            hintStyle: TextStyle(
              color: palette.textFaint,
              fontSize: 26,
              letterSpacing: 12,
              fontWeight: FontWeight.w900,
            ),
            errorText: hasError ? ' ' : null,
            errorStyle: const TextStyle(height: 0, fontSize: 0),
            enabledBorder: hasError
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: BorderSide(color: palette.error),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

/// Campo de búsqueda compacto con acción de limpiar.
final class SearchField extends StatelessWidget {
  const SearchField({
    required this.controller,
    this.hintText,
    this.onChanged,
    this.onClear,
    this.onSubmitted,
    this.autofocus = false,
    super.key,
  });

  final TextEditingController controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return TextField(
      controller: controller,
      autofocus: autofocus,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      cursorColor: palette.brand,
      style: TextStyle(color: palette.text, fontSize: 14.5),
      decoration: InputDecoration(
        hintText: hintText,
        isDense: true,
        prefixIcon: Icon(Icons.search_rounded, color: palette.textMuted),
        suffixIcon: onClear == null
            ? null
            : IconButton(
                onPressed: onClear,
                tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
                icon: Icon(
                  Icons.close_rounded,
                  color: palette.textMuted,
                  size: 20,
                ),
              ),
      ),
    );
  }
}
