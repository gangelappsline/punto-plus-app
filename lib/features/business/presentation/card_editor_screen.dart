import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/presentation/theme.dart';
import '../../../core/presentation/widgets.dart';
import '../../demo/data/demo_seed.dart';
import '../../wallet/domain/loyalty_card.dart';
import '../../wallet/presentation/loyalty_card_tile.dart';

class CardEditorScreen extends ConsumerWidget {
  const CardEditorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => AsyncPanel(
        value: ref.watch(cardsProvider),
        onRetry: () => ref.invalidate(cardsProvider),
        builder: (snapshot) => _CardForm(
            card: snapshot.cards
                .firstWhere((card) => card.businessId == demoBusinessId)),
      );
}

class _CardForm extends ConsumerStatefulWidget {
  const _CardForm({required this.card});
  final LoyaltyCard card;
  @override
  ConsumerState<_CardForm> createState() => _CardFormState();
}

class _CardFormState extends ConsumerState<_CardForm> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _reward;
  late LoyaltyCard _draft;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _draft = widget.card;
    _reward = TextEditingController(text: widget.card.reward);
  }

  @override
  void dispose() {
    _reward.dispose();
    super.dispose();
  }

  Future<void> _pick(String type) async {
    setState(() => _busy = true);
    try {
      final path = await ref
          .read(mediaServiceProvider)
          .pickImage(fromFiles: type == 'stamp');
      if (path != null && mounted) {
        setState(() {
          _draft = switch (type) {
            'logo' => _draft.copyWith(logoPath: path),
            'background' => _draft.copyWith(backgroundPath: path),
            _ => _draft.copyWith(stampPath: path),
          };
        });
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
      await ref
          .read(actionsProvider)
          .saveCard(_draft.copyWith(reward: _reward.text.trim()));
      if (mounted) {
        showMessage(context, 'Diseño guardado en la demo.');
        context.go('/business');
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
  Widget build(BuildContext context) => Form(
      key: _form,
      child: ListView(padding: const EdgeInsets.all(24), children: [
        Row(children: [
          IconButton(
              onPressed: () => context.go('/business'),
              tooltip: 'Volver sin guardar',
              icon: const Icon(Icons.arrow_back_rounded)),
          Expanded(
              child: Text('Hazla tuya',
                  style: Theme.of(context).textTheme.headlineMedium)),
        ]),
        const SizedBox(height: 10),
        const Text('Una tarjeta con la personalidad de tu negocio.',
            style: TextStyle(color: muted)),
        const SizedBox(height: 24),
        LoyaltyCardTile(card: _draft, expanded: true),
        const SectionHeader('Tu recompensa'),
        TextFormField(
            controller: _reward,
            enabled: !_busy,
            maxLength: 120,
            decoration: const InputDecoration(
                labelText: '¿Qué se llevan tus clientes?'),
            onChanged: (value) =>
                setState(() => _draft = _draft.copyWith(reward: value)),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Escribe una recompensa.'
                : null),
        const SizedBox(height: 12),
        Row(children: [
          const Expanded(
              child: Text('Meta de sellos',
                  style: TextStyle(fontWeight: FontWeight.w600))),
          IconButton(
              onPressed: _busy || _draft.target <= 1
                  ? null
                  : () => setState(() =>
                      _draft = _draft.copyWith(target: _draft.target - 1)),
              tooltip: 'Un sello menos',
              icon: const Icon(Icons.remove_circle_outline)),
          Text('${_draft.target}',
              style: Theme.of(context).textTheme.titleLarge),
          IconButton(
              onPressed: _busy || _draft.target >= 20
                  ? null
                  : () => setState(() =>
                      _draft = _draft.copyWith(target: _draft.target + 1)),
              tooltip: 'Un sello más',
              icon: const Icon(Icons.add_circle_outline)),
        ]),
        const Text('De 1 a 20 sellos. Los sellos ya acumulados se conservan.',
            style: TextStyle(fontSize: 12, color: muted)),
        const SectionHeader('Color de la tarjeta'),
        Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              0xFFE5EDCA,
              0xFFF3DDCF,
              0xFFDBDFF2,
              0xFFF5E7AD,
              0xFFD5E9E8
            ]
                .map((color) => Semantics(
                      label: 'Color ${color.toRadixString(16)}',
                      selected: _draft.color == color,
                      child: InkWell(
                          onTap: _busy
                              ? null
                              : () => setState(
                                  () => _draft = _draft.copyWith(color: color)),
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                  color: Color(color),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: _draft.color == color
                                          ? ink
                                          : Colors.transparent,
                                      width: 2)),
                              child: _draft.color == color
                                  ? const Icon(Icons.check_rounded)
                                  : null)),
                    ))
                .toList()),
        const SectionHeader('Icono de sello'),
        Wrap(
            spacing: 8,
            children: ['coffee', 'bakery', 'wellness', 'star']
                .map((symbol) => ChoiceChip(
                      avatar: Icon(businessIcon(symbol), size: 20),
                      label: Text(switch (symbol) {
                        'coffee' => 'Café',
                        'bakery' => 'Pan',
                        'wellness' => 'Flor',
                        _ => 'Estrella'
                      }),
                      selected: _draft.symbol == symbol,
                      onSelected: _busy
                          ? null
                          : (_) => setState(() => _draft =
                              _draft.copyWith(symbol: symbol, stampPath: '')),
                    ))
                .toList()),
        const SectionHeader('Imágenes de tu marca'),
        const Text(
            'PNG o JPEG · máximo 5 MB · almacenadas solo en este dispositivo en modo demo.',
            style: TextStyle(fontSize: 12, color: muted)),
        const SizedBox(height: 12),
        ...['logo', 'background', 'stamp'].map((type) {
          final title = switch (type) {
            'logo' => 'Logo del negocio',
            'background' => 'Fondo de tarjeta',
            _ => 'Imagen de sello'
          };
          final path = switch (type) {
            'logo' => _draft.logoPath,
            'background' => _draft.backgroundPath,
            _ => _draft.stampPath
          };
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: SizedBox(
                width: 48,
                height: 48,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: MediaImage(path: path))),
            title: Text(title),
            subtitle: Text(path.isEmpty ? 'Sin imagen' : 'Imagen seleccionada'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              if (path.isNotEmpty)
                IconButton(
                    tooltip: 'Quitar $title',
                    onPressed: _busy
                        ? null
                        : () => setState(() {
                              _draft = switch (type) {
                                'logo' => _draft.copyWith(logoPath: ''),
                                'background' =>
                                  _draft.copyWith(backgroundPath: ''),
                                _ => _draft.copyWith(stampPath: ''),
                              };
                            }),
                    icon: const Icon(Icons.close_rounded)),
              IconButton(
                  tooltip: 'Elegir $title',
                  onPressed: _busy ? null : () => _pick(type),
                  icon: const Icon(Icons.upload_rounded)),
            ]),
          );
        }),
        const SizedBox(height: 24),
        FilledButton(
            onPressed: _busy || ref.watch(offlineProvider) ? null : _save,
            child: Text(_busy ? 'Guardando…' : 'Guardar diseño')),
        const SizedBox(height: 30),
      ]));
}
