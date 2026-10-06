import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/platform/device_services.dart';
import '../../../../core/providers/data_providers.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/image_thumb.dart';
import '../../../../core/widgets/progress.dart';
import '../../../cards/data/models/loyalty_card.dart';
import '../../data/models/manage_inputs.dart';
import '../providers/business_providers.dart';

/// Alta y edición de tarjetas del negocio en cuatro pasos.
final class BusinessCardFormScreen extends ConsumerStatefulWidget {
  const BusinessCardFormScreen({this.cardId, super.key});

  final String? cardId;

  @override
  ConsumerState<BusinessCardFormScreen> createState() =>
      _BusinessCardFormScreenState();
}

final class _BusinessCardFormScreenState
    extends ConsumerState<BusinessCardFormScreen> {
  final GlobalKey<FormState> _basicsKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _reward = TextEditingController();
  int _requiredStamps = AppConstants.defaultRequiredStamps;
  Color _color = AppFormatters.colorFromHex(
        AppConstants.cardColorPresets.first,
      ) ??
      const Color(0xFF007D8D);
  String? _logoUrl;
  String? _backgroundUrl;
  String? _stampIconUrl;
  bool _isActive = true;
  int _step = 0;
  bool _saving = false;
  bool _loaded = false;

  bool get _isEditing => widget.cardId != null;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _reward.dispose();
    super.dispose();
  }

  void _hydrate(LoyaltyCardModel card) {
    if (_loaded) return;
    _loaded = true;
    _name.text = card.name;
    _description.text = card.description ?? '';
    _reward.text = card.rewardDescription ?? '';
    _requiredStamps = card.requiredStamps;
    _color = card.backgroundColor ?? _color;
    _logoUrl = card.logoUrl;
    _backgroundUrl = card.backgroundUrl;
    _stampIconUrl = card.stampIconUrl;
    _isActive = card.isActive;
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final List<LoyaltyCardModel> cards =
        ref.watch(businessCardsControllerProvider).valueOrNull ??
            <LoyaltyCardModel>[];
    if (_isEditing && !_loaded) {
      for (final LoyaltyCardModel card in cards) {
        if (card.id == widget.cardId) _hydrate(card);
      }
    }

    return AppScaffold(
      title: _isEditing
          ? context.l10n.manageCardsFormEditTitle
          : context.l10n.manageCardsFormCreateTitle,
      showBackButton: true,
      scrollable: false,
      padding: EdgeInsets.zero,
      bottomBar: BottomActionBar(
        child: Row(
          children: <Widget>[
            if (_step > 0) ...<Widget>[
              Expanded(
                child: SecondaryButton(
                  label: context.l10n.manageCardsStepBack,
                  icon: Icons.arrow_back_rounded,
                  onPressed: _saving
                      ? null
                      : () => setState(() => _step -= 1),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              flex: 2,
              child: PrimaryButton(
                label: _step == 3
                    ? context.l10n.manageCardsSaveAction
                    : context.l10n.manageCardsStepNext,
                icon: _step == 3
                    ? Icons.check_rounded
                    : Icons.arrow_forward_rounded,
                isLoading: _saving,
                onPressed: _saving ? null : _next,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: <Widget>[
          StepDots(
            count: 4,
            currentIndex: _step,
            labels: <String>[
              context.l10n.manageCardsStepBasics,
              context.l10n.manageCardsStepReward,
              context.l10n.manageCardsStepDesign,
              context.l10n.manageCardsStepReview,
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          if (_step == 0)
            Form(
              key: _basicsKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  AppTextField(
                    label: context.l10n.manageCardsFieldName,
                    hintText: context.l10n.manageCardsFieldNameHint,
                    controller: _name,
                    prefixIcon: Icons.badge_outlined,
                    required: true,
                    validator: (String? value) =>
                        (value ?? '').trim().length < 3
                            ? context.l10n.validationNameShort
                            : null,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    label: context.l10n.manageCardsFieldDescription,
                    hintText: context.l10n.manageCardsFieldDescriptionHint,
                    controller: _description,
                    prefixIcon: Icons.notes_rounded,
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _StampsPicker(
                    value: _requiredStamps,
                    onChanged: (int value) =>
                        setState(() => _requiredStamps = value),
                  ),
                ],
              ),
            ),
          if (_step == 1)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                AppTextField(
                  label: context.l10n.manageCardsFieldReward,
                  hintText: context.l10n.manageCardsFieldRewardHint,
                  controller: _reward,
                  prefixIcon: Icons.card_giftcard_outlined,
                  maxLines: 3,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        context.l10n.manageCardsPreviewTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      StampsGrid(
                        stampsCount: (_requiredStamps / 2).floor(),
                        requiredStamps: _requiredStamps,
                        columns: 6,
                        stampSize: 30,
                        tone: palette.brand,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          if (_step == 2)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  context.l10n.manageCardsFieldColor,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: AppConstants.cardColorPresets.map((String hex) {
                    final Color option =
                        AppFormatters.colorFromHex(hex) ?? palette.brand;
                    final bool selected = option.toARGB32() == _color.toARGB32();
                    return GestureDetector(
                      onTap: () => setState(() => _color = option),
                      child: Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          color: option,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected ? palette.text : palette.divider,
                            width: selected ? 3 : 1.5,
                          ),
                        ),
                        child: selected
                            ? Icon(
                                Icons.check_rounded,
                                color: option.computeLuminance() > 0.6
                                    ? Colors.black87
                                    : Colors.white,
                                size: 20,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  context.l10n.manageCardsAssetsTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  context.l10n.manageCardsAssetsHint,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.md),
                _AssetPicker(
                  label: context.l10n.manageCardsAssetsLogo,
                  field: 'logo',
                  cardId: widget.cardId,
                  url: _logoUrl,
                  onChanged: (String? url) => setState(() => _logoUrl = url),
                ),
                const SizedBox(height: AppSpacing.sm),
                _AssetPicker(
                  label: context.l10n.manageCardsAssetsBackground,
                  field: 'background',
                  cardId: widget.cardId,
                  url: _backgroundUrl,
                  onChanged: (String? url) =>
                      setState(() => _backgroundUrl = url),
                ),
                const SizedBox(height: AppSpacing.sm),
                _AssetPicker(
                  label: context.l10n.manageCardsAssetsStampIcon,
                  field: 'stamp_icon',
                  cardId: widget.cardId,
                  url: _stampIconUrl,
                  onChanged: (String? url) =>
                      setState(() => _stampIconUrl = url),
                ),
                const SizedBox(height: AppSpacing.lg),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _isActive,
                  onChanged: (bool value) => setState(() => _isActive = value),
                  title: Text(
                    context.l10n.manageCardsFieldActive,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(context.l10n.manageCardsFieldActiveSubtitle),
                ),
              ],
            ),
          if (_step == 3) _ReviewPreview(
                name: _name.text,
                reward: _reward.text,
                description: _description.text,
                requiredStamps: _requiredStamps,
                color: _color,
                logoUrl: _logoUrl,
                isActive: _isActive,
              ),
        ],
      ),
    );
  }

  Future<void> _next() async {
    if (_step < 3) {
      if (_step == 0 && !(_basicsKey.currentState?.validate() ?? false)) {
        return;
      }
      setState(() => _step += 1);
      return;
    }
    await _save();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final LoyaltyCardModel card = await ref
          .read(businessCardsControllerProvider.notifier)
          .save(
            id: widget.cardId,
            input: LoyaltyCardInput(
              name: _name.text,
              requiredStamps: _requiredStamps,
              description: _description.text,
              rewardDescription: _reward.text,
              backgroundColor: _color,
              isActive: _isActive,
              logoUrl: _logoUrl,
              backgroundUrl: _backgroundUrl,
              stampIconUrl: _stampIconUrl,
            ),
          );
      if (!mounted) return;
      context.showSnack(
        context.l10n.manageCardsSaved,
        kind: AppSnackKind.success,
      );
      context.go('${AppRoutes.businessCards}?highlight=${card.id}');
    } catch (error) {
      if (!mounted) return;
      context.showSnack(
        context.l10n.manageCardsSaveError,
        kind: AppSnackKind.error,
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

final class _StampsPicker extends StatelessWidget {
  const _StampsPicker({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${context.l10n.manageCardsFieldRequiredStamps}: $value',
          style: TextStyle(
            color: palette.textMuted,
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
          ),
        ),
        Slider(
          value: value.toDouble(),
          min: AppConstants.minRequiredStamps.toDouble(),
          max: AppConstants.maxRequiredStamps.toDouble(),
          divisions:
              AppConstants.maxRequiredStamps - AppConstants.minRequiredStamps,
          label: '$value',
          activeColor: palette.brand,
          onChanged: (double raw) => onChanged(raw.round()),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '${AppConstants.minRequiredStamps}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '${AppConstants.maxRequiredStamps}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}

final class _AssetPicker extends ConsumerStatefulWidget {
  const _AssetPicker({
    required this.label,
    required this.field,
    required this.cardId,
    required this.url,
    required this.onChanged,
  });

  final String label;
  final String field;
  final String? cardId;
  final String? url;
  final ValueChanged<String?> onChanged;

  @override
  ConsumerState<_AssetPicker> createState() => _AssetPickerState();
}

final class _AssetPickerState extends ConsumerState<_AssetPicker> {
  bool _uploading = false;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final MediaPickerService picker = ref.watch(mediaPickerServiceProvider);
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: <Widget>[
          RemoteImage(
            url: widget.url,
            width: 52,
            height: 52,
            icon: Icons.image_outlined,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              widget.label,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
          if (_uploading)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: palette.brand,
                ),
              ),
            )
          else
            IconActionButton(
              icon: Icons.upload_rounded,
              tooltip: context.l10n.manageCardsAssetsUpload,
              onPressed: _pick,
            ),
        ],
      ),
    );
  }

  Future<void> _pick() async {
    final String? cardId = widget.cardId;
    if (cardId == null) {
      context.showSnack(context.l10n.manageCardsAssetsHint);
      return;
    }
    final MediaPickerService picker = ref.read(mediaPickerServiceProvider);
    if (!picker.isSupported) {
      context.showSnack(context.l10n.manageCardsAssetsError);
      return;
    }
    final PickedImage? image = await picker.pickFromGallery();
    if (image == null || !mounted) return;
    setState(() => _uploading = true);
    try {
      final List<int> bytes = await File(image.path).readAsBytes();
      final LoyaltyCardModel card = await ref
          .read(businessCardsControllerProvider.notifier)
          .uploadAsset(
            cardId: cardId,
            field: widget.field,
            bytes: bytes,
            filename: image.name ?? 'asset.jpg',
          );
      if (!mounted) return;
      final String? url = switch (widget.field) {
        'background' => card.backgroundUrl,
        'stamp_icon' => card.stampIconUrl,
        _ => card.logoUrl,
      };
      widget.onChanged(url);
      context.showSnack(
        context.l10n.manageCardsAssetsUploaded,
        kind: AppSnackKind.success,
      );
    } catch (error) {
      if (!mounted) return;
      context.showSnack(
        context.l10n.manageCardsAssetsError,
        kind: AppSnackKind.error,
      );
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }
}

final class _ReviewPreview extends StatelessWidget {
  const _ReviewPreview({
    required this.name,
    required this.reward,
    required this.description,
    required this.requiredStamps,
    required this.color,
    required this.logoUrl,
    required this.isActive,
  });

  final String name;
  final String reward;
  final String description;
  final int requiredStamps;
  final Color color;
  final String? logoUrl;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final Color foreground =
        color.computeLuminance() > 0.6 ? Colors.black87 : Colors.white;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SectionHeader(title: context.l10n.manageCardsPreviewTitle),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                color,
                Color.lerp(color, Colors.black, 0.24) ?? color,
              ],
            ),
            borderRadius: AppRadius.allLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  RemoteImage(
                    url: logoUrl,
                    fallbackInitials: name,
                    width: 46,
                    height: 46,
                    radius: AppRadius.md,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      name.isEmpty
                          ? context.l10n.manageCardsFieldNameHint
                          : name,
                      style: TextStyle(
                        color: foreground,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  StatusBadge(
                    label: isActive
                        ? context.l10n.manageCardsFieldActive
                        : context.l10n.cardsInactive,
                    color: isActive ? palette.success : palette.textMuted,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              StampsGrid(
                stampsCount: 0,
                requiredStamps: requiredStamps,
                columns: 6,
                stampSize: 32,
                tone: foreground,
                pendingTone: foreground.withValues(alpha: 0.22),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                reward.isEmpty
                    ? context.l10n.manageCardsFieldRewardHint
                    : reward,
                style: TextStyle(
                  color: foreground.withValues(alpha: 0.9),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
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
                icon: Icons.approval_rounded,
                label: context.l10n.manageCardsFieldRequiredStamps,
                value: '$requiredStamps',
              ),
              DetailRow(
                icon: Icons.category_outlined,
                label: context.l10n.manageCardsFieldColor,
                value: AppFormatters.hexCode(color),
              ),
              DetailRow(
                icon: Icons.notes_rounded,
                label: context.l10n.manageCardsFieldDescription,
                value: description,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
