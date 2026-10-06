/// Rutas de la API de Punto+ (Laravel + Passport).
///
/// `API_BASE_URL` debe incluir el prefijo `/api`, por ejemplo
/// `https://api.punto-plus.com.mx/api`.
abstract final class ApiPaths {
  // --- Autenticación -------------------------------------------------------
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refresh = '/auth/refresh';
  static const String verifyCode = '/auth/verify-code';
  static const String resendCode = '/auth/resend-code';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String google = '/auth/google';
  static const String apple = '/auth/apple';
  static const String user = '/user';

  /// Rutas que no requieren `Authorization`.
  static const Set<String> publicPaths = <String>{
    register,
    login,
    refresh,
    verifyCode,
    resendCode,
    forgotPassword,
    resetPassword,
    google,
    apple,
    terms,
    privacy,
  };

  // --- Cliente: tarjetas ---------------------------------------------------
  static const String customerCards = '/customer/cards';
  static const String customerCardsJoin = '/customer/cards/join';

  static String customerCard(String id) => '/customer/cards/$id';
  static String customerCardStamps(String id) => '/customer/cards/$id/stamps';
  static String customerCardRedeem(String id) => '/customer/cards/$id/redeem';
  static String customerCardQr(String id) => '/customer/cards/$id/qr';

  // --- Cliente: premios y promociones --------------------------------------
  static const String customerRewards = '/customer/rewards';
  static const String customerPromotions = '/customer/promotions';
  static const String customerReferral = '/customer/referral';
  static const String customerFavorites = '/customer/favorites';

  static String customerRewardRedeem(String id) => '/customer/rewards/$id/redeem';

  // --- Negocios (descubrimiento) ------------------------------------------
  static const String businessesNearby = '/businesses/nearby';

  static String business(String id) => '/businesses/$id';
  static String businessCards(String id) => '/businesses/$id/cards';
  static String businessPromotions(String id) => '/businesses/$id/promotions';

  // --- Perfil --------------------------------------------------------------
  static const String profile = '/profile';
  static const String profileAvatar = '/profile/avatar';
  static const String profilePassword = '/profile/password';
  static const String notifications = '/notifications';

  static String notificationRead(String id) => '/notifications/$id/read';

  // --- Legal ---------------------------------------------------------------
  static const String terms = '/legal/terms';
  static const String privacy = '/legal/privacy';

  // --- Modo negocio --------------------------------------------------------
  static const String businessDashboard = '/business/dashboard';
  static const String businessOwnCards = '/business/cards';
  static const String businessOwnPromotions = '/business/promotions';
  static const String businessCustomers = '/business/customers';
  static const String businessStampsScan = '/business/stamps/scan';
  static const String businessStampsRecent = '/business/stamps/recent';

  static String businessOwnCard(String id) => '/business/cards/$id';
  static String businessOwnCardAssets(String id) =>
      '/business/cards/$id/upload-assets';
  static String businessOwnPromotion(String id) => '/business/promotions/$id';
  static String businessCustomer(String id) => '/business/customers/$id';
}
