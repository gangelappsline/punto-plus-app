// GENERATED CODE - DO NOT MODIFY BY HAND.
//
// Fuente: l10n/strings.json
// Regenerar con: python3 tool/generate_l10n.py

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Textos de la aplicación en español (predeterminado) e inglés.
abstract class AppLocalizations {
  const AppLocalizations();

  static const List<Locale> supportedLocales = <Locale>[
    Locale('es'),
    Locale('en'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    final AppLocalizations? localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    if (localizations != null) return localizations;
    return const AppLocalizationsEs();
  }

  static AppLocalizations forLocale(Locale locale) =>
      locale.languageCode == 'en' ? const AppLocalizationsEn() : const AppLocalizationsEs();

  /// Locale que representa esta instancia.
  Locale get locale;

  /// Busca `key` en el catálogo y reemplaza los marcadores de `args`.
  String translate(String key, [Map<String, String>? args]);

  String get appName;
  String get appTagline;
  String get authAcceptPrivacy;
  String get authAcceptPrivacyPrefix;
  String get authAcceptTerms;
  String get authAcceptTermsPrefix;
  String get authAccountPendingVerification;
  String get authBackToLogin;
  String get authEmailHint;
  String get authEmailLabel;
  String get authForgotAction;
  String get authForgotPassword;
  String get authForgotSubtitle;
  String get authForgotSuccess;
  String get authForgotTitle;
  String get authHidePassword;
  String get authLoginAction;
  String get authLoginSubtitle;
  String get authLoginTitle;
  String get authLogout;
  String get authLogoutConfirmMessage;
  String get authLogoutConfirmTitle;
  String get authNameHint;
  String get authNameLabel;
  String get authOtpLabel;
  String get authPasswordHint;
  String get authPasswordLabel;
  String get authPhoneHint;
  String get authPhoneLabel;
  String get authRegisterAction;
  String get authRegisterSubtitle;
  String get authRegisterTitle;
  String get authRememberMe;
  String get authResetAction;
  String get authResetCodeLabel;
  String get authResetConfirmPasswordLabel;
  String get authResetNewPasswordLabel;
  String get authResetSubtitle;
  String get authResetSuccess;
  String get authResetTitle;
  String get authRoleBusiness;
  String get authRoleBusinessDescription;
  String get authRoleCustomer;
  String get authRoleCustomerDescription;
  String get authRoleLabel;
  String get authSessionExpired;
  String get authShowPassword;
  String get authSocialApple;
  String get authSocialDivider;
  String get authSocialGoogle;
  String authSocialNotConfigured(Object provider);
  String authSocialSetupMessage(Object provider);
  String get authVerifyAction;
  String get authVerifyChangeDestination;
  String get authVerifyInvalid;
  String get authVerifyResendAction;
  String authVerifyResendIn(Object seconds);
  String get authVerifyResendSuccess;
  String authVerifySubtitle(Object destination);
  String get authVerifySuccess;
  String get authVerifyTitle;
  String get authWelcomeBenefit1;
  String get authWelcomeBenefit2;
  String get authWelcomeBenefit3;
  String get authWelcomeLogin;
  String get authWelcomeRegister;
  String get authWelcomeSubtitle;
  String get authWelcomeTitle;
  String get businessAboutTitle;
  String get businessAddress;
  String get businessCallAction;
  String get businessCardsTitle;
  String get businessClosedNow;
  String get businessDirectionsAction;
  String get businessDirectionsHint;
  String businessDistanceLabel(Object distance);
  String get businessError;
  String get businessFavoriteAdd;
  String get businessFavoriteRemove;
  String get businessGallery;
  String get businessGalleryTitle;
  String get businessHours;
  String get businessJoinAction;
  String get businessJoined;
  String get businessNotFoundMessage;
  String get businessNotFoundTitle;
  String get businessOpenNow;
  String get businessPhone;
  String get businessPromotionsTitle;
  String get businessScheduleUnavailable;
  String get businessShareAction;
  String get cardsCompletedBadge;
  String cardsCompletedOn(Object date);
  String get cardsDetailError;
  String get cardsDetailTitle;
  String get cardsEmptyMessage;
  String get cardsEmptyTitle;
  String cardsExpiresOn(Object date);
  String get cardsHistoryEmpty;
  String get cardsHistoryTitle;
  String get cardsInactive;
  String get cardsJoinAction;
  String get cardsJoinAlreadyMember;
  String get cardsJoinCodeHint;
  String get cardsJoinCodeLabel;
  String get cardsJoinCodeRequired;
  String get cardsJoinError;
  String get cardsJoinHelp;
  String cardsJoinSuccess(Object business);
  String get cardsJoinTitle;
  String cardsProgress(Object current, Object total);
  String get cardsReadyBadge;
  String cardsRemaining(Object count);
  String get cardsRewardLabel;
  String cardsRulesMessage(Object stamps);
  String get cardsRulesTitle;
  String get cardsShowQrAction;
  String cardsStampAddedAt(Object date);
  String get cardsStampsTitle;
  String get cardsSubtitle;
  String get cardsTitle;
  String get commonAccept;
  String get commonAll;
  String get commonApply;
  String get commonBack;
  String get commonCancel;
  String get commonClear;
  String get commonClose;
  String get commonComingSoon;
  String get commonContinueAction;
  String get commonCopied;
  String get commonCopy;
  String get commonDelete;
  String get commonEdit;
  String get commonEmptyGenericMessage;
  String get commonEmptyGenericTitle;
  String get commonErrorGenericMessage;
  String get commonErrorGenericTitle;
  String get commonFilters;
  String commonKmAway(Object distance);
  String get commonListView;
  String get commonLoading;
  String get commonMapView;
  String get commonNewBadge;
  String get commonNo;
  String get commonOfflineBanner;
  String get commonOk;
  String get commonOptional;
  String commonPointsCount(Object count);
  String get commonRequiredIndicator;
  String get commonRetry;
  String get commonSave;
  String get commonSaving;
  String get commonSearch;
  String get commonSeeAll;
  String get commonSeeDetail;
  String get commonShare;
  String commonStampsCount(Object count);
  String get commonTabHome;
  String get commonTabMap;
  String get commonTabProfile;
  String get commonTabPromotions;
  String get commonTabRewards;
  String get commonYes;
  String get errorsCancelled;
  String get errorsConnection;
  String get errorsForbidden;
  String get errorsForbiddenMessage;
  String get errorsForbiddenTitle;
  String get errorsMaintenanceMessage;
  String get errorsMaintenanceTitle;
  String get errorsNoConnectionAction;
  String get errorsNoConnectionMessage;
  String get errorsNoConnectionTitle;
  String get errorsNotFound;
  String get errorsNotFoundAction;
  String get errorsNotFoundMessage;
  String get errorsNotFoundTitle;
  String get errorsRateLimited;
  String get errorsRequestFailed;
  String get errorsSecureConnection;
  String get errorsServer;
  String get errorsTimeout;
  String get errorsUnauthorized;
  String get errorsUnauthorizedMessage;
  String get errorsUnauthorizedTitle;
  String get errorsUnexpected;
  String get errorsValidationFailed;
  String get helpContactMessage;
  String get helpContactTitle;
  String get helpEmailAction;
  String get helpFaq1Answer;
  String get helpFaq1Question;
  String get helpFaq2Answer;
  String get helpFaq2Question;
  String get helpFaq3Answer;
  String get helpFaq3Question;
  String get helpFaq4Answer;
  String get helpFaq4Question;
  String get helpFaq5Answer;
  String get helpFaq5Question;
  String get helpFaqTitle;
  String get helpSubtitle;
  String get helpTitle;
  String get homeCompletedBanner;
  String get homeCompletedBannerMessage;
  String homeGreeting(Object name);
  String get homeGreetingNoName;
  String get homeMyCardsTitle;
  String get homeNearbyTitle;
  String get homeNoCardsMessage;
  String get homeNoCardsTitle;
  String get homePointsCardSubtitle;
  String get homePointsCardTitle;
  String get homePromotionsTitle;
  String get homeQuickJoinCard;
  String get homeQuickJoinCardHint;
  String get homeQuickNearby;
  String get homeQuickPromotions;
  String get homeQuickReferral;
  String get homeQuickRewards;
  String get homeStatsCards;
  String get homeStatsCompleted;
  String get homeStatsStamps;
  String get homeSubtitle;
  String get legalAboutContact;
  String get legalAboutDescription;
  String get legalAboutLegal;
  String get legalAboutMadeFor;
  String get legalAboutTitle;
  String get legalAboutVersion;
  String get legalAboutWebsite;
  String get legalError;
  String get legalPrivacyTitle;
  String get legalTermsTitle;
  String legalUpdatedAt(Object date);
  String get manageCardsAssetsBackground;
  String get manageCardsAssetsError;
  String get manageCardsAssetsHint;
  String get manageCardsAssetsLogo;
  String get manageCardsAssetsStampIcon;
  String get manageCardsAssetsTitle;
  String get manageCardsAssetsUpload;
  String get manageCardsAssetsUploaded;
  String manageCardsCustomersCount(Object count);
  String get manageCardsDeleteConfirmMessage;
  String get manageCardsDeleteConfirmTitle;
  String get manageCardsDeleted;
  String get manageCardsEmptyMessage;
  String get manageCardsEmptyTitle;
  String get manageCardsError;
  String get manageCardsFieldActive;
  String get manageCardsFieldActiveSubtitle;
  String get manageCardsFieldColor;
  String get manageCardsFieldDescription;
  String get manageCardsFieldDescriptionHint;
  String get manageCardsFieldName;
  String get manageCardsFieldNameHint;
  String get manageCardsFieldRequiredStamps;
  String get manageCardsFieldReward;
  String get manageCardsFieldRewardHint;
  String get manageCardsFormCreateTitle;
  String get manageCardsFormEditTitle;
  String get manageCardsNewAction;
  String get manageCardsPreviewTitle;
  String get manageCardsSaveAction;
  String get manageCardsSaveError;
  String get manageCardsSaved;
  String get manageCardsStepBack;
  String get manageCardsStepBasics;
  String get manageCardsStepDesign;
  String get manageCardsStepNext;
  String get manageCardsStepReview;
  String get manageCardsStepReward;
  String get manageCardsSubtitle;
  String get manageCardsTitle;
  String manageCustomersCardProgress(Object card, Object current, Object total);
  String manageCustomersCardsCount(Object count);
  String manageCustomersCustomerSince(Object date);
  String get manageCustomersDetailTitle;
  String get manageCustomersEmptyMessage;
  String get manageCustomersEmptyTitle;
  String get manageCustomersError;
  String get manageCustomersErrorDetail;
  String manageCustomersLastVisit(Object date);
  String get manageCustomersSearchHint;
  String manageCustomersStampsTotal(Object count);
  String get manageCustomersSubtitle;
  String get manageCustomersTitle;
  String get manageDashboardChartEmpty;
  String get manageDashboardChartRangeMonth;
  String get manageDashboardChartRangeWeek;
  String get manageDashboardChartTitle;
  String get manageDashboardError;
  String manageDashboardGreeting(Object name);
  String get manageDashboardMetricActiveCards;
  String get manageDashboardMetricCustomers;
  String get manageDashboardMetricRedemptions;
  String get manageDashboardMetricStampsMonth;
  String get manageDashboardMetricStampsToday;
  String get manageDashboardQuickCards;
  String get manageDashboardQuickCustomers;
  String get manageDashboardQuickPromotions;
  String get manageDashboardQuickScan;
  String get manageDashboardRecentEmpty;
  String get manageDashboardRecentStampsTitle;
  String get manageDashboardSubtitle;
  String get manageDashboardTitle;
  String get manageDashboardTopCustomersTitle;
  String get managePromotionsDeleteConfirmMessage;
  String get managePromotionsDeleteConfirmTitle;
  String get managePromotionsDeleted;
  String get managePromotionsEmptyMessage;
  String get managePromotionsEmptyTitle;
  String get managePromotionsError;
  String get managePromotionsFieldActive;
  String get managePromotionsFieldDescription;
  String get managePromotionsFieldEndsAt;
  String get managePromotionsFieldStartsAt;
  String get managePromotionsFieldTitle;
  String get managePromotionsFieldTitleHint;
  String get managePromotionsFormCreateTitle;
  String get managePromotionsFormEditTitle;
  String get managePromotionsNewAction;
  String get managePromotionsPickDate;
  String get managePromotionsSaveAction;
  String get managePromotionsSaveError;
  String get managePromotionsSaved;
  String get managePromotionsStatusActive;
  String get managePromotionsStatusExpired;
  String get managePromotionsStatusPaused;
  String get managePromotionsStatusScheduled;
  String get managePromotionsSubtitle;
  String get managePromotionsTitle;
  String get manageScanCameraUnavailableMessage;
  String get manageScanCameraUnavailableTitle;
  String get manageScanCardLabel;
  String get manageScanCustomerLabel;
  String get manageScanDuplicate;
  String get manageScanError;
  String get manageScanInstruction;
  String get manageScanInvalidCode;
  String get manageScanManualAction;
  String get manageScanManualEntry;
  String get manageScanManualHint;
  String get manageScanProcessing;
  String get manageScanRecentEmpty;
  String get manageScanRecentTitle;
  String get manageScanRewardUnlocked;
  String get manageScanScanAgain;
  String get manageScanStampsLabel;
  String manageScanSuccessMessage(Object name, Object count, Object card);
  String get manageScanSuccessTitle;
  String get manageScanTitle;
  String mapBusinessesFound(Object count);
  String get mapCategories;
  String get mapCategoryAll;
  String get mapEmptyMessage;
  String get mapEmptyTitle;
  String get mapError;
  String get mapFavoritesOnly;
  String get mapLocationDeniedMessage;
  String get mapLocationDeniedTitle;
  String get mapManualLocation;
  String get mapManualLocationHint;
  String mapManualLocationSaved(Object area);
  String get mapMyLocation;
  String get mapOpenSettings;
  String get mapRadiusLabel;
  String mapRadiusValue(Object km);
  String get mapSearchHint;
  String get mapStaticViewHint;
  String get mapTitle;
  String get mapYouAreHere;
  String get notificationsEmptyMessage;
  String get notificationsEmptyTitle;
  String get notificationsError;
  String get notificationsMarkAllRead;
  String get notificationsMarkedRead;
  String get notificationsTitle;
  String get notificationsTypeGenericTitle;
  String notificationsTypePromotionBody(Object business, Object promotion);
  String get notificationsTypePromotionTitle;
  String notificationsTypeRewardBody(Object card);
  String get notificationsTypeRewardTitle;
  String notificationsTypeStampBody(Object business, Object count);
  String get notificationsTypeStampTitle;
  String get onboardingNext;
  String get onboardingSkip;
  String get onboardingSlide1Message;
  String get onboardingSlide1Title;
  String get onboardingSlide2Message;
  String get onboardingSlide2Title;
  String get onboardingSlide3Message;
  String get onboardingSlide3Title;
  String get onboardingSlide4Message;
  String get onboardingSlide4Title;
  String get onboardingStart;
  String get profileAboutAction;
  String get profileAvatarChange;
  String get profileAvatarError;
  String get profileAvatarHint;
  String get profileAvatarUploaded;
  String get profileBusinessModeAction;
  String get profileCardsCount;
  String get profileChangePasswordAction;
  String get profileChangePasswordConfirm;
  String get profileChangePasswordCurrent;
  String get profileChangePasswordNew;
  String get profileChangePasswordSuccess;
  String get profileChangePasswordTitle;
  String get profileDeleteAccountAction;
  String get profileDeleteAccountConfirm;
  String get profileDeleteAccountError;
  String get profileDeleteAccountMessage;
  String get profileDeleteAccountSuccess;
  String get profileDeleteAccountTitle;
  String get profileEditAction;
  String get profileEditError;
  String get profileEditSuccess;
  String get profileEditTitle;
  String get profileHelpAction;
  String get profileLegalAction;
  String profileMemberSince(Object date);
  String get profileNotificationsAction;
  String get profilePendingVerification;
  String get profilePoints;
  String get profileReferralAction;
  String get profileRewardCount;
  String get profileRoleAdmin;
  String get profileRoleBusiness;
  String get profileRoleCustomer;
  String get profileSettingsAction;
  String get profileStampsTotal;
  String get profileStatsTitle;
  String get profileSwitchToBusiness;
  String get profileSwitchToCustomer;
  String get profileTitle;
  String get profileVerified;
  String get profileVerifyAction;
  String get promotionsDetailTitle;
  String get promotionsEmptyMessage;
  String get promotionsEmptyTitle;
  String get promotionsError;
  String get promotionsExpired;
  String promotionsStartsOn(Object date);
  String get promotionsSubtitle;
  String get promotionsTerms;
  String get promotionsTitle;
  String promotionsValidUntil(Object date);
  String get qrBrightnessHint;
  String get qrBrightnessUnavailable;
  String get qrCameraUnavailable;
  String get qrCodeLabel;
  String get qrError;
  String get qrExpiredMessage;
  String get qrExpiredTitle;
  String qrExpiresAt(Object time);
  String qrExpiresIn(Object seconds);
  String get qrInstruction;
  String get qrRegenerateAction;
  String get qrShareCode;
  String qrSubtitle(Object business);
  String get qrTitle;
  String get referralCodeLabel;
  String get referralCompletedLabel;
  String get referralCopyAction;
  String get referralEmptyMessage;
  String get referralEmptyTitle;
  String get referralError;
  String get referralHowTitle;
  String referralInvitedCount(Object count);
  String get referralPendingLabel;
  String get referralShareAction;
  String referralShareMessage(Object code);
  String get referralStep1;
  String get referralStep2;
  String get referralStep3;
  String get referralSubtitle;
  String get referralTitle;
  String get rewardsCodeLabel;
  String get rewardsDetailTitle;
  String get rewardsEmptyAvailableMessage;
  String get rewardsEmptyAvailableTitle;
  String get rewardsEmptyExpiredMessage;
  String get rewardsEmptyExpiredTitle;
  String get rewardsEmptyRedeemedMessage;
  String get rewardsEmptyRedeemedTitle;
  String rewardsExpiresOn(Object date);
  String get rewardsRedeemAction;
  String get rewardsRedeemConfirmAction;
  String get rewardsRedeemConfirmMessage;
  String get rewardsRedeemConfirmTitle;
  String get rewardsRedeemError;
  String get rewardsRedeemSuccess;
  String rewardsRedeemedAt(Object date);
  String rewardsRequiresStamps(Object count);
  String get rewardsStatusAvailable;
  String get rewardsStatusExpired;
  String get rewardsStatusRedeemed;
  String get rewardsTabAvailable;
  String get rewardsTabExpired;
  String get rewardsTabRedeemed;
  String get rewardsTitle;
  String get settingsAppearanceTitle;
  String get settingsCacheClear;
  String get settingsCacheCleared;
  String get settingsCacheSubtitle;
  String get settingsDataTitle;
  String get settingsLanguageEn;
  String get settingsLanguageEs;
  String get settingsLanguageLabel;
  String get settingsLanguageSystem;
  String get settingsLocationAuto;
  String get settingsLocationAutoSubtitle;
  String get settingsLocationManual;
  String get settingsLocationManualHint;
  String get settingsLocationTitle;
  String get settingsNotificationsTitle;
  String get settingsNotifyGeneral;
  String get settingsNotifyPromotions;
  String get settingsNotifyPromotionsSubtitle;
  String get settingsNotifyRewards;
  String get settingsNotifyRewardsSubtitle;
  String get settingsNotifyStamps;
  String get settingsNotifyStampsSubtitle;
  String get settingsPreferencesSaved;
  String get settingsThemeDark;
  String get settingsThemeLabel;
  String get settingsThemeLight;
  String get settingsThemeSystem;
  String get settingsTitle;
  String settingsVersionLabel(Object version);
  String timeDaysAgo(Object days);
  String timeHoursAgo(Object hours);
  String get timeJustNow;
  String timeMinutesAgo(Object minutes);
  String get timeToday;
  String timeWeeksAgo(Object weeks);
  String get timeYesterday;
  String get validationCodeInvalid;
  String get validationDateOrder;
  String get validationEmailInvalid;
  String get validationEmailOrPhoneInvalid;
  String get validationNameShort;
  String validationNumberRange(Object min, Object max);
  String get validationNumericInvalid;
  String get validationOtpSixDigits;
  String get validationPasswordMismatch;
  String get validationPasswordShort;
  String get validationPhoneInvalid;
  String get validationRequired;
  String get validationTermsRequired;
  String validationTooLong(Object max);
  String get validationUrlInvalid;
}

final class AppLocalizationsEs extends AppLocalizations {
  const AppLocalizationsEs();

