import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/platform/device_services.dart';
import '../../../../core/providers/data_providers.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/image_thumb.dart';
import '../../../../core/widgets/progress.dart';
import '../../../../core/widgets/skeletons.dart';
import '../../data/models/business_customer.dart';
import '../providers/business_providers.dart';

/// Ficha de un cliente fiel: contacto, avance y sellos.
final class BusinessCustomerDetailScreen extends ConsumerWidget {
  const BusinessCustomerDetailScreen({required this.customerId, super.key});

  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppPalette palette = context.palette;
    final AsyncValue<BusinessCustomerModel> customer =
        ref.watch(businessCustomerDetailProvider(customerId));

    return AppScaffold(
      title: context.l10n.manageCustomersDetailTitle,
      showBackButton: true,
      scrollable: false,
      padding: EdgeInsets.zero,
      body: customer.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: ListSkeleton(items: 4, height: 72),
        ),
        error: (Object error, StackTrace stack) => Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: ErrorStateView(
            message: context.l10n.manageCustomersErrorDetail,
            onRetry: () =>
                ref.invalidate(businessCustomerDetailProvider(customerId)),
          ),
        ),
        data: (BusinessCustomerModel value) => ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: <Widget>[
            AppCard(
              child: Column(
                children: <Widget>[
                  UserAvatar(
                    initials: value.initials,
                    imageUrl: value.avatarUrl,
                    size: AppSizes.avatarLg,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    value.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.sm,
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      StatusBadge(
                        label:
                            '${value.stampsTotal} ${context.l10n.commonStampsCount}',
                        color: palette.brand,
                        icon: Icons.approval_rounded,
                      ),
                      if (value.joinedAt != null)
                        StatusBadge(
                          label: AppFormatters.shortDate(
                            context,
                            value.joinedAt,
                          ),
                          color: palette.textMuted,
                          icon: Icons.event_outlined,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DetailRow(
                    icon: Icons.mail_outline_rounded,
                    label: context.l10n.authEmailLabel,
                    value: value.email,
                  ),
                  DetailRow(
                    icon: Icons.phone_outlined,
                    label: context.l10n.authPhoneLabel,
                    value: value.phone,
                    trailing: value.phone == null
                        ? null
                        : IconActionButton(
                            icon: Icons.copy_rounded,
                            tooltip: context.l10n.commonCopy,
                            onPressed: () async {
                              final ShareResult result = await ref
                                  .read(shareServiceProvider)
                                  .shareText(value.phone!);
                              if (!context.mounted) return;
                              if (result.copied) {
                                context.showSnack(context.l10n.commonCopied);
                              }
                            },
                          ),
                  ),
                  DetailRow(
                    icon: Icons.history_rounded,
                    label: context.l10n.manageScanRecentTitle,
                    value: AppFormatters.dateTime(context, value.lastVisitAt),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SectionHeader(title: context.l10n.cardsTitle),
            if (value.cards.isEmpty)
              EmptyStateView(
                compact: true,
                icon: Icons.credit_card_off_outlined,
                title: context.l10n.cardsEmptyTitle,
                message: context.l10n.cardsEmptyMessage,
              )
            else
              ...value.cards.map(
                (CustomerCardProgress card) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                card.cardName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13.5,
                                ),
                              ),
                            ),
                            Text(
                              '${card.stampsCount}/${card.requiredStamps}',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: palette.brand,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        AnimatedProgressBar(value: card.progress),
                        const SizedBox(height: AppSpacing.sm),
                        StampsGrid(
                          stampsCount: card.stampsCount,
                          requiredStamps: card.requiredStamps,
                          columns: 8,
                          stampSize: 24,
                          animate: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            SecondaryButton(
              label: context.l10n.manageScanManualEntry,
              icon: Icons.qr_code_scanner_rounded,
              onPressed: () => context.showSnack(
                context.l10n.manageScanInstruction,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
