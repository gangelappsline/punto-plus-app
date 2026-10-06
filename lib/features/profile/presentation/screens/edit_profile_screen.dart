import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/platform/device_services.dart';
import '../../../../core/providers/data_providers.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/image_thumb.dart';
import '../../../auth/data/models/user_model.dart';
import '../../data/models/profile_requests.dart';
import '../providers/profile_providers.dart';

/// Edición de datos personales y contraseña.
final class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

final class _EditProfileScreenState extends ConsumerState<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);
  final GlobalKey<FormState> _profileKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordKey = GlobalKey<FormState>();

  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  final TextEditingController _current = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  bool _obscure = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final UserModel? user = ref.read(currentUserProvider);
    _name = TextEditingController(text: user?.displayName ?? '');
    _email = TextEditingController(text: user?.email ?? '');
    _phone = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _tabs.dispose();
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _current.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final UserModel? user = ref.watch(currentUserProvider);
    final AsyncValue<UserModel?> saving =
        ref.watch(editProfileControllerProvider);

    return AppScaffold(
      title: context.l10n.profileEditTitle,
      showBackButton: true,
      scrollable: false,
      padding: EdgeInsets.zero,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.md,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: palette.segmented,
                borderRadius: AppRadius.allPill,
              ),
              padding: const EdgeInsets.all(3),
              child: TabBar(
                controller: _tabs,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: palette.surface,
                  borderRadius: AppRadius.allPill,
                ),
                labelColor: palette.brand,
                unselectedLabelColor: palette.textMuted,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 12.5,
                ),
                tabs: <Widget>[
                  Tab(text: context.l10n.profileEditTitle),
                  Tab(text: context.l10n.profileChangePasswordTitle),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: <Widget>[
                _profileForm(user, saving.value is AsyncLoading),
                _passwordForm(saving.value is AsyncLoading),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileForm(UserModel? user, bool loading) => ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                UserAvatar(
                  initials: user?.initials ?? 'P+',
                  imageUrl: user?.avatarUrl,
                  size: AppSizes.avatarLg,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  context.l10n.profileAvatarHint,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextButton.icon(
                  onPressed: loading ? null : _pickAvatar,
                  icon: const Icon(Icons.upload_rounded, size: 18),
                  label: Text(context.l10n.profileAvatarChange),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Form(
            key: _profileKey,
            child: Column(
              children: <Widget>[
                AppTextField(
                  label: context.l10n.authNameLabel,
                  hintText: context.l10n.authNameHint,
                  controller: _name,
                  prefixIcon: Icons.person_outline_rounded,
                  required: true,
                  validator: (String? value) => (value ?? '').trim().length < 3
                      ? context.l10n.validationNameShort
                      : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: context.l10n.authEmailLabel,
                  hintText: context.l10n.authEmailHint,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.mail_outline_rounded,
                  validator: (String? value) =>
                      (value ?? '').isEmpty || value!.isEmail
                          ? null
                          : context.l10n.validationEmailInvalid,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: context.l10n.authPhoneLabel,
                  hintText: context.l10n.authPhoneHint,
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  validator: (String? value) =>
                      (value ?? '').isEmpty || value!.isPhone
                          ? null
                          : context.l10n.validationPhoneInvalid,
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: context.l10n.commonSave,
                  icon: Icons.check_rounded,
                  isLoading: loading,
                  onPressed: () => _saveProfile(),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _passwordForm(bool loading) => ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: <Widget>[
          Form(
            key: _passwordKey,
            child: Column(
              children: <Widget>[
                AppTextField(
                  label: context.l10n.profileChangePasswordCurrent,
                  controller: _current,
                  obscureText: _obscure,
                  prefixIcon: Icons.lock_outline_rounded,
                  onToggleObscure: () => setState(() => _obscure = !_obscure),
                  required: true,
                  validator: (String? value) =>
                      (value ?? '').length < 6
                          ? context.l10n.validationPasswordShort
                          : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: context.l10n.profileChangePasswordNew,
                  controller: _password,
                  obscureText: _obscure,
                  prefixIcon: Icons.lock_reset_rounded,
                  onToggleObscure: () => setState(() => _obscure = !_obscure),
                  required: true,
                  validator: (String? value) =>
                      (value ?? '').length < 8
                          ? context.l10n.validationPasswordShort
                          : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: context.l10n.profileChangePasswordConfirm,
                  controller: _confirm,
                  obscureText: _obscure,
                  prefixIcon: Icons.lock_outline_rounded,
                  required: true,
                  validator: (String? value) => value != _password.text
                      ? context.l10n.validationPasswordMismatch
                      : null,
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: context.l10n.commonSave,
                  icon: Icons.check_rounded,
                  isLoading: loading,
                  onPressed: () => _changePassword(),
                ),
                const SizedBox(height: AppSpacing.xl),
                DangerButton(
                  label: context.l10n.profileDeleteAccountAction,
                  onPressed: _deleteAccount,
                ),
              ],
            ),
          ),
        ],
      );

  Future<void> _saveProfile() async {
    if (!(_profileKey.currentState?.validate() ?? false)) return;
    try {
      await ref.read(editProfileControllerProvider.notifier).save(
            UpdateProfileRequest(
              name: _name.text.trim(),
              email: _email.text.trim().isEmpty ? null : _email.text.trim(),
              phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
            ),
          );
      if (!mounted) return;
      context.showSnack(
        context.l10n.profileEditSuccess,
        kind: AppSnackKind.success,
      );
    } catch (error) {
      if (!mounted) return;
      context.showSnack(
        context.l10n.profileEditError,
        kind: AppSnackKind.error,
      );
    }
  }

  Future<void> _changePassword() async {
    if (!(_passwordKey.currentState?.validate() ?? false)) return;
    try {
      await ref.read(editProfileControllerProvider.notifier).changePassword(
            ChangePasswordRequest(
              currentPassword: _current.text,
              password: _password.text,
            ),
          );
      _current.clear();
      _password.clear();
      _confirm.clear();
      if (!mounted) return;
      context.showSnack(
        context.l10n.profileChangePasswordSuccess,
        kind: AppSnackKind.success,
      );
    } catch (error) {
      if (!mounted) return;
      context.showSnack(
        context.l10n.commonErrorGenericMessage,
        kind: AppSnackKind.error,
      );
    }
  }

  Future<void> _deleteAccount() async {
    final bool confirmed = await showConfirmDialog(
      context: context,
      title: context.l10n.profileDeleteAccountTitle,
      message: context.l10n.profileDeleteAccountMessage,
      confirmLabel: context.l10n.profileDeleteAccountAction,
      isDestructive: true,
      icon: Icons.delete_forever_rounded,
    );
    if (!confirmed) return;
    try {
      await ref.read(editProfileControllerProvider.notifier).deleteAccount();
      if (!mounted) return;
      context.showSnack(
        context.l10n.profileDeleteAccountSuccess,
        kind: AppSnackKind.success,
      );
    } catch (error) {
      if (!mounted) return;
      context.showSnack(
        context.l10n.profileDeleteAccountError,
        kind: AppSnackKind.error,
      );
    }
  }

  Future<void> _pickAvatar() async {
    final MediaPickerService picker = ref.read(mediaPickerServiceProvider);
    if (!picker.isSupported) {
      if (!mounted) return;
      context.showSnack(context.l10n.profileAvatarError);
      return;
    }
    final PickedImage? image = await picker.pickFromGallery();
    if (image == null || !mounted) return;
    try {
      final List<int> bytes = await File(image.path).readAsBytes();
      await ref
          .read(editProfileControllerProvider.notifier)
          .uploadAvatar(bytes: bytes, filename: image.name ?? 'avatar.jpg');
      if (!mounted) return;
      context.showSnack(
        context.l10n.profileAvatarUploaded,
        kind: AppSnackKind.success,
      );
    } catch (error) {
      if (!mounted) return;
      context.showSnack(
        context.l10n.profileAvatarError,
        kind: AppSnackKind.error,
      );
    }
  }
}
