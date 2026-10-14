import '../../wallet/domain/loyalty_card.dart';
import 'promotion.dart';

abstract interface class BusinessRepository {
  Future<void> registerPurchase({
    required String businessId,
    required String qr,
    required String operationId,
  });
  Future<void> saveCard(String businessId, LoyaltyCard card);
  Future<List<Promotion>> promotions();
  Future<void> savePromotion(String businessId, Promotion promotion);
  Future<void> deletePromotion(String businessId, String id);
}
