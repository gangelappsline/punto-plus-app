import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/providers.dart';
import '../../../core/presentation/theme.dart';
import '../../../core/presentation/widgets.dart';
import '../../demo/data/demo_seed.dart';
import '../domain/promotion.dart';

class PromotionsScreen extends ConsumerStatefulWidget {
  const PromotionsScreen({super.key});
  @override
  ConsumerState<PromotionsScreen> createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends ConsumerState<PromotionsScreen> {
  bool _deleting = false;

  Future<void> _delete(Promotion promotion) async {
    if (!await confirmAction(context,
            title: 'Eliminar promoción',
            message: 'Se eliminará “${promotion.title}” de la demo.',
            confirm: 'Eliminar') ||
        !mounted) {
      return;
    }
    setState(() => _deleting = true);
    try {
      await ref.read(actionsProvider).deletePromotion(promotion.id);
    } on Object catch (error) {
      if (mounted) {
        showMessage(context, friendlyError(error));
      }
    } finally {
      if (mounted) {
        setState(() => _deleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) =>
      ListView(padding: const EdgeInsets.all(24), children: [
        Row(children: [
          IconButton(
              onPressed: () => context.go('/business'),
              tooltip: 'Volver al negocio',
              icon: const Icon(Icons.arrow_back_rounded)),
          Expanded(
              child: Text('Promociones',
                  style: Theme.of(context).textTheme.headlineMedium)),
        ]),
        const SizedBox(height: 20),
        FilledButton.icon(
            onPressed: ref.watch(offlineProvider)
                ? null
                : () => showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      showDragHandle: true,
                      builder: (_) => const _PromotionForm(),
                    ),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Crear promoción')),
        const SizedBox(height: 24),
        AsyncPanel(
            value: ref.watch(promotionsProvider),
            onRetry: () => ref.invalidate(promotionsProvider),
            builder: (promotions) {
              final owned = promotions
                  .where((item) => item.businessId == demoBusinessId)
                  .toList();
              if (owned.isEmpty) {
                return const EmptyState(
                    icon: Icons.campaign_outlined,
                    title: 'Dales una razón más',
                    subtitle:
                        'Publica tu primera promoción. Los clientes demo la verán en Descubrir.');
              }
              return Column(
                  children: owned
                      .map((promotion) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: SoftPanel(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (promotion.imagePath.isNotEmpty) ...[
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: SizedBox(
                                        height: 170,
                                        width: double.infinity,
                                        child: MediaImage(
                                            path: promotion.imagePath))),
                                const SizedBox(height: 12),
                              ],
                              Text(promotion.title,
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              const SizedBox(height: 8),
                              Text(promotion.description),
                              const SizedBox(height: 10),
                              Text(
                                  '${promotion.expiresAt.isAfter(DateTime.now()) ? 'Vigente hasta' : 'Venció el'} ${DateFormat.yMMMd('es_MX').format(promotion.expiresAt)}',
                                  style: const TextStyle(
                                      color: muted, fontSize: 12)),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(
                                      onPressed: _deleting ||
                                              ref.watch(offlineProvider)
                                          ? null
                                          : () => _delete(promotion),
                                      icon: const Icon(Icons.delete_outline),
                                      label: const Text('Eliminar'))),
                            ],
                          ))))
                      .toList());
            }),
      ]);
}

class _PromotionForm extends ConsumerStatefulWidget {
  const _PromotionForm();
  @override
  ConsumerState<_PromotionForm> createState() => _PromotionFormState();
}

class _PromotionFormState extends ConsumerState<_PromotionForm> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _id = newOperationId();
  DateTime _expires = DateTime.now().add(const Duration(days: 7));
  String _image = '';
  bool _busy = false;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    setState(() => _busy = true);
    try {
      final path = await ref.read(mediaServiceProvider).pickImage();
      if (path != null && mounted) {
        setState(() => _image = path);
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

  Future<void> _save() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(actionsProvider).savePromotion(Promotion(
            id: _id,
            businessId: demoBusinessId,
            title: _title.text.trim(),
            description: _description.text.trim(),
            expiresAt: _expires,
            imagePath: _image,
          ));
      if (mounted) {
        showMessage(context, 'Promoción publicada en demo.');
        Navigator.pop(context);
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
  Widget build(BuildContext context) => SafeArea(
          child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
            24, 8, 24, MediaQuery.viewInsetsOf(context).bottom + 24),
        child: Form(
            key: _form,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Una buena noticia',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 20),
                  TextFormField(
                      controller: _title,
                      enabled: !_busy,
                      maxLength: 70,
                      decoration: const InputDecoration(labelText: 'Título'),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Agrega un título.'
                              : null),
                  const SizedBox(height: 12),
                  TextFormField(
                      controller: _description,
                      enabled: !_busy,
                      maxLength: 500,
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(
                          labelText: 'Detalles y condiciones'),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Describe la promoción.'
                              : null),
                  ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.event_outlined),
                      title: const Text('Vigencia'),
                      subtitle:
                          Text(DateFormat.yMMMd('es_MX').format(_expires)),
                      trailing: const Icon(Icons.edit_outlined),
                      onTap: _busy
                          ? null
                          : () async {
                              final now = DateTime.now();
                              final selected = await showDatePicker(
                                  context: context,
                                  initialDate: _expires,
                                  firstDate: now,
                                  lastDate: now.add(const Duration(days: 365)));
                              if (selected != null && mounted) {
                                setState(() => _expires = DateTime(
                                    selected.year,
                                    selected.month,
                                    selected.day,
                                    23,
                                    59,
                                    59));
                              }
                            }),
                  if (_image.isNotEmpty)
                    SizedBox(
                        height: 140,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: MediaImage(path: _image))),
                  OutlinedButton.icon(
                      onPressed: _busy ? null : _pick,
                      icon: const Icon(Icons.add_photo_alternate_outlined),
                      label: const Text('Elegir imagen (opcional)')),
                  const SizedBox(height: 20),
                  FilledButton(
                      onPressed:
                          _busy || ref.watch(offlineProvider) ? null : _save,
                      child: Text(_busy ? 'Guardando…' : 'Publicar en demo')),
                ])),
      ));
}