  static const Map<String, String> _strings = <String, String>{
    'app_name': 'Punto+',
    'app_tagline': 'Tus recompensas, siempre contigo',
    'auth_accept_privacy': 'política de privacidad',
    'auth_accept_privacy_prefix': 'y la',
    'auth_accept_terms': 'términos y condiciones',
    'auth_accept_terms_prefix': 'Acepto los',
    'auth_account_pending_verification': 'Verifica tu cuenta para continuar.',
    'auth_back_to_login': 'Volver al inicio de sesión',
    'auth_email_hint': 'tu@correo.com',
    'auth_email_label': 'Correo electrónico',
    'auth_forgot_action': 'Enviar código',
    'auth_forgot_password': '¿Olvidaste tu contraseña?',
    'auth_forgot_subtitle': 'Te enviaremos un código para restablecer tu contraseña.',
    'auth_forgot_success': 'Revisa tu correo: enviamos un código de recuperación.',
    'auth_forgot_title': 'Recupera tu acceso',
    'auth_hide_password': 'Ocultar contraseña',
    'auth_login_action': 'Continuar',
    'auth_login_subtitle': 'Ingresa con el correo o celular de tu cuenta.',
    'auth_login_title': 'Bienvenido de vuelta',
    'auth_logout': 'Cerrar sesión',
    'auth_logout_confirm_message': 'Tendrás que ingresar tus datos nuevamente.',
    'auth_logout_confirm_title': '¿Cerrar sesión?',
    'auth_name_hint': 'Ana Pérez',
    'auth_name_label': 'Nombre completo',
    'auth_otp_label': 'Código de verificación',
    'auth_password_hint': 'Mínimo 8 caracteres',
    'auth_password_label': 'Contraseña',
    'auth_phone_hint': '55 1234 5678',
    'auth_phone_label': 'Celular',
    'auth_register_action': 'Registrarme',
    'auth_register_subtitle': 'Elige tu tipo de cuenta para empezar.',
    'auth_register_title': 'Crea tu cuenta',
    'auth_remember_me': 'Recordarme',
    'auth_reset_action': 'Actualizar contraseña',
    'auth_reset_code_label': 'Código recibido',
    'auth_reset_confirm_password_label': 'Repite la contraseña',
    'auth_reset_new_password_label': 'Nueva contraseña',
    'auth_reset_subtitle': 'Ingresa el código recibido y elige una contraseña nueva.',
    'auth_reset_success': 'Tu contraseña se actualizó. Inicia sesión de nuevo.',
    'auth_reset_title': 'Nueva contraseña',
    'auth_role_business': 'Negocio',
    'auth_role_business_description': 'Escanea QR y gestiona tu programa',
    'auth_role_customer': 'Cliente',
    'auth_role_customer_description': 'Acumula sellos y canjea recompensas',
    'auth_role_label': 'Tipo de cuenta',
    'auth_session_expired': 'Tu sesión expiró. Ingresa de nuevo.',
    'auth_show_password': 'Mostrar contraseña',
    'auth_social_apple': 'Apple ID',
    'auth_social_divider': 'o continúa con',
    'auth_social_google': 'Google',
    'auth_social_not_configured': 'Configura las credenciales de {provider} para habilitar este acceso.',
    'auth_social_setup_message': 'Configura las credenciales de {provider} para habilitar este acceso.',
    'auth_verify_action': 'Verificar',
    'auth_verify_change_destination': 'Cambiar correo o celular',
    'auth_verify_invalid': 'El código es incorrecto o ya expiró.',
    'auth_verify_resend_action': 'Reenviar código',
    'auth_verify_resend_in': 'Reenviar en {seconds}s',
    'auth_verify_resend_success': 'Te enviamos un código nuevo.',
    'auth_verify_subtitle': 'Enviamos un código de 6 dígitos a {destination}.',
    'auth_verify_success': '¡Tu cuenta está verificada!',
    'auth_verify_title': 'Verifica tu cuenta',
    'auth_welcome_benefit_1': 'Todas tus tarjetas en un solo lugar',
    'auth_welcome_benefit_2': 'Promociones exclusivas de tus favoritos',
    'auth_welcome_benefit_3': 'Sin papeles, sin perder sellos',
    'auth_welcome_login': 'Iniciar sesión',
    'auth_welcome_register': 'Crear cuenta',
    'auth_welcome_subtitle': 'Tu billetera de recompensas para negocios locales.',
    'auth_welcome_title': 'Bienvenido a Punto+',
    'business_about_title': 'Acerca del negocio',
    'business_address': 'Dirección',
    'business_call_action': 'Llamar',
    'business_cards_title': 'Tarjetas disponibles',
    'business_closed_now': 'Cerrado',
    'business_directions_action': 'Cómo llegar',
    'business_directions_hint': 'Se abrirá la app de mapas con la ruta al negocio.',
    'business_distance_label': 'A {distance} km',
    'business_error': 'No pudimos cargar el negocio.',
    'business_favorite_add': 'Guardar en favoritos',
    'business_favorite_remove': 'Quitar de favoritos',
    'business_gallery': 'Galería',
    'business_gallery_title': 'Galería',
    'business_hours': 'Horario',
    'business_join_action': 'Unirme a esta tarjeta',
    'business_joined': 'Ya tienes esta tarjeta',
    'business_not_found_message': 'El negocio que buscas ya no está disponible.',
    'business_not_found_title': 'Negocio no encontrado',
    'business_open_now': 'Abierto ahora',
    'business_phone': 'Teléfono',
    'business_promotions_title': 'Promociones',
    'business_schedule_unavailable': 'Horario disponible en el negocio',
    'business_share_action': 'Compartir negocio',
    'cards_completed_badge': '¡Completa!',
    'cards_completed_on': 'Completada el {date}',
    'cards_detail_error': 'No pudimos cargar esta tarjeta.',
    'cards_detail_title': 'Detalle de la tarjeta',
    'cards_empty_message': 'Únete a tu primera tarjeta con el código del negocio.',
    'cards_empty_title': 'Sin tarjetas todavía',
    'cards_expires_on': 'Vence el {date}',
    'cards_history_empty': 'Todavía no registras sellos en esta tarjeta.',
    'cards_history_title': 'Historial de sellos',
    'cards_inactive': 'Tarjeta pausada',
    'cards_join_action': 'Unirme',
    'cards_join_already_member': 'Ya tienes esta tarjeta en tu lista.',
    'cards_join_code_hint': 'Ej. PP-5F3A9C o el contenido del QR',
    'cards_join_code_label': 'Código o QR del negocio',
    'cards_join_code_required': 'Ingresa el código del negocio.',
    'cards_join_error': 'No pudimos validar el código. Revísalo e inténtalo de nuevo.',
    'cards_join_help': 'Pide el código al personal del negocio o escanea su QR.',
    'cards_join_success': '¡Listo! Te uniste a {business}.',
    'cards_join_title': 'Unirme a una tarjeta',
    'cards_progress': '{current} de {total} sellos',
    'cards_ready_badge': 'Premio listo',
    'cards_remaining': 'Te faltan {count} sellos',
    'cards_reward_label': 'Recompensa',
    'cards_rules_message': 'Acumula {stamps} sellos mostrando tu QR en cada compra y canjea tu premio.',
    'cards_rules_title': 'Cómo funciona',
    'cards_show_qr_action': 'Mostrar mi QR',
    'cards_stamp_added_at': 'Sello del {date}',
    'cards_stamps_title': 'Tus sellos',
    'cards_subtitle': 'Toca una tarjeta para ver tus sellos y tu QR.',
    'cards_title': 'Mis tarjetas',
    'common_accept': 'Aceptar',
    'common_all': 'Todos',
    'common_apply': 'Aplicar',
    'common_back': 'Volver',
    'common_cancel': 'Cancelar',
    'common_clear': 'Limpiar',
    'common_close': 'Cerrar',
    'common_coming_soon': 'Muy pronto',
    'common_continue_action': 'Continuar',
    'common_copied': 'Copiado al portapapeles',
    'common_copy': 'Copiar',
    'common_delete': 'Eliminar',
    'common_edit': 'Editar',
    'common_empty_generic_message': 'Cuando haya información disponible la verás en esta pantalla.',
    'common_empty_generic_title': 'Nada por aquí',
    'common_error_generic_message': 'No pudimos completar la operación. Inténtalo de nuevo.',
    'common_error_generic_title': 'Algo salió mal',
    'common_filters': 'Filtros',
    'common_km_away': 'a {distance} km',
    'common_list_view': 'Lista',
    'common_loading': 'Cargando…',
    'common_map_view': 'Mapa',
    'common_new_badge': 'Nuevo',
    'common_no': 'No',
    'common_offline_banner': 'Sin conexión: mostrando datos guardados',
    'common_ok': 'Entendido',
    'common_optional': 'Opcional',
    'common_points_count': '{count} pts',
    'common_required_indicator': 'Obligatorio',
    'common_retry': 'Reintentar',
    'common_save': 'Guardar',
    'common_saving': 'Guardando…',
    'common_search': 'Buscar',
    'common_see_all': 'Ver todo',
    'common_see_detail': 'Ver detalle',
    'common_share': 'Compartir',
    'common_stamps_count': '{count} sellos',
    'common_tab_home': 'Inicio',
    'common_tab_map': 'Mapa',
    'common_tab_profile': 'Perfil',
    'common_tab_promotions': 'Promos',
    'common_tab_rewards': 'Premios',
    'common_yes': 'Sí',
    'errors_cancelled': 'La solicitud fue cancelada.',
    'errors_connection': 'No pudimos conectarnos. Revisa tu conexión a internet.',
    'errors_forbidden': 'Tu cuenta no tiene permisos para esta acción.',
    'errors_forbidden_message': 'Tu cuenta no tiene permisos para ver esta sección.',
    'errors_forbidden_title': 'Acceso restringido',
    'errors_maintenance_message': 'Volvemos en unos minutos. Gracias por tu paciencia.',
    'errors_maintenance_title': 'Estamos en mantenimiento',
    'errors_no_connection_action': 'Reintentar',
    'errors_no_connection_message': 'Revisa tu red e inténtalo de nuevo. Tus datos guardados siguen disponibles.',
    'errors_no_connection_title': 'Sin conexión',
    'errors_not_found': 'No encontramos la información.',
    'errors_not_found_action': 'Ir al inicio',
    'errors_not_found_message': 'La ruta que buscas no existe o cambió de lugar.',
    'errors_not_found_title': 'Pantalla no encontrada',
    'errors_rate_limited': 'Demasiados intentos. Espera un momento.',
    'errors_request_failed': 'No pudimos completar la solicitud.',
    'errors_secure_connection': 'No se pudo validar la conexión segura.',
    'errors_server': 'Tuvimos un problema en el servidor. Inténtalo más tarde.',
    'errors_timeout': 'La conexión tardó demasiado. Inténtalo de nuevo.',
    'errors_unauthorized': 'Tus datos de acceso no son correctos.',
    'errors_unauthorized_message': 'Ingresa de nuevo para continuar.',
    'errors_unauthorized_title': 'Sesión requerida',
    'errors_unexpected': 'Ocurrió un error inesperado. Inténtalo de nuevo.',
    'errors_validation_failed': 'Revisa los datos del formulario.',
    'help_contact_message': 'Escríbenos y te respondemos en menos de 24 horas hábiles.',
    'help_contact_title': '¿Necesitas más ayuda?',
    'help_email_action': 'Escribir a soporte',
    'help_faq_1_answer': 'Abre la tarjeta del negocio y muestra tu código QR en cada compra. El personal lo escanea y el sello aparece al instante.',
    'help_faq_1_question': '¿Cómo acumulo sellos?',
    'help_faq_2_answer': 'Los códigos duran pocos minutos por seguridad. Genera uno nuevo desde la pantalla del QR y muéstralo de nuevo.',
    'help_faq_2_question': '¿Qué pasa si mi código QR expira?',
    'help_faq_3_answer': 'Cuando completas los sellos, la recompensa aparece en la pestaña Premios. Ábrela, presiona canjear y muestra el código al negocio.',
    'help_faq_3_question': '¿Cómo canjeo una recompensa?',
    'help_faq_4_answer': 'Sí. Al crear la cuenta elige el tipo Negocio para escanear QR y administrar tus tarjetas y promociones.',
    'help_faq_4_question': '¿Puedo registrarme como negocio?',
    'help_faq_5_answer': 'Ve a Perfil > Editar perfil > Eliminar cuenta. Se borrarán tus datos de forma permanente.',
    'help_faq_5_question': '¿Cómo elimino mi cuenta?',
    'help_faq_title': 'Preguntas frecuentes',
    'help_subtitle': 'Respuestas rápidas y canales de soporte.',
    'help_title': 'Ayuda y contacto',
    'home_completed_banner': '¡Tienes premios listos!',
    'home_completed_banner_message': 'Completa una tarjeta y canjea tu recompensa cuando quieras.',
    'home_greeting': '¡Hola, {name}!',
    'home_greeting_no_name': '¡Hola!',
    'home_my_cards_title': 'Mis tarjetas',
    'home_nearby_title': 'Cerca de ti',
    'home_no_cards_message': 'Únete a una tarjeta con el código QR del negocio y empieza a acumular sellos.',
    'home_no_cards_title': 'Aún no tienes tarjetas',
    'home_points_card_subtitle': 'Canjeables en promociones participantes',
    'home_points_card_title': 'Puntos Punto+',
    'home_promotions_title': 'Promociones activas',
    'home_quick_join_card': 'Unirme a una tarjeta',
    'home_quick_join_card_hint': 'Escanea el QR del negocio o escribe el código',
    'home_quick_nearby': 'Negocios cerca',
    'home_quick_promotions': 'Promociones',
    'home_quick_referral': 'Invita y gana',
    'home_quick_rewards': 'Mis premios',
    'home_stats_cards': 'Tarjetas activas',
    'home_stats_completed': 'Completadas',
    'home_stats_stamps': 'Sellos totales',
    'home_subtitle': 'Este es el resumen de tus recompensas.',
    'legal_about_contact': 'Contacto',
    'legal_about_description': 'Punto+ es la billetera de recompensas para negocios locales: acumula sellos, descubre promociones y canjea premios reales desde tu celular.',
    'legal_about_legal': 'Legal',
    'legal_about_made_for': 'Hecho para negocios y clientes de México.',
    'legal_about_title': 'Acerca de Punto+',
    'legal_about_version': 'Versión',
    'legal_about_website': 'Sitio web',
    'legal_error': 'No pudimos cargar el documento.',
    'legal_privacy_title': 'Política de privacidad',
    'legal_terms_title': 'Términos y condiciones',
    'legal_updated_at': 'Última actualización: {date}',
    'manage_cards_assets_background': 'Imagen de fondo',
    'manage_cards_assets_error': 'No pudimos subir la imagen.',
    'manage_cards_assets_hint': 'PNG o JPG de hasta 2 MB. Requiere el selector de imágenes habilitado.',
    'manage_cards_assets_logo': 'Logo del negocio',
    'manage_cards_assets_stamp_icon': 'Icono del sello',
    'manage_cards_assets_title': 'Imágenes',
    'manage_cards_assets_upload': 'Subir imagen',
    'manage_cards_assets_uploaded': 'Imagen cargada.',
    'manage_cards_customers_count': '{count} clientes',
    'manage_cards_delete_confirm_message': 'Los clientes ya no podrán sumar sellos en esta tarjeta.',
    'manage_cards_delete_confirm_title': '¿Eliminar tarjeta?',
    'manage_cards_deleted': 'Tarjeta eliminada.',
    'manage_cards_empty_message': 'Crea tu primera tarjeta, define los sellos y la recompensa.',
    'manage_cards_empty_title': 'Aún no tienes tarjetas',
    'manage_cards_error': 'No pudimos cargar tus tarjetas.',
    'manage_cards_field_active': 'Tarjeta activa',
    'manage_cards_field_active_subtitle': 'Los clientes pueden unirse y sumar sellos',
    'manage_cards_field_color': 'Color de fondo',
    'manage_cards_field_description': 'Descripción',
    'manage_cards_field_description_hint': 'Explica a tus clientes cómo funciona',
    'manage_cards_field_name': 'Nombre de la tarjeta',
    'manage_cards_field_name_hint': 'Ej. Café de la casa',
    'manage_cards_field_required_stamps': 'Sellos necesarios',
    'manage_cards_field_reward': 'Recompensa',
    'manage_cards_field_reward_hint': 'Ej. Café gratis',
    'manage_cards_form_create_title': 'Nueva tarjeta',
    'manage_cards_form_edit_title': 'Editar tarjeta',
    'manage_cards_new_action': 'Nueva tarjeta',
    'manage_cards_preview_title': 'Vista previa',
    'manage_cards_save_action': 'Guardar tarjeta',
    'manage_cards_save_error': 'No pudimos guardar la tarjeta.',
    'manage_cards_saved': 'Tarjeta guardada.',
    'manage_cards_step_back': 'Atrás',
    'manage_cards_step_basics': 'Datos',
    'manage_cards_step_design': 'Diseño',
    'manage_cards_step_next': 'Siguiente',
    'manage_cards_step_review': 'Revisión',
    'manage_cards_step_reward': 'Recompensa',
    'manage_cards_subtitle': 'Diseña las tarjetas que verán tus clientes.',
    'manage_cards_title': 'Tarjetas de fidelidad',
    'manage_customers_card_progress': '{card}: {current}/{total}',
    'manage_customers_cards_count': '{count} tarjetas',
    'manage_customers_customer_since': 'Cliente desde {date}',
    'manage_customers_detail_title': 'Detalle del cliente',
    'manage_customers_empty_message': 'Cuando tus clientes escaneen su primer QR aparecerán aquí.',
    'manage_customers_empty_title': 'Sin clientes todavía',
    'manage_customers_error': 'No pudimos cargar tus clientes.',
    'manage_customers_error_detail': 'No pudimos cargar al cliente.',
    'manage_customers_last_visit': 'Última visita: {date}',
    'manage_customers_search_hint': 'Buscar por nombre o correo',
    'manage_customers_stamps_total': '{count} sellos acumulados',
    'manage_customers_subtitle': 'Personas que acumulan sellos en tus tarjetas.',
    'manage_customers_title': 'Clientes fieles',
    'manage_dashboard_chart_empty': 'Sin datos en este periodo',
    'manage_dashboard_chart_range_month': '30 días',
    'manage_dashboard_chart_range_week': '7 días',
    'manage_dashboard_chart_title': 'Sellos por día',
    'manage_dashboard_error': 'No pudimos cargar tus métricas.',
    'manage_dashboard_greeting': 'Hola, {name}',
    'manage_dashboard_metric_active_cards': 'Tarjetas activas',
    'manage_dashboard_metric_customers': 'Clientes fieles',
    'manage_dashboard_metric_redemptions': 'Premios canjeados',
    'manage_dashboard_metric_stamps_month': 'Sellos del mes',
    'manage_dashboard_metric_stamps_today': 'Sellos hoy',
    'manage_dashboard_quick_cards': 'Mis tarjetas',
    'manage_dashboard_quick_customers': 'Clientes',
    'manage_dashboard_quick_promotions': 'Promociones',
    'manage_dashboard_quick_scan': 'Escanear QR',
    'manage_dashboard_recent_empty': 'Sin sellos registrados hoy',
    'manage_dashboard_recent_stamps_title': 'Últimos sellos',
    'manage_dashboard_subtitle': 'Así va tu programa de fidelidad.',
    'manage_dashboard_title': 'Panel del negocio',
    'manage_dashboard_top_customers_title': 'Clientes destacados',
    'manage_promotions_delete_confirm_message': 'Dejará de mostrarse a los clientes.',
    'manage_promotions_delete_confirm_title': '¿Eliminar promoción?',
    'manage_promotions_deleted': 'Promoción eliminada.',
    'manage_promotions_empty_message': 'Crea una promoción para atraer más visitas.',
    'manage_promotions_empty_title': 'Sin promociones',
    'manage_promotions_error': 'No pudimos cargar tus promociones.',
    'manage_promotions_field_active': 'Promoción activa',
    'manage_promotions_field_description': 'Descripción',
    'manage_promotions_field_ends_at': 'Termina',
    'manage_promotions_field_starts_at': 'Inicia',
    'manage_promotions_field_title': 'Título',
    'manage_promotions_field_title_hint': '2x1 en bebidas',
    'manage_promotions_form_create_title': 'Nueva promoción',
    'manage_promotions_form_edit_title': 'Editar promoción',
    'manage_promotions_new_action': 'Nueva promoción',
    'manage_promotions_pick_date': 'Elegir fecha',
    'manage_promotions_save_action': 'Guardar promoción',
    'manage_promotions_save_error': 'No pudimos guardar la promoción.',
    'manage_promotions_saved': 'Promoción guardada.',
    'manage_promotions_status_active': 'Activa',
    'manage_promotions_status_expired': 'Vencida',
    'manage_promotions_status_paused': 'Pausada',
    'manage_promotions_status_scheduled': 'Programada',
    'manage_promotions_subtitle': 'Publica beneficios para tus clientes.',
    'manage_promotions_title': 'Promociones',
    'manage_scan_camera_unavailable_message': 'Este build no incluye el escáner. Usa el registro manual con el código del cliente.',
    'manage_scan_camera_unavailable_title': 'Cámara no disponible',
    'manage_scan_card_label': 'Tarjeta',
    'manage_scan_customer_label': 'Cliente',
    'manage_scan_duplicate': 'Ese código ya se registró en esta sesión.',
    'manage_scan_error': 'No pudimos registrar el sello.',
    'manage_scan_instruction': 'Apunta la cámara al código QR del cliente',
    'manage_scan_invalid_code': 'El código no es válido o ya expiró.',
    'manage_scan_manual_action': 'Registrar sello',
    'manage_scan_manual_entry': 'Registrar código manualmente',
    'manage_scan_manual_hint': 'Código del cliente',
    'manage_scan_processing': 'Registrando sello…',
    'manage_scan_recent_empty': 'Todavía no registras sellos hoy',
    'manage_scan_recent_title': 'Sellos recientes',
    'manage_scan_reward_unlocked': '¡La tarjeta se completó! Puede canjear su premio.',
    'manage_scan_scan_again': 'Escanear otro',
    'manage_scan_stamps_label': 'Sellos',
    'manage_scan_success_message': '{name} ahora tiene {count} sellos en {card}.',
    'manage_scan_success_title': '¡Sello registrado!',
    'manage_scan_title': 'Escanear QR',
    'map_businesses_found': '{count} negocios',
    'map_categories': 'Categorías',
    'map_category_all': 'Todos',
    'map_empty_message': 'Prueba con un radio mayor o mueve el mapa a otra zona.',
    'map_empty_title': 'Sin negocios en este radio',
    'map_error': 'No pudimos cargar los negocios cercanos.',
    'map_favorites_only': 'Solo favoritos',
    'map_location_denied_message': 'Puedes activar el permiso en los ajustes del sistema o elegir una zona manualmente.',
    'map_location_denied_title': 'Sin acceso a tu ubicación',
    'map_manual_location': 'Elegir zona',
    'map_manual_location_hint': 'Ciudad o colonia',
    'map_manual_location_saved': 'Usando la zona {area} como referencia.',
    'map_my_location': 'Mi ubicación',
    'map_open_settings': 'Abrir ajustes',
    'map_radius_label': 'Radio',
    'map_radius_value': '{km} km',
    'map_search_hint': 'Buscar negocio o categoría',
    'map_static_view_hint': 'Vista esquemática. Conecta Google Maps para el mapa completo.',
    'map_title': 'Mapa de negocios',
    'map_you_are_here': 'Estás aquí',
    'notifications_empty_message': 'Aquí verás tus sellos, premios y promociones.',
    'notifications_empty_title': 'Sin notificaciones',
    'notifications_error': 'No pudimos cargar las notificaciones.',
    'notifications_mark_all_read': 'Marcar todo como leído',
    'notifications_marked_read': 'Notificaciones marcadas como leídas.',
    'notifications_title': 'Notificaciones',
    'notifications_type_generic_title': 'Novedad en Punto+',
    'notifications_type_promotion_body': '{business} publicó: {promotion}',
    'notifications_type_promotion_title': 'Nueva promoción',
    'notifications_type_reward_body': 'Completaste {card}. Ya puedes canjear tu recompensa.',
    'notifications_type_reward_title': '¡Premio desbloqueado!',
    'notifications_type_stamp_body': '{business} sumó un sello a tu tarjeta ({count} en total).',
    'notifications_type_stamp_title': 'Sello registrado',
    'onboarding_next': 'Siguiente',
    'onboarding_skip': 'Omitir',
    'onboarding_slide_1_message': 'Muestra tu código QR en cada visita y suma sellos al instante.',
    'onboarding_slide_1_title': 'Acumula sellos sin tarjetas de papel',
    'onboarding_slide_2_message': 'Explora el mapa, encuentra promociones y guarda tus favoritos.',
    'onboarding_slide_2_title': 'Descubre negocios cerca de ti',
    'onboarding_slide_3_message': 'Al completar tu tarjeta desbloqueas premios que puedes canjear al momento.',
    'onboarding_slide_3_title': 'Canjea recompensas reales',
    'onboarding_slide_4_message': 'Escanea QR, crea tarjetas a tu medida y revisa tus métricas.',
    'onboarding_slide_4_title': 'Para negocios, todo en un panel',
    'onboarding_start': 'Comenzar',
    'profile_about_action': 'Acerca de Punto+',
    'profile_avatar_change': 'Cambiar foto',
    'profile_avatar_error': 'No pudimos subir la foto.',
    'profile_avatar_hint': 'Usa una foto cuadrada de al menos 400x400 px.',
    'profile_avatar_uploaded': 'Foto actualizada.',
    'profile_business_mode_action': 'Modo negocio',
    'profile_cards_count': 'Tarjetas',
    'profile_change_password_action': 'Actualizar contraseña',
    'profile_change_password_confirm': 'Repite la contraseña nueva',
    'profile_change_password_current': 'Contraseña actual',
    'profile_change_password_new': 'Contraseña nueva',
    'profile_change_password_success': 'Contraseña actualizada.',
    'profile_change_password_title': 'Cambiar contraseña',
    'profile_delete_account_action': 'Eliminar mi cuenta',
    'profile_delete_account_confirm': 'Sí, eliminar',
    'profile_delete_account_error': 'No pudimos eliminar la cuenta.',
    'profile_delete_account_message': 'Se borrarán tus tarjetas, sellos y premios. Esta acción no se puede deshacer.',
    'profile_delete_account_success': 'Tu cuenta fue eliminada.',
    'profile_delete_account_title': 'Eliminar cuenta',
    'profile_edit_action': 'Editar perfil',
    'profile_edit_error': 'No pudimos guardar los cambios.',
    'profile_edit_success': 'Perfil actualizado.',
    'profile_edit_title': 'Editar perfil',
    'profile_help_action': 'Ayuda y contacto',
    'profile_legal_action': 'Términos y privacidad',
    'profile_member_since': 'Miembro desde {date}',
    'profile_notifications_action': 'Notificaciones',
    'profile_pending_verification': 'Verificación pendiente',
    'profile_points': 'Puntos',
    'profile_referral_action': 'Invita a tus amigos',
    'profile_reward_count': 'Premios',
    'profile_role_admin': 'Administrador',
    'profile_role_business': 'Negocio',
    'profile_role_customer': 'Cliente',
    'profile_settings_action': 'Ajustes',
    'profile_stamps_total': 'Sellos',
    'profile_stats_title': 'Tu actividad',
    'profile_switch_to_business': 'Cambiar a modo negocio',
    'profile_switch_to_customer': 'Volver a modo cliente',
    'profile_title': 'Mi perfil',
    'profile_verified': 'Cuenta verificada',
    'profile_verify_action': 'Verificar ahora',
    'promotions_detail_title': 'Detalle de la promoción',
    'promotions_empty_message': 'Cuando tus negocios favoritos publiquen promociones las verás aquí.',
    'promotions_empty_title': 'Sin promociones activas',
    'promotions_error': 'No pudimos cargar las promociones.',
    'promotions_expired': 'Promoción vencida',
    'promotions_starts_on': 'Desde {date}',
    'promotions_subtitle': 'Beneficios activos de los negocios que sigues.',
    'promotions_terms': 'Consulta términos en el negocio',
    'promotions_title': 'Promociones',
    'promotions_valid_until': 'Válida hasta {date}',
    'qr_brightness_hint': 'Aumentamos el brillo de tu pantalla al máximo.',
    'qr_brightness_unavailable': 'Sube el brillo de tu pantalla para un escaneo más rápido.',
    'qr_camera_unavailable': 'El escaneo con cámara requiere el plugin de escaneo.',
    'qr_code_label': 'Código manual',
    'qr_error': 'No pudimos generar tu código. Inténtalo de nuevo.',
    'qr_expired_message': 'Genera uno nuevo para seguir acumulando.',
    'qr_expired_title': 'Tu código expiró',
    'qr_expires_at': 'Válido hasta {time}',
    'qr_expires_in': 'Vence en {seconds}s',
    'qr_instruction': 'Pide al personal que escanee este código',
    'qr_regenerate_action': 'Generar nuevo código',
    'qr_share_code': 'Compartir código',
    'qr_subtitle': 'Muéstralo en {business} para sumar un sello.',
    'qr_title': 'Tu código QR',
    'referral_code_label': 'Tu código',
    'referral_completed_label': 'Completados',
    'referral_copy_action': 'Copiar código',
    'referral_empty_message': 'Comparte tu código y empieza a ganar puntos extra.',
    'referral_empty_title': 'Aún no invitas a nadie',
    'referral_error': 'No pudimos cargar tus referidos.',
    'referral_how_title': '¿Cómo funciona?',
    'referral_invited_count': '{count} invitados',
    'referral_pending_label': 'Pendientes',
    'referral_share_action': 'Compartir invitación',
    'referral_share_message': '¡Únete a Punto+ con mi código {code} y empieza a acumular recompensas!',
    'referral_step_1': 'Comparte tu código con quien quieras invitar.',
    'referral_step_2': 'Tu invitado se registra y suma su primer sello.',
    'referral_step_3': 'Ambos reciben puntos en su cuenta.',
    'referral_subtitle': 'Comparte tu código: tú y tu invitado reciben puntos al primer sello.',
    'referral_title': 'Invita y gana',
    'rewards_code_label': 'Código de canje',
    'rewards_detail_title': 'Detalle del premio',
    'rewards_empty_available_message': 'Completa una tarjeta para desbloquear tu primer premio.',
    'rewards_empty_available_title': 'Aún no tienes premios',
    'rewards_empty_expired_message': 'Los premios vencidos aparecerán en esta pestaña.',
    'rewards_empty_expired_title': 'Nada por expirar',
    'rewards_empty_redeemed_message': 'Cuando canjees un premio verás aquí el historial.',
    'rewards_empty_redeemed_title': 'Sin canjes todavía',
    'rewards_expires_on': 'Vence el {date}',
    'rewards_redeem_action': 'Canjear premio',
    'rewards_redeem_confirm_action': 'Sí, canjear',
    'rewards_redeem_confirm_message': 'Muestra el código de canje al personal del negocio para confirmarlo.',
    'rewards_redeem_confirm_title': '¿Canjear este premio?',
    'rewards_redeem_error': 'No pudimos canjear el premio.',
    'rewards_redeem_success': '¡Premio canjeado! Muestra el código al negocio.',
    'rewards_redeemed_at': 'Canjeado el {date}',
    'rewards_requires_stamps': 'Requiere completar {count} sellos',
    'rewards_status_available': 'Disponible',
    'rewards_status_expired': 'Expirado',
    'rewards_status_redeemed': 'Canjeado',
    'rewards_tab_available': 'Disponibles',
    'rewards_tab_expired': 'Expirados',
    'rewards_tab_redeemed': 'Canjeados',
    'rewards_title': 'Mis premios',
    'settings_appearance_title': 'Apariencia',
    'settings_cache_clear': 'Borrar datos guardados',
    'settings_cache_cleared': 'Datos guardados eliminados.',
    'settings_cache_subtitle': 'Se volverán a descargar tus tarjetas al abrir la app',
    'settings_data_title': 'Datos',
    'settings_language_en': 'Inglés',
    'settings_language_es': 'Español',
    'settings_language_label': 'Idioma',
    'settings_language_system': 'Del sistema',
    'settings_location_auto': 'Usar mi ubicación',
    'settings_location_auto_subtitle': 'Recomendaciones de negocios cercanos',
    'settings_location_manual': 'Zona de referencia',
    'settings_location_manual_hint': 'Ciudad o colonia',
    'settings_location_title': 'Ubicación',
    'settings_notifications_title': 'Notificaciones',
    'settings_notify_general': 'Avisos generales',
    'settings_notify_promotions': 'Promociones',
    'settings_notify_promotions_subtitle': 'Novedades de tus negocios favoritos',
    'settings_notify_rewards': 'Premios disponibles',
    'settings_notify_rewards_subtitle': 'Cuando completas una tarjeta',
    'settings_notify_stamps': 'Sellos nuevos',
    'settings_notify_stamps_subtitle': 'Avisos cuando sumas un sello',
    'settings_preferences_saved': 'Preferencias guardadas.',
    'settings_theme_dark': 'Oscuro',
    'settings_theme_label': 'Tema',
    'settings_theme_light': 'Claro',
    'settings_theme_system': 'Del sistema',
    'settings_title': 'Ajustes',
    'settings_version_label': 'Versión {version}',
    'time_days_ago': 'Hace {days} días',
    'time_hours_ago': 'Hace {hours} h',
    'time_just_now': 'Hace un momento',
    'time_minutes_ago': 'Hace {minutes} min',
    'time_today': 'Hoy',
    'time_weeks_ago': 'Hace {weeks} semanas',
    'time_yesterday': 'Ayer',
    'validation_code_invalid': 'Código no válido',
    'validation_date_order': 'La fecha final debe ser posterior a la inicial',
    'validation_email_invalid': 'Correo no válido',
    'validation_email_or_phone_invalid': 'Ingresa un correo o celular válido',
    'validation_name_short': 'Escribe tu nombre completo',
    'validation_number_range': 'Ingresa un valor entre {min} y {max}',
    'validation_numeric_invalid': 'Ingresa solo números',
    'validation_otp_six_digits': 'Ingresa los 6 dígitos',
    'validation_password_mismatch': 'Las contraseñas no coinciden',
    'validation_password_short': 'Usa al menos 8 caracteres',
    'validation_phone_invalid': 'Celular no válido',
    'validation_required': 'Campo obligatorio',
    'validation_terms_required': 'Debes aceptar los términos y la política de privacidad',
    'validation_too_long': 'Máximo {max} caracteres',
    'validation_url_invalid': 'Enlace no válido',
  };

