import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_router.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/auth_state.dart';

final class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

final class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(_restoreSession);
  }

  Future<void> _restoreSession() async {
    await ref.read(authControllerProvider.notifier).restoreSession();
    if (!mounted) return;
    final state = ref.read(authControllerProvider);
    context.go(
      state.status == AuthStatus.authenticated
          ? AppRoutes.home
          : AppRoutes.auth,
    );
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.teal),
        ),
      );
}
