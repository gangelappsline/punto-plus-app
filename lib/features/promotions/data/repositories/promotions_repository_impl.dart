import '../../../../core/storage/local_cache.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/promotions_repository.dart';
import '../datasources/promotions_remote_data_source.dart';
import '../models/promotion.dart';

final class PromotionsRepositoryImpl implements PromotionsRepository {
  const PromotionsRepositoryImpl(this._remoteDataSource, this._cache);

  static const String _cacheKey = 'cache.promotions';

  final PromotionsRemoteDataSource _remoteDataSource;
  final LocalCache _cache;

  @override
  Future<Result<List<PromotionModel>>> fetchPromotions({
    String? businessId,
    bool forceRefresh = false,
  }) async {
    try {
      final List<PromotionModel> promotions =
          await _remoteDataSource.fetchPromotions(businessId: businessId);
      if (businessId == null) {
        await _cache.saveList(
          _cacheKey,
          promotions.map((PromotionModel item) => item.toJson()).toList(),
        );
      }
      return Success<List<PromotionModel>>(promotions);
    } on Exception catch (error) {
      if (forceRefresh) return Failure<List<PromotionModel>>(error);
      final List<Map<String, dynamic>> cached = await _cache.readList(_cacheKey);
      if (cached.isEmpty) return Failure<List<PromotionModel>>(error);
      return Success<List<PromotionModel>>(
        cached.map(PromotionModel.fromJson).toList(),
      );
    }
  }
}
