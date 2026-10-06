import 'package:dio/dio.dart';

import '../../../../core/config/api_paths.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_response.dart';
import '../models/customer_card.dart';
import '../models/customer_card_qr.dart';
import '../models/stamp.dart';

/// Endpoints de tarjetas del cliente.
final class CardsRemoteDataSource {
  const CardsRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<CustomerCardModel>> fetchCards() async {
    try {
      final Response<dynamic> response =
          await _dio.get<dynamic>(ApiPaths.customerCards);
      return ApiResponse.asList(response.data)
          .map(CustomerCardModel.fromJson)
          .toList();
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<CustomerCardModel> fetchCard(String id) async {
    try {
      final Response<dynamic> response =
          await _dio.get<dynamic>(ApiPaths.customerCard(id));
      return CustomerCardModel.fromJson(ApiResponse.asMap(response.data));
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<List<StampModel>> fetchStamps(String id) async {
    try {
      final Response<dynamic> response =
          await _dio.get<dynamic>(ApiPaths.customerCardStamps(id));
      return ApiResponse.asList(response.data).map(StampModel.fromJson).toList();
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  /// Une al cliente a una tarjeta a partir del código o QR del negocio.
  Future<CustomerCardModel> join(String qrCode) async {
    try {
      final Response<dynamic> response = await _dio.post<dynamic>(
        ApiPaths.customerCardsJoin,
        data: <String, dynamic>{'qr_code': qrCode},
      );
      return CustomerCardModel.fromJson(ApiResponse.asMap(response.data));
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  /// Solicita un QR temporal para acumular un sello.
  Future<CustomerCardQr> fetchQr(String id) async {
    try {
      final Response<dynamic> response =
          await _dio.get<dynamic>(ApiPaths.customerCardQr(id));
      return CustomerCardQr.fromJson(
        ApiResponse.asMap(response.data),
        customerCardId: id,
      );
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  /// Canjea la recompensa de una tarjeta completada.
  Future<CustomerCardModel?> redeem(String id) async {
    try {
      final Response<dynamic> response =
          await _dio.post<dynamic>(ApiPaths.customerCardRedeem(id));
      final Map<String, dynamic> body = ApiResponse.asMap(response.data);
      if (body.isEmpty) return null;
      return CustomerCardModel.fromJson(body);
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }
}
