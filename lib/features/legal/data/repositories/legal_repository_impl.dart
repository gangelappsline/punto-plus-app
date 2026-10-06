import '../../../../core/storage/local_cache.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/legal_repository.dart';
import '../datasources/legal_remote_data_source.dart';
import '../models/legal_document.dart';

final class LegalRepositoryImpl implements LegalRepository {
  const LegalRepositoryImpl(this._remoteDataSource, this._cache);

  static const String termsKey = 'cache.legal.terms';
  static const String privacyKey = 'cache.legal.privacy';

  final LegalRemoteDataSource _remoteDataSource;
  final LocalCache _cache;

  @override
  Future<Result<LegalDocument>> fetchTerms() =>
      _fetch(_remoteDataSource.fetchTerms, termsKey);

  @override
  Future<Result<LegalDocument>> fetchPrivacy() =>
      _fetch(_remoteDataSource.fetchPrivacy, privacyKey);

  Future<Result<LegalDocument>> _fetch(
    Future<LegalDocument> Function() operation,
    String cacheKey,
  ) async {
    try {
      final LegalDocument document = await operation();
      await _cache.saveMap(cacheKey, <String, dynamic>{
        'title': document.title,
        'content': document.content,
        if (document.updatedAt != null)
          'updated_at': document.updatedAt!.toIso8601String(),
      });
      return Success<LegalDocument>(document);
    } on Exception catch (error) {
      final Map<String, dynamic>? cached = await _cache.readMap(cacheKey);
      if (cached == null) return Failure<LegalDocument>(error);
      return Success<LegalDocument>(LegalDocument.fromJson(cached));
    }
  }
}
