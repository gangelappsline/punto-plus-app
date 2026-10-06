import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:punto_plus/core/errors/app_exception.dart';
import 'package:punto_plus/core/providers/data_providers.dart';
import 'package:punto_plus/core/theme/app_theme.dart';
import 'package:punto_plus/core/utils/result.dart';
import 'package:punto_plus/features/auth/data/models/auth_session.dart';
import 'package:punto_plus/features/auth/data/models/login_request.dart';
import 'package:punto_plus/features/auth/data/models/password_recovery_request.dart';
import 'package:punto_plus/features/auth/data/models/register_request.dart';
import 'package:punto_plus/features/auth/data/models/social_auth_request.dart';
import 'package:punto_plus/features/auth/data/models/user_model.dart';
import 'package:punto_plus/features/auth/data/models/verification_requests.dart';
import 'package:punto_plus/features/auth/domain/repositories/auth_repository.dart';
import 'package:punto_plus/features/auth/presentation/screens/auth_screen.dart';
import 'package:punto_plus/features/auth/presentation/widgets/auth_segmented_control.dart';

void main() {
  Widget wrap({AuthMode mode = AuthMode.login}) => ProviderScope(
        overrides: <Override>[
          authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: AuthScreen(initialMode: mode),
        ),
      );

  testWidgets('muestra el acceso y cambia a la pestaña de registro', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('Bienvenido de vuelta'), findsOneWidget);
    expect(find.text('Continuar'), findsOneWidget);
    expect(find.text('Google'), findsOneWidget);
    expect(find.text('Apple ID'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('register-tab')));
    await tester.pumpAndSettle();

    expect(find.text('Crea tu cuenta'), findsOneWidget);
    expect(find.text('Registrarme'), findsOneWidget);
  });

  testWidgets('abre directamente la pestaña solicitada por la ruta', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(wrap(mode: AuthMode.register));
    await tester.pumpAndSettle();

    expect(find.text('Crea tu cuenta'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('login-tab')));
    await tester.pumpAndSettle();

    expect(find.text('Bienvenido de vuelta'), findsOneWidget);
  });

  testWidgets('valida campos vacíos antes de iniciar sesión', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey<String>('login-submit')));
    await tester.pumpAndSettle();

    expect(find.text('Campo obligatorio'), findsWidgets);
  });
}

final class _FakeAuthRepository implements AuthRepository {
  @override
  Future<Result<AuthSession>> login(LoginRequest request) async =>
      const Failure<AuthSession>(AppException(message: 'No pudimos iniciar sesión.'));

  @override
  Future<Result<AuthSession>> register(RegisterRequest request) async =>
      const Failure<AuthSession>(AppException(message: 'No pudimos iniciar sesión.'));

  @override
  Future<Result<void>> verifyCode(VerifyCodeRequest request) async =>
      const Success<void>(null);

  @override
  Future<Result<void>> resendCode(ResendCodeRequest request) async =>
      const Success<void>(null);

  @override
  Future<Result<void>> requestPasswordReset(
    PasswordRecoveryRequest request,
  ) async =>
      const Success<void>(null);

  @override
  Future<Result<void>> resetPassword(ResetPasswordRequest request) async =>
      const Success<void>(null);

  @override
  Future<Result<AuthSession>> authenticateWithSocialProvider(
    SocialAuthRequest request,
  ) async =>
      const Failure<AuthSession>(AppException(message: 'No pudimos iniciar sesión.'));

  @override
  Future<AuthSession?> restoreSession() async => null;

  @override
  Future<Result<UserModel>> refreshUser() async =>
      const Failure<UserModel>(AppException(message: 'No pudimos iniciar sesión.'));

  @override
  Future<Result<void>> logout() async => const Success<void>(null);
}
