import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_router.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../data/models/login_request.dart';
import '../../data/models/register_request.dart';
import 'auth_text_field.dart';
import 'gradient_button.dart';
import '../../../../core/utils/extensions.dart';

final class RegisterCard extends ConsumerStatefulWidget {
  const RegisterCard({super.key});

  @override
  ConsumerState<RegisterCard> createState() => _RegisterCardState();
}

final class _RegisterCardState extends ConsumerState<RegisterCard> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _usePhone = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    TextInput.finishAutofillContext();
    final success = await ref.read(authControllerProvider.notifier).register(
          RegisterRequest(
            fullName: _nameController.text,
            identifier: _identifierController.text,
            password: _passwordController.text,
            type: _usePhone ? IdentifierType.phone : IdentifierType.email,
          ),
        );
    if (success && mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 25, 24, 25),
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
      child: AutofillGroup(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                context.l10n.authRegisterTitle,
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 19,
                  height: 1.15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                context.l10n.authRegisterSubtitle,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                  height: 1.25,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15),
              AuthTextField(
                label: context.l10n.authNameLabel,
                controller: _nameController,
                hintText: context.l10n.authNameHint,
                prefixIcon: Icons.person_outline_rounded,
                validator: (String? value) => Validators.required(
                  value,
                  message: context.l10n.validationNameShort,
                ),
                keyboardType: TextInputType.name,
                autofillHints: const <String>[AutofillHints.name],
              ),
              const SizedBox(height: 14),
              AuthTextField(
                label: _usePhone
                    ? context.l10n.authPhoneLabel
                    : context.l10n.authEmailLabel,
                controller: _identifierController,
                hintText: _usePhone
                    ? context.l10n.authPhoneHint
                    : context.l10n.authEmailHint,
                prefixIcon: _usePhone
                    ? Icons.phone_iphone_rounded
                    : Icons.alternate_email_rounded,
                actionLabel: context.l10n.authVerifyChangeDestination,
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
                label: context.l10n.authPasswordLabel,
                controller: _passwordController,
                hintText: context.l10n.authPasswordHint,
                prefixIcon: Icons.lock_outline_rounded,
                validator: Validators.password,
                obscureText: _obscurePassword,
                onToggleObscure: () => setState(
                  () => _obscurePassword = !_obscurePassword,
                ),
                textInputAction: TextInputAction.done,
                autofillHints: const <String>[AutofillHints.newPassword],
              ),
              const SizedBox(height: 16),
              GradientButton(
                label: context.l10n.authRegisterAction,
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
