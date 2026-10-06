import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions.dart';

final class AuthTextField extends StatelessWidget {
  const AuthTextField({
    required this.label,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.onToggleObscure,
    this.textInputAction = TextInputAction.next,
    this.autofillHints,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final TextInputAction textInputAction;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (actionLabel != null)
                InkWell(
                  onTap: onAction,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (actionIcon != null) ...<Widget>[
                          Icon(
                            actionIcon,
                            color: AppColors.teal,
                            size: 13,
                          ),
                          const SizedBox(width: 2),
                        ],
                        Text(
                          actionLabel!,
                          style: const TextStyle(
                            color: AppColors.teal,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            obscureText: obscureText,
            textInputAction: textInputAction,
            autofillHints: autofillHints,
            cursorColor: AppColors.teal,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              isDense: true,
              prefixIcon: Icon(
                prefixIcon,
                size: 21,
                color: AppColors.textMuted,
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 45,
                minHeight: 48,
              ),
              suffixIcon: onToggleObscure == null
                  ? null
                  : IconButton(
                      tooltip: obscureText
                          ? context.l10n.authShowPassword
                          : context.l10n.authHidePassword,
                      onPressed: onToggleObscure,
                      icon: Icon(
                        obscureText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textMuted,
                        size: 21,
                      ),
                    ),
            ),
          ),
        ],
      );
}
