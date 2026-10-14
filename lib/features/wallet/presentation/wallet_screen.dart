import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/providers.dart';
import '../../../core/presentation/theme.dart';
import '../../../core/presentation/widgets.dart';
import 'loyalty_card_tile.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});
  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  bool _onlyReady = false;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        onRefresh: () => ref.refresh(cardsProvider.future),
        child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            children: [
              Row(children: [
                const Expanded(child: Brand()),
                IconButton.filledTonal(
                    onPressed: () => context.go('/settings'),
                    tooltip: 'Mi perfil',
                    icon: const Icon(Icons.person_outline_rounded)),
              ]),
              const SizedBox(height: 30),
              Text('Hola, ${ref.watch(sessionProvider)?.name ?? 'Alex'} 👋',
                  style: const TextStyle(color: muted)),
              const SizedBox(height: 8),
              Text('Lo bueno de volver.',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 10),
              const Text('Tus pequeños hábitos, grandes recompensas.',
                  style: TextStyle(color: muted)),
              const SizedBox(height: 24),
              AsyncPanel(
                value: ref.watch(cardsProvider),
                onRetry: () => ref.invalidate(cardsProvider),
                builder: (snapshot) {
                  final ready =
                      snapshot.cards.where((card) => card.canRedeem).length;
                  final cards = snapshot.cards
                      .where((card) => !_onlyReady || card.canRedeem)
                      .toList();
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SoftPanel(
                            color: ink,
                            child: Row(children: [
                              Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                      color: lime, shape: BoxShape.circle),
                                  child: const Icon(Icons.redeem_outlined)),
                              const SizedBox(width: 16),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text(
                                        '$ready ${ready == 1 ? 'recompensa lista' : 'recompensas listas'}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18)),
                                    const SizedBox(height: 4),
                                    const Text('Algo bueno te está esperando.',
                                        style: TextStyle(
                                            color: Color(0xFFCEDCCA),
                                            fontSize: 12)),
                                  ])),
                            ])),
                        SectionHeader('Mis tarjetas',
                            trailing: Text('${snapshot.cards.length} lugares',
                                style: const TextStyle(
                                    color: muted, fontSize: 12))),
                        Wrap(spacing: 8, children: [
                          ChoiceChip(
                              label: const Text('Todas'),
                              selected: !_onlyReady,
                              onSelected: (_) =>
                                  setState(() => _onlyReady = false)),
                          ChoiceChip(
                              label: const Text('Para canjear'),
                              selected: _onlyReady,
                              onSelected: (_) =>
                                  setState(() => _onlyReady = true)),
                        ]),
                        const SizedBox(height: 16),
                        if (cards.isEmpty)
                          const EmptyState(
                              icon: Icons.loyalty_outlined,
                              title: 'Lo mejor está por venir',
                              subtitle:
                                  'Sigue visitando tus lugares favoritos para completar tus tarjetas.'),
                        ...cards.map((card) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: LoyaltyCardTile(
                                  card: card,
                                  onTap: () =>
                                      context.push('/cards/${card.id}')),
                            )),
                        if (snapshot.fromCache)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                                'Copia local · ${DateFormat('d MMM, HH:mm', 'es_MX').format(snapshot.savedAt)}',
                                style: const TextStyle(
                                    fontSize: 12, color: muted)),
                          ),
                      ]);
                },
              ),
              TextButton.icon(
                  onPressed: () => context.go('/explore'),
                  icon: const Icon(Icons.explore_outlined),
                  label: const Text('Encuentra tu próximo lugar favorito')),
              const SizedBox(height: 16),
            ]),
      );
}
