import 'package:dio/dio.dart';

import '../../../../core/config/api_paths.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_response.dart';
import '../../../auth/data/models/user_model.dart';
import '../models/app_notification.dart';
import '../models/profile_requests.dart';
import '../models/referral_summary.dart';

/// Endpoints de perfil, notificaciones y referidos.
final class ProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._dio);

  final Dio _dio;

  Future<UserModel> updateProfile(UpdateProfileRequest request) async {
    try {
      final Response<dynamic> response = await _dio.put<dynamic>(
        ApiPaths.profile,
        data: request.toJson(),
      );
      return _userFromResponse(response.data);
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<UserModel> uploadAvatar({
    required List<int> bytes,
    required String filename,
  }) async {
    try {
      final FormData formData = FormData.fromMap(<String, dynamic>{
        'avatar': MultipartFile.fromBytes(bytes, filename: filename),
      });
      final Response<dynamic> response = await _dio.post<dynamic>(
        ApiPaths.profileAvatar,
        data: formData,
      );
      return _userFromResponse(response.data);
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<void> changePassword(ChangePasswordRequest request) async {
    try {
      await _dio.put<dynamic>(ApiPaths.profilePassword, data: request.toJson());
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _dio.delete<dynamic>(ApiPaths.profile);
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<List<AppNotificationModel>> fetchNotifications() async {
    try {
      final Response<dynamic> response =
          await _dio.get<dynamic>(ApiPaths.notifications);
      return ApiResponse.asList(response.data)
          .map(AppNotificationModel.fromJson)
          .toList();
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<void> markNotificationRead(String id) async {
    try {
      await _dio.put<dynamic>(ApiPaths.notificationRead(id));
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<ReferralSummary> fetchReferral() async {
    try {
      final Response<dynamic> response =
          await _dio.get<dynamic>(ApiPaths.customerReferral);
      return ReferralSummary.fromJson(ApiResponse.asMap(response.data));
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  UserModel _userFromResponse(dynamic data) {
    final Map<String, dynamic> body = ApiResponse.asMap(data);
    final Map<String, dynamic> user = body.containsKey('user')
        ? ApiResponse.asMap(body['user'])
        : body;
    if (user.isEmpty) {
      throw AppException.localized('errors.request_failed');
    }
    return UserModel.fromJson(user);
  }
}
