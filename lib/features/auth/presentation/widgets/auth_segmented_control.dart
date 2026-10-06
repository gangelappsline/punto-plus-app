import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions.dart';

enum AuthMode { login, register }

final class AuthSegmentedControl extends StatelessWidget {
  const AuthSegmentedControl({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final AuthMode value;
  final ValueChanged<AuthMode> onChanged;

  @override
  Widget build(BuildContext context) => Container(
        height: 40,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: AppColors.segmented,
          borderRadius: BorderRadius.circular(24),
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final itemWidth = constraints.maxWidth / 2;
            return Stack(
              children: <Widget>[
                AnimatedAlign(
                  alignment: value == AuthMode.login
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  child: Container(
                    width: itemWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(21),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Color(0x13000000),
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    _Segment(
                      key: const ValueKey<String>('login-tab'),
                      label: context.l10n.authLoginAction,
                      isSelected: value == AuthMode.login,
                      onTap: () => onChanged(AuthMode.login),
                    ),
                    _Segment(
                      key: const ValueKey<String>('register-tab'),
                      label: context.l10n.authRegisterAction,
                      isSelected: value == AuthMode.register,
                      onTap: () => onChanged(AuthMode.register),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
}

final class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Semantics(
          selected: isSelected,
          button: true,
          child: InkWell(
            borderRadius: BorderRadius.circular(21),
            onTap: onTap,
            child: Center(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: TextStyle(
                  color: isSelected ? AppColors.teal : AppColors.textMuted,
                  fontFamily: 'NunitoSans',
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
                child: Text(label),
              ),
            ),
          ),
        ),
      );
}
