import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/image_thumb.dart';
import '../../../../core/widgets/skeletons.dart';
import '../../data/models/business_customer.dart';
import '../providers/business_providers.dart';

/// Clientes fieles del negocio con búsqueda por nombre o contacto.
final class BusinessCustomersScreen extends ConsumerStatefulWidget {
  const BusinessCustomersScreen({super.key});

  @override
  ConsumerState<BusinessCustomersScreen> createState() =>
      _BusinessCustomersScreenState();
}

final class _BusinessCustomersScreenState
    extends ConsumerState<BusinessCustomersScreen> {
  final TextEditingController _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final AsyncValue<List<BusinessCustomerModel>> customers =
        ref.watch(businessCustomersProvider(_query));

    return AppScaffold(
      title: context.l10n.manageCustomersTitle,
      showBackButton: true,
      scrollable: false,
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
              children: <Widget>[
                Text(
                  context.l10n.manageCustomersSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                SearchField(
                  controller: _search,
                  hintText: context.l10n.manageCustomersSearchHint,
                  onChanged: (String value) => setState(() => _query = value),
                  onClear: () => setState(() {
                    _query = '';
                    _search.clear();
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: AsyncValueView<List<BusinessCustomerModel>>(
              value: customers,
              loading: const Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: ListSkeleton(items: 5, height: 64),
              ),
              onRetry: () => ref.invalidate(businessCustomersProvider(_query)),
              emptyBuilder: (List<BusinessCustomerModel> value) =>
                  value.isEmpty
                      ? EmptyStateView(
                          icon: Icons.people_outline_rounded,
                          title: context.l10n.manageCustomersEmptyTitle,
                          message: context.l10n.manageCustomersEmptyMessage,
                        )
                      : null,
              builder: (List<BusinessCustomerModel> value) => ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  0,
                  AppSpacing.xl,
                  96,
                ),
                children: <Widget>[
                  Text(
                    '${value.length} '
                    '${context.l10n.manageDashboardQuickCustomers}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...value.map(
                    (BusinessCustomerModel customer) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: AppCard(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        onTap: () => context.push(
                          AppRoutes.businessCustomerPath(customer.id),
                        ),
                        child: Row(
                          children: <Widget>[
                            UserAvatar(
                              initials: customer.initials,
                              imageUrl: customer.avatarUrl,
                              size: AppSizes.avatarSm,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    customer.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 13.5,
                                    ),
                                  ),
                                  Text(
                                    customer.phone ??
                                        customer.email ??
                                        context.l10n.profileRoleCustomer,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall,
                                  ),
                                  Text(
                                    '${context.l10n.manageDashboardMetricStampsToday}: '
                                    '${customer.stampsTotal}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                StatusBadge(
                                  label:
                                      '${customer.stampsTotal} ${context.l10n.commonStampsCount}',
                                  color: palette.brand,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppFormatters.relative(
                                    context,
                                    customer.lastVisitAt,
                                  ),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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
