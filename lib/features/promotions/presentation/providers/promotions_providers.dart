import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/data_providers.dart';
import '../../../../core/utils/result.dart';
import '../../data/models/promotion.dart';
import '../../domain/repositories/promotions_repository.dart';

/// Promociones activas de los negocios del cliente.
final promotionsControllerProvider =
    AsyncNotifierProvider<PromotionsController, List<PromotionModel>>(
  PromotionsController.new,
);

final class PromotionsController extends AsyncNotifier<List<PromotionModel>> {
  late PromotionsRepository _repository;

  @override
  Future<List<PromotionModel>> build() {
    _repository = ref.watch(promotionsRepositoryProvider);
    return _load();
  }

  Future<List<PromotionModel>> _load({bool force = false}) async {
    final Result<List<PromotionModel>> result =
        await _repository.fetchPromotions(forceRefresh: force);
    return switch (result) {
      Success<List<PromotionModel>>(:final value) => value,
      Failure<List<PromotionModel>>(:final error) => throw error,
    };
  }

  Future<void> refresh({bool force = true}) async {
    state = const AsyncValue<List<PromotionModel>>.loading();
    state = await AsyncValue.guard(() => _load(force: force));
  }
}

/// Promociones vigentes (excluye vencidas y programadas).
final activePromotionsProvider = Provider<List<PromotionModel>>((Ref ref) {
  final List<PromotionModel> promotions =
      ref.watch(promotionsControllerProvider).valueOrNull ??
          <PromotionModel>[];
  return promotions
      .where((PromotionModel promotion) => promotion.isCurrentlyActive)
      .toList();
});
