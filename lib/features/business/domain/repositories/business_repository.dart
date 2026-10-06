import '../../../../core/utils/result.dart';
import '../../../cards/data/models/loyalty_card.dart';
import '../../../cards/data/models/stamp.dart';
import '../../../promotions/data/models/promotion.dart';
import '../../data/models/business_customer.dart';
import '../../data/models/business_dashboard.dart';
import '../../data/models/manage_inputs.dart';
import '../../data/models/scan_stamp_result.dart';

/// Contrato del modo negocio.
abstract interface class BusinessRepository {
  Future<Result<BusinessDashboard>> fetchDashboard();

  Future<Result<List<LoyaltyCardModel>>> fetchCards();

  Future<Result<LoyaltyCardModel>> createCard(LoyaltyCardInput input);

  Future<Result<LoyaltyCardModel>> updateCard(
    String id,
    LoyaltyCardInput input,
  );

  Future<Result<void>> deleteCard(String id);

  Future<Result<LoyaltyCardModel>> uploadCardAsset({
    required String cardId,
    required String field,
    required List<int> bytes,
    required String filename,
  });

  Future<Result<List<PromotionModel>>> fetchPromotions();

  Future<Result<PromotionModel>> createPromotion(PromotionInput input);

  Future<Result<PromotionModel>> updatePromotion(
    String id,
    PromotionInput input,
  );

  Future<Result<void>> deletePromotion(String id);

  Future<Result<List<BusinessCustomerModel>>> fetchCustomers({String? query});

  Future<Result<BusinessCustomerModel>> fetchCustomer(String id);

  Future<Result<ScanStampResult>> scanStamp(String qrCode);

  Future<Result<List<StampModel>>> fetchRecentStamps();
}
