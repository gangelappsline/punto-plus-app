import '../../../core/network/app_failure.dart';

/// Local demo protocol, NOT the Punto Plus API's QR format.
class DemoQr {
  const DemoQr({required this.memberId, required this.cardId});
  final String memberId;
  final String cardId;

  String encode() => Uri(
        scheme: 'puntoplus-demo',
        host: 'stamp',
        queryParameters: {'v': '1', 'member': memberId, 'card': cardId},
      ).toString();

  static DemoQr parse(String value) {
    if (value.length > 2048) {
      throw const AppFailure('QR demasiado largo.');
    }
    final uri = Uri.tryParse(value.trim());
    if (uri == null ||
        uri.scheme != 'puntoplus-demo' ||
        uri.host != 'stamp' ||
        uri.path.isNotEmpty ||
        uri.fragment.isNotEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.hasPort ||
        uri.queryParameters['v'] != '1' ||
        uri.queryParametersAll.length != 3 ||
        uri.queryParametersAll.values.any((values) => values.length != 1) ||
        (uri.queryParameters['member'] ?? '').isEmpty ||
        (uri.queryParameters['card'] ?? '').isEmpty) {
      throw const AppFailure('Este no es un QR de la demo de Punto Plus.');
    }
    return DemoQr(
      memberId: uri.queryParameters['member']!,
      cardId: uri.queryParameters['card']!,
    );
  }
}
