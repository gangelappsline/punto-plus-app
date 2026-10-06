import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../controllers/auth_state.dart';

/// Pantalla de arranque: restaura la sesión y decide la primera ruta.
final class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

final class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(_bootstrap);
  }

  Future<void> _bootstrap() async {
    final bool onboardingCompleted =
        (await ref.read(preferencesStoreProvider).load()).onboardingCompleted;
    await ref.read(authControllerProvider.notifier).restoreSession();
    if (!mounted) return;
    final AuthState state = ref.read(authControllerProvider);
    final String target;
    if (state.status == AuthStatus.authenticated) {
      target = AppRoutes.home;
    } else if (state.pendingVerificationIdentifier != null) {
      target = AppRoutes.verifyCode;
    } else if (!onboardingCompleted) {
      target = AppRoutes.onboarding;
    } else {
      target = AppRoutes.welcome;
    }
    if (mounted) context.go(target);
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Punto+',
                style: TextStyle(
                  color: AppColors.teal,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              SizedBox.square(
                dimension: 26,
                child: CircularProgressIndicator(
                  strokeWidth: 2.6,
                  color: AppColors.teal,
                ),
              ),
            ],
          ),
        ),
      );
}
