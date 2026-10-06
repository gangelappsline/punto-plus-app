import '../../../../core/utils/result.dart';
import '../../data/models/promotion.dart';

/// Contrato de promociones visibles al cliente.
abstract interface class PromotionsRepository {
  Future<Result<List<PromotionModel>>> fetchPromotions({
    String? businessId,
    bool forceRefresh = false,
  });
}