  @override
  Locale get locale => const Locale('es');

  @override
  String translate(String key, [Map<String, String>? args]) {
    var value = _strings[key] ?? key;
    if (args != null) {
      args.forEach((String name, String replacement) {
        value = value.replaceAll('{$name}', replacement);
      });
    }
    return value;
  }

  String get appName;
  String get appTagline;
  String get authAcceptPrivacy;
  String get authAcceptPrivacyPrefix;
  String get authAcceptTerms;
  String get authAcceptTermsPrefix;
  String get authAccountPendingVerification;
  String get authBackToLogin;
  String get authEmailHint;
  String get authEmailLabel;
  String get authForgotAction;
  String get authForgotPassword;
  String get authForgotSubtitle;
  String get authForgotSuccess;
  String get authForgotTitle;
  String get authHidePassword;
  String get authLoginAction;
  String get authLoginSubtitle;
  String get authLoginTitle;
  String get authLogout;
  String get authLogoutConfirmMessage;
  String get authLogoutConfirmTitle;
  String get authNameHint;
  String get authNameLabel;
  String get authOtpLabel;
  String get authPasswordHint;
  String get authPasswordLabel;
  String get authPhoneHint;
  String get authPhoneLabel;
  String get authRegisterAction;
  String get authRegisterSubtitle;
  String get authRegisterTitle;
  String get authRememberMe;
  String get authResetAction;
  String get authResetCodeLabel;
  String get authResetConfirmPasswordLabel;
  String get authResetNewPasswordLabel;
  String get authResetSubtitle;
  String get authResetSuccess;
  String get authResetTitle;
  String get authRoleBusiness;
  String get authRoleBusinessDescription;
  String get authRoleCustomer;
  String get authRoleCustomerDescription;
  String get authRoleLabel;
  String get authSessionExpired;
  String get authShowPassword;
  String get authSocialApple;
  String get authSocialDivider;
  String get authSocialGoogle;
  String authSocialNotConfigured(Object provider);
  String authSocialSetupMessage(Object provider);
  String get authVerifyAction;
  String get authVerifyChangeDestination;
  String get authVerifyInvalid;
  String get authVerifyResendAction;
  String authVerifyResendIn(Object seconds);
  String get authVerifyResendSuccess;
  String authVerifySubtitle(Object destination);
  String get authVerifySuccess;
  String get authVerifyTitle;
  String get authWelcomeBenefit1;
  String get authWelcomeBenefit2;
  String get authWelcomeBenefit3;
  String get authWelcomeLogin;
  String get authWelcomeRegister;
  String get authWelcomeSubtitle;
  String get authWelcomeTitle;
  String get businessAboutTitle;
  String get businessAddress;
  String get businessCallAction;
  String get businessCardsTitle;
  String get businessClosedNow;
  String get businessDirectionsAction;
  String get businessDirectionsHint;
  String businessDistanceLabel(Object distance);
  String get businessError;
  String get businessFavoriteAdd;
  String get businessFavoriteRemove;
  String get businessGallery;
  String get businessGalleryTitle;
  String get businessHours;
  String get businessJoinAction;
  String get businessJoined;
  String get businessNotFoundMessage;
  String get businessNotFoundTitle;
  String get businessOpenNow;
  String get businessPhone;
  String get businessPromotionsTitle;
  String get businessScheduleUnavailable;
  String get businessShareAction;
  String get cardsCompletedBadge;
  String cardsCompletedOn(Object date);
  String get cardsDetailError;
  String get cardsDetailTitle;
  String get cardsEmptyMessage;
  String get cardsEmptyTitle;
  String cardsExpiresOn(Object date);
  String get cardsHistoryEmpty;
  String get cardsHistoryTitle;
  String get cardsInactive;
  String get cardsJoinAction;
  String get cardsJoinAlreadyMember;
  String get cardsJoinCodeHint;
  String get cardsJoinCodeLabel;
  String get cardsJoinCodeRequired;
  String get cardsJoinError;
  String get cardsJoinHelp;
  String cardsJoinSuccess(Object business);
  String get cardsJoinTitle;
  String cardsProgress(Object current, Object total);
  String get cardsReadyBadge;
  String cardsRemaining(Object count);
  String get cardsRewardLabel;
  String cardsRulesMessage(Object stamps);
  String get cardsRulesTitle;
  String get cardsShowQrAction;
  String cardsStampAddedAt(Object date);
  String get cardsStampsTitle;
  String get cardsSubtitle;
  String get cardsTitle;
  String get commonAccept;
  String get commonAll;
  String get commonApply;
  String get commonBack;
  String get commonCancel;
  String get commonClear;
  String get commonClose;
  String get commonComingSoon;
  String get commonContinueAction;
  String get commonCopied;
  String get commonCopy;
  String get commonDelete;
  String get commonEdit;
  String get commonEmptyGenericMessage;
  String get commonEmptyGenericTitle;
  String get commonErrorGenericMessage;
  String get commonErrorGenericTitle;
  String get commonFilters;
  String commonKmAway(Object distance);
  String get commonListView;
  String get commonLoading;
  String get commonMapView;
  String get commonNewBadge;
  String get commonNo;
  String get commonOfflineBanner;
  String get commonOk;
  String get commonOptional;
  String commonPointsCount(Object count);
  String get commonRequiredIndicator;
  String get commonRetry;
  String get commonSave;
  String get commonSaving;
  String get commonSearch;
  String get commonSeeAll;
  String get commonSeeDetail;
  String get commonShare;
  String commonStampsCount(Object count);
  String get commonTabHome;
  String get commonTabMap;
  String get commonTabProfile;
  String get commonTabPromotions;
  String get commonTabRewards;
  String get commonYes;
  String get errorsCancelled;
  String get errorsConnection;
  String get errorsForbidden;
  String get errorsForbiddenMessage;
  String get errorsForbiddenTitle;
  String get errorsMaintenanceMessage;
  String get errorsMaintenanceTitle;
  String get errorsNoConnectionAction;
  String get errorsNoConnectionMessage;
  String get errorsNoConnectionTitle;
  String get errorsNotFound;
  String get errorsNotFoundAction;
  String get errorsNotFoundMessage;
  String get errorsNotFoundTitle;
  String get errorsRateLimited;
  String get errorsRequestFailed;
  String get errorsSecureConnection;
  String get errorsServer;
  String get errorsTimeout;
  String get errorsUnauthorized;
  String get errorsUnauthorizedMessage;
  String get errorsUnauthorizedTitle;
  String get errorsUnexpected;
  String get errorsValidationFailed;
  String get helpContactMessage;
  String get helpContactTitle;
  String get helpEmailAction;
  String get helpFaq1Answer;
  String get helpFaq1Question;
  String get helpFaq2Answer;
  String get helpFaq2Question;
  String get helpFaq3Answer;
  String get helpFaq3Question;
  String get helpFaq4Answer;
  String get helpFaq4Question;
  String get helpFaq5Answer;
  String get helpFaq5Question;
  String get helpFaqTitle;
  String get helpSubtitle;
  String get helpTitle;
  String get homeCompletedBanner;
  String get homeCompletedBannerMessage;
  String homeGreeting(Object name);
  String get homeGreetingNoName;
  String get homeMyCardsTitle;
  String get homeNearbyTitle;
  String get homeNoCardsMessage;
  String get homeNoCardsTitle;
  String get homePointsCardSubtitle;
  String get homePointsCardTitle;
  String get homePromotionsTitle;
  String get homeQuickJoinCard;
  String get homeQuickJoinCardHint;
  String get homeQuickNearby;
  String get homeQuickPromotions;
  String get homeQuickReferral;
  String get homeQuickRewards;
  String get homeStatsCards;
  String get homeStatsCompleted;
  String get homeStatsStamps;
  String get homeSubtitle;
  String get legalAboutContact;
  String get legalAboutDescription;
  String get legalAboutLegal;
  String get legalAboutMadeFor;
  String get legalAboutTitle;
  String get legalAboutVersion;
  String get legalAboutWebsite;
  String get legalError;
  String get legalPrivacyTitle;
  String get legalTermsTitle;
  String legalUpdatedAt(Object date);
  String get manageCardsAssetsBackground;
  String get manageCardsAssetsError;
  String get manageCardsAssetsHint;
  String get manageCardsAssetsLogo;
  String get manageCardsAssetsStampIcon;
  String get manageCardsAssetsTitle;
  String get manageCardsAssetsUpload;
  String get manageCardsAssetsUploaded;
  String manageCardsCustomersCount(Object count);
  String get manageCardsDeleteConfirmMessage;
  String get manageCardsDeleteConfirmTitle;
  String get manageCardsDeleted;
  String get manageCardsEmptyMessage;
  String get manageCardsEmptyTitle;
  String get manageCardsError;
  String get manageCardsFieldActive;
  String get manageCardsFieldActiveSubtitle;
  String get manageCardsFieldColor;
  String get manageCardsFieldDescription;
  String get manageCardsFieldDescriptionHint;
  String get manageCardsFieldName;
  String get manageCardsFieldNameHint;
  String get manageCardsFieldRequiredStamps;
  String get manageCardsFieldReward;
  String get manageCardsFieldRewardHint;
  String get manageCardsFormCreateTitle;
  String get manageCardsFormEditTitle;
  String get manageCardsNewAction;
  String get manageCardsPreviewTitle;
  String get manageCardsSaveAction;
  String get manageCardsSaveError;
  String get manageCardsSaved;
  String get manageCardsStepBack;
  String get manageCardsStepBasics;
  String get manageCardsStepDesign;
  String get manageCardsStepNext;
  String get manageCardsStepReview;
  String get manageCardsStepReward;
  String get manageCardsSubtitle;
  String get manageCardsTitle;
  String manageCustomersCardProgress(Object card, Object current, Object total);
  String manageCustomersCardsCount(Object count);
  String manageCustomersCustomerSince(Object date);
  String get manageCustomersDetailTitle;
  String get manageCustomersEmptyMessage;
  String get manageCustomersEmptyTitle;
  String get manageCustomersError;
  String get manageCustomersErrorDetail;
  String manageCustomersLastVisit(Object date);
  String get manageCustomersSearchHint;
  String manageCustomersStampsTotal(Object count);
  String get manageCustomersSubtitle;
  String get manageCustomersTitle;
  String get manageDashboardChartEmpty;
  String get manageDashboardChartRangeMonth;
  String get manageDashboardChartRangeWeek;
  String get manageDashboardChartTitle;
  String get manageDashboardError;
  String manageDashboardGreeting(Object name);
  String get manageDashboardMetricActiveCards;
  String get manageDashboardMetricCustomers;
  String get manageDashboardMetricRedemptions;
  String get manageDashboardMetricStampsMonth;
  String get manageDashboardMetricStampsToday;
  String get manageDashboardQuickCards;
  String get manageDashboardQuickCustomers;
  String get manageDashboardQuickPromotions;
  String get manageDashboardQuickScan;
  String get manageDashboardRecentEmpty;
  String get manageDashboardRecentStampsTitle;
  String get manageDashboardSubtitle;
  String get manageDashboardTitle;
  String get manageDashboardTopCustomersTitle;
  String get managePromotionsDeleteConfirmMessage;
  String get managePromotionsDeleteConfirmTitle;
  String get managePromotionsDeleted;
  String get managePromotionsEmptyMessage;
  String get managePromotionsEmptyTitle;
  String get managePromotionsError;
  String get managePromotionsFieldActive;
  String get managePromotionsFieldDescription;
  String get managePromotionsFieldEndsAt;
  String get managePromotionsFieldStartsAt;
  String get managePromotionsFieldTitle;
  String get managePromotionsFieldTitleHint;
  String get managePromotionsFormCreateTitle;
  String get managePromotionsFormEditTitle;
  String get managePromotionsNewAction;
  String get managePromotionsPickDate;
  String get managePromotionsSaveAction;
  String get managePromotionsSaveError;
  String get managePromotionsSaved;
  String get managePromotionsStatusActive;
  String get managePromotionsStatusExpired;
  String get managePromotionsStatusPaused;
  String get managePromotionsStatusScheduled;
  String get managePromotionsSubtitle;
  String get managePromotionsTitle;
  String get manageScanCameraUnavailableMessage;
  String get manageScanCameraUnavailableTitle;
  String get manageScanCardLabel;
  String get manageScanCustomerLabel;
  String get manageScanDuplicate;
  String get manageScanError;
  String get manageScanInstruction;
  String get manageScanInvalidCode;
  String get manageScanManualAction;
  String get manageScanManualEntry;
  String get manageScanManualHint;
  String get manageScanProcessing;
  String get manageScanRecentEmpty;
  String get manageScanRecentTitle;
  String get manageScanRewardUnlocked;
  String get manageScanScanAgain;
  String get manageScanStampsLabel;
  String manageScanSuccessMessage(Object name, Object count, Object card);
  String get manageScanSuccessTitle;
  String get manageScanTitle;
  String mapBusinessesFound(Object count);
  String get mapCategories;
  String get mapCategoryAll;
  String get mapEmptyMessage;
  String get mapEmptyTitle;
  String get mapError;
  String get mapFavoritesOnly;
  String get mapLocationDeniedMessage;
  String get mapLocationDeniedTitle;
  String get mapManualLocation;
  String get mapManualLocationHint;
  String mapManualLocationSaved(Object area);
  String get mapMyLocation;
  String get mapOpenSettings;
  String get mapRadiusLabel;
  String mapRadiusValue(Object km);
  String get mapSearchHint;
  String get mapStaticViewHint;
  String get mapTitle;
  String get mapYouAreHere;
  String get notificationsEmptyMessage;
  String get notificationsEmptyTitle;
  String get notificationsError;
  String get notificationsMarkAllRead;
  String get notificationsMarkedRead;
  String get notificationsTitle;
  String get notificationsTypeGenericTitle;
  String notificationsTypePromotionBody(Object business, Object promotion);
  String get notificationsTypePromotionTitle;
  String notificationsTypeRewardBody(Object card);
  String get notificationsTypeRewardTitle;
  String notificationsTypeStampBody(Object business, Object count);
  String get notificationsTypeStampTitle;
  String get onboardingNext;
  String get onboardingSkip;
  String get onboardingSlide1Message;
  String get onboardingSlide1Title;
  String get onboardingSlide2Message;
  String get onboardingSlide2Title;
  String get onboardingSlide3Message;
  String get onboardingSlide3Title;
  String get onboardingSlide4Message;
  String get onboardingSlide4Title;
  String get onboardingStart;
  String get profileAboutAction;
  String get profileAvatarChange;
  String get profileAvatarError;
  String get profileAvatarHint;
  String get profileAvatarUploaded;
  String get profileBusinessModeAction;
  String get profileCardsCount;
  String get profileChangePasswordAction;
  String get profileChangePasswordConfirm;
  String get profileChangePasswordCurrent;
  String get profileChangePasswordNew;
  String get profileChangePasswordSuccess;
  String get profileChangePasswordTitle;
  String get profileDeleteAccountAction;
  String get profileDeleteAccountConfirm;
  String get profileDeleteAccountError;
  String get profileDeleteAccountMessage;
  String get profileDeleteAccountSuccess;
  String get profileDeleteAccountTitle;
  String get profileEditAction;
  String get profileEditError;
  String get profileEditSuccess;
  String get profileEditTitle;
  String get profileHelpAction;
  String get profileLegalAction;
  String profileMemberSince(Object date);
  String get profileNotificationsAction;
  String get profilePendingVerification;
  String get profilePoints;
  String get profileReferralAction;
  String get profileRewardCount;
  String get profileRoleAdmin;
  String get profileRoleBusiness;
  String get profileRoleCustomer;
  String get profileSettingsAction;
  String get profileStampsTotal;
  String get profileStatsTitle;
  String get profileSwitchToBusiness;
  String get profileSwitchToCustomer;
  String get profileTitle;
  String get profileVerified;
  String get profileVerifyAction;
  String get promotionsDetailTitle;
  String get promotionsEmptyMessage;
  String get promotionsEmptyTitle;
  String get promotionsError;
  String get promotionsExpired;
  String promotionsStartsOn(Object date);
  String get promotionsSubtitle;
  String get promotionsTerms;
  String get promotionsTitle;
  String promotionsValidUntil(Object date);
  String get qrBrightnessHint;
  String get qrBrightnessUnavailable;
  String get qrCameraUnavailable;
  String get qrCodeLabel;
  String get qrError;
  String get qrExpiredMessage;
  String get qrExpiredTitle;
  String qrExpiresAt(Object time);
  String qrExpiresIn(Object seconds);
  String get qrInstruction;
  String get qrRegenerateAction;
  String get qrShareCode;
  String qrSubtitle(Object business);
  String get qrTitle;
  String get referralCodeLabel;
  String get referralCompletedLabel;
  String get referralCopyAction;
  String get referralEmptyMessage;
  String get referralEmptyTitle;
  String get referralError;
  String get referralHowTitle;
  String referralInvitedCount(Object count);
  String get referralPendingLabel;
  String get referralShareAction;
  String referralShareMessage(Object code);
  String get referralStep1;
  String get referralStep2;
  String get referralStep3;
  String get referralSubtitle;
  String get referralTitle;
  String get rewardsCodeLabel;
  String get rewardsDetailTitle;
  String get rewardsEmptyAvailableMessage;
  String get rewardsEmptyAvailableTitle;
  String get rewardsEmptyExpiredMessage;
  String get rewardsEmptyExpiredTitle;
  String get rewardsEmptyRedeemedMessage;
  String get rewardsEmptyRedeemedTitle;
  String rewardsExpiresOn(Object date);
  String get rewardsRedeemAction;
  String get rewardsRedeemConfirmAction;
  String get rewardsRedeemConfirmMessage;
  String get rewardsRedeemConfirmTitle;
  String get rewardsRedeemError;
  String get rewardsRedeemSuccess;
  String rewardsRedeemedAt(Object date);
  String rewardsRequiresStamps(Object count);
  String get rewardsStatusAvailable;
  String get rewardsStatusExpired;
  String get rewardsStatusRedeemed;
  String get rewardsTabAvailable;
  String get rewardsTabExpired;
  String get rewardsTabRedeemed;
  String get rewardsTitle;
  String get settingsAppearanceTitle;
  String get settingsCacheClear;
  String get settingsCacheCleared;
  String get settingsCacheSubtitle;
  String get settingsDataTitle;
  String get settingsLanguageEn;
  String get settingsLanguageEs;
  String get settingsLanguageLabel;
  String get settingsLanguageSystem;
  String get settingsLocationAuto;
  String get settingsLocationAutoSubtitle;
  String get settingsLocationManual;
  String get settingsLocationManualHint;
  String get settingsLocationTitle;
  String get settingsNotificationsTitle;
  String get settingsNotifyGeneral;
  String get settingsNotifyPromotions;
  String get settingsNotifyPromotionsSubtitle;
  String get settingsNotifyRewards;
  String get settingsNotifyRewardsSubtitle;
  String get settingsNotifyStamps;
  String get settingsNotifyStampsSubtitle;
  String get settingsPreferencesSaved;
  String get settingsThemeDark;
  String get settingsThemeLabel;
  String get settingsThemeLight;
  String get settingsThemeSystem;
  String get settingsTitle;
  String settingsVersionLabel(Object version);
  String timeDaysAgo(Object days);
  String timeHoursAgo(Object hours);
  String get timeJustNow;
  String timeMinutesAgo(Object minutes);
  String get timeToday;
  String timeWeeksAgo(Object weeks);
  String get timeYesterday;
  String get validationCodeInvalid;
  String get validationDateOrder;
  String get validationEmailInvalid;
  String get validationEmailOrPhoneInvalid;
  String get validationNameShort;
  String validationNumberRange(Object min, Object max);
  String get validationNumericInvalid;
  String get validationOtpSixDigits;
  String get validationPasswordMismatch;
  String get validationPasswordShort;
  String get validationPhoneInvalid;
  String get validationRequired;
  String get validationTermsRequired;
  String validationTooLong(Object max);
  String get validationUrlInvalid;

  @override
  String get appName => translate('app_name');

  @override
  String get appTagline => translate('app_tagline');

  @override
  String get authAcceptPrivacy => translate('auth_accept_privacy');

  @override
  String get authAcceptPrivacyPrefix => translate('auth_accept_privacy_prefix');

  @override
  String get authAcceptTerms => translate('auth_accept_terms');

  @override
  String get authAcceptTermsPrefix => translate('auth_accept_terms_prefix');

  @override
  String get authAccountPendingVerification => translate('auth_account_pending_verification');

  @override
  String get authBackToLogin => translate('auth_back_to_login');

  @override
  String get authEmailHint => translate('auth_email_hint');

  @override
  String get authEmailLabel => translate('auth_email_label');

  @override
  String get authForgotAction => translate('auth_forgot_action');

  @override
  String get authForgotPassword => translate('auth_forgot_password');

  @override
  String get authForgotSubtitle => translate('auth_forgot_subtitle');

  @override
  String get authForgotSuccess => translate('auth_forgot_success');

  @override
  String get authForgotTitle => translate('auth_forgot_title');

  @override
  String get authHidePassword => translate('auth_hide_password');

  @override
  String get authLoginAction => translate('auth_login_action');

  @override
  String get authLoginSubtitle => translate('auth_login_subtitle');

  @override
  String get authLoginTitle => translate('auth_login_title');

  @override
  String get authLogout => translate('auth_logout');

  @override
  String get authLogoutConfirmMessage => translate('auth_logout_confirm_message');

  @override
  String get authLogoutConfirmTitle => translate('auth_logout_confirm_title');

  @override
  String get authNameHint => translate('auth_name_hint');

  @override
  String get authNameLabel => translate('auth_name_label');

  @override
  String get authOtpLabel => translate('auth_otp_label');

  @override
  String get authPasswordHint => translate('auth_password_hint');

  @override
  String get authPasswordLabel => translate('auth_password_label');

  @override
  String get authPhoneHint => translate('auth_phone_hint');

  @override
  String get authPhoneLabel => translate('auth_phone_label');

  @override
  String get authRegisterAction => translate('auth_register_action');

  @override
  String get authRegisterSubtitle => translate('auth_register_subtitle');

  @override
  String get authRegisterTitle => translate('auth_register_title');

  @override
  String get authRememberMe => translate('auth_remember_me');

  @override
  String get authResetAction => translate('auth_reset_action');

  @override
  String get authResetCodeLabel => translate('auth_reset_code_label');

  @override
  String get authResetConfirmPasswordLabel => translate('auth_reset_confirm_password_label');

  @override
  String get authResetNewPasswordLabel => translate('auth_reset_new_password_label');

  @override
  String get authResetSubtitle => translate('auth_reset_subtitle');

  @override
  String get authResetSuccess => translate('auth_reset_success');

  @override
  String get authResetTitle => translate('auth_reset_title');

  @override
  String get authRoleBusiness => translate('auth_role_business');

  @override
  String get authRoleBusinessDescription => translate('auth_role_business_description');

  @override
  String get authRoleCustomer => translate('auth_role_customer');

  @override
  String get authRoleCustomerDescription => translate('auth_role_customer_description');

  @override
  String get authRoleLabel => translate('auth_role_label');

  @override
  String get authSessionExpired => translate('auth_session_expired');

  @override
  String get authShowPassword => translate('auth_show_password');

  @override
  String get authSocialApple => translate('auth_social_apple');

  @override
  String get authSocialDivider => translate('auth_social_divider');

  @override
  String get authSocialGoogle => translate('auth_social_google');

  @override
  String authSocialNotConfigured(Object provider) => translate('auth_social_not_configured', <String, String>{'provider': '$provider'});

  @override
  String authSocialSetupMessage(Object provider) => translate('auth_social_setup_message', <String, String>{'provider': '$provider'});

  @override
  String get authVerifyAction => translate('auth_verify_action');

  @override
  String get authVerifyChangeDestination => translate('auth_verify_change_destination');

  @override
  String get authVerifyInvalid => translate('auth_verify_invalid');

  @override
  String get authVerifyResendAction => translate('auth_verify_resend_action');

  @override
  String authVerifyResendIn(Object seconds) => translate('auth_verify_resend_in', <String, String>{'seconds': '$seconds'});

  @override
  String get authVerifyResendSuccess => translate('auth_verify_resend_success');

  @override
  String authVerifySubtitle(Object destination) => translate('auth_verify_subtitle', <String, String>{'destination': '$destination'});

