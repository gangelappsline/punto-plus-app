import '../../../../core/utils/result.dart';
import '../../data/models/auth_session.dart';
import '../../data/models/login_request.dart';
import '../../data/models/password_recovery_request.dart';
import '../../data/models/register_request.dart';
import '../../data/models/social_auth_request.dart';
import '../../data/models/user_model.dart';
import '../../data/models/verification_requests.dart';

/// Contrato de autenticación usado por la capa de presentación.
abstract interface class AuthRepository {
  Future<Result<AuthSession>> login(LoginRequest request);

  Future<Result<AuthSession>> register(RegisterRequest request);

  Future<Result<void>> verifyCode(VerifyCodeRequest request);

  Future<Result<void>> resendCode(ResendCodeRequest request);

  Future<Result<void>> requestPasswordReset(PasswordRecoveryRequest request);

  Future<Result<void>> resetPassword(ResetPasswordRequest request);

  Future<Result<AuthSession>> authenticateWithSocialProvider(
    SocialAuthRequest request,
  );

  /// Restaura la sesión guardada, renovando el token cuando expiró.
  Future<AuthSession?> restoreSession();

  /// Vuelve a leer el perfil autenticado.
  Future<Result<UserModel>> refreshUser();

  Future<Result<void>> logout();
}
