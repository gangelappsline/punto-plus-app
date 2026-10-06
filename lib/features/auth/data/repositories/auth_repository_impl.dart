import '../../../../core/storage/token_storage.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_session.dart';
import '../models/login_request.dart';
import '../models/password_recovery_request.dart';
import '../models/register_request.dart';
import '../models/social_auth_request.dart';
import '../models/user_model.dart';
import '../models/verification_requests.dart';

final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource, this._tokenStorage);

  final AuthRemoteDataSource _remoteDataSource;
  final TokenStorage _tokenStorage;

  @override
  Future<Result<AuthSession>> login(LoginRequest request) =>
      _persistSession(() => _remoteDataSource.login(request));

  @override
  Future<Result<AuthSession>> register(RegisterRequest request) =>
      _persistSession(() => _remoteDataSource.register(request));

  @override
  Future<Result<void>> verifyCode(VerifyCodeRequest request) =>
      _run(() => _remoteDataSource.verifyCode(request));

  @override
  Future<Result<void>> resendCode(ResendCodeRequest request) =>
      _run(() => _remoteDataSource.resendCode(request));

  @override
  Future<Result<void>> requestPasswordReset(
    PasswordRecoveryRequest request,
  ) =>
      _run(() => _remoteDataSource.requestPasswordReset(request));

  @override
  Future<Result<void>> resetPassword(ResetPasswordRequest request) =>
      _run(() => _remoteDataSource.resetPassword(request));

  @override
  Future<Result<AuthSession>> authenticateWithSocialProvider(
    SocialAuthRequest request,
  ) =>
      _persistSession(
        () => _remoteDataSource.authenticateWithSocialProvider(request),
      );

  @override
  Future<AuthSession?> restoreSession() async {
    final AuthSession? session = await _tokenStorage.readSession();
    if (session == null) return null;
    if (!session.isExpired) return session;

    try {
      final AuthSession refreshedSession = await _remoteDataSource
          .refreshSession(
        refreshToken: session.refreshToken,
        currentUser: session.user,
      );
      await _tokenStorage.saveSession(refreshedSession);
      return refreshedSession;
    } on Exception {
      await _tokenStorage.clear();
      return null;
    }
  }

  @override
  Future<Result<UserModel>> refreshUser() async {
    try {
      final UserModel user = await _remoteDataSource.fetchProfile();
      final AuthSession? session = await _tokenStorage.readSession();
      if (session != null) {
        await _tokenStorage.saveSession(
          AuthSession(
            accessToken: session.accessToken,
            refreshToken: session.refreshToken,
            expiresAt: session.expiresAt,
            user: user,
          ),
        );
      }
      return Success<UserModel>(user);
    } on Exception catch (error) {
      return Failure<UserModel>(error);
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _tokenStorage.clear();
      return const Success<void>(null);
    } on Exception catch (error) {
      // La sesión local se limpia incluso si el backend no responde.
      await _tokenStorage.clear();
      return Failure<void>(error);
    }
  }

  Future<Result<AuthSession>> _persistSession(
    Future<AuthSession> Function() operation,
  ) async {
    try {
      final AuthSession session = await operation();
      await _tokenStorage.saveSession(session);
      return Success<AuthSession>(session);
    } on Exception catch (error) {
      return Failure<AuthSession>(error);
    }
  }

  Future<Result<void>> _run(Future<void> Function() operation) async {
    try {
      await operation();
      return const Success<void>(null);
    } on Exception catch (error) {
      return Failure<void>(error);
    }
  }
}
