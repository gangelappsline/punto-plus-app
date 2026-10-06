import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_routes.dart';
import '../../features/auth/presentation/controllers/auth_state.dart';
import '../providers/app_providers.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import '../utils/extensions.dart';

/// Franja que recuerda verificar la cuenta con el código de 6 dígitos.
///
/// Se oculta cuando la cuenta ya está verificada (o no hay sesión).
final class PendingVerificationBanner extends ConsumerWidget {
  const PendingVerificationBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppPalette palette = context.palette;
    final bool mustVerify = ref.watch(
      authControllerProvider.select((AuthState state) => state.mustVerify),
    );
    if (!mustVerify) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: palette.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: palette.warning.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.verified_outlined, color: palette.warning, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              context.l10n.authAccountPendingVerification,
              style: TextStyle(
                color: palette.text,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(
            onPressed: () => context.push(AppRoutes.verifyCode),
            child: Text(
              context.l10n.authVerifyAction,
              style: TextStyle(
                color: palette.warning,
                fontWeight: FontWeight.w900,
                fontSize: 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
