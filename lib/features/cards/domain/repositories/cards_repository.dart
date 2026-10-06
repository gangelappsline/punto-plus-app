import '../../../../core/utils/result.dart';
import '../../data/models/customer_card.dart';
import '../../data/models/customer_card_qr.dart';
import '../../data/models/stamp.dart';

/// Contrato de tarjetas de fidelidad del cliente.
abstract interface class CardsRepository {
  /// Tarjetas del cliente (usa caché local si no hay red).
  Future<Result<List<CustomerCardModel>>> fetchCards({bool forceRefresh = false});

  Future<Result<CustomerCardModel>> fetchCard(String id);

  Future<Result<List<StampModel>>> fetchStamps(String cardId);

  Future<Result<CustomerCardModel>> join(String code);

  Future<Result<CustomerCardQr>> fetchQr(String cardId);

  Future<Result<CustomerCardModel?>> redeem(String cardId);
}
