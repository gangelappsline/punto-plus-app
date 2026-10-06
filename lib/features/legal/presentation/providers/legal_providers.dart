import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/providers/data_providers.dart';
import '../../../../core/utils/result.dart';
import '../../data/models/legal_document.dart';
import '../../domain/repositories/legal_repository.dart';

/// Documento legal solicitado (términos o privacidad).
enum LegalDocumentKind { terms, privacy }

final legalDocumentProvider =
    FutureProvider.family<LegalDocument, LegalDocumentKind>(
  (Ref ref, LegalDocumentKind kind) async {
    final LegalRepository repository = ref.watch(legalRepositoryProvider);
    final Result<LegalDocument> result = switch (kind) {
      LegalDocumentKind.terms => await repository.fetchTerms(),
      LegalDocumentKind.privacy => await repository.fetchPrivacy(),
    };
    return switch (result) {
      Success<LegalDocument>(:final value) => value,
      Failure<LegalDocument>(:final error) => throw error,
    };
  },
);

/// Datos mostrados en la pantalla "Acerca de".
@immutable
final class AppAboutInfo {
  const AppAboutInfo({
    required this.version,
    required this.environment,
    required this.supportEmail,
    required this.websiteUrl,
    required this.hasMapsKey,
  });

  final String version;
  final String environment;
  final String supportEmail;
  final String websiteUrl;
  final bool hasMapsKey;

  bool get isProduction => environment == 'prod';
}

const String appVersion = '1.0.0';

final appAboutInfoProvider = Provider<AppAboutInfo>((Ref ref) {
  final AppConfig config = ref.watch(appConfigProvider);
  return AppAboutInfo(
    version: appVersion,
    environment: config.environment,
    supportEmail: config.supportEmail,
    websiteUrl: config.websiteUrl,
    hasMapsKey: config.hasMapsKey,
  );
});
