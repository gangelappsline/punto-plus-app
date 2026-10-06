import '../../../../core/storage/local_cache.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/rewards_repository.dart';
import '../datasources/rewards_remote_data_source.dart';
import '../models/reward.dart';

final class RewardsRepositoryImpl implements RewardsRepository {
  const RewardsRepositoryImpl(this._remoteDataSource, this._cache);

  static const String _cacheKey = 'cache.rewards';

  final RewardsRemoteDataSource _remoteDataSource;
  final LocalCache _cache;

  @override
  Future<Result<List<RewardModel>>> fetchRewards({
    bool forceRefresh = false,
  }) async {
    try {
      final List<RewardModel> rewards =
          await _remoteDataSource.fetchRewards();
      await _cache.saveList(
        _cacheKey,
        rewards.map((RewardModel reward) => reward.toJson()).toList(),
      );
      return Success<List<RewardModel>>(rewards);
    } on Exception catch (error) {
      if (forceRefresh) return Failure<List<RewardModel>>(error);
      final List<Map<String, dynamic>> cached = await _cache.readList(_cacheKey);
      if (cached.isEmpty) return Failure<List<RewardModel>>(error);
      return Success<List<RewardModel>>(
        cached.map(RewardModel.fromJson).toList(),
      );
    }
  }

  @override
  Future<Result<RewardModel?>> redeem(String rewardId) async {
    try {
      return Success<RewardModel?>(await _remoteDataSource.redeem(rewardId));
    } on Exception catch (error) {
      return Failure<RewardModel?>(error);
    }
  }
}
