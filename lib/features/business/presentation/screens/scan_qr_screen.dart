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
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/image_thumb.dart';
import '../../../../core/widgets/progress.dart';
import '../../../cards/data/models/stamp.dart';
import '../../data/models/scan_stamp_result.dart';
import '../providers/business_providers.dart';

/// Escaneo de códigos QR para registrar sellos.
///
/// El lector de cámara se resuelve por el puerto [ScannerService]; cuando el
/// plugin `mobile_scanner` esté disponible se activa sin cambios en la UI.
final class ScanQrScreen extends ConsumerStatefulWidget {
  const ScanQrScreen({super.key});

  @override
  ConsumerState<ScanQrScreen> createState() => _ScanQrScreenState();
}

final class _ScanQrScreenState extends ConsumerState<ScanQrScreen> {
  final TextEditingController _manual = TextEditingController();

  @override
  void dispose() {
    _manual.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final ScanState state = ref.watch(scanControllerProvider);
    final ScannerService scanner = ref.watch(scannerServiceProvider);
    final AsyncValue<List<StampModel>> recent =
        ref.watch(recentStampsProvider);

    return AppScaffold(
      title: context.l10n.manageScanTitle,
      showBackButton: true,
      scrollable: false,
      padding: EdgeInsets.zero,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: <Widget>[
          Text(
            context.l10n.manageScanInstruction,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          _ScannerPanel(
            enabled: scanner.isSupported,
            processing: state.isProcessing,
            onScanned: _register,
          ),
          if (!scanner.isSupported) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            AppCard(
              color: palette.warning.withValues(alpha: 0.1),
              borderColor: palette.warning.withValues(alpha: 0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.no_photography_outlined,
                        color: palette.warning,
                        size: 18,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          context.l10n.manageScanCameraUnavailableTitle,
                          style: TextStyle(
                            color: palette.warning,
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    context.l10n.manageScanCameraUnavailableMessage,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: context.l10n.manageScanManualEntry,
            hintText: context.l10n.manageScanManualHint,
            controller: _manual,
            prefixIcon: Icons.keyboard_rounded,
            textInputAction: TextInputAction.done,
            helperText: context.l10n.manageScanManualAction,
            onSubmitted: _register,
          ),
          const SizedBox(height: AppSpacing.sm),
          PrimaryButton(
            label: context.l10n.manageScanManualAction,
            icon: Icons.add_task_rounded,
            isLoading: state.isProcessing,
            onPressed: () => _register(_manual.text),
          ),
          if (state.errorMessage != null) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            _ErrorPanel(message: state.errorMessage!),
          ],
          if (state.result != null) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            _ScanResultPanel(
              result: state.result!,
              onScanAgain: () {
                _manual.clear();
                ref.read(scanControllerProvider.notifier).reset();
              },
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          SectionHeader(title: context.l10n.manageScanRecentTitle),
          recent.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (Object error, StackTrace stack) => EmptyStateView(
              compact: true,
              icon: Icons.error_outline_rounded,
              title: context.l10n.commonErrorGenericTitle,
              message: context.l10n.commonErrorGenericMessage,
              actionLabel: context.l10n.commonRetry,
              onAction: () => ref.invalidate(recentStampsProvider),
            ),
            data: (List<StampModel> value) => value.isEmpty
                ? EmptyStateView(
                    compact: true,
                    icon: Icons.history_rounded,
                    title: context.l10n.manageScanRecentEmpty,
                    message: context.l10n.commonEmptyGenericMessage,
                  )
                : Column(
                    children: value
                        .map(
                          (StampModel stamp) => Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: AppCard(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 32,
                                    width: 32,
                                    decoration: BoxDecoration(
                                      color: palette.brandSoft,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.star_rounded,
                                      size: 16,
                                      color: palette.brand,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    AppFormatters.relative(
                                      context,
                                      stamp.createdAt,
                                    ),
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _register(String code) async {
    final ScanStampResult? result = await ref
        .read(scanControllerProvider.notifier)
        .scan(code);
    if (!mounted) return;
    if (result != null) {
      context.showSnack(
        result.rewardUnlocked
            ? context.l10n.manageScanRewardUnlocked
            : context.l10n.manageScanSuccessTitle,
        kind: AppSnackKind.success,
      );
      ref.invalidate(recentStampsProvider);
      ref.invalidate(businessDashboardProvider);
      _manual.clear();
      return;
    }
    final String? error = ref.read(scanControllerProvider).errorMessage;
    if (error != null) {
      context.showSnack(
        switch (error) {
          'duplicate' => context.l10n.manageScanDuplicate,
          'invalid' => context.l10n.manageScanInvalidCode,
          _ => context.l10n.manageScanError,
        },
        kind: AppSnackKind.error,
      );
    }
  }
}

final class _ScannerPanel extends StatelessWidget {
  const _ScannerPanel({
    required this.enabled,
    required this.processing,
    required this.onScanned,
  });

  final bool enabled;
  final bool processing;
  final ValueChanged<String> onScanned;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return AspectRatio(
      aspectRatio: 1.25,
      child: Container(
        decoration: BoxDecoration(
          color: palette.brandStrong,
          borderRadius: AppRadius.allLg,
          border: Border.all(
            color: enabled ? palette.brand : palette.divider,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned.fill(
              child: CustomPaint(
                painter: _ScannerFramePainter(palette: palette),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.qr_code_scanner_rounded,
                  size: 54,
                  color: enabled
                      ? palette.onBrand
                      : palette.onBrand.withValues(alpha: 0.4),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  processing
                      ? context.l10n.manageScanProcessing
                      : context.l10n.manageScanInstruction,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: palette.onBrand.withValues(alpha: 0.92),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            if (enabled)
              Positioned(
                bottom: AppSpacing.md,
                child: TextButton.icon(
                  onPressed: processing
                      ? null
                      : () => onScanned(''),
                  icon: const Icon(Icons.qr_code_2_rounded, size: 18),
                  label: Text(context.l10n.manageScanScanAgain),
                  style: TextButton.styleFrom(
                    foregroundColor: palette.onBrand,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final class _ScannerFramePainter extends CustomPainter {
  const _ScannerFramePainter({required this.palette});

  final AppPalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = palette.brand.withValues(alpha: 0.85)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const double corner = 34;
    final Rect rect = Rect.fromLTWH(
      size.width * 0.16,
      size.height * 0.16,
      size.width * 0.68,
      size.height * 0.68,
    );
    final Path path = Path()
      ..moveTo(rect.left, rect.top + corner)
      ..lineTo(rect.left, rect.top)
      ..lineTo(rect.left + corner, rect.top)
      ..moveTo(rect.right - corner, rect.top)
      ..lineTo(rect.right, rect.top)
      ..lineTo(rect.right, rect.top + corner)
      ..moveTo(rect.right, rect.bottom - corner)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.right - corner, rect.bottom)
      ..moveTo(rect.left + corner, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..lineTo(rect.left, rect.bottom - corner);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ScannerFramePainter oldDelegate) => false;
}

final class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return AppCard(
      color: palette.error.withValues(alpha: 0.08),
      borderColor: palette.error.withValues(alpha: 0.3),
      child: Row(
        children: <Widget>[
          Icon(Icons.error_outline_rounded, color: palette.error, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              switch (message) {
                'duplicate' => context.l10n.manageScanDuplicate,
                'invalid' => context.l10n.manageScanInvalidCode,
                _ => message,
              },
              style: TextStyle(
                color: palette.error,
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _ScanResultPanel extends StatelessWidget {
  const _ScanResultPanel({required this.result, required this.onScanAgain});

  final ScanStampResult result;
  final VoidCallback onScanAgain;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    return AppCard(
      color: palette.success.withValues(alpha: 0.08),
      borderColor: palette.success.withValues(alpha: 0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                result.isCompleted
                    ? Icons.emoji_events_rounded
                    : Icons.check_circle_rounded,
                color: palette.success,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  context.l10n.manageScanSuccessTitle,
                  style: TextStyle(
                    color: palette.success,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
              ),
              StatusBadge(
                label: AppFormatters.relative(context, result.createdAt),
                color: palette.success,
                filled: false,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          DetailRow(
            icon: Icons.person_outline_rounded,
            label: context.l10n.manageScanCustomerLabel,
            value: result.customerName,
          ),
          DetailRow(
            icon: Icons.credit_card_rounded,
            label: context.l10n.manageScanCardLabel,
            value: result.cardName,
          ),
          DetailRow(
            icon: Icons.approval_rounded,
            label: context.l10n.manageScanStampsLabel,
            value: '${result.stampsCount}/${result.requiredStamps}',
          ),
          const SizedBox(height: AppSpacing.sm),
          StampsGrid(
            stampsCount: result.stampsCount,
            requiredStamps: result.requiredStamps,
            columns: 6,
            stampSize: 30,
            tone: palette.success,
          ),
          if (result.rewardUnlocked) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: <Widget>[
                CompletionBadge(
                  label: context.l10n.manageScanRewardUnlocked,
                  tone: palette.accent,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    result.message ?? context.l10n.cardsRewardLabel,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(
            label: context.l10n.manageScanScanAgain,
            icon: Icons.qr_code_scanner_rounded,
            onPressed: onScanAgain,
          ),
        ],
      ),
    );
  }
}
