import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/app_failure.dart';
import 'theme.dart';

IconData businessIcon(String symbol) => switch (symbol) {
      'bakery' => Icons.bakery_dining_outlined,
      'wellness' => Icons.spa_outlined,
      'star' => Icons.star_outline_rounded,
      _ => Icons.coffee_outlined,
    };

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
}

String friendlyError(Object error) =>
    error is AppFailure ? error.message : 'Algo salió mal. Inténtalo de nuevo.';

class AsyncPanel<T> extends StatelessWidget {
  const AsyncPanel(
      {required this.value, required this.builder, this.onRetry, super.key});
  final AsyncValue<T> value;
  final Widget Function(T) builder;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => value.when(
        data: builder,
        loading: () => const Padding(
          padding: EdgeInsets.all(60),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (error, _) => EmptyState(
          icon: Icons.cloud_off_outlined,
          title: 'No pudimos cargar los datos',
          subtitle: friendlyError(error),
          action: onRetry == null
              ? null
              : OutlinedButton(
                  onPressed: onRetry, child: const Text('Reintentar')),
        ),
      );
}

class EmptyState extends StatelessWidget {
  const EmptyState(
      {required this.icon,
      required this.title,
      required this.subtitle,
      this.action,
      super.key});
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 48, color: muted),
          const SizedBox(height: 16),
          Text(title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(subtitle, textAlign: TextAlign.center),
          if (action != null) ...[const SizedBox(height: 20), action!],
        ]),
      );
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {this.trailing, super.key});
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 14),
        child: Row(children: [
          Expanded(
              child:
                  Text(title, style: Theme.of(context).textTheme.titleLarge)),
          if (trailing != null) trailing!,
        ]),
      );
}

class SoftPanel extends StatelessWidget {
  const SoftPanel({required this.child, this.color = Colors.white, super.key});
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(24)),
        child: child,
      );
}

class Brand extends StatelessWidget {
  const Brand({this.large = false, super.key});
  final bool large;

  @override
  Widget build(BuildContext context) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: large ? 44 : 32,
          height: large ? 44 : 32,
          decoration: BoxDecoration(
              color: ink, borderRadius: BorderRadius.circular(12)),
          child: Icon(Icons.add_rounded, color: lime, size: large ? 34 : 26),
        ),
        const SizedBox(width: 9),
        Text('punto',
            style: TextStyle(
                fontSize: large ? 30 : 23,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.2)),
        Text('plus',
            style: TextStyle(
                fontSize: large ? 30 : 23,
                fontWeight: FontWeight.w400,
                letterSpacing: -1.2)),
      ]);
}

class MediaImage extends StatelessWidget {
  const MediaImage({required this.path, this.fit = BoxFit.cover, super.key});
  final String path;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
        color: lime.withValues(alpha: 0.3),
        child: const Center(child: Icon(Icons.image_outlined)));
    if (path.isEmpty) {
      return fallback;
    }
    final uri = Uri.tryParse(path);
    if (uri?.scheme == 'https') {
      return CachedNetworkImage(
        imageUrl: path,
        fit: fit,
        placeholder: (_, __) => fallback,
        errorWidget: (_, __, ___) => fallback,
      );
    }
    if (uri?.hasScheme ?? false) {
      return fallback;
    }
    return Image.file(File(path),
        fit: fit, errorBuilder: (_, __, ___) => fallback);
  }
}

Future<bool> confirmAction(
  BuildContext context, {
  required String title,
  required String message,
  required String confirm,
}) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(confirm)),
        ],
      ),
    ) ??
    false;
