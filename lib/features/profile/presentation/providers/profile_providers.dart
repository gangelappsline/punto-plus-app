import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../core/providers/data_providers.dart';
import '../../../../core/utils/result.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../cards/data/models/customer_card.dart';
import '../../../rewards/data/models/reward.dart';
import '../../data/models/app_notification.dart';
import '../../data/models/profile_requests.dart';
import '../../data/models/referral_summary.dart';
import '../../domain/repositories/profile_repository.dart';

/// Resumen de actividad mostrado en el perfil.
final class ProfileStats {
  const ProfileStats({
    required this.points,
    required this.cards,
    required this.stamps,
    required this.rewards,
  });

  final int points;
  final int cards;
  final int stamps;
  final int rewards;
}

final profileStatsProvider = Provider<ProfileStats>((Ref ref) {
  final UserModel? user = ref.watch(currentUserProvider);
  final List<CustomerCardModel> cards =
      ref.watch(cardsControllerProvider).valueOrNull ?? <CustomerCardModel>[];
  final List<RewardModel> rewards =
      ref.watch(rewardsControllerProvider).valueOrNull ?? <RewardModel>[];
  return ProfileStats(
    points: user?.points ?? 0,
    cards: cards.length,
    stamps: cards.fold(
      0,
      (int total, CustomerCardModel card) => total + card.stampsCount,
    ),
    rewards: rewards
        .where((RewardModel reward) => reward.resolvedStatus == RewardStatus.redeemed)
        .length,
  );
});

/// Centro de notificaciones.
final notificationsControllerProvider = AsyncNotifierProvider<
    NotificationsController, List<AppNotificationModel>>(
  NotificationsController.new,
);

final class NotificationsController
    extends AsyncNotifier<List<AppNotificationModel>> {
  ProfileRepository get _repository => ref.read(profileRepositoryProvider);

  @override
  Future<List<AppNotificationModel>> build() async {
    final Result<List<AppNotificationModel>> result =
        await _repository.fetchNotifications();
    return switch (result) {
      Success<List<AppNotificationModel>>(:final value) => value,
      Failure<List<AppNotificationModel>>(:final error) => throw error,
    };
  }

  Future<void> refresh() async {
    state = const AsyncValue<List<AppNotificationModel>>.loading();
    state = await AsyncValue.guard(
      () async {
        final Result<List<AppNotificationModel>> result =
            await _repository.fetchNotifications();
        return switch (result) {
          Success<List<AppNotificationModel>>(:final value) => value,
          Failure<List<AppNotificationModel>>(:final error) => throw error,
        };
      },
    );
  }

  /// Marca una notificación como leída.
  Future<void> markRead(String id) async {
    final List<AppNotificationModel> current =
        state.valueOrNull ?? <AppNotificationModel>[];
    state = AsyncValue<List<AppNotificationModel>>.data(
      current
          .map(
            (AppNotificationModel item) =>
                item.id == id ? item.copyWith(isRead: true) : item,
          )
          .toList(),
    );
    await _repository.markNotificationRead(id);
  }

  /// Marca todas las notificaciones como leídas.
  Future<void> markAllRead() async {
    final List<AppNotificationModel> current =
        state.valueOrNull ?? <AppNotificationModel>[];
    final List<AppNotificationModel> unread = current
        .where((AppNotificationModel item) => !item.isRead)
        .toList();
    state = AsyncValue<List<AppNotificationModel>>.data(
      current
          .map((AppNotificationModel item) => item.copyWith(isRead: true))
          .toList(),
    );
    for (final AppNotificationModel item in unread) {
      await _repository.markNotificationRead(item.id);
    }
  }

}

/// Cantidad de avisos sin leer (insignia del tab de perfil).
final unreadNotificationsProvider = Provider<int>((Ref ref) {
  final List<AppNotificationModel> items =
      ref.watch(notificationsControllerProvider).valueOrNull ??
          <AppNotificationModel>[];
  return items.where((AppNotificationModel item) => !item.isRead).length;
});

/// Programa de referidos del cliente.
final referralProvider = FutureProvider<ReferralSummary>((Ref ref) async {
  final Result<ReferralSummary> result =
      await ref.watch(profileRepositoryProvider).fetchReferral();
  return switch (result) {
    Success<ReferralSummary>(:final value) => value,
    Failure<ReferralSummary>(:final error) => throw error,
  };
});

/// Estado del formulario de edición de perfil.
final editProfileControllerProvider =
    NotifierProvider<EditProfileController, AsyncValue<UserModel?>>(
  EditProfileController.new,
);

final class EditProfileController extends Notifier<AsyncValue<UserModel?>> {
  ProfileRepository get _repository => ref.read(profileRepositoryProvider);

  @override
  AsyncValue<UserModel?> build() => const AsyncValue<UserModel?>.data(null);

  /// Guarda los datos básicos del perfil.
  Future<UserModel> save(UpdateProfileRequest request) async {
    state = const AsyncValue<UserModel?>.loading();
    final Result<UserModel> result = await _repository.updateProfile(request);
    switch (result) {
      case Success<UserModel>(:final value):
        ref.read(authControllerProvider.notifier).updateUser(value);
        state = AsyncValue<UserModel?>.data(value);
        return value;
      case Failure<UserModel>(:final error):
        state = AsyncValue<UserModel?>.error(error, StackTrace.current);
        throw error;
    }
  }

  /// Sube una nueva foto de perfil.
  Future<UserModel> uploadAvatar({
    required List<int> bytes,
    required String filename,
  }) async {
    state = const AsyncValue<UserModel?>.loading();
    final Result<UserModel> result = await _repository.uploadAvatar(
      bytes: bytes,
      filename: filename,
    );
    switch (result) {
      case Success<UserModel>(:final value):
        ref.read(authControllerProvider.notifier).updateUser(value);
        state = AsyncValue<UserModel?>.data(value);
        return value;
      case Failure<UserModel>(:final error):
        state = AsyncValue<UserModel?>.error(error, StackTrace.current);
        throw error;
    }
  }

  /// Cambia la contraseña del usuario autenticado.
  Future<void> changePassword(ChangePasswordRequest request) async {
    final Result<void> result = await _repository.changePassword(request);
    if (result is Failure<void>) throw result.error;
  }

  /// Elimina la cuenta y cierra la sesión local.
  Future<void> deleteAccount() async {
    final Result<void> result = await _repository.deleteAccount();
    if (result is Failure<void>) throw result.error;
    await ref.read(authControllerProvider.notifier).logout();
  }
}
