import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/image_thumb.dart';
import '../providers/legal_providers.dart';

/// Información de la app, versión y ligas legales.
final class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppPalette palette = context.palette;
    final AppAboutInfo about = ref.watch(appAboutInfoProvider);

    return AppScaffold(
      title: context.l10n.legalAboutTitle,
      showBackButton: true,
      scrollable: false,
      padding: const EdgeInsets.all(AppSpacing.xl),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 84,
                width: 84,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  gradient: AppColors.brandGradient,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  'P+',
                  style: TextStyle(
                    color: palette.onBrand,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                context.l10n.appName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                context.l10n.appTagline,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              StatusBadge(
                label:
                    '${context.l10n.legalAboutVersion} ${about.version}',
                color: palette.brand,
                icon: Icons.sell_outlined,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  context.l10n.legalAboutDescription,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                DetailRow(
                  icon: Icons.business_center_outlined,
                  label: context.l10n.legalAboutMadeFor,
                  value: context.l10n.appName,
                ),
                DetailRow(
                  icon: Icons.construction_outlined,
                  label: context.l10n.settingsLanguageLabel,
                  value: about.environment,
                ),
                DetailRow(
                  icon: Icons.map_outlined,
                  label: context.l10n.mapTitle,
                  value: about.hasMapsKey
                      ? context.l10n.commonYes
                      : context.l10n.commonNo,
                ),
                DetailRow(
                  icon: Icons.mail_outline_rounded,
                  label: context.l10n.legalAboutContact,
                  value: about.supportEmail,
                ),
                DetailRow(
                  icon: Icons.language_rounded,
                  label: context.l10n.legalAboutWebsite,
                  value: about.websiteUrl,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SectionHeader(title: context.l10n.legalAboutLegal),
          SecondaryButton(
            label: context.l10n.legalTermsTitle,
            icon: Icons.gavel_outlined,
            onPressed: () => context.push(AppRoutes.terms),
          ),
          const SizedBox(height: AppSpacing.sm),
          SecondaryButton(
            label: context.l10n.legalPrivacyTitle,
            icon: Icons.privacy_tip_outlined,
            onPressed: () => context.push(AppRoutes.privacy),
          ),
          const SizedBox(height: AppSpacing.sm),
          SecondaryButton(
            label: context.l10n.helpTitle,
            icon: Icons.help_outline_rounded,
            onPressed: () => context.push(AppRoutes.help),
          ),
        ],
      ),
    );
  }
}
