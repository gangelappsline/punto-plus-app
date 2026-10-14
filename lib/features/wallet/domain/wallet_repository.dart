import 'loyalty_card.dart';

abstract interface class WalletRepository {
  Future<CardSnapshot> cards(String userId, {required bool offline});
  Future<void> redeem(String userId, String cardId, String operationId);
}
