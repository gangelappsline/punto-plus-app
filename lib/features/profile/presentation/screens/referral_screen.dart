import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/platform/device_services.dart';
import '../../../../core/providers/data_providers.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/image_thumb.dart';
import '../../../../core/widgets/skeletons.dart';
import '../../data/models/referral_summary.dart';
import '../providers/profile_providers.dart';

/// Programa de referidos: código, pasos e invitaciones.
final class ReferralScreen extends ConsumerWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppPalette palette = context.palette;
    final AsyncValue<ReferralSummary> referral = ref.watch(referralProvider);

    return AppScaffold(
      title: context.l10n.referralTitle,
      showBackButton: true,
      scrollable: false,
      padding: EdgeInsets.zero,
      body: AsyncValueView<ReferralSummary>(
        value: referral,
        loading: const Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: ListSkeleton(items: 4, height: 64),
        ),
        onRetry: () => ref.invalidate(referralProvider),
        builder: (ReferralSummary value) => ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: <Widget>[
            Text(
              context.l10n.referralSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[palette.brandStrong, palette.brand],
                ),
                borderRadius: AppRadius.allLg,
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    context.l10n.referralCodeLabel,
                    style: TextStyle(
                      color: palette.onBrand.withValues(alpha: 0.85),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SelectableText(
                    value.code,
                    style: TextStyle(
                      color: palette.onBrand,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: SecondaryButton(
                          label: context.l10n.referralCopyAction,
                          icon: Icons.copy_rounded,
                          onPressed: () async {
                            await ref
                                .read(shareServiceProvider)
                                .shareText(value.code);
                            if (!context.mounted) return;
                            context.showSnack(
                              context.l10n.commonCopied,
                              kind: AppSnackKind.success,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: PrimaryButton(
                          label: context.l10n.referralShareAction,
                          icon: Icons.share_rounded,
                          onPressed: () async {
                            final ShareResult result = await ref
                                .read(shareServiceProvider)
                                .shareText(
                                  '${context.l10n.referralShareAction}: ${value.code}',
                                  subject: context.l10n.appName,
                                );
                            if (!context.mounted) return;
                            if (result.copied) {
                              context.showSnack(context.l10n.commonCopied);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: <Widget>[
                Expanded(
                  child: StatTile(
                    icon: Icons.people_outline_rounded,
                    label: context.l10n.referralCompletedLabel,
                    value: '${value.completedCount}',
                    tone: palette.success,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: StatTile(
                    icon: Icons.hourglass_bottom_rounded,
                    label: context.l10n.referralPendingLabel,
                    value: '${value.pendingCount}',
                    tone: palette.warning,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: StatTile(
                    icon: Icons.stars_rounded,
                    label: context.l10n.profilePoints,
                    value: '${value.pointsEarned}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    context.l10n.referralHowTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _Step(
                    index: 1,
                    text: context.l10n.referralStep1,
                  ),
                  _Step(
                    index: 2,
                    text: context.l10n.referralStep2,
                  ),
                  _Step(
                    index: 3,
                    text: context.l10n.referralStep3,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SectionHeader(title: context.l10n.referralCompletedLabel),
            if (value.invites.isEmpty)
              EmptyStateView(
                compact: true,
                icon: Icons.group_add_outlined,
                title: context.l10n.referralEmptyTitle,
                message: context.l10n.referralEmptyMessage,
              )
            else
              ...value.invites.map(
                (ReferralInvite invite) => AppCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: <Widget>[
                      UserAvatar(
                        initials: (invite.name ?? 'P+').initials,
                        size: AppSizes.avatarSm,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              invite.name ?? '—',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13.5,
                              ),
                            ),
                            Text(
                              AppFormatters.relative(
                                context,
                                invite.createdAt,
                              ),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      StatusBadge(
                        label: invite.isCompleted
                            ? context.l10n.referralCompletedLabel
                            : context.l10n.referralPendingLabel,
                        color: invite.isCompleted
                            ? palette.success
                            : palette.warning,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final class _Step extends StatelessWidget {
  const _Step({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 24,
            width: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: palette.brandSoft,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$index',
              style: TextStyle(
                color: palette.brand,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
