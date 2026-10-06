import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/models/app_preferences.dart';
import '../../../../core/platform/location_service.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/providers/data_providers.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../legal/presentation/providers/legal_providers.dart';

/// Preferencias de tema, idioma, avisos y ubicación.
final class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppPalette palette = context.palette;
    final AppPreferences preferences = ref.watch(appPreferencesProvider);
    final String? areaName = ref.watch(referenceAreaProvider).name;
    final String version = appVersion;

    return AppScaffold(
      title: context.l10n.settingsTitle,
      showBackButton: true,
      scrollable: false,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        96,
      ),
      body: ListView(
        children: <Widget>[
          _Group(
            title: context.l10n.settingsAppearanceTitle,
            children: <Widget>[
              _RadioRow<String>(
                label: context.l10n.settingsThemeLabel,
                value: preferences.themeMode.name,
                options: <String, String>{
                  ThemeMode.system.name: context.l10n.settingsThemeSystem,
                  ThemeMode.light.name: context.l10n.settingsThemeLight,
                  ThemeMode.dark.name: context.l10n.settingsThemeDark,
                },
                onChanged: (String value) => ref
                    .read(appPreferencesProvider.notifier)
                    .setThemeMode(
                      ThemeMode.values.firstWhere(
                        (ThemeMode mode) => mode.name == value,
                      ),
                    ),
              ),
              _RadioRow<String>(
                label: context.l10n.settingsLanguageLabel,
                value: preferences.languageCode ?? 'system',
                options: <String, String>{
                  'system': context.l10n.settingsLanguageSystem,
                  'es': context.l10n.settingsLanguageEs,
                  'en': context.l10n.settingsLanguageEn,
                },
                onChanged: (String value) => ref
                    .read(appPreferencesProvider.notifier)
                    .setLanguage(value == 'system' ? null : value),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _Group(
            title: context.l10n.settingsNotificationsTitle,
            children: <Widget>[
              _SwitchRow(
                label: context.l10n.settingsNotifyStamps,
                subtitle: context.l10n.settingsNotifyStampsSubtitle,
                value: preferences.notifyStamps,
                onChanged: (bool value) => ref
                    .read(appPreferencesProvider.notifier)
                    .setNotification(stamps: value),
              ),
              _SwitchRow(
                label: context.l10n.settingsNotifyRewards,
                subtitle: context.l10n.settingsNotifyRewardsSubtitle,
                value: preferences.notifyRewards,
                onChanged: (bool value) => ref
                    .read(appPreferencesProvider.notifier)
                    .setNotification(rewards: value),
              ),
              _SwitchRow(
                label: context.l10n.settingsNotifyPromotions,
                subtitle: context.l10n.settingsNotifyPromotionsSubtitle,
                value: preferences.notifyPromotions,
                onChanged: (bool value) => ref
                    .read(appPreferencesProvider.notifier)
                    .setNotification(promotions: value),
              ),
              _SwitchRow(
                label: context.l10n.settingsNotifyGeneral,
                value: preferences.notifyGeneral,
                onChanged: (bool value) => ref
                    .read(appPreferencesProvider.notifier)
                    .setNotification(general: value),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _Group(
            title: context.l10n.settingsLocationTitle,
            children: <Widget>[
              _SwitchRow(
                label: context.l10n.settingsLocationAuto,
                subtitle: context.l10n.settingsLocationAutoSubtitle,
                value: preferences.useDeviceLocation,
                onChanged: (bool value) =>
                    _toggleDeviceLocation(context, ref, value),
              ),
              if (!preferences.useDeviceLocation)
                _RadioRow<String>(
                  label: context.l10n.settingsLocationManualHint,
                  value: areaName,
                  options: <String, String>{
                    for (final ReferenceArea area
                        in ManualLocationService.areas)
                      area.name: area.name,
                  },
                  onChanged: (String value) => ref
                      .read(appPreferencesProvider.notifier)
                      .setManualArea(value),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _Group(
            title: context.l10n.settingsDataTitle,
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.info_outline_rounded, color: palette.brand),
                title: Text(
                  context.l10n.profileAboutAction,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text(context.l10n.legalAboutDescription),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push(AppRoutes.about),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading:
                    Icon(Icons.delete_sweep_outlined, color: palette.error),
                title: Text(
                  context.l10n.settingsCacheClear,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text(context.l10n.settingsCacheSubtitle),
                onTap: () async {
                  await ref.read(localCacheProvider).clear();
                  if (!context.mounted) return;
                  context.showSnack(
                    context.l10n.settingsCacheCleared,
                    kind: AppSnackKind.success,
                  );
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.gavel_outlined, color: palette.brand),
                title: Text(
                  context.l10n.legalTermsTitle,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                onTap: () => context.push(AppRoutes.terms),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.privacy_tip_outlined, color: palette.brand),
                title: Text(
                  context.l10n.legalPrivacyTitle,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                onTap: () => context.push(AppRoutes.privacy),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '${context.l10n.legalAboutVersion} $version',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: palette.textFaint),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleDeviceLocation(
    BuildContext context,
    WidgetRef ref,
    bool value,
  ) async {
    if (!value) {
      await ref.read(appPreferencesProvider.notifier).setUseDeviceLocation(false);
      return;
    }
    final LocationService service = ref.read(locationServiceProvider);
    final LocationPermissionStatus status = await service.requestPermission();
    if (!context.mounted) return;
    if (status != LocationPermissionStatus.granted) {
      await showConfirmDialog(
        context: context,
        title: context.l10n.mapLocationDeniedTitle,
        message: context.l10n.mapLocationDeniedMessage,
        confirmLabel: context.l10n.mapOpenSettings,
        isDestructive: false,
        icon: Icons.location_disabled_rounded,
      );
      return;
    }
    await ref.read(appPreferencesProvider.notifier).setUseDeviceLocation(true);
  }
}

final class _Group extends StatelessWidget {
  const _Group({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SectionHeader(title: title),
          AppCard(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Column(children: children),
          ),
        ],
      );
}

final class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
        ),
        subtitle: subtitle == null
            ? null
            : Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
        value: value,
        onChanged: onChanged,
      );
}

final class _RadioRow<T> extends StatelessWidget {
  const _RadioRow({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final T value;
  final Map<T, String> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              color: palette.text,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: options.entries
                .map(
                  (MapEntry<T, String> entry) => ChoiceChip(
                    label: Text(entry.value),
                    selected: entry.key == value,
                    onSelected: (_) => onChanged(entry.key),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

/// Acción de soporte mostrada al final de la configuración.
final class SettingsSupportTile extends StatelessWidget {
  const SettingsSupportTile({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: AppSpacing.md),
        child: SecondaryButton(
          label: context.l10n.helpContactTitle,
          icon: Icons.mail_outline_rounded,
          onPressed: () => context.push(AppRoutes.help),
        ),
      );
}
