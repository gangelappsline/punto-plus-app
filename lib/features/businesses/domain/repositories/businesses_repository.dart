import '../../../../core/utils/result.dart';
import '../../../cards/data/models/loyalty_card.dart';
import '../../../promotions/data/models/promotion.dart';
import '../../data/models/business.dart';

/// Contrato de descubrimiento de negocios para el cliente.
abstract interface class BusinessesRepository {
  Future<Result<List<BusinessModel>>> fetchNearby({
    required double latitude,
    required double longitude,
    required double radiusKm,
    String? category,
    String? query,
    bool forceRefresh = false,
  });

  Future<Result<BusinessModel>> fetchBusiness(String id);

  Future<Result<List<LoyaltyCardModel>>> fetchBusinessCards(String businessId);

  Future<Result<List<PromotionModel>>> fetchBusinessPromotions(
    String businessId,
  );
}
