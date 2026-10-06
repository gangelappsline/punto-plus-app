import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/platform/device_services.dart';
import '../../../../core/providers/data_providers.dart';
import '../../../../core/qr/qr_view.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/skeletons.dart';
import '../../data/models/customer_card_qr.dart';
import '../providers/cards_providers.dart';

/// Muestra el código QR de la tarjeta con brillo al máximo y caducidad.
final class ShowQrScreen extends ConsumerStatefulWidget {
  const ShowQrScreen({required this.cardId, super.key});

  final String cardId;

  @override
  ConsumerState<ShowQrScreen> createState() => _ShowQrScreenState();
}

final class _ShowQrScreenState extends ConsumerState<ShowQrScreen> {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  bool _brightnessBoosted = false;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(_boostBrightness);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _restoreBrightness();
    super.dispose();
  }

  Future<void> _boostBrightness() async {
    final bool boosted =
        await ref.read(brightnessControllerProvider).maximize();
    if (!mounted) return;
    setState(() => _brightnessBoosted = boosted);
  }

  Future<void> _restoreBrightness() async {
    try {
      await ref.read(brightnessControllerProvider).restore();
    } catch (_) {
      // El brillo se restaura automáticamente al salir de la app.
    }
  }

  void _tick() {
    final CustomerCardQr? qr =
        ref.read(cardQrControllerProvider(widget.cardId)).valueOrNull;
    if (qr == null) return;
    final Duration remaining = qr.expiresAt.difference(DateTime.now());
    if (!mounted) return;
    setState(() => _remaining = remaining.isNegative ? Duration.zero : remaining);
    if (remaining.isNegative && !qr.isExpired) {
      ref.read(cardQrControllerProvider(widget.cardId).notifier).regenerate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final AsyncValue<CustomerCardQr> qr =
        ref.watch(cardQrControllerProvider(widget.cardId));

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        title: Text(context.l10n.qrTitle),
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    context.l10n.qrInstruction,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AsyncValueView<CustomerCardQr>(
                    value: qr,
                    loading: const ShimmerBox(
                      height: 280,
                      radius: AppRadius.lg,
                    ),
                    onRetry: () => ref
                        .read(
                          cardQrControllerProvider(widget.cardId).notifier,
                        )
                        .regenerate(),
                    builder: (CustomerCardQr value) => _QrPanel(qr: value),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _ExpiryPanel(
                    expiry: qr.valueOrNull?.expiresAt,
                    remaining: _remaining,
                    boosted: _brightnessBoosted,
                    onRegenerate: () => ref
                        .read(cardQrControllerProvider(widget.cardId).notifier)
                        .regenerate(),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: SecondaryButton(
                          label: context.l10n.qrShareCode,
                          icon: Icons.share_rounded,
                          onPressed: _share,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _share() async {
    final String? code =
        ref.read(cardQrControllerProvider(widget.cardId)).valueOrNull?.code;
    if (code == null) return;
    final ShareResult result = await ref
        .read(shareServiceProvider)
        .shareText('${context.l10n.qrCodeLabel}: $code');
    if (!mounted) return;
    if (result.copied) {
      context.showSnack(context.l10n.commonCopied, kind: AppSnackKind.success);
    }
  }
}

final class _QrPanel extends StatelessWidget {
  const _QrPanel({required this.qr});

  final CustomerCardQr qr;

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          QrView.fromText(
            qr.code,
            semanticLabel: context.l10n.qrCodeLabel,
            size: 288,
            padding: 18,
            borderRadius: AppRadius.lg,
          ),
          const SizedBox(height: AppSpacing.md),
          SelectableText(
            qr.code,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          if (qr.cardName != null || qr.businessName != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                <String?>[qr.businessName, qr.cardName]
                    .whereType<String>()
                    .join(' · '),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      );
}

final class _ExpiryPanel extends StatelessWidget {
  const _ExpiryPanel({
    required this.expiry,
    required this.remaining,
    required this.boosted,
    required this.onRegenerate,
  });

  final DateTime? expiry;
  final Duration remaining;
  final bool boosted;
  final VoidCallback onRegenerate;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final bool expired = remaining <= Duration.zero;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      color: expired
          ? palette.error.withValues(alpha: 0.08)
          : palette.surfaceAlt,
      borderColor: expired
          ? palette.error.withValues(alpha: 0.3)
          : palette.divider,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                expired ? Icons.timer_off_rounded : Icons.timer_outlined,
                color: expired ? palette.error : palette.brand,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  expired
                      ? context.l10n.qrExpiredTitle
                      : AppFormatters.countdown(remaining),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13.5,
                    color: expired ? palette.error : palette.text,
                  ),
                ),
              ),
              if (expiry != null)
                Text(
                  AppFormatters.time(context, expiry),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
          if (expired) ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            Text(
              context.l10n.qrExpiredMessage,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              label: context.l10n.qrRegenerateAction,
              icon: Icons.refresh_rounded,
              onPressed: onRegenerate,
            ),
          ] else ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: <Widget>[
                Icon(
                  boosted
                      ? Icons.brightness_high_rounded
                      : Icons.brightness_medium_rounded,
                  size: 15,
                  color: boosted ? palette.brand : palette.textMuted,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    boosted
                        ? context.l10n.qrBrightnessHint
                        : context.l10n.qrBrightnessUnavailable,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
