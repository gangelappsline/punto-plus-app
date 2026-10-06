import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/data_providers.dart';
import '../../../../core/utils/result.dart';
import '../../data/models/reward.dart';
import '../../domain/repositories/rewards_repository.dart';

/// Premios del cliente (disponibles, canjeados y expirados).
final rewardsControllerProvider =
    AsyncNotifierProvider<RewardsController, List<RewardModel>>(
  RewardsController.new,
);

final class RewardsController extends AsyncNotifier<List<RewardModel>> {
  late RewardsRepository _repository;

  @override
  Future<List<RewardModel>> build() {
    _repository = ref.watch(rewardsRepositoryProvider);
    return _load();
  }

  Future<List<RewardModel>> _load({bool force = false}) async {
    final Result<List<RewardModel>> result =
        await _repository.fetchRewards(forceRefresh: force);
    return switch (result) {
      Success<List<RewardModel>>(:final value) => value,
      Failure<List<RewardModel>>(:final error) => throw error,
    };
  }

  Future<void> refresh({bool force = true}) async {
    state = const AsyncValue<List<RewardModel>>.loading();
    state = await AsyncValue.guard(() => _load(force: force));
  }

  /// Canjea un premio y actualiza el estado local.
  Future<RewardModel?> redeem(String rewardId) async {
    final Result<RewardModel?> result = await _repository.redeem(rewardId);
    final RewardModel? redeemed = switch (result) {
      Success<RewardModel?>(:final value) => value,
      Failure<RewardModel?>(:final error) => throw error,
    };
    final List<RewardModel> current = state.valueOrNull ?? <RewardModel>[];
    final List<RewardModel> updated = current
        .map(
          (RewardModel reward) => reward.id == rewardId
              ? (redeemed ?? reward).copyWith(
                  status: RewardStatus.redeemed,
                  redeemedAt: redeemed?.redeemedAt ?? DateTime.now(),
                )
              : reward,
        )
        .toList();
    state = AsyncValue<List<RewardModel>>.data(updated);
    return redeemed;
  }
}

/// Premios agrupados por estado, para las pestañas de la pantalla.
final rewardsByStatusProvider =
    Provider.family<List<RewardModel>, RewardStatus>((Ref ref, RewardStatus status) {
  final List<RewardModel> rewards =
      ref.watch(rewardsControllerProvider).valueOrNull ?? <RewardModel>[];
  return rewards
      .where((RewardModel reward) => reward.resolvedStatus == status)
      .toList();
});

/// Premios disponibles (usados en el inicio del cliente).
final availableRewardsProvider = Provider<List<RewardModel>>(
  (Ref ref) =>
      ref.watch(rewardsByStatusProvider(RewardStatus.available)),
);

/// Detalle de un premio por identificador.
final rewardByIdProvider =
    Provider.family<RewardModel?, String>((Ref ref, String id) {
  final List<RewardModel> rewards =
      ref.watch(rewardsControllerProvider).valueOrNull ?? <RewardModel>[];
  for (final RewardModel reward in rewards) {
    if (reward.id == id) return reward;
  }
  return null;
});
