import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/data_providers.dart';
import '../../../../core/utils/result.dart';
import '../../../cards/data/models/loyalty_card.dart';
import '../../../cards/data/models/stamp.dart';
import '../../../promotions/data/models/promotion.dart';
import '../../data/models/business_customer.dart';
import '../../data/models/business_dashboard.dart';
import '../../data/models/manage_inputs.dart';
import '../../data/models/scan_stamp_result.dart';
import '../../domain/repositories/business_repository.dart';

/// Métricas del programa de fidelidad.
final businessDashboardProvider = FutureProvider<BusinessDashboard>(
  (Ref ref) async {
    final Result<BusinessDashboard> result =
        await ref.watch(businessRepositoryProvider).fetchDashboard();
    return switch (result) {
      Success<BusinessDashboard>(:final value) => value,
      Failure<BusinessDashboard>(:final error) => throw error,
    };
  },
);

/// Tarjetas configuradas por el negocio.
final businessCardsControllerProvider =
    AsyncNotifierProvider<BusinessCardsController, List<LoyaltyCardModel>>(
  BusinessCardsController.new,
);

final class BusinessCardsController
    extends AsyncNotifier<List<LoyaltyCardModel>> {
  BusinessRepository get _repository => ref.read(businessRepositoryProvider);

  @override
  Future<List<LoyaltyCardModel>> build() async {
    final Result<List<LoyaltyCardModel>> result =
        await _repository.fetchCards();
    return switch (result) {
      Success<List<LoyaltyCardModel>>(:final value) => value,
      Failure<List<LoyaltyCardModel>>(:final error) => throw error,
    };
  }

  Future<void> refresh() async {
    state = const AsyncValue<List<LoyaltyCardModel>>.loading();
    state = await AsyncValue.guard(() async {
      final Result<List<LoyaltyCardModel>> result =
          await _repository.fetchCards();
      return switch (result) {
        Success<List<LoyaltyCardModel>>(:final value) => value,
        Failure<List<LoyaltyCardModel>>(:final error) => throw error,
      };
    });
  }

  /// Crea o actualiza una tarjeta y recarga la lista.
  Future<LoyaltyCardModel> save({
    String? id,
    required LoyaltyCardInput input,
  }) async {
    final Result<LoyaltyCardModel> result = id == null
        ? await _repository.createCard(input)
        : await _repository.updateCard(id, input);
    final LoyaltyCardModel card = switch (result) {
      Success<LoyaltyCardModel>(:final value) => value,
      Failure<LoyaltyCardModel>(:final error) => throw error,
    };
    await refresh();
    return card;
  }

  /// Elimina una tarjeta del negocio.
  Future<void> delete(String id) async {
    final Result<void> result = await _repository.deleteCard(id);
    if (result is Failure<void>) throw result.error;
    final List<LoyaltyCardModel> current =
        state.valueOrNull ?? <LoyaltyCardModel>[];
    state = AsyncValue<List<LoyaltyCardModel>>.data(
      current.where((LoyaltyCardModel card) => card.id != id).toList(),
    );
  }

  /// Sube una imagen asociada a la tarjeta (logo, fondo o icono).
  Future<LoyaltyCardModel> uploadAsset({
    required String cardId,
    required String field,
    required List<int> bytes,
    required String filename,
  }) async {
    final Result<LoyaltyCardModel> result = await _repository.uploadCardAsset(
      cardId: cardId,
      field: field,
      bytes: bytes,
      filename: filename,
    );
    final LoyaltyCardModel card = switch (result) {
      Success<LoyaltyCardModel>(:final value) => value,
      Failure<LoyaltyCardModel>(:final error) => throw error,
    };
    await refresh();
    return card;
  }
}

/// Promociones publicadas por el negocio.
final businessPromotionsControllerProvider =
    AsyncNotifierProvider<BusinessPromotionsController, List<PromotionModel>>(
  BusinessPromotionsController.new,
);