  @override
  String get authVerifySuccess => translate('auth_verify_success');

  @override
  String get authVerifyTitle => translate('auth_verify_title');

  @override
  String get authWelcomeBenefit1 => translate('auth_welcome_benefit_1');

  @override
  String get authWelcomeBenefit2 => translate('auth_welcome_benefit_2');

  @override
  String get authWelcomeBenefit3 => translate('auth_welcome_benefit_3');

  @override
  String get authWelcomeLogin => translate('auth_welcome_login');

  @override
  String get authWelcomeRegister => translate('auth_welcome_register');

  @override
  String get authWelcomeSubtitle => translate('auth_welcome_subtitle');

  @override
  String get authWelcomeTitle => translate('auth_welcome_title');

  @override
  String get businessAboutTitle => translate('business_about_title');

  @override
  String get businessAddress => translate('business_address');

  @override
  String get businessCallAction => translate('business_call_action');

  @override
  String get businessCardsTitle => translate('business_cards_title');

  @override
  String get businessClosedNow => translate('business_closed_now');

  @override
  String get businessDirectionsAction => translate('business_directions_action');

  @override
  String get businessDirectionsHint => translate('business_directions_hint');

  @override
  String businessDistanceLabel(Object distance) => translate('business_distance_label', <String, String>{'distance': '$distance'});

  @override
  String get businessError => translate('business_error');

  @override
  String get businessFavoriteAdd => translate('business_favorite_add');

  @override
  String get businessFavoriteRemove => translate('business_favorite_remove');

  @override
  String get businessGallery => translate('business_gallery');

  @override
  String get businessGalleryTitle => translate('business_gallery_title');

  @override
  String get businessHours => translate('business_hours');

  @override
  String get businessJoinAction => translate('business_join_action');

  @override
  String get businessJoined => translate('business_joined');

  @override
  String get businessNotFoundMessage => translate('business_not_found_message');

  @override
  String get businessNotFoundTitle => translate('business_not_found_title');

  @override
  String get businessOpenNow => translate('business_open_now');

  @override
  String get businessPhone => translate('business_phone');

  @override
  String get businessPromotionsTitle => translate('business_promotions_title');

  @override
  String get businessScheduleUnavailable => translate('business_schedule_unavailable');

  @override
  String get businessShareAction => translate('business_share_action');

  @override
  String get cardsCompletedBadge => translate('cards_completed_badge');

  @override
  String cardsCompletedOn(Object date) => translate('cards_completed_on', <String, String>{'date': '$date'});

  @override
  String get cardsDetailError => translate('cards_detail_error');

  @override
  String get cardsDetailTitle => translate('cards_detail_title');

  @override
  String get cardsEmptyMessage => translate('cards_empty_message');

  @override
  String get cardsEmptyTitle => translate('cards_empty_title');

  @override
  String cardsExpiresOn(Object date) => translate('cards_expires_on', <String, String>{'date': '$date'});

  @override
  String get cardsHistoryEmpty => translate('cards_history_empty');

  @override
  String get cardsHistoryTitle => translate('cards_history_title');

  @override
  String get cardsInactive => translate('cards_inactive');

  @override
  String get cardsJoinAction => translate('cards_join_action');

  @override
  String get cardsJoinAlreadyMember => translate('cards_join_already_member');

  @override
  String get cardsJoinCodeHint => translate('cards_join_code_hint');

  @override
  String get cardsJoinCodeLabel => translate('cards_join_code_label');

  @override
  String get cardsJoinCodeRequired => translate('cards_join_code_required');

  @override
  String get cardsJoinError => translate('cards_join_error');

  @override
  String get cardsJoinHelp => translate('cards_join_help');

  @override
  String cardsJoinSuccess(Object business) => translate('cards_join_success', <String, String>{'business': '$business'});

  @override
  String get cardsJoinTitle => translate('cards_join_title');

  @override
  String cardsProgress(Object current, Object total) => translate('cards_progress', <String, String>{'current': '$current', 'total': '$total'});

  @override
  String get cardsReadyBadge => translate('cards_ready_badge');

  @override
  String cardsRemaining(Object count) => translate('cards_remaining', <String, String>{'count': '$count'});

  @override
  String get cardsRewardLabel => translate('cards_reward_label');

  @override
  String cardsRulesMessage(Object stamps) => translate('cards_rules_message', <String, String>{'stamps': '$stamps'});

  @override
  String get cardsRulesTitle => translate('cards_rules_title');

  @override
  String get cardsShowQrAction => translate('cards_show_qr_action');

  @override
  String cardsStampAddedAt(Object date) => translate('cards_stamp_added_at', <String, String>{'date': '$date'});

  @override
  String get cardsStampsTitle => translate('cards_stamps_title');

  @override
  String get cardsSubtitle => translate('cards_subtitle');

  @override
  String get cardsTitle => translate('cards_title');

  @override
  String get commonAccept => translate('common_accept');

  @override
  String get commonAll => translate('common_all');

  @override
  String get commonApply => translate('common_apply');

  @override
  String get commonBack => translate('common_back');

  @override
  String get commonCancel => translate('common_cancel');

  @override
  String get commonClear => translate('common_clear');

  @override
  String get commonClose => translate('common_close');

  @override
  String get commonComingSoon => translate('common_coming_soon');

  @override
  String get commonContinueAction => translate('common_continue_action');

  @override
  String get commonCopied => translate('common_copied');

  @override
  String get commonCopy => translate('common_copy');

  @override
  String get commonDelete => translate('common_delete');

  @override
  String get commonEdit => translate('common_edit');

  @override
  String get commonEmptyGenericMessage => translate('common_empty_generic_message');

  @override
  String get commonEmptyGenericTitle => translate('common_empty_generic_title');

  @override
  String get commonErrorGenericMessage => translate('common_error_generic_message');

  @override
  String get commonErrorGenericTitle => translate('common_error_generic_title');

  @override
  String get commonFilters => translate('common_filters');

  @override
  String commonKmAway(Object distance) => translate('common_km_away', <String, String>{'distance': '$distance'});

  @override
  String get commonListView => translate('common_list_view');

  @override
  String get commonLoading => translate('common_loading');

  @override
  String get commonMapView => translate('common_map_view');

  @override
  String get commonNewBadge => translate('common_new_badge');

  @override
  String get commonNo => translate('common_no');

  @override
  String get commonOfflineBanner => translate('common_offline_banner');

  @override
  String get commonOk => translate('common_ok');

  @override
  String get commonOptional => translate('common_optional');

  @override
  String commonPointsCount(Object count) => translate('common_points_count', <String, String>{'count': '$count'});

  @override
  String get commonRequiredIndicator => translate('common_required_indicator');

  @override
  String get commonRetry => translate('common_retry');

  @override
  String get commonSave => translate('common_save');

  @override
  String get commonSaving => translate('common_saving');

  @override
  String get commonSearch => translate('common_search');

  @override
  String get commonSeeAll => translate('common_see_all');

  @override
  String get commonSeeDetail => translate('common_see_detail');

  @override
  String get commonShare => translate('common_share');

  @override
  String commonStampsCount(Object count) => translate('common_stamps_count', <String, String>{'count': '$count'});

  @override
  String get commonTabHome => translate('common_tab_home');

  @override
  String get commonTabMap => translate('common_tab_map');

  @override
  String get commonTabProfile => translate('common_tab_profile');

  @override
  String get commonTabPromotions => translate('common_tab_promotions');

  @override
  String get commonTabRewards => translate('common_tab_rewards');

  @override
  String get commonYes => translate('common_yes');

  @override
  String get errorsCancelled => translate('errors_cancelled');

  @override
  String get errorsConnection => translate('errors_connection');

  @override
  String get errorsForbidden => translate('errors_forbidden');

  @override
  String get errorsForbiddenMessage => translate('errors_forbidden_message');

  @override
  String get errorsForbiddenTitle => translate('errors_forbidden_title');

  @override
  String get errorsMaintenanceMessage => translate('errors_maintenance_message');

  @override
  String get errorsMaintenanceTitle => translate('errors_maintenance_title');

  @override
  String get errorsNoConnectionAction => translate('errors_no_connection_action');

  @override
  String get errorsNoConnectionMessage => translate('errors_no_connection_message');

  @override
  String get errorsNoConnectionTitle => translate('errors_no_connection_title');

  @override
  String get errorsNotFound => translate('errors_not_found');

  @override
  String get errorsNotFoundAction => translate('errors_not_found_action');

  @override
  String get errorsNotFoundMessage => translate('errors_not_found_message');

  @override
  String get errorsNotFoundTitle => translate('errors_not_found_title');

  @override
  String get errorsRateLimited => translate('errors_rate_limited');

  @override
  String get errorsRequestFailed => translate('errors_request_failed');

  @override
  String get errorsSecureConnection => translate('errors_secure_connection');

  @override
  String get errorsServer => translate('errors_server');

  @override
  String get errorsTimeout => translate('errors_timeout');

  @override
  String get errorsUnauthorized => translate('errors_unauthorized');

  @override
  String get errorsUnauthorizedMessage => translate('errors_unauthorized_message');

  @override
  String get errorsUnauthorizedTitle => translate('errors_unauthorized_title');

  @override
  String get errorsUnexpected => translate('errors_unexpected');

  @override
  String get errorsValidationFailed => translate('errors_validation_failed');

  @override
  String get helpContactMessage => translate('help_contact_message');

  @override
  String get helpContactTitle => translate('help_contact_title');

  @override
  String get helpEmailAction => translate('help_email_action');

  @override
  String get helpFaq1Answer => translate('help_faq_1_answer');

  @override
  String get helpFaq1Question => translate('help_faq_1_question');

  @override
  String get helpFaq2Answer => translate('help_faq_2_answer');

  @override
  String get helpFaq2Question => translate('help_faq_2_question');

  @override
  String get helpFaq3Answer => translate('help_faq_3_answer');

  @override
  String get helpFaq3Question => translate('help_faq_3_question');

  @override
  String get helpFaq4Answer => translate('help_faq_4_answer');

  @override
  String get helpFaq4Question => translate('help_faq_4_question');

  @override
  String get helpFaq5Answer => translate('help_faq_5_answer');

  @override
  String get helpFaq5Question => translate('help_faq_5_question');

  @override
  String get helpFaqTitle => translate('help_faq_title');

  @override
  String get helpSubtitle => translate('help_subtitle');

  @override
  String get helpTitle => translate('help_title');

  @override
  String get homeCompletedBanner => translate('home_completed_banner');

  @override
  String get homeCompletedBannerMessage => translate('home_completed_banner_message');

  @override
  String homeGreeting(Object name) => translate('home_greeting', <String, String>{'name': '$name'});

  @override
  String get homeGreetingNoName => translate('home_greeting_no_name');

  @override
  String get homeMyCardsTitle => translate('home_my_cards_title');

  @override
  String get homeNearbyTitle => translate('home_nearby_title');

  @override
  String get homeNoCardsMessage => translate('home_no_cards_message');

  @override
  String get homeNoCardsTitle => translate('home_no_cards_title');

  @override
  String get homePointsCardSubtitle => translate('home_points_card_subtitle');

  @override
  String get homePointsCardTitle => translate('home_points_card_title');

  @override
  String get homePromotionsTitle => translate('home_promotions_title');

  @override
  String get homeQuickJoinCard => translate('home_quick_join_card');

  @override
  String get homeQuickJoinCardHint => translate('home_quick_join_card_hint');

  @override
  String get homeQuickNearby => translate('home_quick_nearby');

  @override
  String get homeQuickPromotions => translate('home_quick_promotions');

  @override
  String get homeQuickReferral => translate('home_quick_referral');

  @override
  String get homeQuickRewards => translate('home_quick_rewards');

  @override
  String get homeStatsCards => translate('home_stats_cards');

  @override
  String get homeStatsCompleted => translate('home_stats_completed');

  @override
  String get homeStatsStamps => translate('home_stats_stamps');

  @override
  String get homeSubtitle => translate('home_subtitle');

  @override
  String get legalAboutContact => translate('legal_about_contact');

  @override
  String get legalAboutDescription => translate('legal_about_description');

  @override
  String get legalAboutLegal => translate('legal_about_legal');

  @override
  String get legalAboutMadeFor => translate('legal_about_made_for');

  @override
  String get legalAboutTitle => translate('legal_about_title');

  @override
  String get legalAboutVersion => translate('legal_about_version');

  @override
  String get legalAboutWebsite => translate('legal_about_website');

  @override
  String get legalError => translate('legal_error');

  @override
  String get legalPrivacyTitle => translate('legal_privacy_title');

  @override
  String get legalTermsTitle => translate('legal_terms_title');

  @override
  String legalUpdatedAt(Object date) => translate('legal_updated_at', <String, String>{'date': '$date'});

  @override
  String get manageCardsAssetsBackground => translate('manage_cards_assets_background');

  @override
  String get manageCardsAssetsError => translate('manage_cards_assets_error');

  @override
  String get manageCardsAssetsHint => translate('manage_cards_assets_hint');

  @override
  String get manageCardsAssetsLogo => translate('manage_cards_assets_logo');

  @override
  String get manageCardsAssetsStampIcon => translate('manage_cards_assets_stamp_icon');

  @override
  String get manageCardsAssetsTitle => translate('manage_cards_assets_title');

  @override
  String get manageCardsAssetsUpload => translate('manage_cards_assets_upload');

  @override
  String get manageCardsAssetsUploaded => translate('manage_cards_assets_uploaded');

  @override
  String manageCardsCustomersCount(Object count) => translate('manage_cards_customers_count', <String, String>{'count': '$count'});

  @override
  String get manageCardsDeleteConfirmMessage => translate('manage_cards_delete_confirm_message');

  @override
  String get manageCardsDeleteConfirmTitle => translate('manage_cards_delete_confirm_title');

  @override
  String get manageCardsDeleted => translate('manage_cards_deleted');

  @override
  String get manageCardsEmptyMessage => translate('manage_cards_empty_message');

  @override
  String get manageCardsEmptyTitle => translate('manage_cards_empty_title');

  @override
  String get manageCardsError => translate('manage_cards_error');

  @override
  String get manageCardsFieldActive => translate('manage_cards_field_active');

  @override
  String get manageCardsFieldActiveSubtitle => translate('manage_cards_field_active_subtitle');

  @override
  String get manageCardsFieldColor => translate('manage_cards_field_color');

  @override
  String get manageCardsFieldDescription => translate('manage_cards_field_description');

  @override
  String get manageCardsFieldDescriptionHint => translate('manage_cards_field_description_hint');

  @override
  String get manageCardsFieldName => translate('manage_cards_field_name');

  @override
  String get manageCardsFieldNameHint => translate('manage_cards_field_name_hint');

  @override
  String get manageCardsFieldRequiredStamps => translate('manage_cards_field_required_stamps');

  @override
  String get manageCardsFieldReward => translate('manage_cards_field_reward');

  @override
  String get manageCardsFieldRewardHint => translate('manage_cards_field_reward_hint');

  @override
  String get manageCardsFormCreateTitle => translate('manage_cards_form_create_title');

  @override
  String get manageCardsFormEditTitle => translate('manage_cards_form_edit_title');

  @override
  String get manageCardsNewAction => translate('manage_cards_new_action');

  @override
  String get manageCardsPreviewTitle => translate('manage_cards_preview_title');

  @override
  String get manageCardsSaveAction => translate('manage_cards_save_action');

  @override
  String get manageCardsSaveError => translate('manage_cards_save_error');

  @override
  String get manageCardsSaved => translate('manage_cards_saved');

  @override
  String get manageCardsStepBack => translate('manage_cards_step_back');

  @override
  String get manageCardsStepBasics => translate('manage_cards_step_basics');

  @override
  String get manageCardsStepDesign => translate('manage_cards_step_design');

  @override
  String get manageCardsStepNext => translate('manage_cards_step_next');

  @override
  String get manageCardsStepReview => translate('manage_cards_step_review');

  @override
  String get manageCardsStepReward => translate('manage_cards_step_reward');

  @override
  String get manageCardsSubtitle => translate('manage_cards_subtitle');

  @override
  String get manageCardsTitle => translate('manage_cards_title');

  @override
  String manageCustomersCardProgress(Object card, Object current, Object total) => translate('manage_customers_card_progress', <String, String>{'card': '$card', 'current': '$current', 'total': '$total'});

  @override
  String manageCustomersCardsCount(Object count) => translate('manage_customers_cards_count', <String, String>{'count': '$count'});

  @override
  String manageCustomersCustomerSince(Object date) => translate('manage_customers_customer_since', <String, String>{'date': '$date'});

  @override
  String get manageCustomersDetailTitle => translate('manage_customers_detail_title');

  @override
  String get manageCustomersEmptyMessage => translate('manage_customers_empty_message');

  @override
  String get manageCustomersEmptyTitle => translate('manage_customers_empty_title');

  @override
  String get manageCustomersError => translate('manage_customers_error');

  @override
  String get manageCustomersErrorDetail => translate('manage_customers_error_detail');

  @override
  String manageCustomersLastVisit(Object date) => translate('manage_customers_last_visit', <String, String>{'date': '$date'});

  @override
  String get manageCustomersSearchHint => translate('manage_customers_search_hint');

  @override
  String manageCustomersStampsTotal(Object count) => translate('manage_customers_stamps_total', <String, String>{'count': '$count'});

  @override
  String get manageCustomersSubtitle => translate('manage_customers_subtitle');

  @override
  String get manageCustomersTitle => translate('manage_customers_title');

  @override
  String get manageDashboardChartEmpty => translate('manage_dashboard_chart_empty');

  @override
  String get manageDashboardChartRangeMonth => translate('manage_dashboard_chart_range_month');

  @override
  String get manageDashboardChartRangeWeek => translate('manage_dashboard_chart_range_week');

  @override
  String get manageDashboardChartTitle => translate('manage_dashboard_chart_title');

  @override
  String get manageDashboardError => translate('manage_dashboard_error');

  @override
  String manageDashboardGreeting(Object name) => translate('manage_dashboard_greeting', <String, String>{'name': '$name'});

  @override
  String get manageDashboardMetricActiveCards => translate('manage_dashboard_metric_active_cards');

  @override
  String get manageDashboardMetricCustomers => translate('manage_dashboard_metric_customers');

  @override
  String get manageDashboardMetricRedemptions => translate('manage_dashboard_metric_redemptions');

  @override
  String get manageDashboardMetricStampsMonth => translate('manage_dashboard_metric_stamps_month');

  @override
  String get manageDashboardMetricStampsToday => translate('manage_dashboard_metric_stamps_today');

  @override
  String get manageDashboardQuickCards => translate('manage_dashboard_quick_cards');

  @override
  String get manageDashboardQuickCustomers => translate('manage_dashboard_quick_customers');

  @override
  String get manageDashboardQuickPromotions => translate('manage_dashboard_quick_promotions');

  @override
  String get manageDashboardQuickScan => translate('manage_dashboard_quick_scan');

  @override
  String get manageDashboardRecentEmpty => translate('manage_dashboard_recent_empty');

  @override
  String get manageDashboardRecentStampsTitle => translate('manage_dashboard_recent_stamps_title');

  @override
  String get manageDashboardSubtitle => translate('manage_dashboard_subtitle');

  @override
  String get manageDashboardTitle => translate('manage_dashboard_title');

  @override
  String get manageDashboardTopCustomersTitle => translate('manage_dashboard_top_customers_title');

  @override
  String get managePromotionsDeleteConfirmMessage => translate('manage_promotions_delete_confirm_message');

  @override
  String get managePromotionsDeleteConfirmTitle => translate('manage_promotions_delete_confirm_title');

  @override
  String get managePromotionsDeleted => translate('manage_promotions_deleted');

  @override
  String get managePromotionsEmptyMessage => translate('manage_promotions_empty_message');

  @override
  String get managePromotionsEmptyTitle => translate('manage_promotions_empty_title');

  @override
  String get managePromotionsError => translate('manage_promotions_error');

  @override
  String get managePromotionsFieldActive => translate('manage_promotions_field_active');

  @override
  String get managePromotionsFieldDescription => translate('manage_promotions_field_description');

  @override
  String get managePromotionsFieldEndsAt => translate('manage_promotions_field_ends_at');

  @override
  String get managePromotionsFieldStartsAt => translate('manage_promotions_field_starts_at');

  @override
  String get managePromotionsFieldTitle => translate('manage_promotions_field_title');

  @override
  String get managePromotionsFieldTitleHint => translate('manage_promotions_field_title_hint');

  @override
  String get managePromotionsFormCreateTitle => translate('manage_promotions_form_create_title');

  @override
  String get managePromotionsFormEditTitle => translate('manage_promotions_form_edit_title');

  @override
  String get managePromotionsNewAction => translate('manage_promotions_new_action');

  @override
  String get managePromotionsPickDate => translate('manage_promotions_pick_date');

  @override
  String get managePromotionsSaveAction => translate('manage_promotions_save_action');

  @override
  String get managePromotionsSaveError => translate('manage_promotions_save_error');

  @override
  String get managePromotionsSaved => translate('manage_promotions_saved');

  @override
  String get managePromotionsStatusActive => translate('manage_promotions_status_active');

  @override
  String get managePromotionsStatusExpired => translate('manage_promotions_status_expired');

  @override
  String get managePromotionsStatusPaused => translate('manage_promotions_status_paused');

  @override
  String get managePromotionsStatusScheduled => translate('manage_promotions_status_scheduled');

  @override
  String get managePromotionsSubtitle => translate('manage_promotions_subtitle');

  @override
  String get managePromotionsTitle => translate('manage_promotions_title');

  @override
  String get manageScanCameraUnavailableMessage => translate('manage_scan_camera_unavailable_message');

  @override
  String get manageScanCameraUnavailableTitle => translate('manage_scan_camera_unavailable_title');

  @override
  String get manageScanCardLabel => translate('manage_scan_card_label');

  @override
  String get manageScanCustomerLabel => translate('manage_scan_customer_label');

  @override
  String get manageScanDuplicate => translate('manage_scan_duplicate');

  @override
  String get manageScanError => translate('manage_scan_error');

  @override
  String get manageScanInstruction => translate('manage_scan_instruction');

  @override
  String get manageScanInvalidCode => translate('manage_scan_invalid_code');

  @override
  String get manageScanManualAction => translate('manage_scan_manual_action');

  @override
  String get manageScanManualEntry => translate('manage_scan_manual_entry');

  @override
  String get manageScanManualHint => translate('manage_scan_manual_hint');

  @override
  String get manageScanProcessing => translate('manage_scan_processing');

  @override
  String get manageScanRecentEmpty => translate('manage_scan_recent_empty');

  @override
  String get manageScanRecentTitle => translate('manage_scan_recent_title');

  @override
  String get manageScanRewardUnlocked => translate('manage_scan_reward_unlocked');

  @override
  String get manageScanScanAgain => translate('manage_scan_scan_again');

  @override
  String get manageScanStampsLabel => translate('manage_scan_stamps_label');

  @override
  String manageScanSuccessMessage(Object name, Object count, Object card) => translate('manage_scan_success_message', <String, String>{'name': '$name', 'count': '$count', 'card': '$card'});

  @override
  String get manageScanSuccessTitle => translate('manage_scan_success_title');

  @override
  String get manageScanTitle => translate('manage_scan_title');

  @override
  String mapBusinessesFound(Object count) => translate('map_businesses_found', <String, String>{'count': '$count'});

  @override
  String get mapCategories => translate('map_categories');

  @override
  String get mapCategoryAll => translate('map_category_all');

  @override
  String get mapEmptyMessage => translate('map_empty_message');

  @override
  String get mapEmptyTitle => translate('map_empty_title');

  @override
  String get mapError => translate('map_error');

  @override
  String get mapFavoritesOnly => translate('map_favorites_only');

  @override
  String get mapLocationDeniedMessage => translate('map_location_denied_message');

  @override
  String get mapLocationDeniedTitle => translate('map_location_denied_title');

  @override
  String get mapManualLocation => translate('map_manual_location');

  @override
  String get mapManualLocationHint => translate('map_manual_location_hint');

  @override
  String mapManualLocationSaved(Object area) => translate('map_manual_location_saved', <String, String>{'area': '$area'});

  @override
  String get mapMyLocation => translate('map_my_location');

  @override
  String get mapOpenSettings => translate('map_open_settings');

  @override
  String get mapRadiusLabel => translate('map_radius_label');

  @override
  String mapRadiusValue(Object km) => translate('map_radius_value', <String, String>{'km': '$km'});

  @override
  String get mapSearchHint => translate('map_search_hint');

  @override
  String get mapStaticViewHint => translate('map_static_view_hint');

  @override
  String get mapTitle => translate('map_title');

  @override
  String get mapYouAreHere => translate('map_you_are_here');

  @override
  String get notificationsEmptyMessage => translate('notifications_empty_message');

  @override
  String get notificationsEmptyTitle => translate('notifications_empty_title');

  @override
  String get notificationsError => translate('notifications_error');

  @override
  String get notificationsMarkAllRead => translate('notifications_mark_all_read');

  @override
  String get notificationsMarkedRead => translate('notifications_marked_read');

  @override
  String get notificationsTitle => translate('notifications_title');

  @override
  String get notificationsTypeGenericTitle => translate('notifications_type_generic_title');

  @override
  String notificationsTypePromotionBody(Object business, Object promotion) => translate('notifications_type_promotion_body', <String, String>{'business': '$business', 'promotion': '$promotion'});

  @override
  String get notificationsTypePromotionTitle => translate('notifications_type_promotion_title');

  @override
  String notificationsTypeRewardBody(Object card) => translate('notifications_type_reward_body', <String, String>{'card': '$card'});

  @override
  String get notificationsTypeRewardTitle => translate('notifications_type_reward_title');

  @override
  String notificationsTypeStampBody(Object business, Object count) => translate('notifications_type_stamp_body', <String, String>{'business': '$business', 'count': '$count'});

  @override
  String get notificationsTypeStampTitle => translate('notifications_type_stamp_title');

  @override
  String get onboardingNext => translate('onboarding_next');

  @override
  String get onboardingSkip => translate('onboarding_skip');

  @override
  String get onboardingSlide1Message => translate('onboarding_slide_1_message');

  @override
  String get onboardingSlide1Title => translate('onboarding_slide_1_title');

  @override
  String get onboardingSlide2Message => translate('onboarding_slide_2_message');

  @override
  String get onboardingSlide2Title => translate('onboarding_slide_2_title');

  @override
  String get onboardingSlide3Message => translate('onboarding_slide_3_message');

  @override
  String get onboardingSlide3Title => translate('onboarding_slide_3_title');

