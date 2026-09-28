import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/data_providers.dart';
import '../../../../core/utils/result.dart';
import '../../data/models/auth_session.dart';
import '../../data/models/login_request.dart';
import '../../data/models/password_recovery_request.dart';
import '../../data/models/register_request.dart';
import '../../data/models/social_auth_request.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

final class AuthController extends Notifier<AuthState> {
  late AuthRepository _repository;

  @override
  AuthState build() {
    _repository = ref.watch(authRepositoryProvider);
    return const AuthState();
  }

  Future<void> restoreSession() async {
    final session = await _repository.restoreSession();
    state = AuthState(
      status: session == null
          ? AuthStatus.unauthenticated
          : AuthStatus.authenticated,
      session: session,
    );
  }

  Future<bool> login(LoginRequest request) =>
      _run(() => _repository.login(request));

  Future<bool> register(RegisterRequest request) =>
      _run(() => _repository.register(request));

  Future<bool> requestPasswordReset(PasswordRecoveryRequest request) async {
    if (state.isLoading) return false;
    state = state.copyWith(status: AuthStatus.loading, clearError: true);
    final result = await _repository.requestPasswordReset(request);
    if (result is Success<void>) {
      state = const AuthState(status: AuthStatus.unauthenticated);
      return true;
    }
    final failure = result as Failure<void>;
    state = AuthState(
      status: AuthStatus.unauthenticated,
      errorMessage: failure.error.toString(),
    );
    return false;
  }

  Future<bool> socialLogin(SocialAuthRequest request) =>
      _run(() => _repository.authenticateWithSocialProvider(request));

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading, clearError: true);
    await _repository.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void clearError() => state = state.copyWith(clearError: true);

  Future<bool> _run(
    Future<Result<AuthSession>> Function() operation,
  ) async {
    if (state.isLoading) return false;
    state = state.copyWith(status: AuthStatus.loading, clearError: true);
    final result = await operation();

    if (result is Success<AuthSession>) {
      state = AuthState(
        status: AuthStatus.authenticated,
        session: result.value,
      );
      return true;
    }

    final failure = result as Failure<AuthSession>;
    state = AuthState(
      status: AuthStatus.unauthenticated,
      errorMessage: failure.error.toString(),
    );
    return false;
  }
}
