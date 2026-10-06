import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/image_thumb.dart';
import '../../../../core/widgets/progress.dart';
import '../../../../core/widgets/skeletons.dart';
import '../../../cards/data/models/loyalty_card.dart';
import '../providers/business_providers.dart';

/// Tarjetas de fidelidad configuradas por el negocio.
final class BusinessCardsScreen extends ConsumerWidget {
  const BusinessCardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppPalette palette = context.palette;
    final int maxStamps = AppConstants.maxRequiredStamps;
    final AsyncValue<List<LoyaltyCardModel>> cards =
        ref.watch(businessCardsControllerProvider);

    return AppScaffold(
      title: context.l10n.manageCardsTitle,
      showBackButton: true,
      scrollable: false,
      padding: EdgeInsets.zero,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.businessCardForm),
        backgroundColor: palette.brand,
        foregroundColor: palette.onBrand,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          context.l10n.manageCardsNewAction,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: AsyncValueView<List<LoyaltyCardModel>>(
        value: cards,
        loading: const Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: CardSkeleton(height: 168),
        ),
        onRetry: () =>
            ref.read(businessCardsControllerProvider.notifier).refresh(),
        emptyBuilder: (List<LoyaltyCardModel> value) => value.isEmpty
            ? EmptyStateView(
                icon: Icons.credit_card_outlined,
                title: context.l10n.manageCardsEmptyTitle,
                message: context.l10n.manageCardsEmptyMessage,
                actionLabel: context.l10n.manageCardsNewAction,
                onAction: () => context.push(AppRoutes.businessCardForm),
              )
            : null,
        builder: (List<LoyaltyCardModel> value) => ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.md,
            AppSpacing.xl,
            96,
          ),
          children: <Widget>[
            Text(
              context.l10n.manageCardsSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            ...value.map(
              (LoyaltyCardModel card) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: AppCard(
                  padding: AppSpacing.md,
                  onTap: () => context.push(
                    AppRoutes.businessCardFormPath(id: card.id),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          RemoteImage(
                            url: card.logoUrl ?? card.stampIconUrl,
                            fallbackInitials: card.name,
                            width: 52,
                            height: 52,
                            radius: AppRadius.md,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  card.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${card.requiredStamps} '
                                  '${context.l10n.commonStampsCount} · '
                                  '${card.customersCount} '
                                  '${context.l10n.manageDashboardQuickCustomers}',
                                  style:
                                      Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          StatusBadge(
                            label: card.isActive
                                ? context.l10n.manageCardsFieldActive
                                : context.l10n.cardsInactive,
                            color: card.isActive
                                ? palette.success
                                : palette.textMuted,
                          ),
                        ],
                      ),
                      if (card.rewardDescription != null) ...<Widget>[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          card.rewardDescription!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                      const SizedBox(height: AppSpacing.md),
                      StampsGrid(
                        stampsCount: 0,
                        requiredStamps: card.requiredStamps,
                        columns: 8,
                        stampSize: 22,
                        tone: palette.brand,
                        pendingTone: palette.segmented,
                        animate: false,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: SecondaryButton(
                              label: context.l10n.commonEdit,
                              icon: Icons.edit_outlined,
                              onPressed: () => context.push(
                                AppRoutes.businessCardFormPath(id: card.id),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          IconActionButton(
                            icon: Icons.delete_outline_rounded,
                            color: palette.error,
                            tooltip: context.l10n.commonDelete,
                            onPressed: () => _delete(context, ref, card),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${context.l10n.manageCardsAssetsHint} '
              '$maxStamps ${context.l10n.commonStampsCount}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    LoyaltyCardModel card,
  ) async {
    final bool confirmed = await showConfirmDialog(
      context: context,
      title: context.l10n.manageCardsDeleteConfirmTitle,
      message: context.l10n.manageCardsDeleteConfirmMessage,
      confirmLabel: context.l10n.commonDelete,
      isDestructive: true,
    );
    if (!confirmed) return;
    try {
      await ref
          .read(businessCardsControllerProvider.notifier)
          .delete(card.id);
      if (!context.mounted) return;
      context.showSnack(
        context.l10n.manageCardsDeleted,
        kind: AppSnackKind.success,
      );
    } catch (error) {
      if (!context.mounted) return;
      context.showSnack(
        context.l10n.manageCardsError,
        kind: AppSnackKind.error,
      );
    }
  }
}
