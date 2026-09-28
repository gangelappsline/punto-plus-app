import 'package:dio/dio.dart';

import '../../../../core/config/api_paths.dart';
import '../../../../core/errors/app_exception.dart';
import '../models/auth_session.dart';
import '../models/login_request.dart';
import '../models/password_recovery_request.dart';
import '../models/register_request.dart';
import '../models/social_auth_request.dart';
import '../models/user_model.dart';

final class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<AuthSession> login(LoginRequest request) =>
      _postSession(ApiPaths.login, request.toJson());

  Future<AuthSession> register(RegisterRequest request) =>
      _postSession(ApiPaths.register, request.toJson());

  Future<void> requestPasswordReset(PasswordRecoveryRequest request) async {
    try {
      await _dio.post<void>(
        ApiPaths.forgotPassword,
        data: request.toJson(),
      );
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

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
    final session = await _postSession(
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

  Future<void> logout() async {
    try {
      await _dio.post<void>(ApiPaths.logout);
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<AuthSession> _postSession(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        path,
        data: body,
      );
      final responseBody = response.data;
      if (responseBody == null) {
        throw const AppException(message: 'La API devolvió una respuesta vacía.');
      }
      final data = responseBody['data'];
      final sessionJson = data is Map<String, dynamic> ? data : responseBody;
      final session = AuthSession.fromJson(sessionJson);
      if (session.accessToken.isEmpty) {
        throw const AppException(
          message: 'La respuesta no contiene un token de acceso.',
          code: 'invalid_auth_response',
        );
      }
      return session;
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }
}
