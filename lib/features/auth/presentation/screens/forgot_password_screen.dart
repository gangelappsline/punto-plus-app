import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/login_request.dart';
import '../../data/models/password_recovery_request.dart';

/// Solicitud del código para restablecer la contraseña.
final class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

final class _ForgotPasswordScreenState
    extends ConsumerState<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _identifier = TextEditingController();

  @override
  void dispose() {
    _identifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return AppScaffold(
      showBackButton: true,
      padding: const EdgeInsets.all(AppSpacing.xl),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: AppSpacing.xl),
            Container(
              height: 62,
              width: 62,
              decoration: BoxDecoration(
                color: palette.brandSoft,
                borderRadius: AppRadius.allLg,
              ),
              child: Icon(
                Icons.lock_reset_rounded,
                color: palette.brand,
                size: 28,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              context.l10n.authForgotTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              context.l10n.authForgotSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(
              label: context.l10n.authEmailLabel,
              hintText: context.l10n.authEmailHint,
              controller: _identifier,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.alternate_email_rounded,
              textInputAction: TextInputAction.done,
              required: true,
              validator: (String? value) => (value ?? '').trim().isEmail ||
                      (value ?? '').isPhone
                  ? null
                  : context.l10n.validationEmailOrPhoneInvalid,
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: context.l10n.authForgotAction,
              icon: Icons.send_rounded,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final String value = _identifier.text.trim();
    final bool success =
        await ref.read(authControllerProvider.notifier).requestPasswordReset(
              PasswordRecoveryRequest(
                identifier: value,
                type:
                    value.isEmail ? IdentifierType.email : IdentifierType.phone,
              ),
            );
    if (!mounted) return;
    if (success) {
      final String resetPath = AppRoutes.resetPassword;
      context.showSnack(
        context.l10n.authForgotSuccess,
        kind: AppSnackKind.success,
      );
      context.push('$resetPath?identifier=$value');
    } else {
      context.showSnack(
        ref.read(authControllerProvider).errorMessage ??
            context.l10n.commonErrorGenericMessage,
        kind: AppSnackKind.error,
      );
    }
  }
}