  @override
  String get onboardingSlide4Message => translate('onboarding_slide_4_message');

  @override
  String get onboardingSlide4Title => translate('onboarding_slide_4_title');

  @override
  String get onboardingStart => translate('onboarding_start');

  @override
  String get profileAboutAction => translate('profile_about_action');

  @override
  String get profileAvatarChange => translate('profile_avatar_change');

  @override
  String get profileAvatarError => translate('profile_avatar_error');

  @override
  String get profileAvatarHint => translate('profile_avatar_hint');

  @override
  String get profileAvatarUploaded => translate('profile_avatar_uploaded');

  @override
  String get profileBusinessModeAction => translate('profile_business_mode_action');

  @override
  String get profileCardsCount => translate('profile_cards_count');

  @override
  String get profileChangePasswordAction => translate('profile_change_password_action');

  @override
  String get profileChangePasswordConfirm => translate('profile_change_password_confirm');

  @override
  String get profileChangePasswordCurrent => translate('profile_change_password_current');

  @override
  String get profileChangePasswordNew => translate('profile_change_password_new');

  @override
  String get profileChangePasswordSuccess => translate('profile_change_password_success');

  @override
  String get profileChangePasswordTitle => translate('profile_change_password_title');

  @override
  String get profileDeleteAccountAction => translate('profile_delete_account_action');

  @override
  String get profileDeleteAccountConfirm => translate('profile_delete_account_confirm');

  @override
  String get profileDeleteAccountError => translate('profile_delete_account_error');

  @override
  String get profileDeleteAccountMessage => translate('profile_delete_account_message');

  @override
  String get profileDeleteAccountSuccess => translate('profile_delete_account_success');

  @override
  String get profileDeleteAccountTitle => translate('profile_delete_account_title');

  @override
  String get profileEditAction => translate('profile_edit_action');

  @override
  String get profileEditError => translate('profile_edit_error');

  @override
  String get profileEditSuccess => translate('profile_edit_success');

  @override
  String get profileEditTitle => translate('profile_edit_title');

  @override
  String get profileHelpAction => translate('profile_help_action');

  @override
  String get profileLegalAction => translate('profile_legal_action');

  @override
  String profileMemberSince(Object date) => translate('profile_member_since', <String, String>{'date': '$date'});

  @override
  String get profileNotificationsAction => translate('profile_notifications_action');

  @override
  String get profilePendingVerification => translate('profile_pending_verification');

  @override
  String get profilePoints => translate('profile_points');

  @override
  String get profileReferralAction => translate('profile_referral_action');

  @override
  String get profileRewardCount => translate('profile_reward_count');

  @override
  String get profileRoleAdmin => translate('profile_role_admin');

  @override
  String get profileRoleBusiness => translate('profile_role_business');

  @override
  String get profileRoleCustomer => translate('profile_role_customer');

  @override
  String get profileSettingsAction => translate('profile_settings_action');

  @override
  String get profileStampsTotal => translate('profile_stamps_total');

  @override
  String get profileStatsTitle => translate('profile_stats_title');

  @override
  String get profileSwitchToBusiness => translate('profile_switch_to_business');

  @override
  String get profileSwitchToCustomer => translate('profile_switch_to_customer');

  @override
  String get profileTitle => translate('profile_title');

  @override
  String get profileVerified => translate('profile_verified');

  @override
  String get profileVerifyAction => translate('profile_verify_action');

  @override
  String get promotionsDetailTitle => translate('promotions_detail_title');

  @override
  String get promotionsEmptyMessage => translate('promotions_empty_message');

  @override
  String get promotionsEmptyTitle => translate('promotions_empty_title');

  @override
  String get promotionsError => translate('promotions_error');

  @override
  String get promotionsExpired => translate('promotions_expired');

  @override
  String promotionsStartsOn(Object date) => translate('promotions_starts_on', <String, String>{'date': '$date'});

  @override
  String get promotionsSubtitle => translate('promotions_subtitle');

  @override
  String get promotionsTerms => translate('promotions_terms');

  @override
  String get promotionsTitle => translate('promotions_title');

  @override
  String promotionsValidUntil(Object date) => translate('promotions_valid_until', <String, String>{'date': '$date'});

  @override
  String get qrBrightnessHint => translate('qr_brightness_hint');

  @override
  String get qrBrightnessUnavailable => translate('qr_brightness_unavailable');

  @override
  String get qrCameraUnavailable => translate('qr_camera_unavailable');

  @override
  String get qrCodeLabel => translate('qr_code_label');

  @override
  String get qrError => translate('qr_error');

  @override
  String get qrExpiredMessage => translate('qr_expired_message');

  @override
  String get qrExpiredTitle => translate('qr_expired_title');

  @override
  String qrExpiresAt(Object time) => translate('qr_expires_at', <String, String>{'time': '$time'});

  @override
  String qrExpiresIn(Object seconds) => translate('qr_expires_in', <String, String>{'seconds': '$seconds'});

  @override
  String get qrInstruction => translate('qr_instruction');

  @override
  String get qrRegenerateAction => translate('qr_regenerate_action');

  @override
  String get qrShareCode => translate('qr_share_code');

  @override
  String qrSubtitle(Object business) => translate('qr_subtitle', <String, String>{'business': '$business'});

  @override
  String get qrTitle => translate('qr_title');

  @override
  String get referralCodeLabel => translate('referral_code_label');

  @override
  String get referralCompletedLabel => translate('referral_completed_label');

  @override
  String get referralCopyAction => translate('referral_copy_action');

  @override
  String get referralEmptyMessage => translate('referral_empty_message');

  @override
  String get referralEmptyTitle => translate('referral_empty_title');

  @override
  String get referralError => translate('referral_error');

  @override
  String get referralHowTitle => translate('referral_how_title');

  @override
  String referralInvitedCount(Object count) => translate('referral_invited_count', <String, String>{'count': '$count'});

  @override
  String get referralPendingLabel => translate('referral_pending_label');

  @override
  String get referralShareAction => translate('referral_share_action');

  @override
  String referralShareMessage(Object code) => translate('referral_share_message', <String, String>{'code': '$code'});

  @override
  String get referralStep1 => translate('referral_step_1');

  @override
  String get referralStep2 => translate('referral_step_2');

  @override
  String get referralStep3 => translate('referral_step_3');

  @override
  String get referralSubtitle => translate('referral_subtitle');

  @override
  String get referralTitle => translate('referral_title');

  @override
  String get rewardsCodeLabel => translate('rewards_code_label');

  @override
  String get rewardsDetailTitle => translate('rewards_detail_title');

  @override
  String get rewardsEmptyAvailableMessage => translate('rewards_empty_available_message');

  @override
  String get rewardsEmptyAvailableTitle => translate('rewards_empty_available_title');

  @override
  String get rewardsEmptyExpiredMessage => translate('rewards_empty_expired_message');

  @override
  String get rewardsEmptyExpiredTitle => translate('rewards_empty_expired_title');

  @override
  String get rewardsEmptyRedeemedMessage => translate('rewards_empty_redeemed_message');

  @override
  String get rewardsEmptyRedeemedTitle => translate('rewards_empty_redeemed_title');

  @override
  String rewardsExpiresOn(Object date) => translate('rewards_expires_on', <String, String>{'date': '$date'});

  @override
  String get rewardsRedeemAction => translate('rewards_redeem_action');

  @override
  String get rewardsRedeemConfirmAction => translate('rewards_redeem_confirm_action');

  @override
  String get rewardsRedeemConfirmMessage => translate('rewards_redeem_confirm_message');

  @override
  String get rewardsRedeemConfirmTitle => translate('rewards_redeem_confirm_title');

  @override
  String get rewardsRedeemError => translate('rewards_redeem_error');

  @override
  String get rewardsRedeemSuccess => translate('rewards_redeem_success');

  @override
  String rewardsRedeemedAt(Object date) => translate('rewards_redeemed_at', <String, String>{'date': '$date'});

  @override
  String rewardsRequiresStamps(Object count) => translate('rewards_requires_stamps', <String, String>{'count': '$count'});

  @override
  String get rewardsStatusAvailable => translate('rewards_status_available');

  @override
  String get rewardsStatusExpired => translate('rewards_status_expired');

  @override
  String get rewardsStatusRedeemed => translate('rewards_status_redeemed');

  @override
  String get rewardsTabAvailable => translate('rewards_tab_available');

  @override
  String get rewardsTabExpired => translate('rewards_tab_expired');

  @override
  String get rewardsTabRedeemed => translate('rewards_tab_redeemed');

  @override
  String get rewardsTitle => translate('rewards_title');

  @override
  String get settingsAppearanceTitle => translate('settings_appearance_title');

  @override
  String get settingsCacheClear => translate('settings_cache_clear');

  @override
  String get settingsCacheCleared => translate('settings_cache_cleared');

  @override
  String get settingsCacheSubtitle => translate('settings_cache_subtitle');

  @override
  String get settingsDataTitle => translate('settings_data_title');

  @override
  String get settingsLanguageEn => translate('settings_language_en');

  @override
  String get settingsLanguageEs => translate('settings_language_es');

  @override
  String get settingsLanguageLabel => translate('settings_language_label');

  @override
  String get settingsLanguageSystem => translate('settings_language_system');

  @override
  String get settingsLocationAuto => translate('settings_location_auto');

  @override
  String get settingsLocationAutoSubtitle => translate('settings_location_auto_subtitle');

  @override
  String get settingsLocationManual => translate('settings_location_manual');

  @override
  String get settingsLocationManualHint => translate('settings_location_manual_hint');

  @override
  String get settingsLocationTitle => translate('settings_location_title');

  @override
  String get settingsNotificationsTitle => translate('settings_notifications_title');

  @override
  String get settingsNotifyGeneral => translate('settings_notify_general');

  @override
  String get settingsNotifyPromotions => translate('settings_notify_promotions');

  @override
  String get settingsNotifyPromotionsSubtitle => translate('settings_notify_promotions_subtitle');

  @override
  String get settingsNotifyRewards => translate('settings_notify_rewards');

  @override
  String get settingsNotifyRewardsSubtitle => translate('settings_notify_rewards_subtitle');

  @override
  String get settingsNotifyStamps => translate('settings_notify_stamps');

  @override
  String get settingsNotifyStampsSubtitle => translate('settings_notify_stamps_subtitle');

  @override
  String get settingsPreferencesSaved => translate('settings_preferences_saved');

  @override
  String get settingsThemeDark => translate('settings_theme_dark');

  @override
  String get settingsThemeLabel => translate('settings_theme_label');

  @override
  String get settingsThemeLight => translate('settings_theme_light');

  @override
  String get settingsThemeSystem => translate('settings_theme_system');

  @override
  String get settingsTitle => translate('settings_title');

  @override
  String settingsVersionLabel(Object version) => translate('settings_version_label', <String, String>{'version': '$version'});

  @override
  String timeDaysAgo(Object days) => translate('time_days_ago', <String, String>{'days': '$days'});

  @override
  String timeHoursAgo(Object hours) => translate('time_hours_ago', <String, String>{'hours': '$hours'});

  @override
  String get timeJustNow => translate('time_just_now');

  @override
  String timeMinutesAgo(Object minutes) => translate('time_minutes_ago', <String, String>{'minutes': '$minutes'});

  @override
  String get timeToday => translate('time_today');

  @override
  String timeWeeksAgo(Object weeks) => translate('time_weeks_ago', <String, String>{'weeks': '$weeks'});

  @override
  String get timeYesterday => translate('time_yesterday');

  @override
  String get validationCodeInvalid => translate('validation_code_invalid');

  @override
  String get validationDateOrder => translate('validation_date_order');

  @override
  String get validationEmailInvalid => translate('validation_email_invalid');

  @override
  String get validationEmailOrPhoneInvalid => translate('validation_email_or_phone_invalid');

  @override
  String get validationNameShort => translate('validation_name_short');

  @override
  String validationNumberRange(Object min, Object max) => translate('validation_number_range', <String, String>{'min': '$min', 'max': '$max'});

  @override
  String get validationNumericInvalid => translate('validation_numeric_invalid');

  @override
  String get validationOtpSixDigits => translate('validation_otp_six_digits');

  @override
  String get validationPasswordMismatch => translate('validation_password_mismatch');

  @override
  String get validationPasswordShort => translate('validation_password_short');

  @override
  String get validationPhoneInvalid => translate('validation_phone_invalid');

  @override
  String get validationRequired => translate('validation_required');

  @override
  String get validationTermsRequired => translate('validation_terms_required');

  @override
  String validationTooLong(Object max) => translate('validation_too_long', <String, String>{'max': '$max'});

  @override
  String get validationUrlInvalid => translate('validation_url_invalid');
}


final class AppLocalizationsEn extends AppLocalizations {
  const AppLocalizationsEn();

