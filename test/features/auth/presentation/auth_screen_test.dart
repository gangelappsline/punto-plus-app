import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:punto_plus/core/providers/data_providers.dart';
import 'package:punto_plus/core/utils/result.dart';
import 'package:punto_plus/features/auth/data/models/auth_session.dart';
import 'package:punto_plus/features/auth/data/models/login_request.dart';
import 'package:punto_plus/features/auth/data/models/password_recovery_request.dart';
import 'package:punto_plus/features/auth/data/models/register_request.dart';
import 'package:punto_plus/features/auth/data/models/social_auth_request.dart';
import 'package:punto_plus/features/auth/domain/repositories/auth_repository.dart';
import 'package:punto_plus/features/auth/presentation/screens/auth_screen.dart';

void main() {
  testWidgets('renders login and changes to register mode', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
        ],
        child: const MaterialApp(home: AuthScreen()),
      ),
    );

    expect(find.text('Bienvenido de vuelta'), findsOneWidget);
    expect(find.text('Continuar'), findsOneWidget);
    expect(find.text('Google'), findsOneWidget);
    expect(find.text('Apple ID'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('register-tab')));
    await tester.pumpAndSettle();

    expect(find.text('Crea tu cuenta'), findsOneWidget);
    expect(find.text('Registrarme'), findsOneWidget);
  });
}

final class _FakeAuthRepository implements AuthRepository {
  @override
  Future<Result<AuthSession>> authenticateWithSocialProvider(
    SocialAuthRequest request,
  ) =>
      throw UnimplementedError();

  @override
  Future<Result<AuthSession>> login(LoginRequest request) =>
      throw UnimplementedError();

  @override
  Future<Result<void>> logout() async => const Success<void>(null);

  @override
  Future<Result<AuthSession>> register(RegisterRequest request) =>
      throw UnimplementedError();

  @override
  Future<Result<void>> requestPasswordReset(
    PasswordRecoveryRequest request,
  ) async =>
      const Success<void>(null);

  @override
  Future<AuthSession?> restoreSession() async => null;
}
