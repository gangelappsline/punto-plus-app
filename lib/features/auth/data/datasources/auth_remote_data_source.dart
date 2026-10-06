import 'package:dio/dio.dart';

import '../../../../core/config/api_paths.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_response.dart';
import '../models/auth_session.dart';
import '../models/login_request.dart';
import '../models/password_recovery_request.dart';
import '../models/register_request.dart';
import '../models/social_auth_request.dart';
import '../models/user_model.dart';
import '../models/verification_requests.dart';

/// Acceso HTTP a los endpoints de autenticación.
final class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<AuthSession> login(LoginRequest request) =>
      _postSession(ApiPaths.login, request.toJson());

  Future<AuthSession> register(RegisterRequest request) =>
      _postSession(ApiPaths.register, request.toJson());

  Future<void> verifyCode(VerifyCodeRequest request) =>
      _postEmpty(ApiPaths.verifyCode, request.toJson());

  Future<void> resendCode(ResendCodeRequest request) =>
      _postEmpty(ApiPaths.resendCode, request.toJson());

  Future<void> requestPasswordReset(PasswordRecoveryRequest request) =>
      _postEmpty(ApiPaths.forgotPassword, request.toJson());

  Future<void> resetPassword(ResetPasswordRequest request) =>
      _postEmpty(ApiPaths.resetPassword, request.toJson());

  Future<AuthSession> authenticateWithSocialProvider(
    SocialAuthRequest request,
  ) =>
      _postSession(
        request.provider == SocialProvider.google
            ? ApiPaths.google
            : ApiPaths.apple,
        request.toJson(),
      );

  Future<AuthSession> refreshSession({
    required String refreshToken,
    required UserModel currentUser,
  }) async {
    final AuthSession session = await _postSession(
      ApiPaths.refresh,
      <String, dynamic>{'refresh_token': refreshToken},
    );
    return AuthSession(
      accessToken: session.accessToken,
      refreshToken:
          session.refreshToken.isEmpty ? refreshToken : session.refreshToken,
      expiresAt: session.expiresAt,
      user: session.user.id.isEmpty ? currentUser : session.user,
    );
  }

  Future<UserModel> fetchProfile() async {
    try {
      final Response<dynamic> response =
          await _dio.get<dynamic>(ApiPaths.user);
      final Map<String, dynamic> json = ApiResponse.asMap(response.data);
      final Map<String, dynamic> user =
          json.containsKey('user') ? ApiResponse.asMap(json['user']) : json;
      if (user.isEmpty) {
        throw AppException.localized('errors.request_failed');
      }
      return UserModel.fromJson(user);
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<void> logout() => _postEmpty(ApiPaths.logout, null);

  Future<AuthSession> _postSession(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final Response<dynamic> response = await _dio.post<dynamic>(
        path,
        data: body,
      );
      final Map<String, dynamic> responseBody = ApiResponse.asMap(
        response.data,
      );
      if (responseBody.isEmpty) {
        throw AppException.localized('errors.request_failed');
      }
      final Map<String, dynamic> sessionJson =
          responseBody.containsKey('user') || responseBody.containsKey('token')
              ? responseBody
              : ApiResponse.asMap(responseBody['data']);
      final AuthSession session = AuthSession.fromJson(
        sessionJson.isEmpty ? responseBody : sessionJson,
      );
      if (session.accessToken.isEmpty) {
        throw AppException.localized(
          'errors.request_failed',
          code: 'invalid_auth_response',
        );
      }
      return session;
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<void> _postEmpty(String path, Map<String, dynamic>? body) async {
    try {
      await _dio.post<dynamic>(path, data: body);
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }
}
