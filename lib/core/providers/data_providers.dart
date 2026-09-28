import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../config/app_config.dart';
import '../network/api_client.dart';
import '../storage/token_storage.dart';

final appConfigProvider = Provider<AppConfig>(
  (Ref ref) => AppConfig.fromEnvironment(),
);

final tokenStorageProvider = Provider<TokenStorage>(
  (Ref ref) => TokenStorage(const FlutterSecureStorage()),
);

final apiClientProvider = Provider<ApiClient>(
  (Ref ref) => ApiClient(
    config: ref.watch(appConfigProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  ),
);

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (Ref ref) => AuthRemoteDataSource(ref.watch(apiClientProvider).dio),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (Ref ref) => AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(tokenStorageProvider),
  ),
);
