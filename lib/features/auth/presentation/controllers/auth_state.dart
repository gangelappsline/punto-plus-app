import '../../data/models/auth_session.dart';
import '../../data/models/user_model.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated }

final class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.session,
    this.errorMessage,
    this.pendingVerificationIdentifier,
    this.notice,
  });

  final AuthStatus status;
  final AuthSession? session;
  final String? errorMessage;

  /// Identificador (correo o celular) pendiente de verificar con OTP.
  final String? pendingVerificationIdentifier;

  /// Mensaje informativo (reenvío de código, verificación exitosa).
  final String? notice;

  bool get isLoading => status == AuthStatus.loading;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  UserModel? get user => session?.user;

  bool get mustVerify =>
      session != null && session!.user.email != null &&
      !session!.user.hasVerifiedEmail;

  AuthState copyWith({
    AuthStatus? status,
    AuthSession? session,
    String? errorMessage,
    String? pendingVerificationIdentifier,
    String? notice,
    bool clearError = false,
    bool clearNotice = false,
    bool clearSession = false,
    bool clearPendingVerification = false,
  }) =>
      AuthState(
        status: status ?? this.status,
        session: clearSession ? null : (session ?? this.session),
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
        pendingVerificationIdentifier: clearPendingVerification
            ? null
            : (pendingVerificationIdentifier ??
                this.pendingVerificationIdentifier),
        notice: clearNotice ? null : (notice ?? this.notice),
      );
}
