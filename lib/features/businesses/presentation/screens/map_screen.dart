import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/platform/location_service.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/providers/data_providers.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/image_thumb.dart';
import '../../../../core/widgets/skeletons.dart';
import '../../../cards/data/models/customer_card.dart';
import '../../../cards/presentation/providers/cards_providers.dart';
import '../../data/models/business.dart';
import '../providers/businesses_providers.dart';
import '../widgets/business_tile.dart';
import '../widgets/map_canvas.dart';

/// Mapa de negocios cercanos con filtros, lista y detalle rápido.
final class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

final class _MapScreenState extends ConsumerState<MapScreen> {
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final MapFilters filters = ref.watch(mapFiltersProvider);
    final AsyncValue<List<BusinessModel>> nearby =
        ref.watch(nearbyBusinessesProvider);
    final List<BusinessModel> visible = ref.watch(visibleBusinessesProvider);
    final GeoPoint point = ref.watch(currentGeoPointProvider);
    final ReferenceArea area = ref.watch(referenceAreaProvider);

    return AppScaffold(
      scrollable: false,
      title: context.l10n.mapTitle,
      padding: EdgeInsets.zero,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.md,
              AppSpacing.xl,
              AppSpacing.sm,
            ),
            child: Column(
              children: <Widget>[
                SearchField(
                  controller: _search,
                  hintText: context.l10n.mapSearchHint,
                  onChanged: (String value) =>
                      ref.read(mapFiltersProvider.notifier).setQuery(value),
                  onClear: () =>
                      ref.read(mapFiltersProvider.notifier).setQuery(''),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: FilterChipRow(
                        options: AppConstants.radiusOptions
                            .map((double value) => '${value.toInt()} km')
                            .toList(),
                        selected: '${filters.radiusKm.toInt()} km',
                        onSelected: (String? value) {
                          if (value == null) return;
                          ref
                              .read(mapFiltersProvider.notifier)
                              .setRadius(double.parse(value.split(' ').first));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '${context.l10n.mapYouAreHere}: ${area.name}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    FilterChip(
                      label: Text(context.l10n.mapFavoritesOnly),
                      selected: filters.favoritesOnly,
                      onSelected: (_) => ref
                          .read(mapFiltersProvider.notifier)
                          .toggleFavoritesOnly(),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    IconActionButton(
                      icon: filters.showMap
                          ? Icons.list_rounded
                          : Icons.map_rounded,
                      tooltip: filters.showMap
                          ? context.l10n.commonListView
                          : context.l10n.commonMapView,
                      onPressed: () =>
                          ref.read(mapFiltersProvider.notifier).toggleView(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: AsyncValueView<List<BusinessModel>>(
              value: nearby,
              loading: const Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: ListSkeleton(items: 4),
              ),
              onRetry: () =>
                  ref.read(nearbyBusinessesProvider.notifier).refresh(),
              emptyBuilder: (List<BusinessModel> value) => value.isEmpty
                  ? EmptyStateView(
                      icon: Icons.location_off_rounded,
                      title: context.l10n.mapEmptyTitle,
                      message: context.l10n.mapEmptyMessage,
                      actionLabel: context.l10n.commonRetry,
                      onAction: () =>
                          ref.read(nearbyBusinessesProvider.notifier).refresh(),
                    )
                  : null,
              builder: (List<BusinessModel> value) => filters.showMap
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xl,
                        0,
                        AppSpacing.xl,
                        AppSpacing.xl,
                      ),
                      child: MapPanel(
                        child: MapCanvas(
                          businesses: visible,
                          userPoint: point,
                          radiusKm: filters.radiusKm,
                          onTapCluster: (MarkerCluster cluster) =>
                              _openCluster(cluster),
                        ),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xl,
                        0,
                        AppSpacing.xl,
                        96,
                      ),
                      children: <Widget>[
                        Text(
                          '${visible.length} '
                          '${context.l10n.homeNearbyTitle}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ...visible.map(
                          (BusinessModel item) =>
                              BusinessTile(business: item),
                        ),
                        if (visible.isEmpty)
                          EmptyStateView(
                            compact: true,
                            icon: Icons.filter_alt_off_rounded,
                            title: context.l10n.mapEmptyTitle,
                            message: context.l10n.mapEmptyMessage,
                          ),
                        const SizedBox(height: AppSpacing.lg),
                        _ManualLocationCard(area: area),
                        const SizedBox(height: AppSpacing.md),
                        SecondaryButton(
                          label: context.l10n.mapMyLocation,
                          icon: Icons.my_location_rounded,
                          onPressed: () => _useDeviceLocation(point),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _useDeviceLocation(GeoPoint fallback) async {
    final LocationService service = ref.read(locationServiceProvider);
    final LocationPermissionStatus status = await service.requestPermission();
    if (!mounted) return;
    if (status != LocationPermissionStatus.granted) {
      showConfirmDialog(
        context: context,
        title: context.l10n.mapLocationDeniedTitle,
        message: context.l10n.mapLocationDeniedMessage,
        confirmLabel: context.l10n.mapOpenSettings,
        cancelLabel: context.l10n.commonCancel,
        icon: Icons.location_disabled_rounded,
      ).then((bool openSettings) {
        if (openSettings) service.openSettings();
      });
      return;
    }
    final GeoPoint? position = await service.currentPosition();
    if (!mounted) return;
    context.showSnack(
      position == null
          ? context.l10n.mapStaticViewHint
          : AppFormatters.distance(
              (position.latitude - fallback.latitude).abs() * 111,
            ),
      kind: position == null ? AppSnackKind.neutral : AppSnackKind.success,
    );
  }

  Future<void> _openCluster(MarkerCluster cluster) async {
    if (cluster.businesses.length > 1) {
      await showAppSheet<void>(
        context: context,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              '${cluster.businesses.length} ${context.l10n.homeNearbyTitle}',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            ...cluster.businesses.map(
              (BusinessModel business) => AppCard(
                padding: const EdgeInsets.all(AppSpacing.sm),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push(AppRoutes.businessDetailPath(business.id));
                },
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: RemoteImage(
                    url: business.logoUrl,
                    fallbackInitials: business.name,
                    width: 44,
                    height: 44,
                  ),
                  title: Text(
                    business.name,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    AppFormatters.distance(business.distanceKm),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.l10n.commonClose),
            ),
          ],
        ),
      );
      return;
    }

    final BusinessModel business = cluster.first;
    await showAppSheet<void>(
      context: context,
      child: _BusinessPreviewSheet(business: business),
    );
  }
}

final class _BusinessPreviewSheet extends ConsumerWidget {
  const _BusinessPreviewSheet({required this.business});

  final BusinessModel business;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<CustomerCardModel> cards =
        ref.watch(cardsControllerProvider).valueOrNull ??
            <CustomerCardModel>[];
    final bool isMember = cards.any(
      (CustomerCardModel card) => card.loyaltyCard.businessId == business.id,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        RemoteImage(
          url: business.coverUrl ?? business.logoUrl,
          fallbackInitials: business.name,
          height: 132,
          radius: AppRadius.lg,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          business.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.xxs),
        Row(
          children: <Widget>[
            if (business.distanceKm != null) ...<Widget>[
              Text(
                AppFormatters.distance(business.distanceKm),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            if (business.isOpenNow != null)
              StatusBadge(
                label: business.isOpenNow!
                    ? context.l10n.businessOpenNow
                    : context.l10n.businessClosedNow,
                color: business.isOpenNow!
                    ? context.palette.success
                    : context.palette.textMuted,
              ),
          ],
        ),
        if (business.address != null) ...<Widget>[
          const SizedBox(height: AppSpacing.sm),
          Text(
            business.address!,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: isMember
              ? context.l10n.cardsJoinAlreadyMember
              : context.l10n.cardsJoinAction,
          icon: isMember ? Icons.check_rounded : Icons.add_card_rounded,
          onPressed: () {
            Navigator.of(context).pop();
            context.push(AppRoutes.businessDetailPath(business.id));
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        SecondaryButton(
          label: context.l10n.commonSeeDetail,
          icon: Icons.storefront_rounded,
          onPressed: () {
            Navigator.of(context).pop();
            context.push(AppRoutes.businessDetailPath(business.id));
          },
        ),
      ],
    );
  }
}

final class _ManualLocationCard extends ConsumerWidget {
  const _ManualLocationCard({required this.area});

  final ReferenceArea area;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppPalette palette = context.palette;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.place_outlined, color: palette.brand, size: 18),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  context.l10n.mapManualLocation,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            context.l10n.mapManualLocationHint,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: ManualLocationService.areas
                .map(
                  (ReferenceArea option) => ChoiceChip(
                    label: Text(option.name),
                    selected: option.name == area.name,
                    onSelected: (_) => ref
                        .read(appPreferencesProvider.notifier)
                        .setManualArea(option.name),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
