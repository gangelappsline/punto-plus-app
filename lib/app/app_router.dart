import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers/app_providers.dart';
import '../features/auth/presentation/controllers/auth_state.dart';
import '../features/auth/presentation/screens/auth_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/onboarding_screen.dart';
import '../features/auth/presentation/screens/reset_password_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/verify_code_screen.dart';
import '../features/auth/presentation/screens/welcome_screen.dart';
import '../features/business/presentation/screens/business_card_form_screen.dart';
import '../features/business/presentation/screens/business_cards_screen.dart';
import '../features/business/presentation/screens/business_customer_detail_screen.dart';
import '../features/business/presentation/screens/business_customers_screen.dart';
import '../features/business/presentation/screens/business_dashboard_screen.dart';
import '../features/business/presentation/screens/business_promotions_screen.dart';
import '../features/business/presentation/screens/scan_qr_screen.dart';
import '../features/businesses/presentation/screens/business_detail_screen.dart';
import '../features/businesses/presentation/screens/favorites_screen.dart';
import '../features/businesses/presentation/screens/map_screen.dart';
import '../features/businesses/presentation/screens/search_screen.dart';
import '../features/cards/presentation/screens/card_detail_screen.dart';
import '../features/cards/presentation/screens/cards_list_screen.dart';
import '../features/cards/presentation/screens/show_qr_screen.dart';
import '../features/home/presentation/screens/home_shell.dart';
import '../features/legal/presentation/screens/about_screen.dart';
import '../features/legal/presentation/screens/legal_document_screen.dart';
import '../features/legal/presentation/providers/legal_providers.dart';
import '../features/profile/presentation/screens/edit_profile_screen.dart';
import '../features/profile/presentation/screens/help_screen.dart';
import '../features/profile/presentation/screens/notifications_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/profile/presentation/screens/referral_screen.dart';
import '../features/profile/presentation/screens/settings_screen.dart';
import '../features/promotions/presentation/screens/promotions_screen.dart';
import '../features/rewards/presentation/screens/reward_detail_screen.dart';
import '../features/rewards/presentation/screens/rewards_screen.dart';
import '../shared/screens/error_screens.dart';
import 'app_routes.dart';

/// Router de la app con guardas por estado de sesión y por rol.
final appRouterProvider = Provider<GoRouter>((Ref ref) {
  final RouterRefreshNotifier notifier = RouterRefreshNotifier(ref);
  ref.onDispose(notifier.dispose);
  final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: notifier,
    debugLogDiagnostics: kDebugMode,
    redirect: (BuildContext context, GoRouterState state) => _redirect(ref, state),
    routes: _routes,
    errorBuilder: (BuildContext context, GoRouterState state) => ErrorScreen(
      title: context.l10n.errorsNotFoundTitle,
      message: context.l10n.errorsNotFoundMessage,
      icon: Icons.explore_off_rounded,
      primaryLabel: context.l10n.errorsNotFoundAction,
      onPrimary: () => context.go(AppRoutes.home),
    ),
  );
  ref.onDispose(router.dispose);
  return router;
});

/// Notifica a go_router cuando cambia la sesión o el rol del usuario.
final class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(Ref ref) {
    _subscription = ref.listen<AuthState>(
      authControllerProvider,
      (AuthState? previous, AuthState next) {
        if (previous?.status != next.status ||
            previous?.session?.user.id != next.session?.user.id ||
            previous?.session?.user.role != next.session?.user.role) {
          notifyListeners();
        }
      },
    );
  }

  late final ProviderSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}

String? _redirect(Ref ref, GoRouterState state) {
  final AuthState auth = ref.read(authControllerProvider);
  final String location = state.matchedLocation;
  final bool isPublic = AppRoutes.publicRoutes.contains(location);
  final bool isSplash = location == AppRoutes.splash;
  final bool isOnboarding = location == AppRoutes.onboarding;

  switch (auth.status) {
    case AuthStatus.initial:
      return isSplash ? null : AppRoutes.splash;
    case AuthStatus.loading:
      return null;
    case AuthStatus.unauthenticated:
      if (isPublic && !isSplash && !isOnboarding && !auth.mustVerify) {
        return null;
      }
      if (auth.pendingVerificationIdentifier != null) {
        return AppRoutes.verifyCode;
      }
      return isOnboarding ? null : AppRoutes.welcome;
    case AuthStatus.authenticated:
      if (auth.mustVerify && location != AppRoutes.verifyCode) {
        return AppRoutes.verifyCode;
      }
      if (isPublic && !_isLegalRoute(location)) {
        return AppRoutes.home;
      }
      if (_isBusinessRoute(location) && !ref.read(isBusinessUserProvider)) {
        return AppRoutes.forbidden;
      }
      return null;
  }
}

