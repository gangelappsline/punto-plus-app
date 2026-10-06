import '../../../../core/errors/app_exception.dart';
import '../../../../core/storage/local_cache.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/cards_repository.dart';
import '../datasources/cards_remote_data_source.dart';
import '../models/customer_card.dart';
import '../models/customer_card_qr.dart';
import '../models/stamp.dart';

final class CardsRepositoryImpl implements CardsRepository {
  const CardsRepositoryImpl(this._remoteDataSource, this._cache);

  final CardsRemoteDataSource _remoteDataSource;
  final LocalCache _cache;

  @override
  Future<Result<List<CustomerCardModel>>> fetchCards({
    bool forceRefresh = false,
  }) async {
    try {
      final List<CustomerCardModel> cards =
          await _remoteDataSource.fetchCards();
      await _cache.saveList(
        LocalCache.cardsKey,
        cards.map((CustomerCardModel card) => card.toJson()).toList(),
      );
      return Success<List<CustomerCardModel>>(cards);
    } on Exception catch (error) {
      if (forceRefresh) {
        return Failure<List<CustomerCardModel>>(error);
      }
      final List<Map<String, dynamic>> cached =
          await _cache.readList(LocalCache.cardsKey);
      if (cached.isEmpty) return Failure<List<CustomerCardModel>>(error);
      return Success<List<CustomerCardModel>>(
        cached.map(CustomerCardModel.fromJson).toList(),
      );
    }
  }

  @override
  Future<Result<CustomerCardModel>> fetchCard(String id) async {
    try {
      return Success<CustomerCardModel>(await _remoteDataSource.fetchCard(id));
    } on Exception catch (error) {
      final List<Map<String, dynamic>> cached =
          await _cache.readList(LocalCache.cardsKey);
      for (final Map<String, dynamic> item in cached) {
        final CustomerCardModel card = CustomerCardModel.fromJson(item);
        if (card.id == id) return Success<CustomerCardModel>(card);
      }
      return Failure<CustomerCardModel>(error);
    }
  }

  @override
  Future<Result<List<StampModel>>> fetchStamps(String cardId) async {
    try {
      return Success<List<StampModel>>(
        await _remoteDataSource.fetchStamps(cardId),
      );
    } on Exception catch (error) {
      return Failure<List<StampModel>>(error);
    }
  }

  @override
  Future<Result<CustomerCardModel>> join(String code) async {
    try {
      final String sanitized = code.trim();
      if (sanitized.isEmpty) {
        return Failure<CustomerCardModel>(
          AppException.localized('cards.joinCodeRequired'),
        );
      }
      return Success<CustomerCardModel>(await _remoteDataSource.join(sanitized));
    } on Exception catch (error) {
      return Failure<CustomerCardModel>(error);
    }
  }

  @override
  Future<Result<CustomerCardQr>> fetchQr(String cardId) async {
    try {
      return Success<CustomerCardQr>(await _remoteDataSource.fetchQr(cardId));
    } on Exception catch (error) {
      return Failure<CustomerCardQr>(error);
    }
  }

  @override
  Future<Result<CustomerCardModel?>> redeem(String cardId) async {
    try {
      return Success<CustomerCardModel?>(
        await _remoteDataSource.redeem(cardId),
      );
    } on Exception catch (error) {
      return Failure<CustomerCardModel?>(error);
    }
  }
}
