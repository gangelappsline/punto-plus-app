import '../../../../core/storage/local_cache.dart';
import '../../../../core/utils/result.dart';
import '../../../auth/data/models/user_model.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/app_notification.dart';
import '../models/profile_requests.dart';
import '../models/referral_summary.dart';

final class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remoteDataSource, this._cache);

  static const String notificationsKey = 'cache.notifications';

  final ProfileRemoteDataSource _remoteDataSource;
  final LocalCache _cache;

  @override
  Future<Result<UserModel>> updateProfile(UpdateProfileRequest request) async {
    try {
      return Success<UserModel>(
        await _remoteDataSource.updateProfile(request),
      );
    } on Exception catch (error) {
      return Failure<UserModel>(error);
    }
  }

  @override
  Future<Result<UserModel>> uploadAvatar({
    required List<int> bytes,
    required String filename,
  }) async {
    try {
      return Success<UserModel>(
        await _remoteDataSource.uploadAvatar(
          bytes: bytes,
          filename: filename,
        ),
      );
    } on Exception catch (error) {
      return Failure<UserModel>(error);
    }
  }

  @override
  Future<Result<void>> changePassword(ChangePasswordRequest request) async {
    try {
      await _remoteDataSource.changePassword(request);
      return const Success<void>(null);
    } on Exception catch (error) {
      return Failure<void>(error);
    }
  }

  @override
  Future<Result<void>> deleteAccount() async {
    try {
      await _remoteDataSource.deleteAccount();
      await _cache.clear();
      return const Success<void>(null);
    } on Exception catch (error) {
      return Failure<void>(error);
    }
  }

  @override
  Future<Result<List<AppNotificationModel>>> fetchNotifications() async {
    try {
      final List<AppNotificationModel> notifications =
          await _remoteDataSource.fetchNotifications();
      await _cache.saveList(
        notificationsKey,
        notifications
            .map((AppNotificationModel item) => item.toJson())
            .toList(),
      );
      return Success<List<AppNotificationModel>>(notifications);
    } on Exception catch (error) {
      final List<Map<String, dynamic>> cached =
          await _cache.readList(notificationsKey);
      if (cached.isEmpty) {
        return Failure<List<AppNotificationModel>>(error);
      }
      return Success<List<AppNotificationModel>>(
        cached.map(AppNotificationModel.fromJson).toList(),
      );
    }
  }

  @override
  Future<Result<void>> markNotificationRead(String id) async {
    try {
      await _remoteDataSource.markNotificationRead(id);
      return const Success<void>(null);
    } on Exception catch (error) {
      return Failure<void>(error);
    }
  }

  @override
  Future<Result<ReferralSummary>> fetchReferral() async {
    try {
      final ReferralSummary summary =
          await _remoteDataSource.fetchReferral();
      await _cache.saveMap(
        LocalCache.referralKey,
        summary.toJson(),
      );
      return Success<ReferralSummary>(summary);
    } on Exception catch (error) {
      final Map<String, dynamic>? cached =
          await _cache.readMap(LocalCache.referralKey);
      if (cached == null) return Failure<ReferralSummary>(error);
      return Success<ReferralSummary>(ReferralSummary.fromJson(cached));
    }
  }
}
