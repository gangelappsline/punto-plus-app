import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/skeletons.dart';
import '../../data/models/reward.dart';
import '../providers/rewards_providers.dart';
import '../widgets/reward_tile.dart';

/// Premios del cliente organizados por estado.
final class RewardsScreen extends ConsumerStatefulWidget {
  const RewardsScreen({super.key});

  @override
  ConsumerState<RewardsScreen> createState() => _RewardsScreenState();
}

final class _RewardsScreenState extends ConsumerState<RewardsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final AsyncValue<List<RewardModel>> rewards =
        ref.watch(rewardsControllerProvider);

    return AppScaffold(
      scrollable: false,
      title: context.l10n.rewardsTitle,
      padding: EdgeInsets.zero,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.md,
              AppSpacing.xl,
              AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
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
                      Tab(text: context.l10n.rewardsTabAvailable),
                      Tab(text: context.l10n.rewardsTabRedeemed),
                      Tab(text: context.l10n.rewardsTabExpired),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: AsyncValueView<List<RewardModel>>(
              value: rewards,
              loading: const Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: ListSkeleton(items: 4),
              ),
              onRetry: () =>
                  ref.read(rewardsControllerProvider.notifier).refresh(),
              builder: (List<RewardModel> value) => TabBarView(
                controller: _tabs,
                children: <Widget>[
                  _RewardList(
                    status: RewardStatus.available,
                    emptyTitle: context.l10n.rewardsEmptyAvailableTitle,
                    emptyMessage: context.l10n.rewardsEmptyAvailableMessage,
                    onRefresh: () => ref
                        .read(rewardsControllerProvider.notifier)
                        .refresh(),
                  ),
                  _RewardList(
                    status: RewardStatus.redeemed,
                    emptyTitle: context.l10n.rewardsEmptyRedeemedTitle,
                    emptyMessage: context.l10n.rewardsEmptyRedeemedMessage,
                    onRefresh: () => ref
                        .read(rewardsControllerProvider.notifier)
                        .refresh(),
                  ),
                  _RewardList(
                    status: RewardStatus.expired,
                    emptyTitle: context.l10n.rewardsEmptyExpiredTitle,
                    emptyMessage: context.l10n.rewardsEmptyExpiredMessage,
                    onRefresh: () => ref
                        .read(rewardsControllerProvider.notifier)
                        .refresh(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _RewardList extends ConsumerWidget {
  const _RewardList({
    required this.status,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.onRefresh,
  });

  final RewardStatus status;
  final String emptyTitle;
  final String emptyMessage;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<RewardModel> items =
        ref.watch(rewardsByStatusProvider(status));
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: items.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                EmptyStateView(
                  icon: status == RewardStatus.available
                      ? Icons.card_giftcard_outlined
                      : Icons.history_rounded,
                  title: emptyTitle,
                  message: emptyMessage,
                  actionLabel: context.l10n.commonRetry,
                  onAction: onRefresh,
                ),
              ],
            )
          : ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.md,
                AppSpacing.xl,
                96,
              ),
              children: items
                  .map(
                    (RewardModel reward) => RewardTile(
                      reward: reward,
                      onTap: () =>
                          context.push(AppRoutes.rewardDetailPath(reward.id)),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
