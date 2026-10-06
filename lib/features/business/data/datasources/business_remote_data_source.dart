import 'package:dio/dio.dart';

import '../../../../core/config/api_paths.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_response.dart';
import '../../../cards/data/models/loyalty_card.dart';
import '../../../cards/data/models/stamp.dart';
import '../../../promotions/data/models/promotion.dart';
import '../models/business_customer.dart';
import '../models/business_dashboard.dart';
import '../models/manage_inputs.dart';
import '../models/scan_stamp_result.dart';

/// Endpoints del modo negocio (panel, tarjetas, promociones y escaneo).
final class BusinessRemoteDataSource {
  const BusinessRemoteDataSource(this._dio);

  final Dio _dio;

  Future<BusinessDashboard> fetchDashboard() async {
    try {
      final Response<dynamic> response =
          await _dio.get<dynamic>(ApiPaths.businessDashboard);
      return BusinessDashboard.fromJson(ApiResponse.asMap(response.data));
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<List<LoyaltyCardModel>> fetchCards() async {
    try {
      final Response<dynamic> response =
          await _dio.get<dynamic>(ApiPaths.businessOwnCards);
      return ApiResponse.asList(response.data)
          .map(LoyaltyCardModel.fromJson)
          .toList();
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<LoyaltyCardModel> createCard(LoyaltyCardInput input) async {
    try {
      final Response<dynamic> response = await _dio.post<dynamic>(
        ApiPaths.businessOwnCards,
        data: input.toJson(),
      );
      return LoyaltyCardModel.fromJson(ApiResponse.asMap(response.data));
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<LoyaltyCardModel> updateCard(
    String id,
    LoyaltyCardInput input,
  ) async {
    try {
      final Response<dynamic> response = await _dio.put<dynamic>(
        ApiPaths.businessOwnCard(id),
        data: input.toJson(),
      );
      return LoyaltyCardModel.fromJson(ApiResponse.asMap(response.data));
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<void> deleteCard(String id) async {
    try {
      await _dio.delete<dynamic>(ApiPaths.businessOwnCard(id));
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  /// Sube logo, fondo o icono de sello de una tarjeta.
  Future<LoyaltyCardModel> uploadCardAsset({
    required String cardId,
    required String field,
    required List<int> bytes,
    required String filename,
  }) async {
    try {
      final FormData formData = FormData.fromMap(<String, dynamic>{
        field: MultipartFile.fromBytes(bytes, filename: filename),
      });
      final Response<dynamic> response = await _dio.post<dynamic>(
        ApiPaths.businessOwnCardAssets(cardId),
        data: formData,
      );
      return LoyaltyCardModel.fromJson(ApiResponse.asMap(response.data));
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<List<PromotionModel>> fetchPromotions() async {
    try {
      final Response<dynamic> response =
          await _dio.get<dynamic>(ApiPaths.businessOwnPromotions);
      return ApiResponse.asList(response.data)
          .map(PromotionModel.fromJson)
          .toList();
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<PromotionModel> createPromotion(PromotionInput input) async {
    try {
      final Response<dynamic> response = await _dio.post<dynamic>(
        ApiPaths.businessOwnPromotions,
        data: input.toJson(),
      );
      return PromotionModel.fromJson(ApiResponse.asMap(response.data));
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<PromotionModel> updatePromotion(
    String id,
    PromotionInput input,
  ) async {
    try {
      final Response<dynamic> response = await _dio.put<dynamic>(
        ApiPaths.businessOwnPromotion(id),
        data: input.toJson(),
      );
      return PromotionModel.fromJson(ApiResponse.asMap(response.data));
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<void> deletePromotion(String id) async {
    try {
      await _dio.delete<dynamic>(ApiPaths.businessOwnPromotion(id));
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<List<BusinessCustomerModel>> fetchCustomers({String? query}) async {
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        ApiPaths.businessCustomers,
        queryParameters: query == null || query.isEmpty
            ? null
            : <String, dynamic>{'q': query},
      );
      return ApiResponse.asList(response.data)
          .map(BusinessCustomerModel.fromJson)
          .toList();
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<BusinessCustomerModel> fetchCustomer(String id) async {
    try {
      final Response<dynamic> response =
          await _dio.get<dynamic>(ApiPaths.businessCustomer(id));
      return BusinessCustomerModel.fromJson(ApiResponse.asMap(response.data));
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  /// Registra un sello a partir del QR (o código) del cliente.
  Future<ScanStampResult> scanStamp(String qrCode) async {
    try {
      final Response<dynamic> response = await _dio.post<dynamic>(
        ApiPaths.businessStampsScan,
        data: <String, dynamic>{'qr_code': qrCode.trim()},
      );
      return ScanStampResult.fromJson(ApiResponse.asMap(response.data));
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<List<StampModel>> fetchRecentStamps() async {
    try {
      final Response<dynamic> response =
          await _dio.get<dynamic>(ApiPaths.businessStampsRecent);
      return ApiResponse.asList(response.data).map(StampModel.fromJson).toList();
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }
}
