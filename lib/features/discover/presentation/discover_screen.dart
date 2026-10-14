import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/providers.dart';
import '../../../core/config/app_config.dart';
import '../../../core/network/app_failure.dart';
import '../../../core/presentation/theme.dart';
import '../../../core/presentation/widgets.dart';
import '../domain/business.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});
  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  String _category = 'Todos';
  String _query = '';
  Position? _position;
  GoogleMapController? _mapController;
  bool _locating = false;

  // GoogleMap owns and disposes its controller with its platform view.

  Future<void> _locate() async {
    setState(() => _locating = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw const AppFailure(
            'Activa la ubicación en los ajustes de tu dispositivo.');
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        throw const AppFailure(
            'Permite la ubicación desde Ajustes del sistema. Puedes seguir explorando la lista.');
      }
      if (permission == LocationPermission.denied) {
        throw const AppFailure(
            'Sin permiso de ubicación. Puedes seguir explorando la lista.');
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 15)),
      );
      if (!mounted) {
        return;
      }
      setState(() => _position = position);
      await _mapController?.animateCamera(CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude)));
    } on Object catch (error) {
      if (mounted) {
        showMessage(context, friendlyError(error));
      }
    } finally {
      if (mounted) {
        setState(() => _locating = false);
      }
    }
  }

  String _distance(Business business) {
    final position = _position;
    if (position == null) {
      return 'CDMX';
    }
    final meters = Geolocator.distanceBetween(position.latitude,
        position.longitude, business.latitude, business.longitude);
    return meters < 1000
        ? '${meters.round()} m'
        : '${(meters / 1000).toStringAsFixed(1)} km';
  }

  Future<void> _details(Business business) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(businessIcon(business.symbol), size: 40),
              const SizedBox(height: 16),
              Text(business.name,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 10),
              Text(business.description),
              const SizedBox(height: 16),
              Text(business.address, style: const TextStyle(color: muted)),
              const SizedBox(height: 8),
              const Text('Negocio ficticio · ubicación ilustrativa',
                  style: TextStyle(fontSize: 12, color: muted)),
              const SizedBox(height: 24),
              FilledButton.icon(
                  onPressed: ref.read(offlineProvider)
                      ? null
                      : () async {
                          final uri =
                              Uri.https('www.google.com', '/maps/dir/', {
                            'api': '1',
                            'destination':
                                '${business.latitude},${business.longitude}',
                          });
                          try {
                            final opened = await launchUrl(uri,
                                mode: LaunchMode.externalApplication);
                            if (!opened && context.mounted) {
                              showMessage(context, 'No se pudo abrir la ruta.');
                            }
                          } on Object {
                            if (context.mounted) {
                              showMessage(context, 'No se pudo abrir la ruta.');
                            }
                          }
                        },
                  icon: const Icon(Icons.directions_outlined),
                  label: const Text('Ver cómo llegar')),
            ]),
      )),
    );
  }

  @override
  Widget build(BuildContext context) =>
      ListView(padding: const EdgeInsets.all(24), children: [
        const SizedBox(height: 10),
        const Text('SAL A DESCUBRIR',
            style: TextStyle(fontSize: 11, letterSpacing: 2, color: muted)),
        const SizedBox(height: 8),
        Text('Tu próximo favorito.',
            style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 12),
        const Text('Pequeños negocios. Grandes razones para volver.',
            style: TextStyle(color: muted)),
        const SizedBox(height: 24),
        TextField(
            onChanged: (value) =>
                setState(() => _query = value.toLowerCase().trim()),
            decoration: const InputDecoration(
                hintText: 'Busca un lugar o categoría',
                prefixIcon: Icon(Icons.search_rounded))),
        const SizedBox(height: 14),
        Wrap(
            spacing: 8,
            children: ['Todos', 'Café', 'Comida', 'Bienestar']
                .map((category) => ChoiceChip(
                      label: Text(category),
                      selected: _category == category,
                      onSelected: (_) => setState(() => _category = category),
                    ))
                .toList()),
        const SizedBox(height: 20),
        AsyncPanel(
            value: ref.watch(businessesProvider),
            onRetry: () => ref.invalidate(businessesProvider),
            builder: (all) {
              final businesses = all
                  .where((business) =>
                      (_category == 'Todos' ||
                          business.category == _category) &&
                      '${business.name} ${business.category}'
                          .toLowerCase()
                          .contains(_query))
                  .toList();
              if (_position != null) {
                double distance(Business b) => Geolocator.distanceBetween(
                    _position!.latitude,
                    _position!.longitude,
                    b.latitude,
                    b.longitude);
                businesses.sort((a, b) => distance(a).compareTo(distance(b)));
              }
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (AppConfig.mapsEnabled && !ref.watch(offlineProvider))
                      ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: SizedBox(
                              height: 250,
                              child: GoogleMap(
                                initialCameraPosition: const CameraPosition(
                                    target: LatLng(19.4195, -99.1604),
                                    zoom: 14.5),
                                onMapCreated: (controller) =>
                                    _mapController = controller,
                                myLocationEnabled: _position != null,
                                myLocationButtonEnabled: false,
                                zoomControlsEnabled: false,
                                mapToolbarEnabled: false,
                                markers: businesses
                                    .map((business) => Marker(
                                          markerId: MarkerId(business.id),
                                          position: LatLng(business.latitude,
                                              business.longitude),
                                          infoWindow:
                                              InfoWindow(title: business.name),
                                          onTap: () => _details(business),
                                        ))
                                    .toSet(),
                              )))
                    else
                      SoftPanel(
                          color: const Color(0xFFE9EDDE),
                          child: Column(children: [
                            const Icon(Icons.map_outlined, size: 48),
                            const SizedBox(height: 12),
                            const Text('Roma Norte, Ciudad de México',
                                style: TextStyle(fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center),
                            const SizedBox(height: 6),
                            Text(
                                ref.watch(offlineProvider)
                                    ? 'Sin conexión · explora los lugares de la demo en la lista.'
                                    : 'Vista de lista · activa Google Maps con una clave para ver el mapa interactivo.',
                                style:
                                    const TextStyle(fontSize: 12, color: muted),
                                textAlign: TextAlign.center),
                          ])),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                        onPressed: _locating ? null : _locate,
                        icon: Icon(_locating
                            ? Icons.hourglass_top_rounded
                            : Icons.my_location_rounded),
                        label: Text(_locating
                            ? 'Buscando tu ubicación…'
                            : 'Ordenar por cercanía')),
                    const Text('La ubicación se usa solo en este dispositivo.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11, color: muted)),
                    const SectionHeader('Lugares para volver'),
                    if (businesses.isEmpty)
                      const EmptyState(
                          icon: Icons.search_off_rounded,
                          title: 'No encontramos lugares',
                          subtitle: 'Prueba otra búsqueda o categoría.'),
                    ...businesses.map((business) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            leading: CircleAvatar(
                                backgroundColor: lime.withValues(alpha: 0.4),
                                child: Icon(businessIcon(business.symbol),
                                    color: ink)),
                            title: Text(business.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700)),
                            subtitle: Text(
                                '${business.category} · ${_distance(business)}'),
                            trailing:
                                const Icon(Icons.north_east_rounded, size: 18),
                            onTap: () => _details(business),
                          ),
                        ))),
                  ]);
            }),
        const SectionHeader('Novedades de la comunidad'),
        AsyncPanel(
            value: ref.watch(promotionsProvider),
            onRetry: () => ref.invalidate(promotionsProvider),
            builder: (promotions) {
              final active = promotions
                  .where((promotion) =>
                      promotion.expiresAt.isAfter(DateTime.now()))
                  .toList();
              if (active.isEmpty) {
                return const SoftPanel(
                    child: Text(
                        'Pronto habrá algo nuevo. Entra como negocio y publica tu primera promoción de demo.'));
              }
              return Column(
                  children: active
                      .map((promotion) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: SoftPanel(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  if (promotion.imagePath.isNotEmpty) ...[
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: SizedBox(
                                            height: 160,
                                            width: double.infinity,
                                            child: MediaImage(
                                                path: promotion.imagePath))),
                                    const SizedBox(height: 12),
                                  ],
                                  const Text('CAFÉ ORIGEN · DEMO',
                                      style: TextStyle(
                                          fontSize: 10,
                                          letterSpacing: 1.5,
                                          color: muted)),
                                  Text(promotion.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge),
                                  const SizedBox(height: 8),
                                  Text(promotion.description),
                                  const SizedBox(height: 8),
                                  Text(
                                      'Hasta ${DateFormat.yMMMd('es_MX').format(promotion.expiresAt)}',
                                      style: const TextStyle(
                                          color: muted, fontSize: 12)),
                                ])),
                          ))
                      .toList());
            }),
        const SizedBox(height: 30),
      ]);
}
