import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/config/app_config.dart';
import '../core/network/api_client.dart';
import '../core/network/app_failure.dart';
import '../core/services/media_service.dart';
import '../core/services/notification_service.dart';
import '../core/storage/token_store.dart';
import '../features/auth/domain/session.dart';
import '../features/business/domain/business_repository.dart';
import '../features/business/domain/promotion.dart';
import '../features/demo/data/demo_repository.dart';
import '../features/demo/data/demo_seed.dart';
import '../features/discover/domain/business.dart';
import '../features/discover/domain/discover_repository.dart';
import '../features/wallet/data/card_cache.dart';
import '../features/wallet/domain/loyalty_card.dart';
import '../features/wallet/domain/wallet_repository.dart';

final preferencesProvider = Provider<SharedPreferences>(
    (ref) => throw StateError('Initialize SharedPreferences in bootstrap.'));
final tokenStoreProvider =
    Provider<TokenStore>((ref) => SecureTokenStore(const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
        )));
final cardCacheProvider =
    Provider((ref) => CardCache(ref.watch(preferencesProvider)));
final demoRepositoryProvider = Provider((ref) => DemoRepository(
    ref.watch(preferencesProvider), ref.watch(cardCacheProvider)));
final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  if (!AppConfig.demo) {
    throw const ContractUnavailable();
  }
  return ref.watch(demoRepositoryProvider);
});
final businessRepositoryProvider = Provider<BusinessRepository>((ref) {
  if (!AppConfig.demo) {
    throw const ContractUnavailable();
  }
  return ref.watch(demoRepositoryProvider);
});
final discoverRepositoryProvider = Provider<DiscoverRepository>((ref) {
  if (!AppConfig.demo) {
    throw const ContractUnavailable();
  }
  return ref.watch(demoRepositoryProvider);
});
final mediaServiceProvider = Provider((ref) => MediaService());
final notificationServiceProvider = Provider((ref) => NotificationService());

final sessionProvider =
    NotifierProvider<SessionController, Session?>(SessionController.new);

class SessionController extends Notifier<Session?> {
  @override
  Session? build() =>
      null; // Explicit role selection each launch; not real auth.

  void enterDemo(UserRole role) {
    if (!AppConfig.demo) {
      throw const ContractUnavailable();
    }
    state = Session(
      userId: role == UserRole.customer ? demoMemberId : 'demo-owner',
      name: role == UserRole.customer ? 'Alex' : 'Café Origen',
      role: role,
    );
  }

  Future<void> signOut() async {
    final session = state;
    state = null;
    ref.invalidate(cardsProvider);
    ref.invalidate(promotionsProvider);
    try {
      if (session != null) {
        await ref.read(cardCacheProvider).clear(session.userId);
      }
    } finally {
      await ref.read(tokenStoreProvider).clear();
    }
  }

  void expire() {
    state = null;
    ref.invalidate(cardsProvider);
    ref.invalidate(promotionsProvider);
  }
}

final apiClientProvider = Provider<Dio>((ref) {
  final client = createApiClient(
    tokens: ref.watch(tokenStoreProvider),
    onUnauthorized: () => ref.read(sessionProvider.notifier).expire(),
  );
  ref.onDispose(() => client.close(force: true));
  return client;
});

final connectivityProvider =
    StreamProvider<List<ConnectivityResult>>((ref) async* {
  final connectivity = Connectivity();
  yield await connectivity.checkConnectivity();
  yield* connectivity.onConnectivityChanged;
});
final simulateOfflineProvider = StateProvider<bool>((ref) => false);
final offlineProvider = Provider<bool>((ref) {
  if (ref.watch(simulateOfflineProvider)) {
    return true;
  }
  final status = ref.watch(connectivityProvider).valueOrNull;
  return status != null &&
      (status.isEmpty || status.contains(ConnectivityResult.none));
});

final cardsProvider = FutureProvider<CardSnapshot>((ref) async {
  final session = ref.watch(sessionProvider);
  if (session == null) {
    throw const AppFailure('Elige un perfil para continuar.');
  }
  // Both demo profiles share ONE synthetic customer to exercise the full loop.
  return ref.watch(walletRepositoryProvider).cards(
        demoMemberId,
        offline: ref.watch(offlineProvider),
      );
});
final businessesProvider = FutureProvider<List<Business>>(
    (ref) => ref.watch(discoverRepositoryProvider).businesses());
final promotionsProvider = FutureProvider<List<Promotion>>(
    (ref) => ref.watch(businessRepositoryProvider).promotions());

final actionsProvider = Provider((ref) => LoyaltyActions(ref));

/// Application/use-case boundary. UI cannot accidentally mutate while offline
/// or with the wrong role. Real authorization must also be enforced by API.
class LoyaltyActions {
  LoyaltyActions(this.ref);
  final Ref ref;

  void _require(UserRole role) {
    if (ref.read(sessionProvider)?.role != role) {
      throw const AppFailure('Tu perfil no permite realizar esta acción.');
    }
    if (ref.read(offlineProvider)) {
      throw const AppFailure('Necesitas conexión para realizar esta acción.');
    }
  }

  void _refresh() {
    ref.invalidate(cardsProvider);
    ref.invalidate(promotionsProvider);
  }

  Future<void> redeem(String cardId, String operationId) async {
    _require(UserRole.customer);
    await ref
        .read(walletRepositoryProvider)
        .redeem(demoMemberId, cardId, operationId);
    _refresh();
  }

  Future<void> purchase(String qr, String operationId) async {
    _require(UserRole.business);
    await ref.read(businessRepositoryProvider).registerPurchase(
          businessId: demoBusinessId,
          qr: qr,
          operationId: operationId,
        );
    _refresh();
  }

  Future<void> saveCard(LoyaltyCard card) async {
    _require(UserRole.business);
    await ref.read(businessRepositoryProvider).saveCard(demoBusinessId, card);
    _refresh();
  }

  Future<void> savePromotion(Promotion promotion) async {
    _require(UserRole.business);
    await ref
        .read(businessRepositoryProvider)
        .savePromotion(demoBusinessId, promotion);
    _refresh();
  }

  Future<void> deletePromotion(String id) async {
    _require(UserRole.business);
    await ref
        .read(businessRepositoryProvider)
        .deletePromotion(demoBusinessId, id);
    _refresh();
  }
}

String newOperationId() {
  final random = Random.secure();
  return List.generate(
      16, (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
}
