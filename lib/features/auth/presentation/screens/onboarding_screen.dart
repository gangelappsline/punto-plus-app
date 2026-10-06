import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/progress.dart';

/// Presentación inicial en cuatro pasos.
final class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

final class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pages = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  List<(IconData, String, String)> _slides() => <(IconData, String, String)>[
        (
          Icons.credit_card_rounded,
          context.l10n.onboardingSlide1Title,
          context.l10n.onboardingSlide1Message,
        ),
        (
          Icons.qr_code_2_rounded,
          context.l10n.onboardingSlide2Title,
          context.l10n.onboardingSlide2Message,
        ),
        (
          Icons.card_giftcard_rounded,
          context.l10n.onboardingSlide3Title,
          context.l10n.onboardingSlide3Message,
        ),
        (
          Icons.storefront_rounded,
          context.l10n.onboardingSlide4Title,
          context.l10n.onboardingSlide4Message,
        ),
      ];

  Future<void> _finish() async {
    await ref.read(appPreferencesProvider.notifier).completeOnboarding();
    if (!mounted) return;
    context.go(AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final List<(IconData, String, String)> slides = _slides();
    final bool isLast = _index == slides.length - 1;

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finish,
                child: Text(context.l10n.onboardingSkip),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pages,
                itemCount: slides.length,
                onPageChanged: (int value) => setState(() => _index = value),
                itemBuilder: (BuildContext context, int index) {
                  final (IconData icon, String title, String message) =
                      slides[index];
                  return Padding(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 168,
                          width: 168,
                          decoration: const BoxDecoration(
                            gradient: AppColors.brandGradient,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            size: 78,
                            color: palette.onBrand,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xxl,
                0,
                AppSpacing.xxl,
                AppSpacing.xxl,
              ),
              child: Column(
                children: <Widget>[
                  StepDots(count: slides.length, currentIndex: _index),
                  const SizedBox(height: AppSpacing.lg),
                  PrimaryButton(
                    label: isLast
                        ? context.l10n.onboardingStart
                        : context.l10n.onboardingNext,
                    icon: isLast
                        ? Icons.rocket_launch_rounded
                        : Icons.arrow_forward_rounded,
                    onPressed: () {
                      if (isLast) {
                        _finish();
                        return;
                      }
                      _pages.nextPage(
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeOutCubic,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
