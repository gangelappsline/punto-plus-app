import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/providers.dart';
import '../../../core/presentation/theme.dart';
import '../../../core/presentation/widgets.dart';
import '../../business/domain/demo_qr.dart';
import '../../demo/data/demo_seed.dart';
import '../domain/loyalty_card.dart';
import 'loyalty_card_tile.dart';

class CardDetailScreen extends ConsumerStatefulWidget {
  const CardDetailScreen({required this.id, super.key});
  final String id;
  @override
  ConsumerState<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends ConsumerState<CardDetailScreen> {
  bool _busy = false;
  bool _celebrate = false;
  String? _operationId;

  Future<void> _redeem(LoyaltyCard card) async {
    if (_busy) {
      return;
    }
    final confirmed = await confirmAction(context,
        title: '¿Canjeamos tu recompensa?',
        message: 'Se descontarán ${card.target} sellos por “${card.reward}”. '
            'Es una operación local de demostración, sin valor real.',
        confirm: 'Canjear en demo');
    if (!confirmed || !mounted) {
      return;
    }
    setState(() => _busy = true);
    _operationId ??= newOperationId();
    try {
      await ref.read(actionsProvider).redeem(card.id, _operationId!);
      _operationId = null;
      if (!mounted) {
        return;
      }
      setState(() => _celebrate = true);
      showMessage(context, '¡Recompensa canjeada en la demo!');
      if (ref.read(preferencesProvider).getBool('notifications') ?? false) {
        try {
          await ref.read(notificationServiceProvider).showReward();
        } on Object {
          // Notification delivery cannot roll back a confirmed redemption.
        }
      }
    } on Object catch (error) {
      if (mounted) {
        showMessage(context, friendlyError(error));
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final offline = ref.watch(offlineProvider);
    return ListView(padding: const EdgeInsets.all(24), children: [
      Row(children: [
        IconButton(
            onPressed: () => context.go('/wallet'),
            tooltip: 'Volver a mis tarjetas',
            icon: const Icon(Icons.arrow_back_rounded)),
        const Expanded(
            child: Text('Tu tarjeta',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
      ]),
      const SizedBox(height: 18),
      AsyncPanel(
          value: ref.watch(cardsProvider),
          onRetry: () => ref.invalidate(cardsProvider),
          builder: (snapshot) {
            final matches =
                snapshot.cards.where((card) => card.id == widget.id);
            if (matches.isEmpty) {
              return const EmptyState(
                  icon: Icons.credit_card_off,
                  title: 'Tarjeta no encontrada',
                  subtitle: 'Vuelve a tu cartera para elegir otra tarjeta.');
            }
            final card = matches.first;
            return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoyaltyCardTile(card: card, expanded: true),
                  if (_celebrate)
                    SizedBox(
                        height: 110,
                        child: Lottie.asset(
                          'assets/animations/success.json',
                          repeat: false,
                          animate: !MediaQuery.of(context).disableAnimations,
                        )),
                  const SectionHeader('Cada visita cuenta'),
                  Text(
                      'Muestra este QR en ${card.businessName} para registrar tu visita de demostración.',
                      style: const TextStyle(color: muted)),
                  const SizedBox(height: 20),
                  SoftPanel(
                      child: Column(children: [
                    if (!offline) ...[
                      Semantics(
                          label: 'Código QR demo de tu tarjeta',
                          child: QrImageView(
                            data:
                                DemoQr(memberId: demoMemberId, cardId: card.id)
                                    .encode(),
                            size: 200,
                            backgroundColor: Colors.white,
                            errorCorrectionLevel: QrErrorCorrectLevel.M,
                          )),
                      const SizedBox(height: 10),
                      const Text('QR DE DEMOSTRACIÓN',
                          style: TextStyle(
                              fontSize: 11, letterSpacing: 2, color: muted)),
                    ] else
                      const Padding(
                          padding: EdgeInsets.all(24),
                          child: Column(children: [
                            Icon(Icons.wifi_off_rounded, size: 40),
                            SizedBox(height: 12),
                            Text(
                                'Conéctate para mostrar tu QR. Las tarjetas guardadas siguen disponibles.',
                                textAlign: TextAlign.center),
                          ])),
                  ])),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: !card.canRedeem || _busy || offline
                        ? null
                        : () => _redeem(card),
                    icon: _busy
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.redeem_outlined),
                    label: Text(_busy
                        ? 'Canjeando…'
                        : card.canRedeem
                            ? 'Canjear recompensa'
                            : 'Faltan ${card.remaining} sellos'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                      onPressed: () async {
                        try {
                          final box = context.findRenderObject()! as RenderBox;
                          await Share.share(
                              'En la demo de Punto Plus, ${card.businessName} recompensa tus visitas: ${card.reward}. Datos ficticios, sin valor comercial.',
                              sharePositionOrigin:
                                  box.localToGlobal(Offset.zero) & box.size);
                        } on Object {
                          if (context.mounted) {
                            showMessage(context,
                                'No pudimos abrir el menú para compartir.');
                          }
                        }
                      },
                      icon: const Icon(Icons.ios_share_rounded),
                      label: const Text('Compartir este lugar')),
                  const SizedBox(height: 20),
                  Text(
                      'Actualizada: ${DateFormat('d MMM y, HH:mm', 'es_MX').format(card.updatedAt)}\n${card.redeemed} recompensas canjeadas en demo.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: muted, fontSize: 12)),
                ]);
          }),
      const SizedBox(height: 24),
    ]);
  }
}
