import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/image_thumb.dart';
import '../../../../core/widgets/skeletons.dart';
import '../../../promotions/data/models/promotion.dart';
import '../../data/models/manage_inputs.dart';
import '../providers/business_providers.dart';

/// Administración de promociones del negocio (alta, edición y baja).
final class BusinessPromotionsScreen extends ConsumerWidget {
  const BusinessPromotionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppPalette palette = context.palette;
    final AsyncValue<List<PromotionModel>> promotions =
        ref.watch(businessPromotionsControllerProvider);

    return AppScaffold(
      title: context.l10n.managePromotionsTitle,
      showBackButton: true,
      scrollable: false,
      padding: EdgeInsets.zero,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context, ref),
        backgroundColor: palette.brand,
        foregroundColor: palette.onBrand,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          context.l10n.managePromotionsNewAction,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: AsyncValueView<List<PromotionModel>>(
        value: promotions,
        loading: const Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: ListSkeleton(items: 4, height: 88),
        ),
        onRetry: () =>
            ref.read(businessPromotionsControllerProvider.notifier).refresh(),
        emptyBuilder: (List<PromotionModel> value) => value.isEmpty
            ? EmptyStateView(
                icon: Icons.local_offer_outlined,
                title: context.l10n.managePromotionsEmptyTitle,
                message: context.l10n.managePromotionsEmptyMessage,
                actionLabel: context.l10n.managePromotionsNewAction,
                onAction: () => _openForm(context, ref),
              )
            : null,
        builder: (List<PromotionModel> value) => ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.md,
            AppSpacing.xl,
            96,
          ),
          children: <Widget>[
            Text(
              context.l10n.managePromotionsSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            ...value.map(
              (PromotionModel promotion) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: AppCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          RemoteImage(
                            url: promotion.imageUrl,
                            fallbackInitials: promotion.title,
                            width: 56,
                            height: 56,
                            icon: Icons.local_offer_rounded,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  promotion.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  promotion.validityLabel(context),
                                  style:
                                      Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 4),
                                StatusBadge(
                                  label: switch (promotion.statusAt()) {
                                    PromotionStatus.active =>
                                      context.l10n.managePromotionsStatusActive,
                                    PromotionStatus.scheduled => context
                                        .l10n.managePromotionsStatusScheduled,
                                    PromotionStatus.expired => context
                                        .l10n.managePromotionsStatusExpired,
                                    PromotionStatus.paused => context
                                        .l10n.managePromotionsStatusPaused,
                                  },
                                  color: switch (promotion.statusAt()) {
                                    PromotionStatus.active => palette.success,
                                    PromotionStatus.scheduled => palette.brand,
                                    PromotionStatus.expired =>
                                      palette.textMuted,
                                    PromotionStatus.paused => palette.warning,
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (promotion.description != null) ...<Widget>[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          promotion.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: SecondaryButton(
                              label: context.l10n.commonEdit,
                              icon: Icons.edit_outlined,
                              onPressed: () =>
                                  _openForm(context, ref, promotion: promotion),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          IconActionButton(
                            icon: Icons.delete_outline_rounded,
                            color: palette.error,
                            tooltip: context.l10n.commonDelete,
                            onPressed: () =>
                                _delete(context, ref, promotion),
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
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    PromotionModel promotion,
  ) async {
    final bool confirmed = await showConfirmDialog(
      context: context,
      title: context.l10n.managePromotionsDeleteConfirmTitle,
      message: context.l10n.managePromotionsDeleteConfirmMessage,
      confirmLabel: context.l10n.commonDelete,
      isDestructive: true,
    );
    if (!confirmed) return;
    try {
      await ref
          .read(businessPromotionsControllerProvider.notifier)
          .delete(promotion.id);
      if (!context.mounted) return;
      context.showSnack(
        context.l10n.managePromotionsDeleted,
        kind: AppSnackKind.success,
      );
    } catch (error) {
      if (!context.mounted) return;
      context.showSnack(
        context.l10n.managePromotionsError,
        kind: AppSnackKind.error,
      );
    }
  }

  Future<void> _openForm(
    BuildContext context,
    WidgetRef ref, {
    PromotionModel? promotion,
  }) =>
      showAppSheet<void>(
        context: context,
        child: _PromotionForm(promotion: promotion),
      );
}

final class _PromotionForm extends ConsumerStatefulWidget {
  const _PromotionForm({this.promotion});

  final PromotionModel? promotion;

  @override
  ConsumerState<_PromotionForm> createState() => _PromotionFormState();
}

final class _PromotionFormState extends ConsumerState<_PromotionForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _title =
      TextEditingController(text: widget.promotion?.title ?? '');
  late final TextEditingController _description =
      TextEditingController(text: widget.promotion?.description ?? '');
  late DateTime? _startsAt = widget.promotion?.startsAt;
  late DateTime? _endsAt = widget.promotion?.endsAt;
  late bool _isActive = widget.promotion?.isActive ?? true;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            widget.promotion == null
                ? context.l10n.managePromotionsFormCreateTitle
                : context.l10n.managePromotionsFormEditTitle,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: context.l10n.managePromotionsFieldTitle,
            hintText: context.l10n.managePromotionsFieldTitleHint,
            controller: _title,
            prefixIcon: Icons.campaign_outlined,
            required: true,
            validator: (String? value) => (value ?? '').trim().length < 4
                ? context.l10n.validationNameShort
                : null,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: context.l10n.managePromotionsFieldDescription,
            controller: _description,
            prefixIcon: Icons.notes_rounded,
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.lg),
          _DateField(
            label: context.l10n.managePromotionsFieldStartsAt,
            value: _startsAt,
            onChanged: (DateTime? value) => setState(() => _startsAt = value),
          ),
          const SizedBox(height: AppSpacing.sm),
          _DateField(
            label: context.l10n.managePromotionsFieldEndsAt,
            value: _endsAt,
            onChanged: (DateTime? value) => setState(() => _endsAt = value),
          ),
          const SizedBox(height: AppSpacing.sm),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _isActive,
            onChanged: (bool value) => setState(() => _isActive = value),
            title: Text(
              context.l10n.managePromotionsFieldActive,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            activeThumbColor: palette.brand,
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: context.l10n.managePromotionsSaveAction,
            icon: Icons.check_rounded,
            isLoading: _saving,
            onPressed: _save,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.commonCancel),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_startsAt != null &&
        _endsAt != null &&
        _endsAt!.isBefore(_startsAt!)) {
      context.showSnack(
        context.l10n.validationDateOrder,
        kind: AppSnackKind.error,
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await ref
          .read(businessPromotionsControllerProvider.notifier)
          .save(
            id: widget.promotion?.id,
            input: PromotionInput(
              title: _title.text,
              description: _description.text,
              startsAt: _startsAt,
              endsAt: _endsAt,
              isActive: _isActive,
              imageUrl: widget.promotion?.imageUrl,
            ),
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      context.showSnack(
        context.l10n.managePromotionsSaved,
        kind: AppSnackKind.success,
      );
    } catch (error) {
      if (!mounted) return;
      context.showSnack(
        context.l10n.managePromotionsSaveError,
        kind: AppSnackKind.error,
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

final class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return InkWell(
      borderRadius: AppRadius.allMd,
      onTap: () async {
        final DateTime? picked = await pickAppDate(
          context: context,
          initialDate: value,
        );
        if (picked != null) onChanged(picked);
      },
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: <Widget>[
            Icon(Icons.event_outlined, size: 18, color: palette.brand),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(label, style: Theme.of(context).textTheme.bodySmall),
                  Text(
                    value == null
                        ? context.l10n.managePromotionsPickDate
                        : AppFormatters.longDate(context, value),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (value != null)
              IconActionButton(
                icon: Icons.close_rounded,
                tooltip: context.l10n.commonClear,
                onPressed: () => onChanged(null),
              ),
          ],
        ),
      ),
    );
  }
}
