import 'package:dio/dio.dart';
import '../models/coin_model.dart';
import '../resources/rest_constants.dart';
import 'base_dio_helper.dart';

class CryptoRepository {
  Future<List<CoinModel>> fetchCoins({
    required int page,
    int perPage = RestConstants.perPage,
  }) async {
    try {
      final response = await DioHelper.getData(
        url: RestConstants.coinMarketsURL,
        query: {
          'vs_currency': RestConstants.vsCurrency,
          'order': RestConstants.order,
          'per_page': perPage,
          'page': page,
          'sparkline': false,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> list = response.data as List<dynamic>;
        return list.map((item) => CoinModel.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to load crypto market data');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network error occurred');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }
}
