import 'package:dio/dio.dart';
import '../models/coin_model.dart';
import '../resources/rest_constants.dart';
import 'base_dio_helper.dart';

class CryptoRepository {
  /// Fetch list of coins from CoinGecko API with pagination
  Future<List<CoinModel>> fetchCoins({
    int page = 1,
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
        return list.map((json) => CoinModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to load market data');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network error occurred');
    } catch (e) {
      throw Exception('Failed to load market data');
    }
  }

  /// Fetch full coin objects for the saved watchlist IDs
  Future<List<CoinModel>> fetchWatchlistCoins(List<String> watchlistIds) async {
    if (watchlistIds.isEmpty) return [];

    try {
      // Fetch coins to match with watchlist IDs
      final coins = await fetchCoins(page: 1, perPage: 250);
      return coins.where((coin) => watchlistIds.contains(coin.id)).toList();
    } catch (e) {
      return [];
    }
  }
}
