import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/verification_requests.dart';

/// Captura el código y la nueva contraseña.
final class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({this.initialEmail, super.key});

  final String? initialEmail;

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

final class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _email =
      TextEditingController(text: widget.initialEmail ?? '');
  final TextEditingController _code = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    _password.dispose();
    _confirm.dispose();
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
            const SizedBox(height: AppSpacing.lg),
            Container(
              height: 62,
              width: 62,
              decoration: BoxDecoration(
                color: palette.brandSoft,
                borderRadius: AppRadius.allLg,
              ),
              child: Icon(
                Icons.password_rounded,
                color: palette.brand,
                size: 28,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              context.l10n.authResetTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              context.l10n.authResetSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(
              label: context.l10n.authEmailLabel,
              hintText: context.l10n.authEmailHint,
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.alternate_email_rounded,
              required: true,
              validator: (String? value) => (value ?? '').trim().isEmail
                  ? null
                  : context.l10n.validationEmailInvalid,
            ),
            const SizedBox(height: AppSpacing.lg),
            OtpField(
              controller: _code,
              length: AppConstants.otpLength,
              autofocus: false,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: context.l10n.authResetNewPasswordLabel,
              controller: _password,
              obscureText: _obscure,
              prefixIcon: Icons.lock_outline_rounded,
              onToggleObscure: () => setState(() => _obscure = !_obscure),
              required: true,
              validator: (String? value) => (value ?? '').length < 8
                  ? context.l10n.validationPasswordShort
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: context.l10n.authResetConfirmPasswordLabel,
              controller: _confirm,
              obscureText: _obscure,
              prefixIcon: Icons.lock_outline_rounded,
              required: true,
              textInputAction: TextInputAction.done,
              validator: (String? value) => value != _password.text
                  ? context.l10n.validationPasswordMismatch
                  : null,
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: context.l10n.authResetAction,
              icon: Icons.check_rounded,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_code.text.length != AppConstants.otpLength) {
      context.showSnack(
        context.l10n.validationOtpSixDigits,
        kind: AppSnackKind.error,
      );
      return;
    }
    final bool success =
        await ref.read(authControllerProvider.notifier).resetPassword(
              ResetPasswordRequest(
                email: _email.text.trim(),
                code: _code.text.trim(),
                password: _password.text,
              ),
            );
    if (!mounted) return;
    if (success) {
      context.showSnack(
        context.l10n.authResetSuccess,
        kind: AppSnackKind.success,
      );
      context.go(AppRoutes.login);
    } else {
      context.showSnack(
        ref.read(authControllerProvider).errorMessage ??
            context.l10n.commonErrorGenericMessage,
        kind: AppSnackKind.error,
      );
    }
  }
}