  static const Map<String, String> _strings = <String, String>{
    'app_name': 'Punto+',
    'app_tagline': 'Your rewards, always with you',
    'auth_accept_privacy': 'privacy policy',
    'auth_accept_privacy_prefix': 'and the',
    'auth_accept_terms': 'terms and conditions',
    'auth_accept_terms_prefix': 'I accept the',
    'auth_account_pending_verification': 'Verify your account to continue.',
    'auth_back_to_login': 'Back to log in',
    'auth_email_hint': 'you@email.com',
    'auth_email_label': 'Email address',
    'auth_forgot_action': 'Send code',
    'auth_forgot_password': 'Forgot your password?',
    'auth_forgot_subtitle': 'We will send you a code to reset your password.',
    'auth_forgot_success': 'Check your email: we sent a recovery code.',
    'auth_forgot_title': 'Recover your access',
    'auth_hide_password': 'Hide password',
    'auth_login_action': 'Continue',
    'auth_login_subtitle': 'Sign in with your account email or phone.',
    'auth_login_title': 'Welcome back',
    'auth_logout': 'Log out',
    'auth_logout_confirm_message': 'You will need to sign in again.',
    'auth_logout_confirm_title': 'Log out?',
    'auth_name_hint': 'Ana Perez',
    'auth_name_label': 'Full name',
    'auth_otp_label': 'Verification code',
    'auth_password_hint': 'At least 8 characters',
    'auth_password_label': 'Password',
    'auth_phone_hint': '555 123 4567',
    'auth_phone_label': 'Phone',
    'auth_register_action': 'Sign up',
    'auth_register_subtitle': 'Choose your account type to get started.',
    'auth_register_title': 'Create your account',
    'auth_remember_me': 'Remember me',
    'auth_reset_action': 'Update password',
    'auth_reset_code_label': 'Received code',
    'auth_reset_confirm_password_label': 'Repeat password',
    'auth_reset_new_password_label': 'New password',
    'auth_reset_subtitle': 'Enter the code you received and choose a new password.',
    'auth_reset_success': 'Your password was updated. Please log in again.',
    'auth_reset_title': 'New password',
    'auth_role_business': 'Business',
    'auth_role_business_description': 'Scan QRs and manage your program',
    'auth_role_customer': 'Customer',
    'auth_role_customer_description': 'Collect stamps and redeem rewards',
    'auth_role_label': 'Account type',
    'auth_session_expired': 'Your session expired. Please sign in again.',
    'auth_show_password': 'Show password',
    'auth_social_apple': 'Apple ID',
    'auth_social_divider': 'or continue with',
    'auth_social_google': 'Google',
    'auth_social_not_configured': 'Set the {provider} credentials to enable this sign-in.',
    'auth_social_setup_message': 'Configure {provider} credentials to enable this sign-in method.',
    'auth_verify_action': 'Verify',
    'auth_verify_change_destination': 'Change email or phone',
    'auth_verify_invalid': 'The code is incorrect or has expired.',
    'auth_verify_resend_action': 'Resend code',
    'auth_verify_resend_in': 'Resend in {seconds}s',
    'auth_verify_resend_success': 'We sent you a new code.',
    'auth_verify_subtitle': 'We sent a 6 digit code to {destination}.',
    'auth_verify_success': 'Your account is verified!',
    'auth_verify_title': 'Verify your account',
    'auth_welcome_benefit_1': 'All your cards in one place',
    'auth_welcome_benefit_2': 'Exclusive promotions from your favorites',
    'auth_welcome_benefit_3': 'No paper, no lost stamps',
    'auth_welcome_login': 'Log in',
    'auth_welcome_register': 'Create account',
    'auth_welcome_subtitle': 'Your rewards wallet for local businesses.',
    'auth_welcome_title': 'Welcome to Punto+',
    'business_about_title': 'About the business',
    'business_address': 'Address',
    'business_call_action': 'Call',
    'business_cards_title': 'Available cards',
    'business_closed_now': 'Closed',
    'business_directions_action': 'Directions',
    'business_directions_hint': 'Your maps app will open with directions to the business.',
    'business_distance_label': '{distance} km away',
    'business_error': 'We could not load the business.',
    'business_favorite_add': 'Save to favorites',
    'business_favorite_remove': 'Remove from favorites',
    'business_gallery': 'Gallery',
    'business_gallery_title': 'Gallery',
    'business_hours': 'Opening hours',
    'business_join_action': 'Join this card',
    'business_joined': 'You already have this card',
    'business_not_found_message': 'The business you are looking for is no longer available.',
    'business_not_found_title': 'Business not found',
    'business_open_now': 'Open now',
    'business_phone': 'Phone',
    'business_promotions_title': 'Promotions',
    'business_schedule_unavailable': 'Schedule available at the business',
    'business_share_action': 'Share business',
    'cards_completed_badge': 'Completed!',
    'cards_completed_on': 'Completed on {date}',
    'cards_detail_error': 'We could not load this card.',
    'cards_detail_title': 'Card details',
    'cards_empty_message': 'Join your first card with a business code.',
    'cards_empty_title': 'No cards yet',
    'cards_expires_on': 'Expires on {date}',
    'cards_history_empty': 'You have no stamps on this card yet.',
    'cards_history_title': 'Stamp history',
    'cards_inactive': 'Card paused',
    'cards_join_action': 'Join',
    'cards_join_already_member': 'You already have this card in your list.',
    'cards_join_code_hint': 'E.g. PP-5F3A9C or the QR content',
    'cards_join_code_label': 'Business code or QR',
    'cards_join_code_required': 'Enter the business code.',
    'cards_join_error': 'We could not validate the code. Check it and try again.',
    'cards_join_help': 'Ask the business staff for the code or scan their QR.',
    'cards_join_success': 'Done! You joined {business}.',
    'cards_join_title': 'Join a card',
    'cards_progress': '{current} of {total} stamps',
    'cards_ready_badge': 'Reward ready',
    'cards_remaining': '{count} stamps to go',
    'cards_reward_label': 'Reward',
    'cards_rules_message': 'Collect {stamps} stamps by showing your QR on each purchase and redeem your reward.',
    'cards_rules_title': 'How it works',
    'cards_show_qr_action': 'Show my QR',
    'cards_stamp_added_at': 'Stamp on {date}',
    'cards_stamps_title': 'Your stamps',
    'cards_subtitle': 'Tap a card to see your stamps and QR.',
    'cards_title': 'My cards',
    'common_accept': 'Accept',
    'common_all': 'All',
    'common_apply': 'Apply',
    'common_back': 'Back',
    'common_cancel': 'Cancel',
    'common_clear': 'Clear',
    'common_close': 'Close',
    'common_coming_soon': 'Coming soon',
    'common_continue_action': 'Continue',
    'common_copied': 'Copied to clipboard',
    'common_copy': 'Copy',
    'common_delete': 'Delete',
    'common_edit': 'Edit',
    'common_empty_generic_message': 'When there is information available you will see it here.',
    'common_empty_generic_title': 'Nothing here',
    'common_error_generic_message': 'We could not complete the operation. Please try again.',
    'common_error_generic_title': 'Something went wrong',
    'common_filters': 'Filters',
    'common_km_away': '{distance} km away',
    'common_list_view': 'List',
    'common_loading': 'Loading…',
    'common_map_view': 'Map',
    'common_new_badge': 'New',
    'common_no': 'No',
    'common_offline_banner': 'Offline: showing cached data',
    'common_ok': 'Got it',
    'common_optional': 'Optional',
    'common_points_count': '{count} pts',
    'common_required_indicator': 'Required',
    'common_retry': 'Retry',
    'common_save': 'Save',
    'common_saving': 'Saving…',
    'common_search': 'Search',
    'common_see_all': 'See all',
    'common_see_detail': 'View details',
    'common_share': 'Share',
    'common_stamps_count': '{count} stamps',
    'common_tab_home': 'Home',
    'common_tab_map': 'Map',
    'common_tab_profile': 'Profile',
    'common_tab_promotions': 'Promos',
    'common_tab_rewards': 'Rewards',
    'common_yes': 'Yes',
    'errors_cancelled': 'The request was cancelled.',
    'errors_connection': 'We could not connect. Check your internet connection.',
    'errors_forbidden': 'Your account cannot perform this action.',
    'errors_forbidden_message': 'Your account does not have permission to view this section.',
    'errors_forbidden_title': 'Restricted access',
    'errors_maintenance_message': 'We will be back in a few minutes. Thanks for your patience.',
    'errors_maintenance_title': 'We are under maintenance',
    'errors_no_connection_action': 'Retry',
    'errors_no_connection_message': 'Check your network and try again. Your cached data is still available.',
    'errors_no_connection_title': 'No connection',
    'errors_not_found': 'We could not find the information.',
    'errors_not_found_action': 'Go home',
    'errors_not_found_message': 'The route you are looking for does not exist or moved.',
    'errors_not_found_title': 'Screen not found',
    'errors_rate_limited': 'Too many attempts. Please wait a moment.',
    'errors_request_failed': 'We could not complete the request.',
    'errors_secure_connection': 'The secure connection could not be validated.',
    'errors_server': 'We had a server problem. Please try again later.',
    'errors_timeout': 'The connection took too long. Please try again.',
    'errors_unauthorized': 'Your sign-in details are not correct.',
    'errors_unauthorized_message': 'Please sign in again to continue.',
    'errors_unauthorized_title': 'Session required',
    'errors_unexpected': 'Something unexpected happened. Please try again.',
    'errors_validation_failed': 'Check the form fields.',
    'help_contact_message': 'Write to us and we will reply within 24 business hours.',
    'help_contact_title': 'Need more help?',
    'help_email_action': 'Email support',
    'help_faq_1_answer': 'Open the business card and show your QR code on each purchase. Staff scans it and the stamp appears instantly.',
    'help_faq_1_question': 'How do I collect stamps?',
    'help_faq_2_answer': 'Codes last a few minutes for security. Generate a new one from the QR screen and show it again.',
    'help_faq_2_question': 'What if my QR code expires?',
    'help_faq_3_answer': 'When you complete the stamps, the reward appears in the Rewards tab. Open it, tap redeem and show the code to the business.',
    'help_faq_3_question': 'How do I redeem a reward?',
    'help_faq_4_answer': 'Yes. When creating your account choose the Business type to scan QRs and manage your cards and promotions.',
    'help_faq_4_question': 'Can I register as a business?',
    'help_faq_5_answer': 'Go to Profile > Edit profile > Delete account. Your data will be permanently deleted.',
    'help_faq_5_question': 'How do I delete my account?',
    'help_faq_title': 'Frequently asked questions',
    'help_subtitle': 'Quick answers and support channels.',
    'help_title': 'Help and contact',
    'home_completed_banner': 'You have rewards ready!',
    'home_completed_banner_message': 'Complete a card and redeem your reward whenever you want.',
    'home_greeting': 'Hi, {name}!',
    'home_greeting_no_name': 'Hi there!',
    'home_my_cards_title': 'My cards',
    'home_nearby_title': 'Near you',
    'home_no_cards_message': 'Join a card with a business QR code and start collecting stamps.',
    'home_no_cards_title': 'You do not have cards yet',
    'home_points_card_subtitle': 'Redeemable in participating promotions',
    'home_points_card_title': 'Punto+ points',
    'home_promotions_title': 'Active promotions',
    'home_quick_join_card': 'Join a card',
    'home_quick_join_card_hint': 'Scan the business QR or type the code',
    'home_quick_nearby': 'Nearby businesses',
    'home_quick_promotions': 'Promotions',
    'home_quick_referral': 'Invite and earn',
    'home_quick_rewards': 'My rewards',
    'home_stats_cards': 'Active cards',
    'home_stats_completed': 'Completed',
    'home_stats_stamps': 'Total stamps',
    'home_subtitle': 'Here is your rewards summary.',
    'legal_about_contact': 'Contact',
    'legal_about_description': 'Punto+ is the rewards wallet for local businesses: collect stamps, discover promotions and redeem real rewards from your phone.',
    'legal_about_legal': 'Legal',
    'legal_about_made_for': 'Made for businesses and customers in Mexico.',
    'legal_about_title': 'About Punto+',
    'legal_about_version': 'Version',
    'legal_about_website': 'Website',
    'legal_error': 'We could not load the document.',
    'legal_privacy_title': 'Privacy policy',
    'legal_terms_title': 'Terms and conditions',
    'legal_updated_at': 'Last updated: {date}',
    'manage_cards_assets_background': 'Background image',
    'manage_cards_assets_error': 'We could not upload the image.',
    'manage_cards_assets_hint': 'PNG or JPG up to 2 MB. Requires the image picker plugin enabled.',
    'manage_cards_assets_logo': 'Business logo',
    'manage_cards_assets_stamp_icon': 'Stamp icon',
    'manage_cards_assets_title': 'Images',
    'manage_cards_assets_upload': 'Upload image',
    'manage_cards_assets_uploaded': 'Image uploaded.',
    'manage_cards_customers_count': '{count} customers',
    'manage_cards_delete_confirm_message': 'Customers will no longer be able to collect stamps on this card.',
    'manage_cards_delete_confirm_title': 'Delete card?',
    'manage_cards_deleted': 'Card deleted.',
    'manage_cards_empty_message': 'Create your first card, define the stamps and the reward.',
    'manage_cards_empty_title': 'You have no cards yet',
    'manage_cards_error': 'We could not load your cards.',
    'manage_cards_field_active': 'Active card',
    'manage_cards_field_active_subtitle': 'Customers can join and collect stamps',
    'manage_cards_field_color': 'Background color',
    'manage_cards_field_description': 'Description',
    'manage_cards_field_description_hint': 'Explain to your customers how it works',
    'manage_cards_field_name': 'Card name',
    'manage_cards_field_name_hint': 'E.g. House coffee',
    'manage_cards_field_required_stamps': 'Required stamps',
    'manage_cards_field_reward': 'Reward',
    'manage_cards_field_reward_hint': 'E.g. Free coffee',
    'manage_cards_form_create_title': 'New card',
    'manage_cards_form_edit_title': 'Edit card',
    'manage_cards_new_action': 'New card',
    'manage_cards_preview_title': 'Preview',
    'manage_cards_save_action': 'Save card',
    'manage_cards_save_error': 'We could not save the card.',
    'manage_cards_saved': 'Card saved.',
    'manage_cards_step_back': 'Back',
    'manage_cards_step_basics': 'Basics',
    'manage_cards_step_design': 'Design',
    'manage_cards_step_next': 'Next',
    'manage_cards_step_review': 'Review',
    'manage_cards_step_reward': 'Reward',
    'manage_cards_subtitle': 'Design the cards your customers will see.',
    'manage_cards_title': 'Loyalty cards',
    'manage_customers_card_progress': '{card}: {current}/{total}',
    'manage_customers_cards_count': '{count} cards',
    'manage_customers_customer_since': 'Customer since {date}',
    'manage_customers_detail_title': 'Customer details',
    'manage_customers_empty_message': 'When your customers scan their first QR they will appear here.',
    'manage_customers_empty_title': 'No customers yet',
    'manage_customers_error': 'We could not load your customers.',
    'manage_customers_error_detail': 'We could not load the customer.',
    'manage_customers_last_visit': 'Last visit: {date}',
    'manage_customers_search_hint': 'Search by name or email',
    'manage_customers_stamps_total': '{count} stamps collected',
    'manage_customers_subtitle': 'People collecting stamps on your cards.',
    'manage_customers_title': 'Loyal customers',
    'manage_dashboard_chart_empty': 'No data for this period',
    'manage_dashboard_chart_range_month': '30 days',
    'manage_dashboard_chart_range_week': '7 days',
    'manage_dashboard_chart_title': 'Stamps per day',
    'manage_dashboard_error': 'We could not load your metrics.',
    'manage_dashboard_greeting': 'Hi, {name}',
    'manage_dashboard_metric_active_cards': 'Active cards',
    'manage_dashboard_metric_customers': 'Loyal customers',
    'manage_dashboard_metric_redemptions': 'Redeemed rewards',
    'manage_dashboard_metric_stamps_month': 'Stamps this month',
    'manage_dashboard_metric_stamps_today': 'Stamps today',
    'manage_dashboard_quick_cards': 'My cards',
    'manage_dashboard_quick_customers': 'Customers',
    'manage_dashboard_quick_promotions': 'Promotions',
    'manage_dashboard_quick_scan': 'Scan QR',
    'manage_dashboard_recent_empty': 'No stamps registered today',
    'manage_dashboard_recent_stamps_title': 'Latest stamps',
    'manage_dashboard_subtitle': 'Here is how your loyalty program is doing.',
    'manage_dashboard_title': 'Business dashboard',
    'manage_dashboard_top_customers_title': 'Top customers',
    'manage_promotions_delete_confirm_message': 'It will stop being shown to customers.',
    'manage_promotions_delete_confirm_title': 'Delete promotion?',
    'manage_promotions_deleted': 'Promotion deleted.',
    'manage_promotions_empty_message': 'Create a promotion to attract more visits.',
    'manage_promotions_empty_title': 'No promotions',
    'manage_promotions_error': 'We could not load your promotions.',
    'manage_promotions_field_active': 'Active promotion',
    'manage_promotions_field_description': 'Description',
    'manage_promotions_field_ends_at': 'Ends',
    'manage_promotions_field_starts_at': 'Starts',
    'manage_promotions_field_title': 'Title',
    'manage_promotions_field_title_hint': '2 for 1 on drinks',
    'manage_promotions_form_create_title': 'New promotion',
    'manage_promotions_form_edit_title': 'Edit promotion',
    'manage_promotions_new_action': 'New promotion',
    'manage_promotions_pick_date': 'Pick date',
    'manage_promotions_save_action': 'Save promotion',
    'manage_promotions_save_error': 'We could not save the promotion.',
    'manage_promotions_saved': 'Promotion saved.',
    'manage_promotions_status_active': 'Active',
    'manage_promotions_status_expired': 'Expired',
    'manage_promotions_status_paused': 'Paused',
    'manage_promotions_status_scheduled': 'Scheduled',
    'manage_promotions_subtitle': 'Publish benefits for your customers.',
    'manage_promotions_title': 'Promotions',
    'manage_scan_camera_unavailable_message': 'This build does not include the scanner. Use manual entry with the customer code.',
    'manage_scan_camera_unavailable_title': 'Camera unavailable',
    'manage_scan_card_label': 'Card',
    'manage_scan_customer_label': 'Customer',
    'manage_scan_duplicate': 'That code was already registered in this session.',
    'manage_scan_error': 'We could not register the stamp.',
    'manage_scan_instruction': 'Point the camera at the customer QR code',
    'manage_scan_invalid_code': 'The code is invalid or has expired.',
    'manage_scan_manual_action': 'Register stamp',
    'manage_scan_manual_entry': 'Enter code manually',
    'manage_scan_manual_hint': 'Customer code',
    'manage_scan_processing': 'Registering stamp…',
    'manage_scan_recent_empty': 'No stamps registered today',
    'manage_scan_recent_title': 'Recent stamps',
    'manage_scan_reward_unlocked': 'The card is complete! The reward can be redeemed.',
    'manage_scan_scan_again': 'Scan another',
    'manage_scan_stamps_label': 'Stamps',
    'manage_scan_success_message': '{name} now has {count} stamps on {card}.',
    'manage_scan_success_title': 'Stamp registered!',
    'manage_scan_title': 'Scan QR',
    'map_businesses_found': '{count} businesses',
    'map_categories': 'Categories',
    'map_category_all': 'All',
    'map_empty_message': 'Try a wider radius or move the map to another area.',
    'map_empty_title': 'No businesses in this radius',
    'map_error': 'We could not load nearby businesses.',
    'map_favorites_only': 'Favorites only',
    'map_location_denied_message': 'You can enable the permission in system settings or pick an area manually.',
    'map_location_denied_title': 'No location access',
    'map_manual_location': 'Pick area',
    'map_manual_location_hint': 'City or neighborhood',
    'map_manual_location_saved': 'Using {area} as reference.',
    'map_my_location': 'My location',
    'map_open_settings': 'Open settings',
    'map_radius_label': 'Radius',
    'map_radius_value': '{km} km',
    'map_search_hint': 'Search business or category',
    'map_static_view_hint': 'Schematic view. Connect Google Maps for the full map.',
    'map_title': 'Business map',
    'map_you_are_here': 'You are here',
    'notifications_empty_message': 'You will see your stamps, rewards and promotions here.',
    'notifications_empty_title': 'No notifications',
    'notifications_error': 'We could not load notifications.',
    'notifications_mark_all_read': 'Mark all as read',
    'notifications_marked_read': 'Notifications marked as read.',
    'notifications_title': 'Notifications',
    'notifications_type_generic_title': 'Punto+ news',
    'notifications_type_promotion_body': '{business} published: {promotion}',
    'notifications_type_promotion_title': 'New promotion',
    'notifications_type_reward_body': 'You completed {card}. You can now redeem your reward.',
    'notifications_type_reward_title': 'Reward unlocked!',
    'notifications_type_stamp_body': '{business} added a stamp to your card ({count} total).',
    'notifications_type_stamp_title': 'Stamp registered',
    'onboarding_next': 'Next',
    'onboarding_skip': 'Skip',
    'onboarding_slide_1_message': 'Show your QR code on every visit and add stamps instantly.',
    'onboarding_slide_1_title': 'Collect stamps without paper cards',
    'onboarding_slide_2_message': 'Explore the map, find promotions and save your favorites.',
    'onboarding_slide_2_title': 'Discover businesses near you',
    'onboarding_slide_3_message': 'Completing your card unlocks rewards you can redeem right away.',
    'onboarding_slide_3_title': 'Redeem real rewards',
    'onboarding_slide_4_message': 'Scan QRs, build custom cards and review your metrics.',
    'onboarding_slide_4_title': 'For businesses, everything in one panel',
    'onboarding_start': 'Get started',
    'profile_about_action': 'About Punto+',
    'profile_avatar_change': 'Change photo',
    'profile_avatar_error': 'We could not upload the photo.',
    'profile_avatar_hint': 'Use a square photo of at least 400x400 px.',
    'profile_avatar_uploaded': 'Photo updated.',
    'profile_business_mode_action': 'Business mode',
    'profile_cards_count': 'Cards',
    'profile_change_password_action': 'Update password',
    'profile_change_password_confirm': 'Repeat new password',
    'profile_change_password_current': 'Current password',
    'profile_change_password_new': 'New password',
    'profile_change_password_success': 'Password updated.',
    'profile_change_password_title': 'Change password',
    'profile_delete_account_action': 'Delete my account',
    'profile_delete_account_confirm': 'Yes, delete',
    'profile_delete_account_error': 'We could not delete the account.',
    'profile_delete_account_message': 'Your cards, stamps and rewards will be deleted. This action cannot be undone.',
    'profile_delete_account_success': 'Your account was deleted.',
    'profile_delete_account_title': 'Delete account',
    'profile_edit_action': 'Edit profile',
    'profile_edit_error': 'We could not save your changes.',
    'profile_edit_success': 'Profile updated.',
    'profile_edit_title': 'Edit profile',
    'profile_help_action': 'Help and contact',
    'profile_legal_action': 'Terms and privacy',
    'profile_member_since': 'Member since {date}',
    'profile_notifications_action': 'Notifications',
    'profile_pending_verification': 'Pending verification',
    'profile_points': 'Points',
    'profile_referral_action': 'Invite your friends',
    'profile_reward_count': 'Rewards',
    'profile_role_admin': 'Administrator',
    'profile_role_business': 'Business',
    'profile_role_customer': 'Customer',
    'profile_settings_action': 'Settings',
    'profile_stamps_total': 'Stamps',
    'profile_stats_title': 'Your activity',
    'profile_switch_to_business': 'Switch to business mode',
    'profile_switch_to_customer': 'Back to customer mode',
    'profile_title': 'My profile',
    'profile_verified': 'Verified account',
    'profile_verify_action': 'Verify now',
    'promotions_detail_title': 'Promotion details',
    'promotions_empty_message': 'When your favorite businesses publish promotions you will see them here.',
    'promotions_empty_title': 'No active promotions',
    'promotions_error': 'We could not load promotions.',
    'promotions_expired': 'Expired promotion',
    'promotions_starts_on': 'From {date}',
    'promotions_subtitle': 'Active benefits from the businesses you follow.',
    'promotions_terms': 'See terms at the business',
    'promotions_title': 'Promotions',
    'promotions_valid_until': 'Valid until {date}',
    'qr_brightness_hint': 'We set your screen brightness to maximum.',
    'qr_brightness_unavailable': 'Turn up your screen brightness for a faster scan.',
    'qr_camera_unavailable': 'Camera scanning requires the scanner plugin.',
    'qr_code_label': 'Manual code',
    'qr_error': 'We could not generate your code. Please try again.',
    'qr_expired_message': 'Generate a new one to keep collecting.',
    'qr_expired_title': 'Your code expired',
    'qr_expires_at': 'Valid until {time}',
    'qr_expires_in': 'Expires in {seconds}s',
    'qr_instruction': 'Ask the staff to scan this code',
    'qr_regenerate_action': 'Generate new code',
    'qr_share_code': 'Share code',
    'qr_subtitle': 'Show it at {business} to add a stamp.',
    'qr_title': 'Your QR code',
    'referral_code_label': 'Your code',
    'referral_completed_label': 'Completed',
    'referral_copy_action': 'Copy code',
    'referral_empty_message': 'Share your code and start earning extra points.',
    'referral_empty_title': 'You have not invited anyone yet',
    'referral_error': 'We could not load your referrals.',
    'referral_how_title': 'How does it work?',
    'referral_invited_count': '{count} invites',
    'referral_pending_label': 'Pending',
    'referral_share_action': 'Share invitation',
    'referral_share_message': 'Join Punto+ with my code {code} and start collecting rewards!',
    'referral_step_1': 'Share your code with whoever you want to invite.',
    'referral_step_2': 'Your guest signs up and collects their first stamp.',
    'referral_step_3': 'You both receive points in your account.',
    'referral_subtitle': 'Share your code: you and your guest get points after the first stamp.',
    'referral_title': 'Invite and earn',
    'rewards_code_label': 'Redemption code',
    'rewards_detail_title': 'Reward details',
    'rewards_empty_available_message': 'Complete a card to unlock your first reward.',
    'rewards_empty_available_title': 'No rewards yet',
    'rewards_empty_expired_message': 'Expired rewards will appear in this tab.',
    'rewards_empty_expired_title': 'Nothing expired',
    'rewards_empty_redeemed_message': 'Once you redeem a reward you will see it here.',
    'rewards_empty_redeemed_title': 'No redemptions yet',
    'rewards_expires_on': 'Expires on {date}',
    'rewards_redeem_action': 'Redeem reward',
    'rewards_redeem_confirm_action': 'Yes, redeem',
    'rewards_redeem_confirm_message': 'Show the redemption code to the business staff to confirm it.',
    'rewards_redeem_confirm_title': 'Redeem this reward?',
    'rewards_redeem_error': 'We could not redeem the reward.',
    'rewards_redeem_success': 'Reward redeemed! Show the code to the business.',
    'rewards_redeemed_at': 'Redeemed on {date}',
    'rewards_requires_stamps': 'Requires completing {count} stamps',
    'rewards_status_available': 'Available',
    'rewards_status_expired': 'Expired',
    'rewards_status_redeemed': 'Redeemed',
    'rewards_tab_available': 'Available',
    'rewards_tab_expired': 'Expired',
    'rewards_tab_redeemed': 'Redeemed',
    'rewards_title': 'My rewards',
    'settings_appearance_title': 'Appearance',
    'settings_cache_clear': 'Clear cached data',
    'settings_cache_cleared': 'Cached data cleared.',
    'settings_cache_subtitle': 'Your cards will be downloaded again when you open the app',
    'settings_data_title': 'Data',
    'settings_language_en': 'English',
    'settings_language_es': 'Spanish',
    'settings_language_label': 'Language',
    'settings_language_system': 'System',
    'settings_location_auto': 'Use my location',
    'settings_location_auto_subtitle': 'Nearby business recommendations',
    'settings_location_manual': 'Reference area',
    'settings_location_manual_hint': 'City or neighborhood',
    'settings_location_title': 'Location',
    'settings_notifications_title': 'Notifications',
    'settings_notify_general': 'General notices',
    'settings_notify_promotions': 'Promotions',
    'settings_notify_promotions_subtitle': 'News from your favorite businesses',
    'settings_notify_rewards': 'Available rewards',
    'settings_notify_rewards_subtitle': 'When you complete a card',
    'settings_notify_stamps': 'New stamps',
    'settings_notify_stamps_subtitle': 'Alerts when you collect a stamp',
    'settings_preferences_saved': 'Preferences saved.',
    'settings_theme_dark': 'Dark',
    'settings_theme_label': 'Theme',
    'settings_theme_light': 'Light',
    'settings_theme_system': 'System',
    'settings_title': 'Settings',
    'settings_version_label': 'Version {version}',
    'time_days_ago': '{days} days ago',
    'time_hours_ago': '{hours} h ago',
    'time_just_now': 'Just now',
    'time_minutes_ago': '{minutes} min ago',
    'time_today': 'Today',
    'time_weeks_ago': '{weeks} weeks ago',
    'time_yesterday': 'Yesterday',
    'validation_code_invalid': 'Invalid code',
    'validation_date_order': 'The end date must be after the start date',
    'validation_email_invalid': 'Invalid email',
    'validation_email_or_phone_invalid': 'Enter a valid email or phone number',
    'validation_name_short': 'Enter your full name',
    'validation_number_range': 'Enter a value between {min} and {max}',
    'validation_numeric_invalid': 'Enter numbers only',
    'validation_otp_six_digits': 'Enter the 6 digits',
    'validation_password_mismatch': 'Passwords do not match',
    'validation_password_short': 'Use at least 8 characters',
    'validation_phone_invalid': 'Invalid phone number',
    'validation_required': 'Required field',
    'validation_terms_required': 'You must accept the terms and privacy policy',
    'validation_too_long': 'Maximum {max} characters',
    'validation_url_invalid': 'Invalid link',
  };

  @override
  Locale get locale => const Locale('en');

  @override
  String translate(String key, [Map<String, String>? args]) {
    var value = _strings[key] ?? key;
    if (args != null) {
      args.forEach((String name, String replacement) {
        value = value.replaceAll('{$name}', replacement);
      });
    }
    return value;
  }

  String get appName;
  String get appTagline;
  String get authAcceptPrivacy;
  String get authAcceptPrivacyPrefix;
  String get authAcceptTerms;
  String get authAcceptTermsPrefix;
  String get authAccountPendingVerification;
  String get authBackToLogin;
  String get authEmailHint;
  String get authEmailLabel;
  String get authForgotAction;
  String get authForgotPassword;
  String get authForgotSubtitle;
  String get authForgotSuccess;
  String get authForgotTitle;
  String get authHidePassword;
  String get authLoginAction;
  String get authLoginSubtitle;
  String get authLoginTitle;
  String get authLogout;
  String get authLogoutConfirmMessage;
  String get authLogoutConfirmTitle;
  String get authNameHint;
  String get authNameLabel;
  String get authOtpLabel;
  String get authPasswordHint;
  String get authPasswordLabel;
  String get authPhoneHint;
  String get authPhoneLabel;
  String get authRegisterAction;
  String get authRegisterSubtitle;
  String get authRegisterTitle;
  String get authRememberMe;
  String get authResetAction;
  String get authResetCodeLabel;
  String get authResetConfirmPasswordLabel;
  String get authResetNewPasswordLabel;
  String get authResetSubtitle;
  String get authResetSuccess;
  String get authResetTitle;
  String get authRoleBusiness;
  String get authRoleBusinessDescription;
  String get authRoleCustomer;
  String get authRoleCustomerDescription;
  String get authRoleLabel;
  String get authSessionExpired;
  String get authShowPassword;
  String get authSocialApple;
  String get authSocialDivider;
  String get authSocialGoogle;
  String authSocialNotConfigured(Object provider);
  String authSocialSetupMessage(Object provider);
  String get authVerifyAction;
  String get authVerifyChangeDestination;
  String get authVerifyInvalid;
  String get authVerifyResendAction;
  String authVerifyResendIn(Object seconds);
  String get authVerifyResendSuccess;
  String authVerifySubtitle(Object destination);
  String get authVerifySuccess;
  String get authVerifyTitle;
  String get authWelcomeBenefit1;
  String get authWelcomeBenefit2;
  String get authWelcomeBenefit3;
  String get authWelcomeLogin;
  String get authWelcomeRegister;
  String get authWelcomeSubtitle;
  String get authWelcomeTitle;
  String get businessAboutTitle;
  String get businessAddress;
  String get businessCallAction;
  String get businessCardsTitle;
  String get businessClosedNow;
  String get businessDirectionsAction;
  String get businessDirectionsHint;
  String businessDistanceLabel(Object distance);
  String get businessError;
  String get businessFavoriteAdd;
  String get businessFavoriteRemove;
  String get businessGallery;
  String get businessGalleryTitle;
  String get businessHours;
  String get businessJoinAction;
  String get businessJoined;
  String get businessNotFoundMessage;
  String get businessNotFoundTitle;
  String get businessOpenNow;
  String get businessPhone;
  String get businessPromotionsTitle;
  String get businessScheduleUnavailable;
  String get businessShareAction;
  String get cardsCompletedBadge;
  String cardsCompletedOn(Object date);
  String get cardsDetailError;
  String get cardsDetailTitle;
  String get cardsEmptyMessage;
  String get cardsEmptyTitle;
  String cardsExpiresOn(Object date);
  String get cardsHistoryEmpty;
  String get cardsHistoryTitle;
  String get cardsInactive;
  String get cardsJoinAction;
  String get cardsJoinAlreadyMember;
  String get cardsJoinCodeHint;
  String get cardsJoinCodeLabel;
  String get cardsJoinCodeRequired;
  String get cardsJoinError;
  String get cardsJoinHelp;
  String cardsJoinSuccess(Object business);
  String get cardsJoinTitle;
  String cardsProgress(Object current, Object total);
  String get cardsReadyBadge;
  String cardsRemaining(Object count);
  String get cardsRewardLabel;
  String cardsRulesMessage(Object stamps);
  String get cardsRulesTitle;
  String get cardsShowQrAction;
  String cardsStampAddedAt(Object date);
  String get cardsStampsTitle;
  String get cardsSubtitle;
  String get cardsTitle;
  String get commonAccept;
  String get commonAll;
  String get commonApply;
  String get commonBack;
  String get commonCancel;
  String get commonClear;
  String get commonClose;
  String get commonComingSoon;
  String get commonContinueAction;
  String get commonCopied;
  String get commonCopy;
  String get commonDelete;
  String get commonEdit;
  String get commonEmptyGenericMessage;
  String get commonEmptyGenericTitle;
  String get commonErrorGenericMessage;
  String get commonErrorGenericTitle;
  String get commonFilters;
  String commonKmAway(Object distance);
  String get commonListView;
  String get commonLoading;
  String get commonMapView;
  String get commonNewBadge;
  String get commonNo;
  String get commonOfflineBanner;
  String get commonOk;
  String get commonOptional;
  String commonPointsCount(Object count);
  String get commonRequiredIndicator;
  String get commonRetry;
  String get commonSave;
  String get commonSaving;
  String get commonSearch;
  String get commonSeeAll;
  String get commonSeeDetail;
  String get commonShare;
  String commonStampsCount(Object count);
  String get commonTabHome;
  String get commonTabMap;
  String get commonTabProfile;
  String get commonTabPromotions;
  String get commonTabRewards;
  String get commonYes;
  String get errorsCancelled;
  String get errorsConnection;
  String get errorsForbidden;
  String get errorsForbiddenMessage;
  String get errorsForbiddenTitle;
  String get errorsMaintenanceMessage;
  String get errorsMaintenanceTitle;
  String get errorsNoConnectionAction;
  String get errorsNoConnectionMessage;
  String get errorsNoConnectionTitle;
  String get errorsNotFound;
  String get errorsNotFoundAction;
  String get errorsNotFoundMessage;
  String get errorsNotFoundTitle;
  String get errorsRateLimited;
  String get errorsRequestFailed;
  String get errorsSecureConnection;
  String get errorsServer;
  String get errorsTimeout;
  String get errorsUnauthorized;
  String get errorsUnauthorizedMessage;
  String get errorsUnauthorizedTitle;
  String get errorsUnexpected;
  String get errorsValidationFailed;
  String get helpContactMessage;
  String get helpContactTitle;
  String get helpEmailAction;
  String get helpFaq1Answer;
  String get helpFaq1Question;
  String get helpFaq2Answer;
  String get helpFaq2Question;
  String get helpFaq3Answer;
  String get helpFaq3Question;
  String get helpFaq4Answer;
  String get helpFaq4Question;
  String get helpFaq5Answer;
  String get helpFaq5Question;
  String get helpFaqTitle;
  String get helpSubtitle;
  String get helpTitle;
  String get homeCompletedBanner;
  String get homeCompletedBannerMessage;
  String homeGreeting(Object name);
  String get homeGreetingNoName;
  String get homeMyCardsTitle;
  String get homeNearbyTitle;
  String get homeNoCardsMessage;
  String get homeNoCardsTitle;
  String get homePointsCardSubtitle;
  String get homePointsCardTitle;
  String get homePromotionsTitle;
  String get homeQuickJoinCard;
  String get homeQuickJoinCardHint;
  String get homeQuickNearby;
  String get homeQuickPromotions;
  String get homeQuickReferral;
  String get homeQuickRewards;
  String get homeStatsCards;
  String get homeStatsCompleted;
  String get homeStatsStamps;
  String get homeSubtitle;
  String get legalAboutContact;
  String get legalAboutDescription;
  String get legalAboutLegal;
  String get legalAboutMadeFor;
  String get legalAboutTitle;
  String get legalAboutVersion;
  String get legalAboutWebsite;
  String get legalError;
  String get legalPrivacyTitle;
  String get legalTermsTitle;
  String legalUpdatedAt(Object date);
  String get manageCardsAssetsBackground;
  String get manageCardsAssetsError;
  String get manageCardsAssetsHint;
  String get manageCardsAssetsLogo;
  String get manageCardsAssetsStampIcon;
  String get manageCardsAssetsTitle;
  String get manageCardsAssetsUpload;
  String get manageCardsAssetsUploaded;
  String manageCardsCustomersCount(Object count);
  String get manageCardsDeleteConfirmMessage;
  String get manageCardsDeleteConfirmTitle;
  String get manageCardsDeleted;
  String get manageCardsEmptyMessage;
  String get manageCardsEmptyTitle;
  String get manageCardsError;
  String get manageCardsFieldActive;
  String get manageCardsFieldActiveSubtitle;
  String get manageCardsFieldColor;
  String get manageCardsFieldDescription;
  String get manageCardsFieldDescriptionHint;
  String get manageCardsFieldName;
  String get manageCardsFieldNameHint;
  String get manageCardsFieldRequiredStamps;
  String get manageCardsFieldReward;
  String get manageCardsFieldRewardHint;
  String get manageCardsFormCreateTitle;
  String get manageCardsFormEditTitle;
  String get manageCardsNewAction;
  String get manageCardsPreviewTitle;
  String get manageCardsSaveAction;
  String get manageCardsSaveError;
  String get manageCardsSaved;
  String get manageCardsStepBack;
  String get manageCardsStepBasics;
  String get manageCardsStepDesign;
  String get manageCardsStepNext;
  String get manageCardsStepReview;
  String get manageCardsStepReward;
  String get manageCardsSubtitle;
  String get manageCardsTitle;
  String manageCustomersCardProgress(Object card, Object current, Object total);
  String manageCustomersCardsCount(Object count);
  String manageCustomersCustomerSince(Object date);
  String get manageCustomersDetailTitle;
  String get manageCustomersEmptyMessage;
  String get manageCustomersEmptyTitle;
  String get manageCustomersError;
  String get manageCustomersErrorDetail;
  String manageCustomersLastVisit(Object date);
  String get manageCustomersSearchHint;
  String manageCustomersStampsTotal(Object count);
  String get manageCustomersSubtitle;
  String get manageCustomersTitle;
  String get manageDashboardChartEmpty;
  String get manageDashboardChartRangeMonth;
  String get manageDashboardChartRangeWeek;
  String get manageDashboardChartTitle;
  String get manageDashboardError;
  String manageDashboardGreeting(Object name);
  String get manageDashboardMetricActiveCards;
  String get manageDashboardMetricCustomers;
  String get manageDashboardMetricRedemptions;
  String get manageDashboardMetricStampsMonth;
  String get manageDashboardMetricStampsToday;
  String get manageDashboardQuickCards;
  String get manageDashboardQuickCustomers;
  String get manageDashboardQuickPromotions;
  String get manageDashboardQuickScan;
  String get manageDashboardRecentEmpty;
  String get manageDashboardRecentStampsTitle;
  String get manageDashboardSubtitle;
  String get manageDashboardTitle;
  String get manageDashboardTopCustomersTitle;
  String get managePromotionsDeleteConfirmMessage;
  String get managePromotionsDeleteConfirmTitle;
  String get managePromotionsDeleted;
  String get managePromotionsEmptyMessage;
  String get managePromotionsEmptyTitle;
  String get managePromotionsError;
  String get managePromotionsFieldActive;
  String get managePromotionsFieldDescription;
  String get managePromotionsFieldEndsAt;
  String get managePromotionsFieldStartsAt;
  String get managePromotionsFieldTitle;
  String get managePromotionsFieldTitleHint;
  String get managePromotionsFormCreateTitle;
  String get managePromotionsFormEditTitle;
  String get managePromotionsNewAction;
  String get managePromotionsPickDate;
  String get managePromotionsSaveAction;
  String get managePromotionsSaveError;
  String get managePromotionsSaved;
  String get managePromotionsStatusActive;
  String get managePromotionsStatusExpired;
  String get managePromotionsStatusPaused;
  String get managePromotionsStatusScheduled;
  String get managePromotionsSubtitle;
  String get managePromotionsTitle;
  String get manageScanCameraUnavailableMessage;
  String get manageScanCameraUnavailableTitle;
  String get manageScanCardLabel;
  String get manageScanCustomerLabel;
  String get manageScanDuplicate;
  String get manageScanError;
  String get manageScanInstruction;
  String get manageScanInvalidCode;
  String get manageScanManualAction;
  String get manageScanManualEntry;
  String get manageScanManualHint;
  String get manageScanProcessing;
  String get manageScanRecentEmpty;
  String get manageScanRecentTitle;
  String get manageScanRewardUnlocked;
  String get manageScanScanAgain;
  String get manageScanStampsLabel;
  String manageScanSuccessMessage(Object name, Object count, Object card);
  String get manageScanSuccessTitle;
  String get manageScanTitle;
  String mapBusinessesFound(Object count);
  String get mapCategories;
  String get mapCategoryAll;
  String get mapEmptyMessage;
  String get mapEmptyTitle;
  String get mapError;
  String get mapFavoritesOnly;
  String get mapLocationDeniedMessage;
  String get mapLocationDeniedTitle;
  String get mapManualLocation;
  String get mapManualLocationHint;
  String mapManualLocationSaved(Object area);
  String get mapMyLocation;
  String get mapOpenSettings;
  String get mapRadiusLabel;
  String mapRadiusValue(Object km);
  String get mapSearchHint;
  String get mapStaticViewHint;
  String get mapTitle;
  String get mapYouAreHere;
  String get notificationsEmptyMessage;
  String get notificationsEmptyTitle;
  String get notificationsError;
  String get notificationsMarkAllRead;
  String get notificationsMarkedRead;
  String get notificationsTitle;
  String get notificationsTypeGenericTitle;
  String notificationsTypePromotionBody(Object business, Object promotion);
  String get notificationsTypePromotionTitle;
  String notificationsTypeRewardBody(Object card);
  String get notificationsTypeRewardTitle;
  String notificationsTypeStampBody(Object business, Object count);
  String get notificationsTypeStampTitle;
  String get onboardingNext;
  String get onboardingSkip;
  String get onboardingSlide1Message;
  String get onboardingSlide1Title;
  String get onboardingSlide2Message;
  String get onboardingSlide2Title;
  String get onboardingSlide3Message;
  String get onboardingSlide3Title;
  String get onboardingSlide4Message;
  String get onboardingSlide4Title;
  String get onboardingStart;
  String get profileAboutAction;
  String get profileAvatarChange;
  String get profileAvatarError;
  String get profileAvatarHint;
  String get profileAvatarUploaded;
  String get profileBusinessModeAction;
  String get profileCardsCount;
  String get profileChangePasswordAction;
  String get profileChangePasswordConfirm;
  String get profileChangePasswordCurrent;
  String get profileChangePasswordNew;
  String get profileChangePasswordSuccess;
  String get profileChangePasswordTitle;
  String get profileDeleteAccountAction;
  String get profileDeleteAccountConfirm;
  String get profileDeleteAccountError;
  String get profileDeleteAccountMessage;
  String get profileDeleteAccountSuccess;
  String get profileDeleteAccountTitle;
  String get profileEditAction;
  String get profileEditError;
  String get profileEditSuccess;
  String get profileEditTitle;
  String get profileHelpAction;
  String get profileLegalAction;
  String profileMemberSince(Object date);
  String get profileNotificationsAction;
  String get profilePendingVerification;
  String get profilePoints;
  String get profileReferralAction;
  String get profileRewardCount;
  String get profileRoleAdmin;
  String get profileRoleBusiness;
  String get profileRoleCustomer;
  String get profileSettingsAction;
  String get profileStampsTotal;
  String get profileStatsTitle;
  String get profileSwitchToBusiness;
  String get profileSwitchToCustomer;
  String get profileTitle;
  String get profileVerified;
  String get profileVerifyAction;
  String get promotionsDetailTitle;
  String get promotionsEmptyMessage;
  String get promotionsEmptyTitle;
  String get promotionsError;
  String get promotionsExpired;
  String promotionsStartsOn(Object date);
  String get promotionsSubtitle;
  String get promotionsTerms;
  String get promotionsTitle;
  String promotionsValidUntil(Object date);
  String get qrBrightnessHint;
  String get qrBrightnessUnavailable;
  String get qrCameraUnavailable;
  String get qrCodeLabel;
  String get qrError;
  String get qrExpiredMessage;
  String get qrExpiredTitle;
  String qrExpiresAt(Object time);
  String qrExpiresIn(Object seconds);
  String get qrInstruction;
  String get qrRegenerateAction;
  String get qrShareCode;
  String qrSubtitle(Object business);
  String get qrTitle;
  String get referralCodeLabel;
  String get referralCompletedLabel;
  String get referralCopyAction;
  String get referralEmptyMessage;
  String get referralEmptyTitle;
  String get referralError;
  String get referralHowTitle;
  String referralInvitedCount(Object count);
  String get referralPendingLabel;
  String get referralShareAction;
  String referralShareMessage(Object code);
  String get referralStep1;
  String get referralStep2;
  String get referralStep3;
  String get referralSubtitle;
  String get referralTitle;
  String get rewardsCodeLabel;
  String get rewardsDetailTitle;
  String get rewardsEmptyAvailableMessage;
  String get rewardsEmptyAvailableTitle;
  String get rewardsEmptyExpiredMessage;
  String get rewardsEmptyExpiredTitle;
  String get rewardsEmptyRedeemedMessage;
  String get rewardsEmptyRedeemedTitle;
  String rewardsExpiresOn(Object date);
  String get rewardsRedeemAction;
  String get rewardsRedeemConfirmAction;
  String get rewardsRedeemConfirmMessage;
  String get rewardsRedeemConfirmTitle;
  String get rewardsRedeemError;
  String get rewardsRedeemSuccess;
  String rewardsRedeemedAt(Object date);
  String rewardsRequiresStamps(Object count);
  String get rewardsStatusAvailable;
  String get rewardsStatusExpired;
  String get rewardsStatusRedeemed;
  String get rewardsTabAvailable;
  String get rewardsTabExpired;
  String get rewardsTabRedeemed;
  String get rewardsTitle;
  String get settingsAppearanceTitle;
  String get settingsCacheClear;
  String get settingsCacheCleared;
  String get settingsCacheSubtitle;
  String get settingsDataTitle;
  String get settingsLanguageEn;
  String get settingsLanguageEs;
  String get settingsLanguageLabel;
  String get settingsLanguageSystem;
  String get settingsLocationAuto;
  String get settingsLocationAutoSubtitle;
  String get settingsLocationManual;
  String get settingsLocationManualHint;
  String get settingsLocationTitle;
  String get settingsNotificationsTitle;
  String get settingsNotifyGeneral;
  String get settingsNotifyPromotions;
  String get settingsNotifyPromotionsSubtitle;
  String get settingsNotifyRewards;
  String get settingsNotifyRewardsSubtitle;
  String get settingsNotifyStamps;
  String get settingsNotifyStampsSubtitle;
  String get settingsPreferencesSaved;
  String get settingsThemeDark;
  String get settingsThemeLabel;
  String get settingsThemeLight;
  String get settingsThemeSystem;
  String get settingsTitle;
  String settingsVersionLabel(Object version);
  String timeDaysAgo(Object days);
  String timeHoursAgo(Object hours);
  String get timeJustNow;
  String timeMinutesAgo(Object minutes);
  String get timeToday;
  String timeWeeksAgo(Object weeks);
  String get timeYesterday;
  String get validationCodeInvalid;
  String get validationDateOrder;
  String get validationEmailInvalid;
  String get validationEmailOrPhoneInvalid;
  String get validationNameShort;
  String validationNumberRange(Object min, Object max);
  String get validationNumericInvalid;
  String get validationOtpSixDigits;
  String get validationPasswordMismatch;
  String get validationPasswordShort;
  String get validationPhoneInvalid;
  String get validationRequired;
  String get validationTermsRequired;
  String validationTooLong(Object max);
  String get validationUrlInvalid;

