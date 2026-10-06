import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../controllers/auth_state.dart';
import '../widgets/auth_segmented_control.dart';
import '../widgets/brand_header.dart';
import '../widgets/login_card.dart';
import '../widgets/register_card.dart';
import '../widgets/social_section.dart';

final class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({this.initialMode = AuthMode.login, super.key});

  /// Pestaña que se muestra al abrir (`/login` o `/register`).
  final AuthMode initialMode;

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

final class _AuthScreenState extends ConsumerState<AuthScreen> {
  late AuthMode _mode = widget.initialMode;

  void _showSocialSetup(String? provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.l10n
              .authSocialNotConfigured(provider ?? ''),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authControllerProvider, (AuthState? previous, AuthState next) {
      final message = next.errorMessage;
      if (message != null && message != previous?.errorMessage) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(context.localizeError(message)),
              backgroundColor: context.palette.error,
            ),
          );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewport) =>
              SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.only(bottom: 28),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 430,
                  minHeight: viewport.maxHeight - 28,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const BrandHeader(),
                      const SizedBox(height: 10),
                      AuthSegmentedControl(
                        value: _mode,
                        onChanged: (AuthMode value) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          ref.read(authControllerProvider.notifier).clearError();
                          setState(() => _mode = value);
                        },
                      ),
                      const SizedBox(height: 15),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 230),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        transitionBuilder: (Widget child, Animation<double> animation) =>
                            FadeTransition(opacity: animation, child: child),
                        child: _mode == AuthMode.login
                            ? const LoginCard(
                                key: ValueKey<String>('login-card'),
                              )
                            : const RegisterCard(
                                key: ValueKey<String>('register-card'),
                              ),
                      ),
                      const SizedBox(height: 17),
                      SocialSection(
                        onGoogle: () => _showSocialSetup('Google'),
                        onApple: () => _showSocialSetup('Apple ID'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
