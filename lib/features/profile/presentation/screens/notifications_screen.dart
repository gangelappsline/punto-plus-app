import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/skeletons.dart';
import '../../data/models/app_notification.dart';
import '../providers/profile_providers.dart';

/// Bandeja de avisos del cliente.
final class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppPalette palette = context.palette;
    final AsyncValue<List<AppNotificationModel>> notifications =
        ref.watch(notificationsControllerProvider);
    final bool hasUnread = (notifications.valueOrNull ??
            <AppNotificationModel>[])
        .any((AppNotificationModel item) => !item.isRead);

    return AppScaffold(
      title: context.l10n.notificationsTitle,
      showBackButton: true,
      scrollable: false,
      padding: EdgeInsets.zero,
      actions: <Widget>[
        if (hasUnread)
          TextButton(
            onPressed: () async {
              await ref
                  .read(notificationsControllerProvider.notifier)
                  .markAllRead();
              if (!context.mounted) return;
              context.showSnack(
                context.l10n.notificationsMarkedRead,
                kind: AppSnackKind.success,
              );
            },
            child: Text(context.l10n.notificationsMarkAllRead),
          ),
      ],
      body: AsyncValueView<List<AppNotificationModel>>(
        value: notifications,
        loading: const Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: ListSkeleton(items: 5, height: 70),
        ),
        onRetry: () =>
            ref.read(notificationsControllerProvider.notifier).refresh(),
        emptyBuilder: (List<AppNotificationModel> value) => value.isEmpty
            ? EmptyStateView(
                icon: Icons.notifications_off_outlined,
                title: context.l10n.notificationsEmptyTitle,
                message: context.l10n.notificationsEmptyMessage,
                actionLabel: context.l10n.commonRetry,
                onAction: () => ref
                    .read(notificationsControllerProvider.notifier)
                    .refresh(),
              )
            : null,
        builder: (List<AppNotificationModel> value) => ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.xl),
          itemCount: value.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (BuildContext context, int index) {
            final AppNotificationModel item = value[index];
            return AppCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              color: item.isRead ? null : palette.brandSoft,
              borderColor: item.isRead
                  ? null
                  : palette.brand.withValues(alpha: 0.3),
              onTap: () => ref
                  .read(notificationsControllerProvider.notifier)
                  .markRead(item.id),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      color: palette.brand.withValues(alpha: 0.14),
                      borderRadius: AppRadius.allSm,
                    ),
                    child: Icon(
                      switch (item.type) {
                        AppNotificationType.stamp =>
                          Icons.approval_rounded,
                        AppNotificationType.reward =>
                          Icons.card_giftcard_rounded,
                        AppNotificationType.promotion =>
                          Icons.local_offer_rounded,
                        AppNotificationType.generic =>
                          Icons.notifications_rounded,
                      },
                      size: 18,
                      color: palette.brand,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13.5,
                                  color: palette.text,
                                ),
                              ),
                            ),
                            if (!item.isRead)
                              Container(
                                height: 8,
                                width: 8,
                                decoration: BoxDecoration(
                                  color: palette.brand,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.body,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          AppFormatters.relative(context, item.createdAt),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: palette.textFaint),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