  @override
  String get appName => translate('app_name');

  @override
  String get appTagline => translate('app_tagline');

  @override
  String get authAcceptPrivacy => translate('auth_accept_privacy');

  @override
  String get authAcceptPrivacyPrefix => translate('auth_accept_privacy_prefix');

  @override
  String get authAcceptTerms => translate('auth_accept_terms');

  @override
  String get authAcceptTermsPrefix => translate('auth_accept_terms_prefix');

  @override
  String get authAccountPendingVerification => translate('auth_account_pending_verification');

  @override
  String get authBackToLogin => translate('auth_back_to_login');

  @override
  String get authEmailHint => translate('auth_email_hint');

  @override
  String get authEmailLabel => translate('auth_email_label');

  @override
  String get authForgotAction => translate('auth_forgot_action');

  @override
  String get authForgotPassword => translate('auth_forgot_password');

  @override
  String get authForgotSubtitle => translate('auth_forgot_subtitle');

  @override
  String get authForgotSuccess => translate('auth_forgot_success');

  @override
  String get authForgotTitle => translate('auth_forgot_title');

  @override
  String get authHidePassword => translate('auth_hide_password');

  @override
  String get authLoginAction => translate('auth_login_action');

  @override
  String get authLoginSubtitle => translate('auth_login_subtitle');

  @override
  String get authLoginTitle => translate('auth_login_title');

  @override
  String get authLogout => translate('auth_logout');

  @override
  String get authLogoutConfirmMessage => translate('auth_logout_confirm_message');

  @override
  String get authLogoutConfirmTitle => translate('auth_logout_confirm_title');

  @override
  String get authNameHint => translate('auth_name_hint');

  @override
  String get authNameLabel => translate('auth_name_label');

  @override
  String get authOtpLabel => translate('auth_otp_label');

  @override
  String get authPasswordHint => translate('auth_password_hint');

  @override
  String get authPasswordLabel => translate('auth_password_label');

  @override
  String get authPhoneHint => translate('auth_phone_hint');

  @override
  String get authPhoneLabel => translate('auth_phone_label');

  @override
  String get authRegisterAction => translate('auth_register_action');

  @override
  String get authRegisterSubtitle => translate('auth_register_subtitle');

  @override
  String get authRegisterTitle => translate('auth_register_title');

  @override
  String get authRememberMe => translate('auth_remember_me');

  @override
  String get authResetAction => translate('auth_reset_action');

  @override
  String get authResetCodeLabel => translate('auth_reset_code_label');

  @override
  String get authResetConfirmPasswordLabel => translate('auth_reset_confirm_password_label');

  @override
  String get authResetNewPasswordLabel => translate('auth_reset_new_password_label');

  @override
  String get authResetSubtitle => translate('auth_reset_subtitle');

  @override
  String get authResetSuccess => translate('auth_reset_success');

  @override
  String get authResetTitle => translate('auth_reset_title');

  @override
  String get authRoleBusiness => translate('auth_role_business');

  @override
  String get authRoleBusinessDescription => translate('auth_role_business_description');

  @override
  String get authRoleCustomer => translate('auth_role_customer');

  @override
  String get authRoleCustomerDescription => translate('auth_role_customer_description');

  @override
  String get authRoleLabel => translate('auth_role_label');

  @override
  String get authSessionExpired => translate('auth_session_expired');

  @override
  String get authShowPassword => translate('auth_show_password');

  @override
  String get authSocialApple => translate('auth_social_apple');

  @override
  String get authSocialDivider => translate('auth_social_divider');

  @override
  String get authSocialGoogle => translate('auth_social_google');

  @override
  String authSocialNotConfigured(Object provider) => translate('auth_social_not_configured', <String, String>{'provider': '$provider'});

  @override
  String authSocialSetupMessage(Object provider) => translate('auth_social_setup_message', <String, String>{'provider': '$provider'});

  @override
  String get authVerifyAction => translate('auth_verify_action');

  @override
  String get authVerifyChangeDestination => translate('auth_verify_change_destination');

  @override
  String get authVerifyInvalid => translate('auth_verify_invalid');

  @override
  String get authVerifyResendAction => translate('auth_verify_resend_action');

  @override
  String authVerifyResendIn(Object seconds) => translate('auth_verify_resend_in', <String, String>{'seconds': '$seconds'});

  @override
  String get authVerifyResendSuccess => translate('auth_verify_resend_success');

  @override
  String authVerifySubtitle(Object destination) => translate('auth_verify_subtitle', <String, String>{'destination': '$destination'});

  @override
  String get authVerifySuccess => translate('auth_verify_success');

  @override
  String get authVerifyTitle => translate('auth_verify_title');

  @override
  String get authWelcomeBenefit1 => translate('auth_welcome_benefit_1');

  @override
  String get authWelcomeBenefit2 => translate('auth_welcome_benefit_2');

  @override
  String get authWelcomeBenefit3 => translate('auth_welcome_benefit_3');

  @override
  String get authWelcomeLogin => translate('auth_welcome_login');

  @override
  String get authWelcomeRegister => translate('auth_welcome_register');

  @override
  String get authWelcomeSubtitle => translate('auth_welcome_subtitle');

  @override
  String get authWelcomeTitle => translate('auth_welcome_title');

  @override
  String get businessAboutTitle => translate('business_about_title');

  @override
  String get businessAddress => translate('business_address');

  @override
  String get businessCallAction => translate('business_call_action');

  @override
  String get businessCardsTitle => translate('business_cards_title');

  @override
  String get businessClosedNow => translate('business_closed_now');

  @override
  String get businessDirectionsAction => translate('business_directions_action');

  @override
  String get businessDirectionsHint => translate('business_directions_hint');

  @override
  String businessDistanceLabel(Object distance) => translate('business_distance_label', <String, String>{'distance': '$distance'});

  @override
  String get businessError => translate('business_error');

  @override
  String get businessFavoriteAdd => translate('business_favorite_add');

  @override
  String get businessFavoriteRemove => translate('business_favorite_remove');

  @override
  String get businessGallery => translate('business_gallery');

  @override
  String get businessGalleryTitle => translate('business_gallery_title');

  @override
  String get businessHours => translate('business_hours');

  @override
  String get businessJoinAction => translate('business_join_action');

  @override
  String get businessJoined => translate('business_joined');

  @override
  String get businessNotFoundMessage => translate('business_not_found_message');

  @override
  String get businessNotFoundTitle => translate('business_not_found_title');

  @override
  String get businessOpenNow => translate('business_open_now');

  @override
  String get businessPhone => translate('business_phone');

  @override
  String get businessPromotionsTitle => translate('business_promotions_title');

  @override
  String get businessScheduleUnavailable => translate('business_schedule_unavailable');

  @override
  String get businessShareAction => translate('business_share_action');

  @override
  String get cardsCompletedBadge => translate('cards_completed_badge');

  @override
  String cardsCompletedOn(Object date) => translate('cards_completed_on', <String, String>{'date': '$date'});

  @override
  String get cardsDetailError => translate('cards_detail_error');

  @override
  String get cardsDetailTitle => translate('cards_detail_title');

  @override
  String get cardsEmptyMessage => translate('cards_empty_message');

  @override
  String get cardsEmptyTitle => translate('cards_empty_title');

  @override
  String cardsExpiresOn(Object date) => translate('cards_expires_on', <String, String>{'date': '$date'});

  @override
  String get cardsHistoryEmpty => translate('cards_history_empty');

  @override
  String get cardsHistoryTitle => translate('cards_history_title');

  @override
  String get cardsInactive => translate('cards_inactive');

  @override
  String get cardsJoinAction => translate('cards_join_action');

  @override
  String get cardsJoinAlreadyMember => translate('cards_join_already_member');

  @override
  String get cardsJoinCodeHint => translate('cards_join_code_hint');

  @override
  String get cardsJoinCodeLabel => translate('cards_join_code_label');

  @override
  String get cardsJoinCodeRequired => translate('cards_join_code_required');

  @override
  String get cardsJoinError => translate('cards_join_error');

  @override
  String get cardsJoinHelp => translate('cards_join_help');

  @override
  String cardsJoinSuccess(Object business) => translate('cards_join_success', <String, String>{'business': '$business'});

  @override
  String get cardsJoinTitle => translate('cards_join_title');

  @override
  String cardsProgress(Object current, Object total) => translate('cards_progress', <String, String>{'current': '$current', 'total': '$total'});

  @override
  String get cardsReadyBadge => translate('cards_ready_badge');

  @override
  String cardsRemaining(Object count) => translate('cards_remaining', <String, String>{'count': '$count'});

  @override
  String get cardsRewardLabel => translate('cards_reward_label');

  @override
  String cardsRulesMessage(Object stamps) => translate('cards_rules_message', <String, String>{'stamps': '$stamps'});

  @override
  String get cardsRulesTitle => translate('cards_rules_title');

  @override
  String get cardsShowQrAction => translate('cards_show_qr_action');

  @override
  String cardsStampAddedAt(Object date) => translate('cards_stamp_added_at', <String, String>{'date': '$date'});

  @override
  String get cardsStampsTitle => translate('cards_stamps_title');

  @override
  String get cardsSubtitle => translate('cards_subtitle');

  @override
  String get cardsTitle => translate('cards_title');

  @override
  String get commonAccept => translate('common_accept');

  @override
  String get commonAll => translate('common_all');

  @override
  String get commonApply => translate('common_apply');

  @override
  String get commonBack => translate('common_back');

  @override
  String get commonCancel => translate('common_cancel');

  @override
  String get commonClear => translate('common_clear');

  @override
  String get commonClose => translate('common_close');

  @override
  String get commonComingSoon => translate('common_coming_soon');

  @override
  String get commonContinueAction => translate('common_continue_action');

  @override
  String get commonCopied => translate('common_copied');

  @override
  String get commonCopy => translate('common_copy');

  @override
  String get commonDelete => translate('common_delete');

  @override
  String get commonEdit => translate('common_edit');

  @override
  String get commonEmptyGenericMessage => translate('common_empty_generic_message');

  @override
  String get commonEmptyGenericTitle => translate('common_empty_generic_title');

  @override
  String get commonErrorGenericMessage => translate('common_error_generic_message');

  @override
  String get commonErrorGenericTitle => translate('common_error_generic_title');

  @override
  String get commonFilters => translate('common_filters');

  @override
  String commonKmAway(Object distance) => translate('common_km_away', <String, String>{'distance': '$distance'});

  @override
  String get commonListView => translate('common_list_view');

  @override
  String get commonLoading => translate('common_loading');

  @override
  String get commonMapView => translate('common_map_view');

  @override
  String get commonNewBadge => translate('common_new_badge');

  @override
  String get commonNo => translate('common_no');

  @override
  String get commonOfflineBanner => translate('common_offline_banner');

  @override
  String get commonOk => translate('common_ok');

  @override
  String get commonOptional => translate('common_optional');

  @override
  String commonPointsCount(Object count) => translate('common_points_count', <String, String>{'count': '$count'});

  @override
  String get commonRequiredIndicator => translate('common_required_indicator');

  @override
  String get commonRetry => translate('common_retry');

  @override
  String get commonSave => translate('common_save');

  @override
  String get commonSaving => translate('common_saving');

  @override
  String get commonSearch => translate('common_search');

  @override
  String get commonSeeAll => translate('common_see_all');

  @override
  String get commonSeeDetail => translate('common_see_detail');

  @override
  String get commonShare => translate('common_share');

  @override
  String commonStampsCount(Object count) => translate('common_stamps_count', <String, String>{'count': '$count'});

  @override
  String get commonTabHome => translate('common_tab_home');

  @override
  String get commonTabMap => translate('common_tab_map');

  @override
  String get commonTabProfile => translate('common_tab_profile');

  @override
  String get commonTabPromotions => translate('common_tab_promotions');

  @override
  String get commonTabRewards => translate('common_tab_rewards');

  @override
  String get commonYes => translate('common_yes');

  @override
  String get errorsCancelled => translate('errors_cancelled');

  @override
  String get errorsConnection => translate('errors_connection');

  @override
  String get errorsForbidden => translate('errors_forbidden');

  @override
  String get errorsForbiddenMessage => translate('errors_forbidden_message');

  @override
  String get errorsForbiddenTitle => translate('errors_forbidden_title');

  @override
  String get errorsMaintenanceMessage => translate('errors_maintenance_message');

  @override
  String get errorsMaintenanceTitle => translate('errors_maintenance_title');

  @override
  String get errorsNoConnectionAction => translate('errors_no_connection_action');

  @override
  String get errorsNoConnectionMessage => translate('errors_no_connection_message');

  @override
  String get errorsNoConnectionTitle => translate('errors_no_connection_title');

  @override
  String get errorsNotFound => translate('errors_not_found');

  @override
  String get errorsNotFoundAction => translate('errors_not_found_action');

  @override
  String get errorsNotFoundMessage => translate('errors_not_found_message');

  @override
  String get errorsNotFoundTitle => translate('errors_not_found_title');

  @override
  String get errorsRateLimited => translate('errors_rate_limited');

  @override
  String get errorsRequestFailed => translate('errors_request_failed');

  @override
  String get errorsSecureConnection => translate('errors_secure_connection');

  @override
  String get errorsServer => translate('errors_server');

  @override
  String get errorsTimeout => translate('errors_timeout');

  @override
  String get errorsUnauthorized => translate('errors_unauthorized');

  @override
  String get errorsUnauthorizedMessage => translate('errors_unauthorized_message');

  @override
  String get errorsUnauthorizedTitle => translate('errors_unauthorized_title');

  @override
  String get errorsUnexpected => translate('errors_unexpected');

  @override
  String get errorsValidationFailed => translate('errors_validation_failed');

  @override
  String get helpContactMessage => translate('help_contact_message');

  @override
  String get helpContactTitle => translate('help_contact_title');

  @override
  String get helpEmailAction => translate('help_email_action');

  @override
  String get helpFaq1Answer => translate('help_faq_1_answer');

  @override
  String get helpFaq1Question => translate('help_faq_1_question');

  @override
  String get helpFaq2Answer => translate('help_faq_2_answer');

  @override
  String get helpFaq2Question => translate('help_faq_2_question');

  @override
  String get helpFaq3Answer => translate('help_faq_3_answer');

  @override
  String get helpFaq3Question => translate('help_faq_3_question');

  @override
  String get helpFaq4Answer => translate('help_faq_4_answer');

  @override
  String get helpFaq4Question => translate('help_faq_4_question');

  @override
  String get helpFaq5Answer => translate('help_faq_5_answer');

  @override
  String get helpFaq5Question => translate('help_faq_5_question');

  @override
  String get helpFaqTitle => translate('help_faq_title');

  @override
  String get helpSubtitle => translate('help_subtitle');

  @override
  String get helpTitle => translate('help_title');

  @override
  String get homeCompletedBanner => translate('home_completed_banner');

  @override
  String get homeCompletedBannerMessage => translate('home_completed_banner_message');

  @override
  String homeGreeting(Object name) => translate('home_greeting', <String, String>{'name': '$name'});

  @override
  String get homeGreetingNoName => translate('home_greeting_no_name');

  @override
  String get homeMyCardsTitle => translate('home_my_cards_title');

  @override
  String get homeNearbyTitle => translate('home_nearby_title');

  @override
  String get homeNoCardsMessage => translate('home_no_cards_message');

  @override
  String get homeNoCardsTitle => translate('home_no_cards_title');

  @override
  String get homePointsCardSubtitle => translate('home_points_card_subtitle');

  @override
  String get homePointsCardTitle => translate('home_points_card_title');

  @override
  String get homePromotionsTitle => translate('home_promotions_title');

  @override
  String get homeQuickJoinCard => translate('home_quick_join_card');

  @override
  String get homeQuickJoinCardHint => translate('home_quick_join_card_hint');

  @override
  String get homeQuickNearby => translate('home_quick_nearby');

  @override
  String get homeQuickPromotions => translate('home_quick_promotions');

  @override
  String get homeQuickReferral => translate('home_quick_referral');

  @override
  String get homeQuickRewards => translate('home_quick_rewards');

  @override
  String get homeStatsCards => translate('home_stats_cards');

  @override
  String get homeStatsCompleted => translate('home_stats_completed');

  @override
  String get homeStatsStamps => translate('home_stats_stamps');

  @override
  String get homeSubtitle => translate('home_subtitle');

  @override
  String get legalAboutContact => translate('legal_about_contact');

  @override
  String get legalAboutDescription => translate('legal_about_description');

  @override
  String get legalAboutLegal => translate('legal_about_legal');

  @override
  String get legalAboutMadeFor => translate('legal_about_made_for');

  @override
  String get legalAboutTitle => translate('legal_about_title');

  @override
  String get legalAboutVersion => translate('legal_about_version');

  @override
  String get legalAboutWebsite => translate('legal_about_website');

  @override
  String get legalError => translate('legal_error');

  @override
  String get legalPrivacyTitle => translate('legal_privacy_title');

  @override
  String get legalTermsTitle => translate('legal_terms_title');

  @override
  String legalUpdatedAt(Object date) => translate('legal_updated_at', <String, String>{'date': '$date'});

  @override
  String get manageCardsAssetsBackground => translate('manage_cards_assets_background');

