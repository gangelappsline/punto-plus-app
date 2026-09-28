import '../../data/models/auth_session.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated }

final class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.session,
    this.errorMessage,
  });

  final AuthStatus status;
  final AuthSession? session;
  final String? errorMessage;

  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthStatus? status,
    AuthSession? session,
    String? errorMessage,
    bool clearError = false,
    bool clearSession = false,
  }) =>
      AuthState(
        status: status ?? this.status,
        session: clearSession ? null : (session ?? this.session),
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      );
}
