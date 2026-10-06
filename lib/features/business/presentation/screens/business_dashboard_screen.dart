import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/image_thumb.dart';
import '../../../../core/widgets/skeletons.dart';
import '../../../cards/data/models/stamp.dart';
import '../../data/models/business_dashboard.dart';
import '../providers/business_providers.dart';
import '../widgets/metric_charts.dart';

/// Panel del negocio: métricas, gráfica, mejores clientes y sellos.
final class BusinessDashboardScreen extends ConsumerStatefulWidget {
  const BusinessDashboardScreen({super.key});

  @override
  ConsumerState<BusinessDashboardScreen> createState() =>
      _BusinessDashboardScreenState();
}

final class _BusinessDashboardScreenState
    extends ConsumerState<BusinessDashboardScreen> {
  bool _isMonth = false;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final AsyncValue<BusinessDashboard> dashboard =
        ref.watch(businessDashboardProvider);
    final String businessName =
        ref.watch(currentUserProvider)?.displayName ?? context.l10n.appName;

    return AppScaffold(
      scrollable: false,
      title: context.l10n.manageDashboardTitle,
      actions: <Widget>[
        IconActionButton(
          icon: Icons.storefront_outlined,
          tooltip: context.l10n.profileSwitchToCustomer,
          onPressed: () => context.go(AppRoutes.home),
        ),
        const SizedBox(width: AppSpacing.sm),
      ],
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        96,
      ),
      body: dashboard.when(
        loading: () => const StatsSkeleton(),
        error: (Object error, StackTrace stack) => ErrorStateView(
          message: context.l10n.manageDashboardError,
          onRetry: () => ref.invalidate(businessDashboardProvider),
        ),
        data: (BusinessDashboard value) => ListView(
          children: <Widget>[
            Text(
              businessName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              context.l10n.manageDashboardSubtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              childAspectRatio: 1.55,
              children: <Widget>[
                StatTile(
                  icon: Icons.approval_rounded,
                  label: context.l10n.manageDashboardMetricStampsToday,
                  value: '${value.stampsToday}',
                  tone: palette.brand,
                ),
                StatTile(
                  icon: Icons.calendar_month_rounded,
                  label: context.l10n.manageDashboardMetricStampsMonth,
                  value: '${value.stampsMonth}',
                  tone: palette.accent,
                ),
                StatTile(
                  icon: Icons.people_alt_rounded,
                  label: context.l10n.manageDashboardMetricCustomers,
                  value: '${value.customersCount}',
                  tone: palette.success,
                ),
                StatTile(
                  icon: Icons.credit_card_rounded,
                  label: context.l10n.manageDashboardMetricActiveCards,
                  value: '${value.activeCardsCount}',
                  tone: palette.warning,
                ),
                StatTile(
                  icon: Icons.redeem_rounded,
                  label: context.l10n.manageDashboardMetricRedemptions,
                  value: '${value.redemptionsMonth}',
                  tone: palette.error,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          context.l10n.manageDashboardChartTitle,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      ChartRangeSelector(
                        isMonth: _isMonth,
                        onChanged: (bool value) =>
                            setState(() => _isMonth = value),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  MetricBarChart(
                    points: _slice(value.series),
                    tone: palette.brand,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SectionHeader(
              title: context.l10n.manageDashboardQuickScan,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: _QuickTile(
                    icon: Icons.qr_code_scanner_rounded,
                    label: context.l10n.manageDashboardQuickScan,
                    onTap: () => context.push(AppRoutes.businessScan),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _QuickTile(
                    icon: Icons.credit_card_rounded,
                    label: context.l10n.manageDashboardQuickCards,
                    onTap: () => context.push(AppRoutes.businessCards),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _QuickTile(
                    icon: Icons.local_offer_rounded,
                    label: context.l10n.manageDashboardQuickPromotions,
                    onTap: () => context.push(AppRoutes.businessPromotions),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _QuickTile(
                    icon: Icons.people_outline_rounded,
                    label: context.l10n.manageDashboardQuickCustomers,
                    onTap: () => context.push(AppRoutes.businessCustomers),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            SectionHeader(
              title: context.l10n.manageDashboardTopCustomersTitle,
              actionLabel: context.l10n.commonSeeAll,
              onAction: () => context.push(AppRoutes.businessCustomers),
            ),
            if (value.topCustomers.isEmpty)
              EmptyStateView(
                compact: true,
                icon: Icons.emoji_events_outlined,
                title: context.l10n.manageDashboardRecentEmpty,
                message: context.l10n.manageCustomersEmptyMessage,
              )
            else
              ...value.topCustomers.map(
                (TopCustomer customer) => AppCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  onTap: () => context.push(
                    AppRoutes.businessCustomerPath(customer.id),
                  ),
                  child: Row(
                    children: <Widget>[
                      UserAvatar(
                        initials: customer.name.initials,
                        imageUrl: customer.avatarUrl,
                        size: AppSizes.avatarSm,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          customer.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                      StatusBadge(
                        label:
                            '${customer.stamps} ${context.l10n.commonStampsCount}',
                        color: palette.brand,
                        icon: Icons.star_rounded,
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            SectionHeader(
              title: context.l10n.manageDashboardRecentStampsTitle,
              subtitle: context.l10n.manageScanRecentTitle,
            ),
            if (value.recentStamps.isEmpty)
              EmptyStateView(
                compact: true,
                icon: Icons.history_rounded,
                title: context.l10n.manageScanRecentEmpty,
                message: context.l10n.commonEmptyGenericMessage,
              )
            else
              ...value.recentStamps.map(_stampRow),
          ],
        ),
      ),
    );
  }

  List<MetricPoint> _slice(List<MetricPoint> series) {
    if (series.isEmpty) return series;
    final int size = _isMonth ? 30 : 7;
    return series.length <= size
        ? series
        : series.sublist(series.length - size);
  }

  Widget _stampRow(StampModel stamp) {
    final AppPalette palette = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: <Widget>[
            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                color: palette.brandSoft,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.star_rounded, size: 17, color: palette.brand),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    stamp.customerName ?? '—',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    stamp.cardName ?? '',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Text(
              AppFormatters.relative(context, stamp.createdAt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

final class _QuickTile extends StatelessWidget {
  const _QuickTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return AppCard(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.sm,
      ),
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Icon(icon, color: palette.brand, size: 20),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              color: palette.text,
            ),
          ),
        ],
      ),
    );
  }
}
