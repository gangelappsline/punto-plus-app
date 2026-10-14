class AppFailure implements Exception {
  const AppFailure(this.message);
  final String message;

  @override
  String toString() => message;
}

class ContractUnavailable extends AppFailure {
  const ContractUnavailable()
      : super('La conexión real requiere el contrato de la API. '
            'Por ahora utiliza el modo demo.');
}