final class BusinessPromotionsController
    extends AsyncNotifier<List<PromotionModel>> {
  BusinessRepository get _repository => ref.read(businessRepositoryProvider);

  @override
  Future<List<PromotionModel>> build() async {
    final Result<List<PromotionModel>> result =
        await _repository.fetchPromotions();
    return switch (result) {
      Success<List<PromotionModel>>(:final value) => value,
      Failure<List<PromotionModel>>(:final error) => throw error,
    };
  }

  Future<void> refresh() async {
    state = const AsyncValue<List<PromotionModel>>.loading();
    state = await AsyncValue.guard(() async {
      final Result<List<PromotionModel>> result =
          await _repository.fetchPromotions();
      return switch (result) {
        Success<List<PromotionModel>>(:final value) => value,
        Failure<List<PromotionModel>>(:final error) => throw error,
      };
    });
  }

  /// Crea o actualiza una promoción.
  Future<PromotionModel> save({
    String? id,
    required PromotionInput input,
  }) async {
    final Result<PromotionModel> result = id == null
        ? await _repository.createPromotion(input)
        : await _repository.updatePromotion(id, input);
    final PromotionModel promotion = switch (result) {
      Success<PromotionModel>(:final value) => value,
      Failure<PromotionModel>(:final error) => throw error,
    };
    await refresh();
    return promotion;
  }

  /// Elimina una promoción.
  Future<void> delete(String id) async {
    final Result<void> result = await _repository.deletePromotion(id);
    if (result is Failure<void>) throw result.error;
    final List<PromotionModel> current =
        state.valueOrNull ?? <PromotionModel>[];
    state = AsyncValue<List<PromotionModel>>.data(
      current.where((PromotionModel item) => item.id != id).toList(),
    );
  }
}

/// Clientes fieles del negocio (filtrados por búsqueda).
final businessCustomersProvider =
    FutureProvider.family<List<BusinessCustomerModel>, String>(
  (Ref ref, String query) async {
    final Result<List<BusinessCustomerModel>> result =
        await ref.watch(businessRepositoryProvider).fetchCustomers(
              query: query.isEmpty ? null : query,
            );
    return switch (result) {
      Success<List<BusinessCustomerModel>>(:final value) => value,
      Failure<List<BusinessCustomerModel>>(:final error) => throw error,
    };
  },
);

/// Detalle de un cliente fiel.
final businessCustomerDetailProvider =
    FutureProvider.family<BusinessCustomerModel, String>(
  (Ref ref, String id) async {
    final Result<BusinessCustomerModel> result =
        await ref.watch(businessRepositoryProvider).fetchCustomer(id);
    return switch (result) {
      Success<BusinessCustomerModel>(:final value) => value,
      Failure<BusinessCustomerModel>(:final error) => throw error,
    };
  },
);

/// Resultado del escaneo de un QR de cliente.
@immutable
final class ScanState {
  const ScanState({
    this.isProcessing = false,
    this.result,
    this.errorMessage,
    this.processedCodes = const <String>{},
  });

  final bool isProcessing;
  final ScanStampResult? result;
  final String? errorMessage;

  /// Códigos ya usados en esta sesión (evita el doble escaneo).
  final Set<String> processedCodes;

  bool wasProcessed(String code) => processedCodes.contains(code);

  ScanState copyWith({
    bool? isProcessing,
    ScanStampResult? result,
    String? errorMessage,
    Set<String>? processedCodes,
    bool clearResult = false,
    bool clearError = false,
  }) =>
      ScanState(
        isProcessing: isProcessing ?? this.isProcessing,
        result: clearResult ? null : (result ?? this.result),
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
        processedCodes: processedCodes ?? this.processedCodes,
      );
}

final scanControllerProvider = NotifierProvider<ScanController, ScanState>(
  ScanController.new,
);

final class ScanController extends Notifier<ScanState> {
  BusinessRepository get _repository => ref.read(businessRepositoryProvider);

  @override
  ScanState build() => const ScanState();

  /// Registra un sello a partir del QR escaneado.
  Future<ScanStampResult?> scan(String code) async {
    final String value = code.trim();
    if (value.isEmpty || state.isProcessing) return null;
    if (state.wasProcessed(value)) {
      state = state.copyWith(errorMessage: 'duplicate', clearResult: true);
      return null;
    }
    state = state.copyWith(isProcessing: true, clearError: true);
    final Result<ScanStampResult> result = await _repository.scanStamp(value);
    switch (result) {
      case Success<ScanStampResult>(value: final ScanStampResult scanned):
        state = ScanState(
          result: scanned,
          processedCodes: <String>{...state.processedCodes, value},
        );
        return value2;
      case Failure<ScanStampResult>(:final error):
        state = state.copyWith(
          isProcessing: false,
          errorMessage: error.toString(),
          clearResult: true,
        );
        return null;
    }
  }

  /// Prepara el escáner para leer otro código.
  void reset() => state = ScanState(processedCodes: state.processedCodes);

  void clearError() => state = state.copyWith(clearError: true);
}

/// Sellos registrados recientemente por el negocio.
final recentStampsProvider = FutureProvider<List<StampModel>>((Ref ref) async {
  final Result<List<StampModel>> result =
      await ref.watch(businessRepositoryProvider).fetchRecentStamps();
  return switch (result) {
    Success<List<StampModel>>(:final value) => value,
    Failure<List<StampModel>>(:final error) => throw error,
  };
});
