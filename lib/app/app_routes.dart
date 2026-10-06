/// Rutas de la aplicación (go_router).
abstract final class AppRoutes {
  // --- Entrada y autenticación --------------------------------------------
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyCode = '/verify-code';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  // --- Área del cliente (con navegación inferior) -------------------------
  static const String home = '/home/cards';
  static const String cards = '/home/cards';
  static const String map = '/home/map';
  static const String rewards = '/home/rewards';
  static const String promotions = '/home/promotions';
  static const String profile = '/home/profile';

  static const String cardDetail = '/cards/:id';
  static const String cardQr = '/cards/:id/qr';
  static const String rewardDetail = '/rewards/:id';
  static const String businessDetail = '/businesses/:id';
  static const String editProfile = '/profile/edit';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String referral = '/referral';
  static const String search = '/search';
  static const String favorites = '/favorites';
  static const String help = '/help';

  // --- Legal ---------------------------------------------------------------
  static const String terms = '/legal/terms';
  static const String privacy = '/legal/privacy';
  static const String about = '/about';

  // --- Modo negocio -------------------------------------------------------
  static const String businessDashboard = '/business';
  static const String businessCards = '/business/cards';
  static const String businessCardForm = '/business/cards/form';
  static const String businessScan = '/business/scan';
  static const String businessPromotions = '/business/promotions';
  static const String businessCustomers = '/business/customers';
  static const String businessCustomerDetail = '/business/customers/:id';

  // --- Errores -------------------------------------------------------------
  static const String noConnection = '/no-connection';
  static const String maintenance = '/maintenance';
  static const String forbidden = '/forbidden';
  static const String notFound = '/not-found';

  /// Construye la ruta de detalle de una tarjeta.
  static String cardDetailPath(String id) => '/cards/$id';

  /// Construye la ruta del código QR de una tarjeta.
  static String cardQrPath(String id) => '/cards/$id/qr';

  /// Construye la ruta de detalle de un premio.
  static String rewardDetailPath(String id) => '/rewards/$id';

  /// Construye la ruta de detalle de un negocio.
  static String businessDetailPath(String id) => '/businesses/$id';

  /// Construye la ruta de edición de una tarjeta del negocio.
  static String businessCardFormPath({String? id}) =>
      id == null ? businessCardForm : '$businessCardForm?id=$id';

  static String businessCustomerPath(String id) => '/business/customers/$id';

  /// Rutas accesibles sin sesión iniciada.
  static const Set<String> publicRoutes = <String>{
    splash,
    onboarding,
    welcome,
    login,
    register,
    verifyCode,
    forgotPassword,
    resetPassword,
    terms,
    privacy,
    about,
    maintenance,
    noConnection,
    forbidden,
    notFound,
  };

  /// Rutas exclusivas del modo negocio.
  static const Set<String> businessRoutes = <String>{
    businessDashboard,
    businessCards,
    businessCardForm,
    businessScan,
    businessPromotions,
    businessCustomers,
    businessCustomerDetail,
  };
}
