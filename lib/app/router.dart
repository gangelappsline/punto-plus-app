import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/presentation/theme.dart';
import '../core/presentation/widgets.dart';
import '../features/auth/domain/session.dart';
import '../features/auth/presentation/welcome_screen.dart';
import '../features/business/presentation/business_screen.dart';
import '../features/business/presentation/card_editor_screen.dart';
import '../features/business/presentation/promotions_screen.dart';
import '../features/business/presentation/scanner_screen.dart';
import '../features/discover/presentation/discover_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/wallet/presentation/card_detail_screen.dart';
import '../features/wallet/presentation/wallet_screen.dart';
import 'providers.dart';

String? sessionRedirect(Session? session, String path) {
  if (session == null) {
    return path == '/welcome' ? null : '/welcome';
  }
  final business = session.role == UserRole.business;
  final home = business ? '/business' : '/wallet';
  if (path == '/' || path == '/welcome') {
    return home;
  }
  if (!business && path.startsWith('/business')) {
    return '/wallet';
  }
  if (business &&
      (path == '/wallet' || path == '/explore' || path.startsWith('/cards'))) {
    return '/business';
  }
  return null;
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(sessionProvider, (_, __) => refresh.value++);
  final router = GoRouter(
    initialLocation: '/welcome',
    refreshListenable: refresh,
    redirect: (_, state) =>
        sessionRedirect(ref.read(sessionProvider), state.uri.path),
    routes: [
      GoRoute(path: '/', redirect: (_, __) => '/welcome'),
      GoRoute(path: '/welcome', builder: (_, __) => const WelcomeScreen()),
      ShellRoute(
          builder: (_, state, child) =>
              AppShell(path: state.uri.path, child: child),
          routes: [
            GoRoute(path: '/wallet', builder: (_, __) => const WalletScreen()),
            GoRoute(
                path: '/cards/:id',
                builder: (_, state) =>
                    CardDetailScreen(id: state.pathParameters['id']!)),
            GoRoute(
                path: '/explore', builder: (_, __) => const DiscoverScreen()),
            GoRoute(
                path: '/settings', builder: (_, __) => const SettingsScreen()),
            GoRoute(
                path: '/business',
                builder: (_, __) => const BusinessScreen(),
                routes: [
                  GoRoute(
                      path: 'scan', builder: (_, __) => const ScannerScreen()),
                  GoRoute(
                      path: 'card',
                      builder: (_, __) => const CardEditorScreen()),
                  GoRoute(
                      path: 'promotions',
                      builder: (_, __) => const PromotionsScreen()),
                ]),
          ]),
    ],
    errorBuilder: (context, _) => Scaffold(
        body: SafeArea(
            child: Center(
                child: EmptyState(
      icon: Icons.explore_off_outlined,
      title: 'Este camino no existe',
      subtitle: 'Vuelve al inicio para continuar.',
      action: FilledButton(
          onPressed: () => context.go('/'), child: const Text('Ir al inicio')),
    )))),
  );
  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
});

class AppShell extends ConsumerWidget {
  const AppShell({required this.path, required this.child, super.key});
  final String path;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final business = ref.watch(sessionProvider)?.role == UserRole.business;
    final offline = ref.watch(offlineProvider);
    final destinations = business
        ? ['/business', '/business/promotions', '/settings']
        : ['/wallet', '/explore', '/settings'];
    final selected = path == '/settings'
        ? 2
        : path == destinations[1]
            ? 1
            : 0;
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: Column(children: [
            Container(
                width: double.infinity,
                color: lime.withValues(alpha: 0.35),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: const Text('DEMO · Datos ficticios, sin valor comercial',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 10, color: ink, letterSpacing: 0.6))),
            AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: offline
                    ? Container(
                        width: double.infinity,
                        color: const Color(0xFFF7E7BB),
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                            'Sin conexión · tarjetas disponibles en modo lectura',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12)))
                    : const SizedBox(width: double.infinity)),
            Expanded(
                child: Center(
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 680),
                        child: child))),
          ])),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: (index) => context.go(destinations[index]),
        destinations: [
          NavigationDestination(
              icon: Icon(
                  business ? Icons.storefront_outlined : Icons.wallet_outlined),
              selectedIcon: Icon(business ? Icons.storefront : Icons.wallet),
              label: business ? 'Mi negocio' : 'Mis tarjetas'),
          NavigationDestination(
              icon: Icon(
                  business ? Icons.campaign_outlined : Icons.explore_outlined),
              selectedIcon: Icon(business ? Icons.campaign : Icons.explore),
              label: business ? 'Promociones' : 'Descubrir'),
          const NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person),
              label: 'Mi perfil'),
        ],
      ),
    );
  }
}
