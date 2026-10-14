import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/providers.dart';
import '../../../core/config/app_config.dart';
import '../../../core/presentation/theme.dart';
import '../../../core/presentation/widgets.dart';
import '../domain/session.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        body: SafeArea(
            child: Center(
                child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: ListView(padding: const EdgeInsets.all(28), children: [
            const SizedBox(height: 20),
            const Align(
                alignment: Alignment.centerLeft, child: Brand(large: true)),
            const SizedBox(height: 32),
            SvgPicture.asset('assets/illustrations/welcome.svg',
                height: 230,
                semanticsLabel:
                    'Tarjeta de fidelidad con sellos y una taza de café'),
            const SizedBox(height: 28),
            Text('Tus lugares favoritos.\nMás recompensas.',
                style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 16),
            const Text(
                'Cada visita cuenta. Reúne tus tarjetas, colecciona momentos y disfruta lo que viene.',
                style: TextStyle(fontSize: 17, height: 1.6, color: muted)),
            const SizedBox(height: 28),
            if (AppConfig.demo) ...[
              FilledButton.icon(
                key: const Key('enter-customer'),
                onPressed: () => ref
                    .read(sessionProvider.notifier)
                    .enterDemo(UserRole.customer),
                icon: const Icon(Icons.wallet_outlined),
                label: const Text('Explorar como cliente'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                key: const Key('enter-business'),
                onPressed: () => ref
                    .read(sessionProvider.notifier)
                    .enterDemo(UserRole.business),
                icon: const Icon(Icons.storefront_outlined),
                label: const Text('Soy un negocio'),
              ),
              const SizedBox(height: 24),
              const Text(
                  'DEMO INTERACTIVA · SIN CUENTA\nLos negocios, saldos y operaciones son ficticios.\nNo se envía información a la API real.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: muted, height: 1.7)),
            ] else
              const SoftPanel(
                  child: Column(children: [
                Icon(Icons.construction_rounded, size: 36),
                SizedBox(height: 12),
                Text('Integración pendiente',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(
                    'Se requiere el contrato de autenticación, tarjetas y QR de la API. Compila con DEMO_MODE=true para explorar la app.'),
              ])),
          ]),
        ))),
      );
}
