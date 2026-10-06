import '../../../../core/utils/result.dart';
import '../../data/models/legal_document.dart';

/// Contrato de documentos legales.
abstract interface class LegalRepository {
  Future<Result<LegalDocument>> fetchTerms();

  Future<Result<LegalDocument>> fetchPrivacy();
}
