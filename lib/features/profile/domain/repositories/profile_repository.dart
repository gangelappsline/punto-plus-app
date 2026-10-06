import '../../../../core/utils/result.dart';
import '../../../auth/data/models/user_model.dart';
import '../../data/models/app_notification.dart';
import '../../data/models/profile_requests.dart';
import '../../data/models/referral_summary.dart';

/// Contrato de perfil, notificaciones y referidos.
abstract interface class ProfileRepository {
  Future<Result<UserModel>> updateProfile(UpdateProfileRequest request);

  Future<Result<UserModel>> uploadAvatar({
    required List<int> bytes,
    required String filename,
  });

  Future<Result<void>> changePassword(ChangePasswordRequest request);

  Future<Result<void>> deleteAccount();

  Future<Result<List<AppNotificationModel>>> fetchNotifications();

  Future<Result<void>> markNotificationRead(String id);

  Future<Result<ReferralSummary>> fetchReferral();
}
