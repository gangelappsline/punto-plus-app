import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/presentation/theme.dart';
import '../../../core/presentation/widgets.dart';
import '../../demo/data/demo_seed.dart';
import '../../wallet/presentation/loyalty_card_tile.dart';

class BusinessScreen extends ConsumerWidget {
  const BusinessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ListView(padding: const EdgeInsets.all(24), children: [
        const SizedBox(height: 8),
        const Brand(),
        const SizedBox(height: 30),
        const Text('TU NEGOCIO, MÁS CERCA',
            style: TextStyle(fontSize: 11, letterSpacing: 2, color: muted)),
        const SizedBox(height: 8),
        Text('Hola, Café Origen.',
            style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 10),
        const Text('Convierte cada visita en una buena razón para volver.',
            style: TextStyle(color: muted)),
        const SizedBox(height: 24),
        FilledButton.icon(
            onPressed: ref.watch(offlineProvider)
                ? null
                : () => context.push('/business/scan'),
            icon: const Icon(Icons.qr_code_scanner_rounded),
            label: const Text('Registrar una visita')),
        const SizedBox(height: 24),
        AsyncPanel(
            value: ref.watch(cardsProvider),
            onRetry: () => ref.invalidate(cardsProvider),
            builder: (snapshot) {
              final card = snapshot.cards
                  .firstWhere((card) => card.businessId == demoBusinessId);
              return Column(children: [
                Row(children: [
                  Expanded(
                      child: SoftPanel(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                        const Icon(Icons.loyalty_outlined),
                        const SizedBox(height: 14),
                        Text('${card.stamps}',
                            style: Theme.of(context).textTheme.headlineMedium),
                        const Text('Sellos del cliente demo',
                            style: TextStyle(fontSize: 12, color: muted)),
                      ]))),
                  const SizedBox(width: 12),
                  Expanded(
                      child: SoftPanel(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                        const Icon(Icons.redeem_outlined),
                        const SizedBox(height: 14),
                        Text('${card.redeemed}',
                            style: Theme.of(context).textTheme.headlineMedium),
                        const Text('Canjes en esta demo',
                            style: TextStyle(fontSize: 12, color: muted)),
                      ]))),
                ]),
                SectionHeader('Tu tarjeta de fidelidad',
                    trailing: IconButton(
                        onPressed: () => context.push('/business/card'),
                        tooltip: 'Personalizar tarjeta',
                        icon: const Icon(Icons.tune_rounded))),
                LoyaltyCardTile(
                    card: card, onTap: () => context.push('/business/card')),
              ]);
            }),
        const SectionHeader('Haz que vuelvan'),
        SoftPanel(
            color: lime.withValues(alpha: 0.45),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.campaign_outlined, size: 30),
              const SizedBox(height: 12),
              Text('Algo nuevo para tus clientes',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text(
                  'Crea una promoción y compártela en la sección Descubrir de la demo.'),
              const SizedBox(height: 12),
              TextButton.icon(
                  onPressed: () => context.push('/business/promotions'),
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Administrar promociones')),
            ])),
        const SizedBox(height: 24),
        const Text(
            'Los perfiles comparten un cliente ficticio. Cambia de perfil para ver los sellos y promociones que registraste.',
            style: TextStyle(color: muted, fontSize: 12)),
      ]);
}
