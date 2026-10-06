import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/customer_card.dart';
import '../providers/cards_providers.dart';

/// Pide el código del negocio y une al cliente a la tarjeta.
///
/// Devuelve la tarjeta creada o `null` si el usuario cancela.
Future<CustomerCardModel?> showJoinCardSheet(
  BuildContext context,
  WidgetRef ref,
) async {
  final TextEditingController controller = TextEditingController();
  final String? code = await showAppSheet<String>(
    context: context,
    child: _JoinCardSheet(controller: controller),
  );
  final String value = (code ?? '').trim();
  controller.dispose();
  if (value.isEmpty) return null;
  try {
    final CustomerCardModel card =
        await ref.read(cardsControllerProvider.notifier).join(value);
    if (!context.mounted) return card;
    context.showSnack(
      '${card.businessName} · ${context.l10n.businessJoined}',
      kind: AppSnackKind.success,
    );
    return card;
  } catch (error) {
    if (!context.mounted) return null;
    context.showSnack(context.l10n.cardsJoinError, kind: AppSnackKind.error);
    return null;
  }
}

final class _JoinCardSheet extends StatelessWidget {
  const _JoinCardSheet({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            context.l10n.cardsJoinTitle,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            context.l10n.cardsJoinHelp,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: context.l10n.cardsJoinCodeLabel,
            hintText: context.l10n.cardsJoinCodeHint,
            controller: controller,
            prefixIcon: Icons.qr_code_rounded,
            textInputAction: TextInputAction.done,
            onSubmitted: (String value) =>
                Navigator.of(context).pop(value.trim()),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: context.l10n.cardsJoinAction,
            icon: Icons.add_card_rounded,
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.commonCancel),
          ),
        ],
      );
}
