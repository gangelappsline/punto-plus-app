import 'package:dio/dio.dart';

import '../../../../core/config/api_paths.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_response.dart';
import '../../../cards/data/models/loyalty_card.dart';
import '../../../promotions/data/models/promotion.dart';
import '../models/business.dart';

/// Endpoints de descubrimiento de negocios.
final class BusinessesRemoteDataSource {
  const BusinessesRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<BusinessModel>> fetchNearby({
    required double latitude,
    required double longitude,
    required double radiusKm,
    String? category,
    String? query,
  }) async {
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        ApiPaths.businessesNearby,
        queryParameters: <String, dynamic>{
          'lat': latitude,
          'lng': longitude,
          'radius': radiusKm,
          if (category != null && category.isNotEmpty) 'category': category,
          if (query != null && query.isNotEmpty) 'q': query,
        },
      );
      return ApiResponse.asList(response.data).map(BusinessModel.fromJson).toList();
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<BusinessModel> fetchBusiness(String id) async {
    try {
      final Response<dynamic> response =
          await _dio.get<dynamic>(ApiPaths.business(id));
      return BusinessModel.fromJson(ApiResponse.asMap(response.data));
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<List<LoyaltyCardModel>> fetchBusinessCards(String id) async {
    try {
      final Response<dynamic> response =
          await _dio.get<dynamic>(ApiPaths.businessCards(id));
      return ApiResponse.asList(response.data)
          .map(LoyaltyCardModel.fromJson)
          .toList();
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<List<PromotionModel>> fetchBusinessPromotions(String id) async {
    try {
      final Response<dynamic> response =
          await _dio.get<dynamic>(ApiPaths.businessPromotions(id));
      return ApiResponse.asList(response.data)
          .map(PromotionModel.fromJson)
          .toList();
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }
}
