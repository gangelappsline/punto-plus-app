import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../app/providers.dart';
import '../../../core/presentation/theme.dart';
import '../../../core/presentation/widgets.dart';
import '../../auth/domain/session.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _busy = false;

  Future<void> _notifications(bool enabled) async {
    setState(() => _busy = true);
    try {
      final allowed = !enabled ||
          await ref.read(notificationServiceProvider).requestPermission();
      await ref
          .read(preferencesProvider)
          .setBool('notifications', enabled && allowed);
      if (!allowed && mounted) {
        showMessage(context,
            'Puedes permitir notificaciones desde Ajustes del sistema.');
      }
    } on Object {
      if (mounted) {
        showMessage(context, 'No se pudieron activar las notificaciones.');
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _about() async {
    try {
      final package = await PackageInfo.fromPlatform();
      final device = await DeviceInfoPlugin().deviceInfo;
      if (!mounted) {
        return;
      }
      final platform = device is AndroidDeviceInfo
          ? 'Android ${device.version.release}'
          : device is IosDeviceInfo
              ? 'iOS ${device.systemVersion}'
              : 'Dispositivo de prueba';
      showAboutDialog(
          context: context,
          applicationName: 'Punto Plus',
          applicationVersion: '${package.version} (${package.buildNumber})',
          applicationIcon:
              const Icon(Icons.add_box_rounded, size: 40, color: ink),
          children: [
            Text(
                '$platform\nDemo local para explorar la experiencia de fidelidad.\n\nNo recopilamos ni enviamos estos metadatos en modo demo.')
          ]);
    } on Object {
      if (mounted) {
        showMessage(
            context, 'No se pudo consultar la información del dispositivo.');
      }
    }
  }

  Future<void> _reset() async {
    if (!await confirmAction(context,
            title: '¿Reiniciar la demo?',
            message:
                'Se eliminarán los cambios de tarjetas, promociones, imágenes y operaciones locales de ambos perfiles.',
            confirm: 'Reiniciar') ||
        !mounted) {
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(demoRepositoryProvider).reset();
      ref.invalidate(cardsProvider);
      ref.invalidate(promotionsProvider);
      await ref.read(mediaServiceProvider).clearDemoMedia();
      if (mounted) {
        showMessage(context, 'La demo está como nueva.');
      }
    } on Object catch (error) {
      if (mounted) {
        showMessage(context, friendlyError(error));
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final notifications =
        ref.read(preferencesProvider).getBool('notifications') ?? false;
    return ListView(padding: const EdgeInsets.all(24), children: [
      const SizedBox(height: 12),
      Text('Tu espacio.', style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: 24),
      SoftPanel(
          child: Row(children: [
        const CircleAvatar(
            radius: 30,
            backgroundColor: lime,
            child: Icon(Icons.person_outline_rounded, size: 30, color: ink)),
        const SizedBox(width: 18),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(session?.name ?? '',
              style: Theme.of(context).textTheme.titleLarge),
          Text(
              session?.role == UserRole.business
                  ? 'Negocio · cuenta demo'
                  : 'Cliente · cuenta demo',
              style: const TextStyle(color: muted)),
        ])),
      ])),
      const SectionHeader('A tu manera'),
      SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Notificaciones locales'),
          subtitle: const Text('Confirmación al canjear una recompensa'),
          value: notifications,
          onChanged: _busy ? null : _notifications),
      const Divider(),
      SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Simular modo offline'),
          subtitle: const Text('Consulta tarjetas; bloquea canjes y compras'),
          value: ref.watch(simulateOfflineProvider),
          onChanged: (value) =>
              ref.read(simulateOfflineProvider.notifier).state = value),
      const Divider(),
      ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.info_outline),
          title: const Text('Acerca de Punto Plus'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _about),
      ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.privacy_tip_outlined),
          title: const Text('Privacidad de la demo'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text('Tus datos, en tu dispositivo'),
                    content: const SingleChildScrollView(
                        child: Text(
                            'Las tarjetas, imágenes y promociones ficticias se guardan localmente. No hay autenticación real ni envío de compras al servidor.\n\nLa cámara solo lee QR; no guardamos video. La ubicación es opcional y se usa para calcular distancias. Google Maps y las rutas externas pueden usar los servicios de Google si los activas.\n\nReinicia la demo para borrar su contenido local. No uses datos personales reales en los formularios.')),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Entendido'))
                    ],
                  ))),
      const SectionHeader('Laboratorio demo'),
      OutlinedButton.icon(
          onPressed: _busy ? null : _reset,
          icon: const Icon(Icons.restart_alt_rounded),
          label: const Text('Reiniciar datos de prueba')),
      const SizedBox(height: 12),
      FilledButton.icon(
          onPressed: _busy
              ? null
              : () async {
                  setState(() => _busy = true);
                  try {
                    await ref.read(sessionProvider.notifier).signOut();
                  } on Object {
                    if (context.mounted) {
                      showMessage(context,
                          'Se cerró el perfil, pero no se pudo completar la limpieza local.');
                    }
                  } finally {
                    if (mounted) {
                      setState(() => _busy = false);
                    }
                  }
                },
          icon: const Icon(Icons.swap_horiz_rounded),
          label: const Text('Salir / cambiar de perfil')),
      const SizedBox(height: 28),
      const Text(
          'Hecho para los lugares a los que siempre quieres volver.\nPunto Plus · Demo 1.0',
          textAlign: TextAlign.center,
          style: TextStyle(color: muted, fontSize: 12, height: 1.7)),
    ]);
  }
}