  @override
  String get manageCardsAssetsError => translate('manage_cards_assets_error');

  @override
  String get manageCardsAssetsHint => translate('manage_cards_assets_hint');

  @override
  String get manageCardsAssetsLogo => translate('manage_cards_assets_logo');

  @override
  String get manageCardsAssetsStampIcon => translate('manage_cards_assets_stamp_icon');

  @override
  String get manageCardsAssetsTitle => translate('manage_cards_assets_title');

  @override
  String get manageCardsAssetsUpload => translate('manage_cards_assets_upload');

  @override
  String get manageCardsAssetsUploaded => translate('manage_cards_assets_uploaded');

  @override
  String manageCardsCustomersCount(Object count) => translate('manage_cards_customers_count', <String, String>{'count': '$count'});

  @override
  String get manageCardsDeleteConfirmMessage => translate('manage_cards_delete_confirm_message');

  @override
  String get manageCardsDeleteConfirmTitle => translate('manage_cards_delete_confirm_title');

  @override
  String get manageCardsDeleted => translate('manage_cards_deleted');

  @override
  String get manageCardsEmptyMessage => translate('manage_cards_empty_message');

  @override
  String get manageCardsEmptyTitle => translate('manage_cards_empty_title');

  @override
  String get manageCardsError => translate('manage_cards_error');

  @override
  String get manageCardsFieldActive => translate('manage_cards_field_active');

  @override
  String get manageCardsFieldActiveSubtitle => translate('manage_cards_field_active_subtitle');

  @override
  String get manageCardsFieldColor => translate('manage_cards_field_color');

  @override
  String get manageCardsFieldDescription => translate('manage_cards_field_description');

  @override
  String get manageCardsFieldDescriptionHint => translate('manage_cards_field_description_hint');

  @override
  String get manageCardsFieldName => translate('manage_cards_field_name');

  @override
  String get manageCardsFieldNameHint => translate('manage_cards_field_name_hint');

  @override
  String get manageCardsFieldRequiredStamps => translate('manage_cards_field_required_stamps');

  @override
  String get manageCardsFieldReward => translate('manage_cards_field_reward');

  @override
  String get manageCardsFieldRewardHint => translate('manage_cards_field_reward_hint');

  @override
  String get manageCardsFormCreateTitle => translate('manage_cards_form_create_title');

  @override
  String get manageCardsFormEditTitle => translate('manage_cards_form_edit_title');

  @override
  String get manageCardsNewAction => translate('manage_cards_new_action');

  @override
  String get manageCardsPreviewTitle => translate('manage_cards_preview_title');

  @override
  String get manageCardsSaveAction => translate('manage_cards_save_action');

  @override
  String get manageCardsSaveError => translate('manage_cards_save_error');

  @override
  String get manageCardsSaved => translate('manage_cards_saved');

  @override
  String get manageCardsStepBack => translate('manage_cards_step_back');

  @override
  String get manageCardsStepBasics => translate('manage_cards_step_basics');

  @override
  String get manageCardsStepDesign => translate('manage_cards_step_design');

  @override
  String get manageCardsStepNext => translate('manage_cards_step_next');

  @override
  String get manageCardsStepReview => translate('manage_cards_step_review');

  @override
  String get manageCardsStepReward => translate('manage_cards_step_reward');

  @override
  String get manageCardsSubtitle => translate('manage_cards_subtitle');

  @override
  String get manageCardsTitle => translate('manage_cards_title');

  @override
  String manageCustomersCardProgress(Object card, Object current, Object total) => translate('manage_customers_card_progress', <String, String>{'card': '$card', 'current': '$current', 'total': '$total'});

  @override
  String manageCustomersCardsCount(Object count) => translate('manage_customers_cards_count', <String, String>{'count': '$count'});

  @override
  String manageCustomersCustomerSince(Object date) => translate('manage_customers_customer_since', <String, String>{'date': '$date'});

  @override
  String get manageCustomersDetailTitle => translate('manage_customers_detail_title');

  @override
  String get manageCustomersEmptyMessage => translate('manage_customers_empty_message');

  @override
  String get manageCustomersEmptyTitle => translate('manage_customers_empty_title');

  @override
  String get manageCustomersError => translate('manage_customers_error');

  @override
  String get manageCustomersErrorDetail => translate('manage_customers_error_detail');

  @override
  String manageCustomersLastVisit(Object date) => translate('manage_customers_last_visit', <String, String>{'date': '$date'});

  @override
  String get manageCustomersSearchHint => translate('manage_customers_search_hint');

  @override
  String manageCustomersStampsTotal(Object count) => translate('manage_customers_stamps_total', <String, String>{'count': '$count'});

  @override
  String get manageCustomersSubtitle => translate('manage_customers_subtitle');

  @override
  String get manageCustomersTitle => translate('manage_customers_title');

  @override
  String get manageDashboardChartEmpty => translate('manage_dashboard_chart_empty');

  @override
  String get manageDashboardChartRangeMonth => translate('manage_dashboard_chart_range_month');

  @override
  String get manageDashboardChartRangeWeek => translate('manage_dashboard_chart_range_week');

  @override
  String get manageDashboardChartTitle => translate('manage_dashboard_chart_title');

  @override
  String get manageDashboardError => translate('manage_dashboard_error');

  @override
  String manageDashboardGreeting(Object name) => translate('manage_dashboard_greeting', <String, String>{'name': '$name'});

  @override
  String get manageDashboardMetricActiveCards => translate('manage_dashboard_metric_active_cards');

  @override
  String get manageDashboardMetricCustomers => translate('manage_dashboard_metric_customers');

  @override
  String get manageDashboardMetricRedemptions => translate('manage_dashboard_metric_redemptions');

  @override
  String get manageDashboardMetricStampsMonth => translate('manage_dashboard_metric_stamps_month');

  @override
  String get manageDashboardMetricStampsToday => translate('manage_dashboard_metric_stamps_today');

  @override
  String get manageDashboardQuickCards => translate('manage_dashboard_quick_cards');

  @override
  String get manageDashboardQuickCustomers => translate('manage_dashboard_quick_customers');

  @override
  String get manageDashboardQuickPromotions => translate('manage_dashboard_quick_promotions');

  @override
  String get manageDashboardQuickScan => translate('manage_dashboard_quick_scan');

  @override
  String get manageDashboardRecentEmpty => translate('manage_dashboard_recent_empty');

  @override
  String get manageDashboardRecentStampsTitle => translate('manage_dashboard_recent_stamps_title');

  @override
  String get manageDashboardSubtitle => translate('manage_dashboard_subtitle');

  @override
  String get manageDashboardTitle => translate('manage_dashboard_title');

  @override
  String get manageDashboardTopCustomersTitle => translate('manage_dashboard_top_customers_title');

  @override
  String get managePromotionsDeleteConfirmMessage => translate('manage_promotions_delete_confirm_message');

  @override
  String get managePromotionsDeleteConfirmTitle => translate('manage_promotions_delete_confirm_title');

  @override
  String get managePromotionsDeleted => translate('manage_promotions_deleted');

  @override
  String get managePromotionsEmptyMessage => translate('manage_promotions_empty_message');

  @override
  String get managePromotionsEmptyTitle => translate('manage_promotions_empty_title');

  @override
  String get managePromotionsError => translate('manage_promotions_error');

  @override
  String get managePromotionsFieldActive => translate('manage_promotions_field_active');

  @override
  String get managePromotionsFieldDescription => translate('manage_promotions_field_description');

  @override
  String get managePromotionsFieldEndsAt => translate('manage_promotions_field_ends_at');

  @override
  String get managePromotionsFieldStartsAt => translate('manage_promotions_field_starts_at');

  @override
  String get managePromotionsFieldTitle => translate('manage_promotions_field_title');

  @override
  String get managePromotionsFieldTitleHint => translate('manage_promotions_field_title_hint');

  @override
  String get managePromotionsFormCreateTitle => translate('manage_promotions_form_create_title');

  @override
  String get managePromotionsFormEditTitle => translate('manage_promotions_form_edit_title');

  @override
  String get managePromotionsNewAction => translate('manage_promotions_new_action');

  @override
  String get managePromotionsPickDate => translate('manage_promotions_pick_date');

  @override
  String get managePromotionsSaveAction => translate('manage_promotions_save_action');

  @override
  String get managePromotionsSaveError => translate('manage_promotions_save_error');

  @override
  String get managePromotionsSaved => translate('manage_promotions_saved');

  @override
  String get managePromotionsStatusActive => translate('manage_promotions_status_active');

  @override
  String get managePromotionsStatusExpired => translate('manage_promotions_status_expired');

  @override
  String get managePromotionsStatusPaused => translate('manage_promotions_status_paused');

  @override
  String get managePromotionsStatusScheduled => translate('manage_promotions_status_scheduled');

  @override
  String get managePromotionsSubtitle => translate('manage_promotions_subtitle');

  @override
  String get managePromotionsTitle => translate('manage_promotions_title');

  @override
  String get manageScanCameraUnavailableMessage => translate('manage_scan_camera_unavailable_message');

  @override
  String get manageScanCameraUnavailableTitle => translate('manage_scan_camera_unavailable_title');

  @override
  String get manageScanCardLabel => translate('manage_scan_card_label');

  @override
  String get manageScanCustomerLabel => translate('manage_scan_customer_label');

  @override
  String get manageScanDuplicate => translate('manage_scan_duplicate');

  @override
  String get manageScanError => translate('manage_scan_error');

  @override
  String get manageScanInstruction => translate('manage_scan_instruction');

  @override
  String get manageScanInvalidCode => translate('manage_scan_invalid_code');

  @override
  String get manageScanManualAction => translate('manage_scan_manual_action');

  @override
  String get manageScanManualEntry => translate('manage_scan_manual_entry');

  @override
  String get manageScanManualHint => translate('manage_scan_manual_hint');

  @override
  String get manageScanProcessing => translate('manage_scan_processing');

  @override
  String get manageScanRecentEmpty => translate('manage_scan_recent_empty');

  @override
  String get manageScanRecentTitle => translate('manage_scan_recent_title');

  @override
  String get manageScanRewardUnlocked => translate('manage_scan_reward_unlocked');

  @override
  String get manageScanScanAgain => translate('manage_scan_scan_again');

  @override
  String get manageScanStampsLabel => translate('manage_scan_stamps_label');

  @override
  String manageScanSuccessMessage(Object name, Object count, Object card) => translate('manage_scan_success_message', <String, String>{'name': '$name', 'count': '$count', 'card': '$card'});

  @override
  String get manageScanSuccessTitle => translate('manage_scan_success_title');

  @override
  String get manageScanTitle => translate('manage_scan_title');

  @override
  String mapBusinessesFound(Object count) => translate('map_businesses_found', <String, String>{'count': '$count'});

  @override
  String get mapCategories => translate('map_categories');

  @override
  String get mapCategoryAll => translate('map_category_all');

  @override
  String get mapEmptyMessage => translate('map_empty_message');

  @override
  String get mapEmptyTitle => translate('map_empty_title');

  @override
  String get mapError => translate('map_error');

  @override
  String get mapFavoritesOnly => translate('map_favorites_only');

  @override
  String get mapLocationDeniedMessage => translate('map_location_denied_message');

  @override
  String get mapLocationDeniedTitle => translate('map_location_denied_title');

  @override
  String get mapManualLocation => translate('map_manual_location');

  @override
  String get mapManualLocationHint => translate('map_manual_location_hint');

  @override
  String mapManualLocationSaved(Object area) => translate('map_manual_location_saved', <String, String>{'area': '$area'});

  @override
  String get mapMyLocation => translate('map_my_location');

  @override
  String get mapOpenSettings => translate('map_open_settings');

  @override
  String get mapRadiusLabel => translate('map_radius_label');

  @override
  String mapRadiusValue(Object km) => translate('map_radius_value', <String, String>{'km': '$km'});

  @override
  String get mapSearchHint => translate('map_search_hint');

  @override
  String get mapStaticViewHint => translate('map_static_view_hint');

  @override
  String get mapTitle => translate('map_title');

  @override
  String get mapYouAreHere => translate('map_you_are_here');

  @override
  String get notificationsEmptyMessage => translate('notifications_empty_message');

  @override
  String get notificationsEmptyTitle => translate('notifications_empty_title');

  @override
  String get notificationsError => translate('notifications_error');

  @override
  String get notificationsMarkAllRead => translate('notifications_mark_all_read');

  @override
  String get notificationsMarkedRead => translate('notifications_marked_read');

  @override
  String get notificationsTitle => translate('notifications_title');

  @override
  String get notificationsTypeGenericTitle => translate('notifications_type_generic_title');

  @override
  String notificationsTypePromotionBody(Object business, Object promotion) => translate('notifications_type_promotion_body', <String, String>{'business': '$business', 'promotion': '$promotion'});

  @override
  String get notificationsTypePromotionTitle => translate('notifications_type_promotion_title');

  @override
  String notificationsTypeRewardBody(Object card) => translate('notifications_type_reward_body', <String, String>{'card': '$card'});

  @override
  String get notificationsTypeRewardTitle => translate('notifications_type_reward_title');

  @override
  String notificationsTypeStampBody(Object business, Object count) => translate('notifications_type_stamp_body', <String, String>{'business': '$business', 'count': '$count'});

  @override
  String get notificationsTypeStampTitle => translate('notifications_type_stamp_title');

  @override
  String get onboardingNext => translate('onboarding_next');

  @override
  String get onboardingSkip => translate('onboarding_skip');

  @override
  String get onboardingSlide1Message => translate('onboarding_slide_1_message');

  @override
  String get onboardingSlide1Title => translate('onboarding_slide_1_title');

  @override
  String get onboardingSlide2Message => translate('onboarding_slide_2_message');

  @override
  String get onboardingSlide2Title => translate('onboarding_slide_2_title');

  @override
  String get onboardingSlide3Message => translate('onboarding_slide_3_message');

  @override
  String get onboardingSlide3Title => translate('onboarding_slide_3_title');

  @override
  String get onboardingSlide4Message => translate('onboarding_slide_4_message');

  @override
  String get onboardingSlide4Title => translate('onboarding_slide_4_title');

  @override
  String get onboardingStart => translate('onboarding_start');

  @override
  String get profileAboutAction => translate('profile_about_action');

  @override
  String get profileAvatarChange => translate('profile_avatar_change');

  @override
  String get profileAvatarError => translate('profile_avatar_error');

  @override
  String get profileAvatarHint => translate('profile_avatar_hint');

  @override
  String get profileAvatarUploaded => translate('profile_avatar_uploaded');

  @override
  String get profileBusinessModeAction => translate('profile_business_mode_action');

  @override
  String get profileCardsCount => translate('profile_cards_count');

  @override
  String get profileChangePasswordAction => translate('profile_change_password_action');

  @override
  String get profileChangePasswordConfirm => translate('profile_change_password_confirm');

  @override
  String get profileChangePasswordCurrent => translate('profile_change_password_current');

  @override
  String get profileChangePasswordNew => translate('profile_change_password_new');

  @override
  String get profileChangePasswordSuccess => translate('profile_change_password_success');

  @override
  String get profileChangePasswordTitle => translate('profile_change_password_title');

  @override
  String get profileDeleteAccountAction => translate('profile_delete_account_action');

  @override
  String get profileDeleteAccountConfirm => translate('profile_delete_account_confirm');

  @override
  String get profileDeleteAccountError => translate('profile_delete_account_error');

  @override
  String get profileDeleteAccountMessage => translate('profile_delete_account_message');

  @override
  String get profileDeleteAccountSuccess => translate('profile_delete_account_success');

  @override
  String get profileDeleteAccountTitle => translate('profile_delete_account_title');

  @override
  String get profileEditAction => translate('profile_edit_action');

  @override
  String get profileEditError => translate('profile_edit_error');

  @override
  String get profileEditSuccess => translate('profile_edit_success');

  @override
  String get profileEditTitle => translate('profile_edit_title');

  @override
  String get profileHelpAction => translate('profile_help_action');

  @override
  String get profileLegalAction => translate('profile_legal_action');

  @override
  String profileMemberSince(Object date) => translate('profile_member_since', <String, String>{'date': '$date'});

  @override
  String get profileNotificationsAction => translate('profile_notifications_action');

  @override
  String get profilePendingVerification => translate('profile_pending_verification');

  @override
  String get profilePoints => translate('profile_points');

  @override
  String get profileReferralAction => translate('profile_referral_action');

  @override
  String get profileRewardCount => translate('profile_reward_count');

  @override
  String get profileRoleAdmin => translate('profile_role_admin');

  @override
  String get profileRoleBusiness => translate('profile_role_business');

  @override
  String get profileRoleCustomer => translate('profile_role_customer');

  @override
  String get profileSettingsAction => translate('profile_settings_action');

  @override
  String get profileStampsTotal => translate('profile_stamps_total');

  @override
  String get profileStatsTitle => translate('profile_stats_title');

  @override
  String get profileSwitchToBusiness => translate('profile_switch_to_business');

  @override
  String get profileSwitchToCustomer => translate('profile_switch_to_customer');

  @override
  String get profileTitle => translate('profile_title');

  @override
  String get profileVerified => translate('profile_verified');

  @override
  String get profileVerifyAction => translate('profile_verify_action');

  @override
  String get promotionsDetailTitle => translate('promotions_detail_title');

  @override
  String get promotionsEmptyMessage => translate('promotions_empty_message');

  @override
  String get promotionsEmptyTitle => translate('promotions_empty_title');

  @override
  String get promotionsError => translate('promotions_error');

  @override
  String get promotionsExpired => translate('promotions_expired');

  @override
  String promotionsStartsOn(Object date) => translate('promotions_starts_on', <String, String>{'date': '$date'});

  @override
  String get promotionsSubtitle => translate('promotions_subtitle');

  @override
  String get promotionsTerms => translate('promotions_terms');

  @override
  String get promotionsTitle => translate('promotions_title');

  @override
  String promotionsValidUntil(Object date) => translate('promotions_valid_until', <String, String>{'date': '$date'});

  @override
  String get qrBrightnessHint => translate('qr_brightness_hint');

  @override
  String get qrBrightnessUnavailable => translate('qr_brightness_unavailable');

  @override
  String get qrCameraUnavailable => translate('qr_camera_unavailable');

  @override
  String get qrCodeLabel => translate('qr_code_label');

  @override
  String get qrError => translate('qr_error');

  @override
  String get qrExpiredMessage => translate('qr_expired_message');

  @override
  String get qrExpiredTitle => translate('qr_expired_title');

  @override
  String qrExpiresAt(Object time) => translate('qr_expires_at', <String, String>{'time': '$time'});

  @override
  String qrExpiresIn(Object seconds) => translate('qr_expires_in', <String, String>{'seconds': '$seconds'});

  @override
  String get qrInstruction => translate('qr_instruction');

  @override
  String get qrRegenerateAction => translate('qr_regenerate_action');

  @override
  String get qrShareCode => translate('qr_share_code');

  @override
  String qrSubtitle(Object business) => translate('qr_subtitle', <String, String>{'business': '$business'});

  @override
  String get qrTitle => translate('qr_title');

  @override
  String get referralCodeLabel => translate('referral_code_label');

  @override
  String get referralCompletedLabel => translate('referral_completed_label');

  @override
  String get referralCopyAction => translate('referral_copy_action');

  @override
  String get referralEmptyMessage => translate('referral_empty_message');

  @override
  String get referralEmptyTitle => translate('referral_empty_title');

  @override
  String get referralError => translate('referral_error');

  @override
  String get referralHowTitle => translate('referral_how_title');

  @override
  String referralInvitedCount(Object count) => translate('referral_invited_count', <String, String>{'count': '$count'});

  @override
  String get referralPendingLabel => translate('referral_pending_label');

  @override
  String get referralShareAction => translate('referral_share_action');

  @override
  String referralShareMessage(Object code) => translate('referral_share_message', <String, String>{'code': '$code'});

  @override
  String get referralStep1 => translate('referral_step_1');

  @override
  String get referralStep2 => translate('referral_step_2');

  @override
  String get referralStep3 => translate('referral_step_3');

  @override
  String get referralSubtitle => translate('referral_subtitle');

  @override
  String get referralTitle => translate('referral_title');

  @override
  String get rewardsCodeLabel => translate('rewards_code_label');

  @override
  String get rewardsDetailTitle => translate('rewards_detail_title');

  @override
  String get rewardsEmptyAvailableMessage => translate('rewards_empty_available_message');

  @override
  String get rewardsEmptyAvailableTitle => translate('rewards_empty_available_title');

  @override
  String get rewardsEmptyExpiredMessage => translate('rewards_empty_expired_message');

  @override
  String get rewardsEmptyExpiredTitle => translate('rewards_empty_expired_title');

  @override
  String get rewardsEmptyRedeemedMessage => translate('rewards_empty_redeemed_message');

  @override
  String get rewardsEmptyRedeemedTitle => translate('rewards_empty_redeemed_title');

  @override
  String rewardsExpiresOn(Object date) => translate('rewards_expires_on', <String, String>{'date': '$date'});

  @override
  String get rewardsRedeemAction => translate('rewards_redeem_action');

  @override
  String get rewardsRedeemConfirmAction => translate('rewards_redeem_confirm_action');

  @override
  String get rewardsRedeemConfirmMessage => translate('rewards_redeem_confirm_message');

  @override
  String get rewardsRedeemConfirmTitle => translate('rewards_redeem_confirm_title');

  @override
  String get rewardsRedeemError => translate('rewards_redeem_error');

  @override
  String get rewardsRedeemSuccess => translate('rewards_redeem_success');

  @override
  String rewardsRedeemedAt(Object date) => translate('rewards_redeemed_at', <String, String>{'date': '$date'});

  @override
  String rewardsRequiresStamps(Object count) => translate('rewards_requires_stamps', <String, String>{'count': '$count'});

  @override
  String get rewardsStatusAvailable => translate('rewards_status_available');

  @override
  String get rewardsStatusExpired => translate('rewards_status_expired');

  @override
  String get rewardsStatusRedeemed => translate('rewards_status_redeemed');

  @override
  String get rewardsTabAvailable => translate('rewards_tab_available');

  @override
  String get rewardsTabExpired => translate('rewards_tab_expired');

  @override
  String get rewardsTabRedeemed => translate('rewards_tab_redeemed');

  @override
  String get rewardsTitle => translate('rewards_title');

  @override
  String get settingsAppearanceTitle => translate('settings_appearance_title');

  @override
  String get settingsCacheClear => translate('settings_cache_clear');

  @override
  String get settingsCacheCleared => translate('settings_cache_cleared');

  @override
  String get settingsCacheSubtitle => translate('settings_cache_subtitle');

  @override
  String get settingsDataTitle => translate('settings_data_title');

  @override
  String get settingsLanguageEn => translate('settings_language_en');

  @override
  String get settingsLanguageEs => translate('settings_language_es');

  @override
  String get settingsLanguageLabel => translate('settings_language_label');

  @override
  String get settingsLanguageSystem => translate('settings_language_system');

  @override
  String get settingsLocationAuto => translate('settings_location_auto');

  @override
  String get settingsLocationAutoSubtitle => translate('settings_location_auto_subtitle');

  @override
  String get settingsLocationManual => translate('settings_location_manual');

  @override
  String get settingsLocationManualHint => translate('settings_location_manual_hint');

  @override
  String get settingsLocationTitle => translate('settings_location_title');

  @override
  String get settingsNotificationsTitle => translate('settings_notifications_title');

  @override
  String get settingsNotifyGeneral => translate('settings_notify_general');

  @override
  String get settingsNotifyPromotions => translate('settings_notify_promotions');

  @override
  String get settingsNotifyPromotionsSubtitle => translate('settings_notify_promotions_subtitle');

  @override
  String get settingsNotifyRewards => translate('settings_notify_rewards');

  @override
  String get settingsNotifyRewardsSubtitle => translate('settings_notify_rewards_subtitle');

  @override
  String get settingsNotifyStamps => translate('settings_notify_stamps');

  @override
  String get settingsNotifyStampsSubtitle => translate('settings_notify_stamps_subtitle');

  @override
  String get settingsPreferencesSaved => translate('settings_preferences_saved');

  @override
  String get settingsThemeDark => translate('settings_theme_dark');

  @override
  String get settingsThemeLabel => translate('settings_theme_label');

  @override
  String get settingsThemeLight => translate('settings_theme_light');

  @override
  String get settingsThemeSystem => translate('settings_theme_system');

  @override
  String get settingsTitle => translate('settings_title');

  @override
  String settingsVersionLabel(Object version) => translate('settings_version_label', <String, String>{'version': '$version'});

  @override
  String timeDaysAgo(Object days) => translate('time_days_ago', <String, String>{'days': '$days'});

  @override
  String timeHoursAgo(Object hours) => translate('time_hours_ago', <String, String>{'hours': '$hours'});

  @override
  String get timeJustNow => translate('time_just_now');

  @override
  String timeMinutesAgo(Object minutes) => translate('time_minutes_ago', <String, String>{'minutes': '$minutes'});

  @override
  String get timeToday => translate('time_today');

  @override
  String timeWeeksAgo(Object weeks) => translate('time_weeks_ago', <String, String>{'weeks': '$weeks'});

  @override
  String get timeYesterday => translate('time_yesterday');

  @override
  String get validationCodeInvalid => translate('validation_code_invalid');

  @override
  String get validationDateOrder => translate('validation_date_order');

  @override
  String get validationEmailInvalid => translate('validation_email_invalid');

  @override
  String get validationEmailOrPhoneInvalid => translate('validation_email_or_phone_invalid');

  @override
  String get validationNameShort => translate('validation_name_short');

  @override
  String validationNumberRange(Object min, Object max) => translate('validation_number_range', <String, String>{'min': '$min', 'max': '$max'});

  @override
  String get validationNumericInvalid => translate('validation_numeric_invalid');

  @override
  String get validationOtpSixDigits => translate('validation_otp_six_digits');

  @override
  String get validationPasswordMismatch => translate('validation_password_mismatch');

  @override
  String get validationPasswordShort => translate('validation_password_short');

  @override
  String get validationPhoneInvalid => translate('validation_phone_invalid');

  @override
  String get validationRequired => translate('validation_required');

  @override
  String get validationTermsRequired => translate('validation_terms_required');

  @override
  String validationTooLong(Object max) => translate('validation_too_long', <String, String>{'max': '$max'});

  @override
  String get validationUrlInvalid => translate('validation_url_invalid');
}

final class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any(
        (Locale supported) => supported.languageCode == locale.languageCode,
      );

  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture<AppLocalizations>(AppLocalizations.forLocale(locale));

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
