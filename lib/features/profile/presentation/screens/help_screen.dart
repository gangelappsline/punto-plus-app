import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/platform/device_services.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/providers/data_providers.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../legal/presentation/providers/legal_providers.dart';

/// Preguntas frecuentes y contacto de soporte.
final class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppPalette palette = context.palette;
    final AppAboutInfo about = ref.watch(appAboutInfoProvider);
    final List<(String, String)> faqs = <(String, String)>[
      (context.l10n.helpFaq1Question, context.l10n.helpFaq1Answer),
      (context.l10n.helpFaq2Question, context.l10n.helpFaq2Answer),
      (context.l10n.helpFaq3Question, context.l10n.helpFaq3Answer),
      (context.l10n.helpFaq4Question, context.l10n.helpFaq4Answer),
      (context.l10n.helpFaq5Question, context.l10n.helpFaq5Answer),
    ];

    return AppScaffold(
      title: context.l10n.helpTitle,
      showBackButton: true,
      scrollable: false,
      padding: EdgeInsets.zero,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: <Widget>[
          Text(
            context.l10n.helpSubtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          ...faqs.map(
            ((String, String) item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: AppCard(
                padding: EdgeInsets.zero,
                child: ExpansionTile(
                  title: Text(
                    item.$1,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13.5,
                    ),
                  ),
                  shape: const Border(),
                  collapsedShape: const Border(),
                  childrenPadding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.$2,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SectionHeader(title: context.l10n.helpContactTitle),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  context.l10n.helpContactMessage,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: <Widget>[
                    Icon(Icons.mail_outline_rounded,
                        size: 16, color: palette.brand),
                    const SizedBox(width: 6),
                    Expanded(
                      child: SelectableText(
                        about.supportEmail,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final ShareResult result = await ref
                            .read(shareServiceProvider)
                            .shareText(about.supportEmail);
                        if (!context.mounted) return;
                        if (result.copied) {
                          context.showSnack(context.l10n.commonCopied);
                        }
                      },
                      child: Text(context.l10n.helpEmailAction),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                SecondaryButton(
                  label: context.l10n.legalAboutWebsite,
                  icon: Icons.language_rounded,
                  onPressed: () async {
                    final ShareResult result = await ref
                        .read(shareServiceProvider)
                        .shareText(about.websiteUrl);
                    if (!context.mounted) return;
                    if (result.copied) {
                      context.showSnack(context.l10n.commonCopied);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
