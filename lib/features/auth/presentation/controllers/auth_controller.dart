import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/data_providers.dart';
import '../../../../core/utils/result.dart';
import '../../data/models/auth_session.dart';
import '../../data/models/login_request.dart';
import '../../data/models/password_recovery_request.dart';
import '../../data/models/register_request.dart';
import '../../data/models/social_auth_request.dart';
import '../../data/models/user_model.dart';
import '../../data/models/verification_requests.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

/// Estado global de sesión: restauración, login, registro, OTP y cierre.
final class AuthController extends Notifier<AuthState> {
  late AuthRepository _repository;

  @override
  AuthState build() {
    _repository = ref.watch(authRepositoryProvider);
    return const AuthState();
  }

  Future<void> restoreSession() async {
    final AuthSession? session = await _repository.restoreSession();
    state = AuthState(
      status: session == null
          ? AuthStatus.unauthenticated
          : AuthStatus.authenticated,
      session: session,
    );
  }

  Future<bool> login(LoginRequest request) =>
      _run(() => _repository.login(request));

  Future<bool> register(RegisterRequest request) async {
    final bool success = await _run(() => _repository.register(request));
    if (success) {
      state = state.copyWith(
        pendingVerificationIdentifier: request.identifier,
      );
    }
    return success;
  }

  /// Verifica el OTP y refresca el perfil para actualizar `emailVerifiedAt`.
  Future<bool> verifyCode({
    required String identifier,
    required String code,
  }) async {
    if (state.isLoading) return false;
    state = state.copyWith(status: AuthStatus.loading, clearError: true);
    final Result<void> result = await _repository.verifyCode(
      VerifyCodeRequest(identifier: identifier, code: code),
    );
    if (result is Success<void>) {
      await refreshUser();
      state = state.copyWith(
        status: AuthStatus.authenticated,
        notice: 'verify_success',
      );
      return true;
    }
    final Failure<void> failure = result as Failure<void>;
    state = state.copyWith(
      status: state.isAuthenticated
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated,
      errorMessage: failure.error.toString(),
    );
    return false;
  }

  Future<bool> resendCode({required String identifier}) async {
    if (state.isLoading) return false;
    state = state.copyWith(status: AuthStatus.loading, clearError: true);
    final Result<void> result = await _repository.resendCode(
      ResendCodeRequest(identifier: identifier),
    );
    if (result is Success<void>) {
      state = state.copyWith(
        status: state.isAuthenticated
            ? AuthStatus.authenticated
            : AuthStatus.unauthenticated,
        notice: 'verify_resent',
      );
      return true;
    }
    final Failure<void> failure = result as Failure<void>;
    state = state.copyWith(
      status: state.isAuthenticated
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated,
      errorMessage: failure.error.toString(),
    );
    return false;
  }

  Future<bool> requestPasswordReset(PasswordRecoveryRequest request) async {
    if (state.isLoading) return false;
    state = state.copyWith(status: AuthStatus.loading, clearError: true);
    final Result<void> result =
        await _repository.requestPasswordReset(request);
    if (result is Success<void>) {
      state = const AuthState(status: AuthStatus.unauthenticated);
      return true;
    }
    final Failure<void> failure = result as Failure<void>;
    state = AuthState(
      status: AuthStatus.unauthenticated,
      errorMessage: failure.error.toString(),
    );
    return false;
  }

  Future<bool> resetPassword(ResetPasswordRequest request) async {
    if (state.isLoading) return false;
    state = state.copyWith(status: AuthStatus.loading, clearError: true);
    final Result<void> result = await _repository.resetPassword(request);
    if (result is Success<void>) {
      state = const AuthState(status: AuthStatus.unauthenticated);
      return true;
    }
    final Failure<void> failure = result as Failure<void>;
    state = AuthState(
      status: AuthStatus.unauthenticated,
      errorMessage: failure.error.toString(),
    );
    return false;
  }

  Future<bool> socialLogin(SocialAuthRequest request) =>
      _run(() => _repository.authenticateWithSocialProvider(request));

  /// Relee el perfil del usuario autenticado.
  Future<void> refreshUser() async {
    final Result<UserModel> result = await _repository.refreshUser();
    if (result is Success<UserModel>) {
      _replaceUser(result.value);
    }
  }

  /// Sincroniza el usuario en memoria tras editar el perfil.
  void updateUser(UserModel user) => _replaceUser(user);

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading, clearError: true);
    await _repository.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void clearError() => state = state.copyWith(clearError: true);

  void clearNotice() => state = state.copyWith(clearNotice: true);

  void setPendingVerification(String identifier) =>
      state = state.copyWith(pendingVerificationIdentifier: identifier);

  void clearPendingVerification() =>
      state = state.copyWith(clearPendingVerification: true);

  void _replaceUser(UserModel user) {
    final AuthSession? session = state.session;
    if (session == null) return;
    state = state.copyWith(
      session: AuthSession(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
        expiresAt: session.expiresAt,
        user: user,
      ),
    );
  }

  Future<bool> _run(
    Future<Result<AuthSession>> Function() operation,
  ) async {
    if (state.isLoading) return false;
    state = state.copyWith(status: AuthStatus.loading, clearError: true);
    final Result<AuthSession> result = await operation();

    if (result is Success<AuthSession>) {
      state = AuthState(
        status: AuthStatus.authenticated,
        session: result.value,
      );
      return true;
    }

    final Failure<AuthSession> failure = result as Failure<AuthSession>;
    state = AuthState(
      status: AuthStatus.unauthenticated,
      errorMessage: failure.error.toString(),
    );
    return false;
  }
}
