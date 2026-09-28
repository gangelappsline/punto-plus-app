import '../../../../core/utils/result.dart';
import '../../data/models/auth_session.dart';
import '../../data/models/login_request.dart';
import '../../data/models/password_recovery_request.dart';
import '../../data/models/register_request.dart';
import '../../data/models/social_auth_request.dart';

abstract interface class AuthRepository {
  Future<Result<AuthSession>> login(LoginRequest request);
  Future<Result<AuthSession>> register(RegisterRequest request);
  Future<Result<void>> requestPasswordReset(PasswordRecoveryRequest request);
  Future<Result<AuthSession>> authenticateWithSocialProvider(
    SocialAuthRequest request,
  );
  Future<AuthSession?> restoreSession();
  Future<Result<void>> logout();
}
