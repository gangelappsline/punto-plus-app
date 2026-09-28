import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_router.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../data/models/login_request.dart';
import '../../data/models/password_recovery_request.dart';
import 'auth_text_field.dart';
import 'gradient_button.dart';

final class LoginCard extends ConsumerStatefulWidget {
  const LoginCard({super.key});

  @override
  ConsumerState<LoginCard> createState() => _LoginCardState();
}

final class _LoginCardState extends ConsumerState<LoginCard> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _usePhone = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    TextInput.finishAutofillContext();
    final success = await ref.read(authControllerProvider.notifier).login(
          LoginRequest(
            identifier: _identifierController.text,
            password: _passwordController.text,
            type: _usePhone ? IdentifierType.phone : IdentifierType.email,
          ),
        );
    if (success && mounted) context.go(AppRoutes.home);
  }

  Future<void> _requestRecovery() async {
    final identifierError = Validators.emailOrPhone(_identifierController.text);
    if (identifierError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa primero tu correo o número celular.'),
        ),
      );
      return;
    }

    final success =
        await ref.read(authControllerProvider.notifier).requestPasswordReset(
              PasswordRecoveryRequest(
                identifier: _identifierController.text,
                type: _usePhone ? IdentifierType.phone : IdentifierType.email,
              ),
            );
    if (!success || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Te enviamos instrucciones para recuperar tu contraseña.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;

    return _AuthCardShell(
      child: AutofillGroup(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Bienvenido de vuelta',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 19,
                  height: 1.15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              const SizedBox(
                width: 265,
                child: Text(
                  'Accede a tus sellos acumulados y premios\npendientes.',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                    height: 1.25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              AuthTextField(
                key: const ValueKey<String>('login-identifier'),
                label: _usePhone ? 'Celular' : 'Correo o Celular',
                controller: _identifierController,
                hintText: _usePhone ? '+52 55 0000 0000' : 'tu.email@ejemplo.com',
                prefixIcon: _usePhone
                    ? Icons.phone_iphone_rounded
                    : Icons.alternate_email_rounded,
                actionLabel: _usePhone ? 'Usar correo' : 'Usar celular',
                actionIcon: Icons.swap_horiz_rounded,
                onAction: () => setState(() => _usePhone = !_usePhone),
                validator: Validators.emailOrPhone,
                keyboardType:
                    _usePhone ? TextInputType.phone : TextInputType.emailAddress,
                autofillHints: _usePhone
                    ? const <String>[AutofillHints.telephoneNumber]
                    : const <String>[AutofillHints.email],
              ),
              const SizedBox(height: 14),
              AuthTextField(
                key: const ValueKey<String>('login-password'),
                label: 'Contraseña',
                controller: _passwordController,
                hintText: '••••••••••••',
                prefixIcon: Icons.lock_outline_rounded,
                actionLabel: '¿Olvidaste?',
                onAction: _requestRecovery,
                validator: Validators.password,
                obscureText: _obscurePassword,
                onToggleObscure: () => setState(
                  () => _obscurePassword = !_obscurePassword,
                ),
                textInputAction: TextInputAction.done,
                autofillHints: const <String>[AutofillHints.password],
              ),
              const SizedBox(height: 16),
              GradientButton(
                key: const ValueKey<String>('login-submit'),
                label: 'Continuar',
                isLoading: isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _AuthCardShell extends StatelessWidget {
  const _AuthCardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 31, 24, 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x0B001B25),
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: child,
      );
}
