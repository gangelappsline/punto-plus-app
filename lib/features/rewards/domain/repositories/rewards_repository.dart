import '../../../../core/utils/result.dart';
import '../../data/models/reward.dart';

/// Contrato de premios del cliente.
abstract interface class RewardsRepository {
  Future<Result<List<RewardModel>>> fetchRewards({bool forceRefresh = false});

  Future<Result<RewardModel?>> redeem(String rewardId);
}
