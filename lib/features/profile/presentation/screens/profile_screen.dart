import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/image_thumb.dart';
import '../../../../core/widgets/progress.dart';
import '../../../auth/data/models/user_model.dart';
import '../providers/profile_providers.dart';

/// Perfil del cliente: datos, estadísticas y accesos de configuración.
final class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppPalette palette = context.palette;
    final UserModel? user = ref.watch(currentUserProvider);
    final ProfileStats stats = ref.watch(profileStatsProvider);
    final int unread = ref.watch(unreadNotificationsProvider);

    return AppScaffold(
      scrollable: false,
      title: context.l10n.profileTitle,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        96,
      ),
      body: ListView(
        children: <Widget>[
          AppCard(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => context.push(AppRoutes.editProfile),
                      child: Stack(
                        children: <Widget>[
                          UserAvatar(
                            initials: user?.initials ?? 'P+',
                            imageUrl: user?.avatarUrl,
                            size: AppSizes.avatarLg,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: palette.brand,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: palette.surface,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.photo_camera_rounded,
                                size: 14,
                                color: palette.onBrand,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            user?.displayName ?? '—',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          if (user?.email != null)
                            Text(
                              user!.email!,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          if (user?.phone != null)
                            Text(
                              user!.phone!,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          const SizedBox(height: AppSpacing.sm),
                          StatusBadge(
                            label: user?.hasVerifiedEmail ?? false
                                ? context.l10n.profileVerified
                                : context.l10n.profilePendingVerification,
                            color: user?.hasVerifiedEmail ?? false
                                ? palette.success
                                : palette.warning,
                            icon: user?.hasVerifiedEmail ?? false
                                ? Icons.verified_rounded
                                : Icons.pending_outlined,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: StatTile(
                        icon: Icons.stars_rounded,
                        label: context.l10n.profilePoints,
                        value: '${stats.points}',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: StatTile(
                        icon: Icons.credit_card_rounded,
                        label: context.l10n.profileCardsCount,
                        value: '${stats.cards}',
                        tone: palette.accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: StatTile(
                        icon: Icons.approval_rounded,
                        label: context.l10n.profileStampsTotal,
                        value: '${stats.stamps}',
                        tone: palette.success,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: StatTile(
                        icon: Icons.card_giftcard_rounded,
                        label: context.l10n.profileRewardCount,
                        value: '${stats.rewards}',
                        tone: palette.warning,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _ProfileGroup(
            items: <_ProfileAction>[
              _ProfileAction(
                icon: Icons.edit_outlined,
                label: context.l10n.profileEditAction,
                onTap: () => context.push(AppRoutes.editProfile),
              ),
              _ProfileAction(
                icon: Icons.notifications_none_rounded,
                label: context.l10n.profileNotificationsAction,
                badge: unread > 0 ? '$unread' : null,
                onTap: () => context.push(AppRoutes.notifications),
              ),
              _ProfileAction(
                icon: Icons.redeem_rounded,
                label: context.l10n.rewardsTitle,
                onTap: () => context.go(AppRoutes.rewards),
              ),
              _ProfileAction(
                icon: Icons.people_outline_rounded,
                label: context.l10n.profileReferralAction,
                onTap: () => context.push(AppRoutes.referral),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _ProfileGroup(
            items: <_ProfileAction>[
              _ProfileAction(
                icon: Icons.settings_outlined,
                label: context.l10n.profileSettingsAction,
                onTap: () => context.push(AppRoutes.settings),
              ),
              if (ref.watch(isBusinessUserProvider))
                _ProfileAction(
                  icon: Icons.storefront_outlined,
                  label: context.l10n.profileBusinessModeAction,
                  onTap: () => context.go(AppRoutes.businessDashboard),
                ),
              _ProfileAction(
                icon: Icons.gavel_outlined,
                label: context.l10n.profileLegalAction,
                onTap: () => context.push(AppRoutes.terms),
              ),
              _ProfileAction(
                icon: Icons.help_outline_rounded,
                label: context.l10n.profileHelpAction,
                onTap: () => context.push(AppRoutes.help),
              ),
              _ProfileAction(
                icon: Icons.info_outline_rounded,
                label: context.l10n.profileAboutAction,
                onTap: () => context.push(AppRoutes.about),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SecondaryButton(
            label: context.l10n.authLogout,
            icon: Icons.logout_rounded,
            onPressed: () async {
              final bool confirmed = await showConfirmDialog(
                context: context,
                title: context.l10n.authLogoutConfirmTitle,
                message: context.l10n.authLogoutConfirmMessage,
                confirmLabel: context.l10n.authLogout,
                isDestructive: true,
                icon: Icons.logout_rounded,
              );
              if (!confirmed) return;
              await ref.read(authControllerProvider.notifier).logout();
            },
          ),
        ],
      ),
    );
  }
}

final class _ProfileAction {
  const _ProfileAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? badge;
}

final class _ProfileGroup extends StatelessWidget {
  const _ProfileGroup({required this.items});

  final List<_ProfileAction> items;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Column(
        children: items
            .map(
              (_ProfileAction action) => ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                leading: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: palette.brandSoft,
                    borderRadius: AppRadius.allSm,
                  ),
                  child: Icon(action.icon, size: 18, color: palette.brand),
                ),
                title: Text(
                  action.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (action.badge != null)
                      StatusBadge(label: action.badge!, color: palette.error),
                    const SizedBox(width: AppSpacing.sm),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: palette.textFaint,
                    ),
                  ],
                ),
                onTap: action.onTap,
              ),
            )
            .toList(),
      ),
    );
  }
}
