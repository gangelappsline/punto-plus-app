import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/business/data/datasources/business_remote_data_source.dart';
import '../../features/business/data/repositories/business_repository_impl.dart';
import '../../features/business/domain/repositories/business_repository.dart';
import '../../features/businesses/data/datasources/businesses_remote_data_source.dart';
import '../../features/businesses/data/repositories/businesses_repository_impl.dart';
import '../../features/businesses/domain/repositories/businesses_repository.dart';
import '../../features/cards/data/datasources/cards_remote_data_source.dart';
import '../../features/cards/data/repositories/cards_repository_impl.dart';
import '../../features/cards/domain/repositories/cards_repository.dart';
import '../../features/legal/data/datasources/legal_remote_data_source.dart';
import '../../features/legal/data/repositories/legal_repository_impl.dart';
import '../../features/legal/domain/repositories/legal_repository.dart';
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/promotions/data/datasources/promotions_remote_data_source.dart';
import '../../features/promotions/data/repositories/promotions_repository_impl.dart';
import '../../features/promotions/domain/repositories/promotions_repository.dart';
import '../../features/rewards/data/datasources/rewards_remote_data_source.dart';
import '../../features/rewards/data/repositories/rewards_repository_impl.dart';
import '../../features/rewards/domain/repositories/rewards_repository.dart';
import '../config/app_config.dart';
import '../network/api_client.dart';
import '../network/network_monitor.dart';
import '../platform/device_services.dart';
import '../platform/location_service.dart';
import '../storage/key_value_store.dart';
import '../storage/local_cache.dart';
import '../storage/preferences_store.dart';
import '../storage/token_storage.dart';

/// Configuración leída de `--dart-define`.
final appConfigProvider = Provider<AppConfig>(
  (Ref ref) => AppConfig.fromEnvironment(),
);

/// Almacenamiento seguro de tokens.
final tokenStorageProvider = Provider<TokenStorage>(
  (Ref ref) => TokenStorage(const FlutterSecureStorage()),
);

/// Almacenamiento clave/valor para preferencias y caché.
final keyValueStoreProvider = Provider<KeyValueStore>(
  (Ref ref) => const SecureKeyValueStore(FlutterSecureStorage()),
);

final preferencesStoreProvider = Provider<PreferencesStore>(
  (Ref ref) => PreferencesStore(ref.watch(keyValueStoreProvider)),
);

final localCacheProvider = Provider<LocalCache>(
  (Ref ref) => LocalCache(ref.watch(keyValueStoreProvider)),
);

/// Monitor de conectividad alimentado por las respuestas HTTP.
final networkMonitorProvider = Provider<NetworkMonitor>((Ref ref) {
  final NetworkMonitor monitor = NetworkMonitor();
  ref.onDispose(monitor.dispose);
  return monitor;
});

/// El estado de conexión observable se expone en `app_providers.dart`
/// (`networkStatusProvider`); aquí solo se construye el monitor.

final apiClientProvider = Provider<ApiClient>(
  (Ref ref) => ApiClient(
    config: ref.watch(appConfigProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
    networkMonitor: ref.watch(networkMonitorProvider),
  ),
);

// --- Puertos de plataforma ------------------------------------------------
final locationServiceProvider = Provider<LocationService>(
  (Ref ref) => ManualLocationService(),
);

final brightnessControllerProvider = Provider<BrightnessController>(
  (Ref ref) => const UnsupportedBrightnessController(),
);

final mediaPickerServiceProvider = Provider<MediaPickerService>(
  (Ref ref) => const UnsupportedMediaPickerService(),
);

final shareServiceProvider = Provider<ShareService>(
  (Ref ref) => const ClipboardShareService(),
);

final scannerServiceProvider = Provider<ScannerService>(
  (Ref ref) => const UnsupportedScannerService(),
);

final notificationServiceProvider = Provider<NotificationService>(
  (Ref ref) => const InAppNotificationService(),
);

// --- Data sources ---------------------------------------------------------
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (Ref ref) => AuthRemoteDataSource(ref.watch(apiClientProvider).dio),
);

final cardsRemoteDataSourceProvider = Provider<CardsRemoteDataSource>(
  (Ref ref) => CardsRemoteDataSource(ref.watch(apiClientProvider).dio),
);

final rewardsRemoteDataSourceProvider = Provider<RewardsRemoteDataSource>(
  (Ref ref) => RewardsRemoteDataSource(ref.watch(apiClientProvider).dio),
);

final promotionsRemoteDataSourceProvider =
    Provider<PromotionsRemoteDataSource>(
  (Ref ref) => PromotionsRemoteDataSource(ref.watch(apiClientProvider).dio),
);

final businessesRemoteDataSourceProvider =
    Provider<BusinessesRemoteDataSource>(
  (Ref ref) => BusinessesRemoteDataSource(ref.watch(apiClientProvider).dio),
);

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>(
  (Ref ref) => ProfileRemoteDataSource(ref.watch(apiClientProvider).dio),
);

final legalRemoteDataSourceProvider = Provider<LegalRemoteDataSource>(
  (Ref ref) => LegalRemoteDataSource(ref.watch(apiClientProvider).dio),
);

final businessRemoteDataSourceProvider = Provider<BusinessRemoteDataSource>(
  (Ref ref) => BusinessRemoteDataSource(ref.watch(apiClientProvider).dio),
);

// --- Repositorios ---------------------------------------------------------
final authRepositoryProvider = Provider<AuthRepository>(
  (Ref ref) => AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(tokenStorageProvider),
  ),
);

final cardsRepositoryProvider = Provider<CardsRepository>(
  (Ref ref) => CardsRepositoryImpl(
    ref.watch(cardsRemoteDataSourceProvider),
    ref.watch(localCacheProvider),
  ),
);

final rewardsRepositoryProvider = Provider<RewardsRepository>(
  (Ref ref) => RewardsRepositoryImpl(
    ref.watch(rewardsRemoteDataSourceProvider),
    ref.watch(localCacheProvider),
  ),
);

final promotionsRepositoryProvider = Provider<PromotionsRepository>(
  (Ref ref) => PromotionsRepositoryImpl(
    ref.watch(promotionsRemoteDataSourceProvider),
    ref.watch(localCacheProvider),
  ),
);

final businessesRepositoryProvider = Provider<BusinessesRepository>(
  (Ref ref) => BusinessesRepositoryImpl(
    ref.watch(businessesRemoteDataSourceProvider),
    ref.watch(localCacheProvider),
  ),
);

final profileRepositoryProvider = Provider<ProfileRepository>(
  (Ref ref) => ProfileRepositoryImpl(
    ref.watch(profileRemoteDataSourceProvider),
    ref.watch(localCacheProvider),
  ),
);

final legalRepositoryProvider = Provider<LegalRepository>(
  (Ref ref) => LegalRepositoryImpl(
    ref.watch(legalRemoteDataSourceProvider),
    ref.watch(localCacheProvider),
  ),
);

final businessRepositoryProvider = Provider<BusinessRepository>(
  (Ref ref) => BusinessRepositoryImpl(
    ref.watch(businessRemoteDataSourceProvider),
    ref.watch(localCacheProvider),
  ),
);
