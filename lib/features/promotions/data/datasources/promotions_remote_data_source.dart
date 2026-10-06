import 'package:dio/dio.dart';

import '../../../../core/config/api_paths.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_response.dart';
import '../models/promotion.dart';

/// Endpoints de promociones para el cliente.
final class PromotionsRemoteDataSource {
  const PromotionsRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<PromotionModel>> fetchPromotions({String? businessId}) async {
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        businessId == null
            ? ApiPaths.customerPromotions
            : ApiPaths.businessPromotions(businessId),
      );
      return ApiResponse.asList(response.data)
          .map(PromotionModel.fromJson)
          .toList();
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }
}
