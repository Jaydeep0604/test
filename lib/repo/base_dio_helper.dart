import 'package:dio/dio.dart';
import '../resources/rest_constants.dart';

class DioHelper {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: RestConstants.baseURL,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      receiveDataWhenStatusError: true,
    ),
  );

  static void init() {
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: false,
        error: true,
      ),
    );
  }

  static Future<Response> getData({
    required final String url,
    final Map<String, dynamic>? query,
  }) => dio.get(
    url,
    queryParameters: query,
  );
}
