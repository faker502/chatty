import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class ApiClient {
  late dio.Dio _dio;
  final String baseUrl;

  ApiClient({required this.baseUrl}) {
    _dio = dio.Dio(dio.BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // 添加拦截器
    _dio.interceptors.add(dio.InterceptorsWrapper(
      onRequest: (options, handler) {
        // 在请求之前做一些处理
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // 在响应之前做一些处理
        return handler.next(response);
      },
      onError: (dio.DioException e, handler) {
        // 错误处理
        return handler.next(e);
      },
    ));
  }

  Future<dio.Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dio.Response> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dio.Response> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dio.Response> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response;
    } catch (e) {
      rethrow;
    }
  }
} 