import '../../../../core/storage/local_cache.dart';
import '../../../../core/utils/result.dart';
import '../../../cards/data/models/loyalty_card.dart';
import '../../../cards/data/models/stamp.dart';
import '../../../promotions/data/models/promotion.dart';
import '../../domain/repositories/business_repository.dart';
import '../datasources/business_remote_data_source.dart';
import '../models/business_customer.dart';
import '../models/business_dashboard.dart';
import '../models/manage_inputs.dart';
import '../models/scan_stamp_result.dart';

final class BusinessRepositoryImpl implements BusinessRepository {
  const BusinessRepositoryImpl(this._remoteDataSource, this._cache);

  static const String recentStampsKey = 'cache.business.recent_stamps';

  final BusinessRemoteDataSource _remoteDataSource;
  final LocalCache _cache;

  @override
  Future<Result<BusinessDashboard>> fetchDashboard() async {
    try {
      return Success<BusinessDashboard>(
        await _remoteDataSource.fetchDashboard(),
      );
    } on Exception catch (error) {
      return Failure<BusinessDashboard>(error);
    }
  }

  @override
  Future<Result<List<LoyaltyCardModel>>> fetchCards() =>
      _guard(_remoteDataSource.fetchCards);

  @override
  Future<Result<LoyaltyCardModel>> createCard(LoyaltyCardInput input) =>
      _guard(() => _remoteDataSource.createCard(input));

  @override
  Future<Result<LoyaltyCardModel>> updateCard(
    String id,
    LoyaltyCardInput input,
  ) =>
      _guard(() => _remoteDataSource.updateCard(id, input));

  @override
  Future<Result<void>> deleteCard(String id) =>
      _guardVoid(() => _remoteDataSource.deleteCard(id));

  @override
  Future<Result<LoyaltyCardModel>> uploadCardAsset({
    required String cardId,
    required String field,
    required List<int> bytes,
    required String filename,
  }) =>
      _guard(
        () => _remoteDataSource.uploadCardAsset(
          cardId: cardId,
          field: field,
          bytes: bytes,
          filename: filename,
        ),
      );

  @override
  Future<Result<List<PromotionModel>>> fetchPromotions() =>
      _guard(_remoteDataSource.fetchPromotions);

  @override
  Future<Result<PromotionModel>> createPromotion(PromotionInput input) =>
      _guard(() => _remoteDataSource.createPromotion(input));

  @override
  Future<Result<PromotionModel>> updatePromotion(
    String id,
    PromotionInput input,
  ) =>
      _guard(() => _remoteDataSource.updatePromotion(id, input));

  @override
  Future<Result<void>> deletePromotion(String id) =>
      _guardVoid(() => _remoteDataSource.deletePromotion(id));

  @override
  Future<Result<List<BusinessCustomerModel>>> fetchCustomers({
    String? query,
  }) =>
      _guard(() => _remoteDataSource.fetchCustomers(query: query));

  @override
  Future<Result<BusinessCustomerModel>> fetchCustomer(String id) =>
      _guard(() => _remoteDataSource.fetchCustomer(id));

  @override
  Future<Result<ScanStampResult>> scanStamp(String qrCode) =>
      _guard(() => _remoteDataSource.scanStamp(qrCode));

  @override
  Future<Result<List<StampModel>>> fetchRecentStamps() async {
    try {
      final List<StampModel> stamps =
          await _remoteDataSource.fetchRecentStamps();
      await _cache.saveList(
        recentStampsKey,
        stamps.map((StampModel stamp) => stamp.toJson()).toList(),
      );
      return Success<List<StampModel>>(stamps);
    } on Exception catch (error) {
      final List<Map<String, dynamic>> cached =
          await _cache.readList(recentStampsKey);
      if (cached.isEmpty) return Failure<List<StampModel>>(error);
      return Success<List<StampModel>>(
        cached.map(StampModel.fromJson).toList(),
      );
    }
  }

  Future<Result<T>> _guard<T>(Future<T> Function() operation) async {
    try {
      return Success<T>(await operation());
    } on Exception catch (error) {
      return Failure<T>(error);
    }
  }

  Future<Result<void>> _guardVoid(Future<void> Function() operation) async {
    try {
      await operation();
      return const Success<void>(null);
    } on Exception catch (error) {
      return Failure<void>(error);
    }
  }
}
