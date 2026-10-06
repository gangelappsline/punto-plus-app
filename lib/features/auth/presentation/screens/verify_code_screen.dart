import 'dart:async';

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
import '../../../../core/widgets/progress.dart';
import '../controllers/auth_state.dart';

/// Verificación del correo o celular con un código de 6 dígitos.
final class VerifyCodeScreen extends ConsumerStatefulWidget {
  const VerifyCodeScreen({super.key});

  @override
  ConsumerState<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

final class _VerifyCodeScreenState extends ConsumerState<VerifyCodeScreen> {
  final TextEditingController _code = TextEditingController();
  Timer? _timer;
  int _seconds = AppConstants.otpResendSeconds;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _code.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _seconds = AppConstants.otpResendSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!mounted) return;
      setState(() => _seconds = _seconds > 0 ? _seconds - 1 : 0);
      if (_seconds == 0) timer.cancel();
    });
  }

  String get _identifier =>
      ref.read(authControllerProvider).pendingVerificationIdentifier ??
      ref.read(currentUserProvider)?.email ??
      ref.read(currentUserProvider)?.phone ??
      '';

  Future<void> _verify(String code) async {
    final bool success = await ref
        .read(authControllerProvider.notifier)
        .verifyCode(identifier: _identifier, code: code);
    if (!mounted) return;
    if (success) {
      context.showSnack(
        context.l10n.authVerifySuccess,
        kind: AppSnackKind.success,
      );
      context.go(AppRoutes.home);
    } else {
      setState(() => _hasError = true);
      context.showSnack(
        ref.read(authControllerProvider).errorMessage ??
            context.l10n.authVerifyInvalid,
        kind: AppSnackKind.error,
      );
    }
  }

  Future<void> _resend() async {
    final bool success = await ref
        .read(authControllerProvider.notifier)
        .resendCode(identifier: _identifier);
    if (!mounted) return;
    if (success) {
      _startTimer();
      context.showSnack(
        context.l10n.authVerifyResendSuccess,
        kind: AppSnackKind.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final AuthState auth = ref.watch(authControllerProvider);

    return AppScaffold(
      showBackButton: true,
      scrollable: true,
      padding: const EdgeInsets.all(AppSpacing.xl),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: AppSpacing.xl),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 62,
              width: 62,
              decoration: BoxDecoration(
                color: palette.brandSoft,
                borderRadius: AppRadius.allLg,
              ),
              child: Icon(
                Icons.mark_email_unread_outlined,
                color: palette.brand,
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            context.l10n.authVerifyTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _identifier.isEmpty
                ? context.l10n.authVerifyChangeDestination
                : '${context.l10n.authVerifyChangeDestination}: $_identifier',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          const StepDots(
            count: 2,
            currentIndex: 1,
          ),
          const SizedBox(height: AppSpacing.xl),
          OtpField(
            controller: _code,
            length: AppConstants.otpLength,
            hasError: _hasError,
            onCompleted: _verify,
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: context.l10n.authVerifyAction,
            icon: Icons.check_circle_outline_rounded,
            isLoading: auth.isLoading,
            onPressed: _code.text.length == AppConstants.otpLength
                ? () => _verify(_code.text)
                : null,
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: TextButton(
              onPressed: _seconds == 0 && !auth.isLoading ? _resend : null,
              child: Text(
                _seconds == 0
                    ? context.l10n.authVerifyResendAction
                    : '${context.l10n.authVerifyResendAction} ($_seconds)',
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).logout();
              if (!context.mounted) return;
              context.go(AppRoutes.welcome);
            },
            child: Text(context.l10n.authBackToLogin),
          ),
        ],
      ),
    );
  }
}
