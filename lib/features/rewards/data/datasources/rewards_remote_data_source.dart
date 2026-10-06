import 'package:dio/dio.dart';

import '../../../../core/config/api_paths.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_response.dart';
import '../models/reward.dart';

/// Endpoints de premios del cliente.
final class RewardsRemoteDataSource {
  const RewardsRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<RewardModel>> fetchRewards({RewardStatus? status}) async {
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        ApiPaths.customerRewards,
        queryParameters: status == null
            ? null
            : <String, dynamic>{'status': status.name},
      );
      return ApiResponse.asList(response.data).map(RewardModel.fromJson).toList();
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<RewardModel?> redeem(String id) async {
    try {
      final Response<dynamic> response =
          await _dio.post<dynamic>(ApiPaths.customerRewardRedeem(id));
      final Map<String, dynamic> body = ApiResponse.asMap(response.data);
      if (body.isEmpty) return null;
      return RewardModel.fromJson(body);
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }
}
