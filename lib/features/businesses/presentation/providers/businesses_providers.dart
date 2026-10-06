import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/platform/location_service.dart';
import '../../../../core/providers/data_providers.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/storage/local_cache.dart';
import '../../../../core/utils/result.dart';
import '../../../cards/data/models/loyalty_card.dart';
import '../../../promotions/data/models/promotion.dart';
import '../../data/models/business.dart';
import '../../domain/repositories/businesses_repository.dart';

/// Filtros aplicados al mapa y a la búsqueda de negocios.
@immutable
final class MapFilters {
  const MapFilters({
    this.radiusKm = AppConstants.defaultRadiusKm,
    this.category,
    this.query = '',
    this.favoritesOnly = false,
    this.showMap = false,
  });

  final double radiusKm;
  final String? category;
  final String query;
  final bool favoritesOnly;
  final bool showMap;

  MapFilters copyWith({
    double? radiusKm,
    String? category,
    bool clearCategory = false,
    String? query,
    bool? favoritesOnly,
    bool? showMap,
  }) =>
      MapFilters(
        radiusKm: radiusKm ?? this.radiusKm,
        category: clearCategory ? null : (category ?? this.category),
        query: query ?? this.query,
        favoritesOnly: favoritesOnly ?? this.favoritesOnly,
        showMap: showMap ?? this.showMap,
      );
}

final mapFiltersProvider = NotifierProvider<MapFiltersController, MapFilters>(
  MapFiltersController.new,
);

final class MapFiltersController extends Notifier<MapFilters> {
  @override
  MapFilters build() => const MapFilters();

  void setRadius(double radiusKm) => state = state.copyWith(radiusKm: radiusKm);

  void setCategory(String? category) => state = category == null
      ? state.copyWith(clearCategory: true)
      : state.copyWith(category: category);

  void setQuery(String query) => state = state.copyWith(query: query);

  void toggleFavoritesOnly() =>
      state = state.copyWith(favoritesOnly: !state.favoritesOnly);

  void toggleView() => state = state.copyWith(showMap: !state.showMap);
}

/// Zona de referencia usada cuando no hay GPS disponible.
final referenceAreaProvider = Provider<ReferenceArea>((Ref ref) {
  final String? areaName = ref.watch(appPreferencesProvider).manualArea;
  return ManualLocationService.areaByName(areaName) ??
      ManualLocationService.areas.first;
});

/// Coordenadas actuales (o la zona de referencia configurada).
final currentGeoPointProvider = Provider<GeoPoint>(
  (Ref ref) => ref.watch(referenceAreaProvider).point,
);

/// Negocios cercanos según los filtros activos.
final nearbyBusinessesProvider =
    AsyncNotifierProvider<NearbyBusinessesController, List<BusinessModel>>(
  NearbyBusinessesController.new,
);

final class NearbyBusinessesController
    extends AsyncNotifier<List<BusinessModel>> {
  @override
  Future<List<BusinessModel>> build() {
    final MapFilters filters = ref.watch(mapFiltersProvider);
    final GeoPoint point = ref.watch(currentGeoPointProvider);
    final Set<String> favorites = ref.watch(favoritesControllerProvider);
    return _load(filters, point, favorites);
  }

  Future<List<BusinessModel>> _load(
    MapFilters filters,
    GeoPoint point,
    Set<String> favorites, {
    bool force = false,
  }) async {
    final Result<List<BusinessModel>> result =
        await ref.read(businessesRepositoryProvider).fetchNearby(
              latitude: point.latitude,
              longitude: point.longitude,
              radiusKm: filters.radiusKm,
              category: filters.category,
              query: filters.query.isEmpty ? null : filters.query,
              forceRefresh: force,
            );
    final List<BusinessModel> businesses = switch (result) {
      Success<List<BusinessModel>>(:final value) => value,
      Failure<List<BusinessModel>>(:final error) => throw error,
    };
    return businesses
        .map(
          (BusinessModel business) =>
              business.copyWith(isFavorite: favorites.contains(business.id)),
        )
        .toList();
  }

  Future<void> refresh({bool force = true}) async {
    final MapFilters filters = ref.read(mapFiltersProvider);
    final GeoPoint point = ref.read(currentGeoPointProvider);
    final Set<String> favorites = ref.read(favoritesControllerProvider);
    state = const AsyncValue<List<BusinessModel>>.loading();
    state = await AsyncValue.guard(
      () => _load(filters, point, favorites, force: force),
    );
  }
}

/// Negocios visibles tras aplicar el filtro de favoritos en memoria.
final visibleBusinessesProvider = Provider<List<BusinessModel>>((Ref ref) {
  final List<BusinessModel> businesses =
      ref.watch(nearbyBusinessesProvider).valueOrNull ?? <BusinessModel>[];
  if (!ref.watch(mapFiltersProvider).favoritesOnly) return businesses;
  return businesses.where((BusinessModel item) => item.isFavorite).toList();
});

/// Negocios favoritos guardados localmente.
final favoritesControllerProvider =
    AsyncNotifierProvider<FavoritesController, Set<String>>(
  FavoritesController.new,
);

final class FavoritesController extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() =>
      ref.watch(localCacheProvider).readIds(LocalCache.favoritesKey);

  Future<void> toggle(String businessId) async {
    final Set<String> current = state.valueOrNull ?? <String>{};
    final Set<String> updated = <String>{...current};
    if (!updated.remove(businessId)) updated.add(businessId);
    state = AsyncValue<Set<String>>.data(updated);
    await ref
        .read(localCacheProvider)
        .saveIds(LocalCache.favoritesKey, updated);
  }

  bool contains(String businessId) =>
      (state.valueOrNull ?? <String>{}).contains(businessId);
}

/// Detalle de un negocio con sus tarjetas y promociones.
@immutable
final class BusinessDetail {
  const BusinessDetail({
    required this.business,
    required this.cards,
    required this.promotions,
  });

  final BusinessModel business;
  final List<LoyaltyCardModel> cards;
  final List<PromotionModel> promotions;
}

final businessDetailProvider =
    FutureProvider.family<BusinessDetail, String>((Ref ref, String id) async {
  final BusinessesRepository repository = ref.watch(businessesRepositoryProvider);
  final List<Object> results = await Future.wait(<Future<Object>>[
    repository.fetchBusiness(id),
    repository.fetchBusinessCards(id),
    repository.fetchBusinessPromotions(id),
  ]);
  final Result<BusinessModel> businessResult = results[0] as Result<BusinessModel>;
  final Result<List<LoyaltyCardModel>> cardsResult =
      results[1] as Result<List<LoyaltyCardModel>>;
  final Result<List<PromotionModel>> promotionsResult =
      results[2] as Result<List<PromotionModel>>;

  final BusinessModel business = switch (businessResult) {
    Success<BusinessModel>(:final value) => value,
    Failure<BusinessModel>(:final error) => throw error,
  };
  return BusinessDetail(
    business: business,
    cards: switch (cardsResult) {
      Success<List<LoyaltyCardModel>>(:final value) => value,
      Failure<List<LoyaltyCardModel>>() => const <LoyaltyCardModel>[],
    },
    promotions: switch (promotionsResult) {
      Success<List<PromotionModel>>(:final value) => value,
      Failure<List<PromotionModel>>() => const <PromotionModel>[],
    },
  );
});
