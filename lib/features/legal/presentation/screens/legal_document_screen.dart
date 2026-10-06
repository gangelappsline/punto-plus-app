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
import '../../data/models/legal_document.dart';
import '../providers/legal_providers.dart';

/// Muestra los términos y condiciones o el aviso de privacidad.
final class LegalDocumentScreen extends ConsumerWidget {
  const LegalDocumentScreen({required this.kind, super.key});

  final LegalDocumentKind kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppPalette palette = context.palette;
    final AsyncValue<LegalDocument> document =
        ref.watch(legalDocumentProvider(kind));
    final String title = kind == LegalDocumentKind.terms
        ? context.l10n.legalTermsTitle
        : context.l10n.legalPrivacyTitle;

    return AppScaffold(
      title: title,
      showBackButton: true,
      scrollable: false,
      padding: EdgeInsets.zero,
      body: AsyncValueView<LegalDocument>(
        value: document,
        loading: const Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: LoadingBlock(height: 220, lines: 6),
        ),
        onRetry: () => ref.invalidate(legalDocumentProvider(kind)),
        builder: (LegalDocument value) => ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: <Widget>[
            Text(
              value.title.isEmpty ? title : value.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (value.updatedAt != null) ...<Widget>[
              const SizedBox(height: AppSpacing.xxs),
              Text(
                AppFormatters.longDate(context, value.updatedAt),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: palette.textFaint),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            if (value.isEmpty)
              EmptyStateView(
                compact: true,
                icon: Icons.description_outlined,
                title: title,
                message: context.l10n.legalError,
                actionLabel: context.l10n.commonRetry,
                onAction: () => ref.invalidate(legalDocumentProvider(kind)),
              )
            else
              Text(
                value.content,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.6,
                    ),
              ),
          ],
        ),
      ),
    );
  }
}
