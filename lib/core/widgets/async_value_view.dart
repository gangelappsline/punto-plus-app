import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'feedback.dart';
import 'skeletons.dart';

/// Renderiza un `AsyncValue` con esqueleto, error y estado vacío.
///
/// Evita repetir el manejo de carga/error en cada pantalla y mantiene la
/// experiencia consistente (shimmer en lugar de spinners).
final class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    required this.value,
    required this.builder,
    this.loading,
    this.emptyBuilder,
    this.onRetry,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) builder;

  /// Esqueleto mostrado durante la carga (por defecto, una lista).
  final Widget? loading;

  /// Devuelve el widget a mostrar cuando el dato está vacío, o `null`.
  final Widget? Function(T data)? emptyBuilder;

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => value.when(
        skipLoadingOnRefresh: true,
        skipLoadingOnReload: true,
        loading: () => loading ?? const ListSkeleton(),
        error: (Object error, StackTrace stack) => ErrorStateView(
          message: error.toString(),
          onRetry: onRetry,
        ),
        data: (T data) => emptyBuilder?.call(data) ?? builder(data),
      );
}
