import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/app_button.dart';

/// Pantalla de bienvenida con accesos a ingresar o crear cuenta.
final class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppPalette palette = context.palette;
    final List<String> benefits = <String>[
      context.l10n.authWelcomeBenefit1,
      context.l10n.authWelcomeBenefit2,
      context.l10n.authWelcomeBenefit3,
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.brandGradient),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Spacer(),
                    Text(
                      context.l10n.appName,
                      style: TextStyle(
                        color: palette.onBrand,
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      context.l10n.authWelcomeTitle,
                      style: TextStyle(
                        color: palette.onBrand,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      context.l10n.authWelcomeSubtitle,
                      style: TextStyle(
                        color: palette.onBrand.withValues(alpha: 0.88),
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    ...benefits.map(
                      (String benefit) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.check_circle_rounded,
                              size: 18,
                              color: palette.onBrand,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                benefit,
                                style: TextStyle(
                                  color: palette.onBrand.withValues(
                                    alpha: 0.95,
                                  ),
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    PrimaryButton(
                      label: context.l10n.authWelcomeRegister,
                      icon: Icons.person_add_alt_1_rounded,
                      color: palette.accent,
                      onPressed: () => context.go(AppRoutes.register),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      height: AppSizes.buttonHeight,
                      child: OutlinedButton(
                        onPressed: () => context.go(AppRoutes.login),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: palette.onBrand,
                          side: BorderSide(
                            color: palette.onBrand.withValues(alpha: 0.6),
                          ),
                        ),
                        child: Text(
                          context.l10n.authWelcomeLogin,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.terms),
                      child: Text(
                        context.l10n.authAcceptTerms,
                        style: TextStyle(
                          color: palette.onBrand.withValues(alpha: 0.9),
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
