import '../../../../core/storage/local_cache.dart';
import '../../../../core/utils/result.dart';
import '../../../cards/data/models/loyalty_card.dart';
import '../../../promotions/data/models/promotion.dart';
import '../../domain/repositories/businesses_repository.dart';
import '../datasources/businesses_remote_data_source.dart';
import '../models/business.dart';

final class BusinessesRepositoryImpl implements BusinessesRepository {
  const BusinessesRepositoryImpl(this._remoteDataSource, this._cache);

  final BusinessesRemoteDataSource _remoteDataSource;
  final LocalCache _cache;

  @override
  Future<Result<List<BusinessModel>>> fetchNearby({
    required double latitude,
    required double longitude,
    required double radiusKm,
    String? category,
    String? query,
    bool forceRefresh = false,
  }) async {
    try {
      final List<BusinessModel> businesses = await _remoteDataSource.fetchNearby(
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
        category: category,
        query: query,
      );
      await _cache.saveList(
        LocalCache.nearbyKey,
        businesses.map((BusinessModel item) => item.toJson()).toList(),
      );
      return Success<List<BusinessModel>>(businesses);
    } on Exception catch (error) {
      if (forceRefresh) return Failure<List<BusinessModel>>(error);
      final List<Map<String, dynamic>> cached =
          await _cache.readList(LocalCache.nearbyKey);
      if (cached.isEmpty) return Failure<List<BusinessModel>>(error);
      return Success<List<BusinessModel>>(
        cached.map(BusinessModel.fromJson).toList(),
      );
    }
  }

  @override
  Future<Result<BusinessModel>> fetchBusiness(String id) async {
    try {
      return Success<BusinessModel>(
        await _remoteDataSource.fetchBusiness(id),
      );
    } on Exception catch (error) {
      final List<Map<String, dynamic>> cached =
          await _cache.readList(LocalCache.nearbyKey);
      for (final Map<String, dynamic> item in cached) {
        final BusinessModel business = BusinessModel.fromJson(item);
        if (business.id == id) return Success<BusinessModel>(business);
      }
      return Failure<BusinessModel>(error);
    }
  }

  @override
  Future<Result<List<LoyaltyCardModel>>> fetchBusinessCards(
    String businessId,
  ) async {
    try {
      return Success<List<LoyaltyCardModel>>(
        await _remoteDataSource.fetchBusinessCards(businessId),
      );
    } on Exception catch (error) {
      return Failure<List<LoyaltyCardModel>>(error);
    }
  }

  @override
  Future<Result<List<PromotionModel>>> fetchBusinessPromotions(
    String businessId,
  ) async {
    try {
      return Success<List<PromotionModel>>(
        await _remoteDataSource.fetchBusinessPromotions(businessId),
      );
    } on Exception catch (error) {
      return Failure<List<PromotionModel>>(error);
    }
  }
}
