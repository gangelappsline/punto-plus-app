import 'package:flutter_test/flutter_test.dart';
import 'package:punto_plus/features/cards/data/models/customer_card.dart';
import 'package:punto_plus/features/cards/data/models/loyalty_card.dart';

void main() {
  const LoyaltyCardModel loyalty = LoyaltyCardModel(
    id: 'card-1',
    name: 'Café gratis',
    requiredStamps: 10,
    businessId: 'biz-1',
    businessName: 'Cafetería Sol',
  );

  CustomerCardModel card({
    int stamps = 0,
    String? qrCode,
    DateTime? qrExpiresAt,
  }) =>
      CustomerCardModel(
        id: 'cc-1',
        loyaltyCard: loyalty,
        stampsCount: stamps,
        requiredStamps: 10,
        qrCode: qrCode,
        qrExpiresAt: qrExpiresAt,
      );

  group('progreso', () {
    test('calcula sellos restantes y porcentaje', () {
      expect(card(stamps: 0).remainingStamps, 10);
      expect(card(stamps: 4).remainingStamps, 6);
      expect(card(stamps: 4).progress, 0.4);
      expect(card(stamps: 4).progressPercentage, 40);
    });

    test('nunca es negativo ni mayor que uno', () {
      expect(card(stamps: 14).remainingStamps, 0);
      expect(card(stamps: 14).progress, 1);
    });

    test('sin meta de sellos el progreso es cero', () {
      const CustomerCardModel empty = CustomerCardModel(
        id: 'cc-2',
        loyaltyCard: LoyaltyCardModel(id: 'c', name: 'x', requiredStamps: 0),
        stampsCount: 3,
        requiredStamps: 0,
      );
      expect(empty.progress, 0);
    });
  });

  group('código QR', () {
    test('sin código no hay QR vigente', () {
      expect(card(stamps: 1).hasFreshQr, isFalse);
    });

    test('un código sin expiración se considera vigente', () {
      expect(card(qrCode: 'PP-ABC123').hasFreshQr, isTrue);
    });

    test('un código expirado deja de ser vigente', () {
      final CustomerCardModel expired = card(
        qrCode: 'PP-OLD',
        qrExpiresAt: DateTime.now().subtract(const Duration(minutes: 1)),
      );
      final CustomerCardModel valid = card(
        qrCode: 'PP-NEW',
        qrExpiresAt: DateTime.now().add(const Duration(minutes: 5)),
      );

      expect(expired.hasFreshQr, isFalse);
      expect(valid.hasFreshQr, isTrue);
    });
  });

  group('fromJson', () {
    test('acepta snake_case anidado y calcula el estado', () {
      final CustomerCardModel parsed = CustomerCardModel.fromJson(
        <String, dynamic>{
          'id': 'cc-9',
          'stamps_count': 10,
          'required_stamps': 10,
          'loyalty_card': <String, dynamic>{
            'id': 'card-9',
            'name': 'Postre gratis',
            'required_stamps': 10,
            'business': <String, dynamic>{'name': 'Cafetería Sol'},
          },
        },
      );

      expect(parsed.id, 'cc-9');
      expect(parsed.stampsCount, 10);
      expect(parsed.requiredStamps, 10);
      expect(parsed.isCompleted, isTrue);
      expect(parsed.businessName, 'Cafetería Sol');
      expect(parsed.progressPercentage, 100);
    });

    test('cae al required_stamps de la tarjeta cuando la API no lo envía', () {
      final CustomerCardModel parsed = CustomerCardModel.fromJson(
        <String, dynamic>{
          'id': 'cc-10',
          'stampsCount': 2,
          'loyaltyCard': <String, dynamic>{
            'id': 'card-10',
            'name': 'Corte gratis',
            'requiredStamps': 8,
          },
        },
      );

      expect(parsed.requiredStamps, 8);
      expect(parsed.progress, 0.25);
      expect(parsed.isCompleted, isFalse);
    });

    test('round-trip de toJson conserva el progreso', () {
      final CustomerCardModel original = card(stamps: 3, qrCode: 'PP-XYZ');
      final CustomerCardModel restored =
          CustomerCardModel.fromJson(original.toJson());

      expect(restored.stampsCount, original.stampsCount);
      expect(restored.requiredStamps, original.requiredStamps);
      expect(restored.qrCode, 'PP-XYZ');
      expect(restored.loyaltyCard.name, 'Café gratis');
    });
  });
}