bool _isLegalRoute(String location) =>
    location == AppRoutes.terms ||
    location == AppRoutes.privacy ||
    location == AppRoutes.about;

bool _isBusinessRoute(String location) {
  if (AppRoutes.businessRoutes.contains(location)) return true;
  return location.startsWith('/business/');
}

final List<RouteBase> _routes = <RouteBase>[
  GoRoute(
    path: AppRoutes.splash,
    builder: (BuildContext context, GoRouterState state) => const SplashScreen(),
  ),
  GoRoute(
    path: AppRoutes.onboarding,
    builder: (BuildContext context, GoRouterState state) =>
        const OnboardingScreen(),
  ),
  GoRoute(
    path: AppRoutes.welcome,
    builder: (BuildContext context, GoRouterState state) => const WelcomeScreen(),
  ),
  GoRoute(
    path: AppRoutes.login,
    builder: (BuildContext context, GoRouterState state) =>
        const AuthScreen(initialMode: AuthMode.login),
  ),
  GoRoute(
    path: AppRoutes.register,
    builder: (BuildContext context, GoRouterState state) =>
        const AuthScreen(initialMode: AuthMode.register),
  ),
  GoRoute(
    path: AppRoutes.verifyCode,
    builder: (BuildContext context, GoRouterState state) =>
        const VerifyCodeScreen(),
  ),
  GoRoute(
    path: AppRoutes.forgotPassword,
    builder: (BuildContext context, GoRouterState state) =>
        const ForgotPasswordScreen(),
  ),
  GoRoute(
    path: AppRoutes.resetPassword,
    builder: (BuildContext context, GoRouterState state) =>
        const ResetPasswordScreen(),
  ),

  // --- Área del cliente ---------------------------------------------------
  StatefulShellRoute.indexedStack(
    builder: (
      BuildContext context,
      GoRouterState state,
      StatefulNavigationShell shell,
    ) =>
        HomeShell(shell: shell),
    branches: <StatefulShellBranch>[
      StatefulShellBranch(
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutes.cards,
            builder: (BuildContext context, GoRouterState state) =>
                const CardsListScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutes.map,
            builder: (BuildContext context, GoRouterState state) =>
                const MapScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutes.rewards,
            builder: (BuildContext context, GoRouterState state) =>
                const RewardsScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutes.promotions,
            builder: (BuildContext context, GoRouterState state) =>
                const PromotionsScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutes.profile,
            builder: (BuildContext context, GoRouterState state) =>
                const ProfileScreen(),
          ),
        ],
      ),
    ],
  ),

  // --- Detalles del cliente ----------------------------------------------
  GoRoute(
    path: AppRoutes.cardDetail,
    builder: (BuildContext context, GoRouterState state) =>
        CardDetailScreen(cardId: state.pathParameters['id'] ?? ''),
    routes: <RouteBase>[
      GoRoute(
        path: 'qr',
        builder: (BuildContext context, GoRouterState state) =>
            ShowQrScreen(cardId: state.pathParameters['id'] ?? ''),
      ),
    ],
  ),
  GoRoute(
    path: AppRoutes.rewardDetail,
    builder: (BuildContext context, GoRouterState state) =>
        RewardDetailScreen(rewardId: state.pathParameters['id'] ?? ''),
  ),
  GoRoute(
    path: AppRoutes.businessDetail,
    builder: (BuildContext context, GoRouterState state) =>
        BusinessDetailScreen(businessId: state.pathParameters['id'] ?? ''),
  ),
  GoRoute(
    path: AppRoutes.editProfile,
    builder: (BuildContext context, GoRouterState state) =>
        const EditProfileScreen(),
  ),
  GoRoute(
    path: AppRoutes.settings,
    builder: (BuildContext context, GoRouterState state) =>
        const SettingsScreen(),
  ),
  GoRoute(
    path: AppRoutes.notifications,
    builder: (BuildContext context, GoRouterState state) =>
        const NotificationsScreen(),
  ),
  GoRoute(
    path: AppRoutes.referral,
    builder: (BuildContext context, GoRouterState state) =>
        const ReferralScreen(),
  ),
  GoRoute(
    path: AppRoutes.search,
    builder: (BuildContext context, GoRouterState state) =>
        const SearchScreen(),
  ),
  GoRoute(
    path: AppRoutes.favorites,
    builder: (BuildContext context, GoRouterState state) =>
        const FavoritesScreen(),
  ),
  GoRoute(
    path: AppRoutes.help,
    builder: (BuildContext context, GoRouterState state) => const HelpScreen(),
  ),

  // --- Legal ---------------------------------------------------------------
  GoRoute(
    path: AppRoutes.terms,
    builder: (BuildContext context, GoRouterState state) =>
        const LegalDocumentScreen(kind: LegalDocumentKind.terms),
  ),
  GoRoute(
    path: AppRoutes.privacy,
    builder: (BuildContext context, GoRouterState state) =>
        const LegalDocumentScreen(kind: LegalDocumentKind.privacy),
  ),
  GoRoute(
    path: AppRoutes.about,
    builder: (BuildContext context, GoRouterState state) => const AboutScreen(),
  ),

  // --- Modo negocio -------------------------------------------------------
  GoRoute(
    path: AppRoutes.businessDashboard,
    builder: (BuildContext context, GoRouterState state) =>
        const BusinessDashboardScreen(),
  ),
  GoRoute(
    path: AppRoutes.businessCards,
    builder: (BuildContext context, GoRouterState state) =>
        const BusinessCardsScreen(),
  ),
  GoRoute(
    path: AppRoutes.businessCardForm,
    builder: (BuildContext context, GoRouterState state) => BusinessCardFormScreen(
      cardId: state.uri.queryParameters['id'],
    ),
  ),
  GoRoute(
    path: AppRoutes.businessScan,
    builder: (BuildContext context, GoRouterState state) =>
        const ScanQrScreen(),
  ),
  GoRoute(
    path: AppRoutes.businessPromotions,
    builder: (BuildContext context, GoRouterState state) =>
        const BusinessPromotionsScreen(),
  ),
  GoRoute(
    path: AppRoutes.businessCustomers,
    builder: (BuildContext context, GoRouterState state) =>
        const BusinessCustomersScreen(),
  ),
  GoRoute(
    path: AppRoutes.businessCustomerDetail,
    builder: (BuildContext context, GoRouterState state) =>
        BusinessCustomerDetailScreen(
      customerId: state.pathParameters['id'] ?? '',
    ),
  ),

  // --- Errores -------------------------------------------------------------
  GoRoute(
    path: AppRoutes.noConnection,
    builder: (BuildContext context, GoRouterState state) => ErrorScreen(
      title: context.l10n.errorsNoConnectionTitle,
      message: context.l10n.errorsNoConnectionMessage,
      icon: Icons.wifi_off_rounded,
      primaryLabel: context.l10n.errorsNoConnectionAction,
      onPrimary: () => context.go(AppRoutes.home),
    ),
  ),
  GoRoute(
    path: AppRoutes.maintenance,
    builder: (BuildContext context, GoRouterState state) => ErrorScreen(
      title: context.l10n.errorsMaintenanceTitle,
      message: context.l10n.errorsMaintenanceMessage,
      icon: Icons.build_circle_outlined,
      primaryLabel: context.l10nCommonRetry,
      onPrimary: () => context.go(AppRoutes.home),
    ),
  ),
  GoRoute(
    path: AppRoutes.forbidden,
    builder: (BuildContext context, GoRouterState state) => ErrorScreen(
      title: context.l10n.errorsForbiddenTitle,
      message: context.l10n.errorsForbiddenMessage,
      icon: Icons.lock_outline_rounded,
      primaryLabel: context.l10nCommonBack,
      onPrimary: () => context.go(AppRoutes.home),
    ),
  ),
  GoRoute(
    path: AppRoutes.notFound,
    builder: (BuildContext context, GoRouterState state) => ErrorScreen(
      title: context.l10n.errorsNotFoundTitle,
      message: context.l10n.errorsNotFoundMessage,
      icon: Icons.explore_off_rounded,
      primaryLabel: context.l10n.errorsNotFoundAction,
      onPrimary: () => context.go(AppRoutes.home),
    ),
  ),
];
