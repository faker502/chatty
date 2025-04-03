import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:linyu_mobile/api/Http.dart';

class UserApi {
  final Dio _dio = Http().dio;
  static final UserApi _instance = UserApi._internal();

  UserApi._internal();

  factory UserApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> login(String account, String password) async {
    try {
      final response = await _dio.post(
        '/v1/api/login',
        data: {'account': account, 'password': password},
      );
      return response.data;
    } on DioException catch (e) {
      print('Get profile error: ${e.message}');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> qrLogin(String? key) async {
    final response = await _dio.post(
      '/v1/api/login/qr',
      data: {'key': key},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> publicKey() async {
    final response = await _dio.get('/v1/api/login/public-key');
    return response.data;
  }

  Future<Map<String, dynamic>> info() async {
    final response = await _dio.get('/v1/api/user/info');
    return response.data;
  }

  Future<Map<String, dynamic>> getImg(String fileName, String targetId) async {
    final response = await _dio.get(
      '/v1/api/user/get/img',
      queryParameters: {'fileName': fileName, 'targetId': targetId},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> emailVerification(String email) async {
    final response = await _dio.post(
      '/v1/api/user/email/verify',
      data: {'email': email},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> emailVerificationByAccount(
      String account) async {
    final response = await _dio.post(
      '/v1/api/user/email/verify/by/account',
      data: {'account': account},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> register(String username, String account,
      String password, String email, String code) async {
    final response = await _dio.post(
      '/v1/api/user/register',
      data: {
        'username': username,
        'account': account,
        'password': password,
        'email': email,
        'code': code
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> upload(FormData formData) async {
    final response = await _dio.post(
      '/v1/api/user/upload/portrait/form',
      data: formData,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> update({
    required String name,
    required String sex,
    required String birthday,
    required String signature,
    required String portrait,
  }) async {
    final response = await _dio.post(
      '/v1/api/user/update',
      data: {
        'name': name,
        'sex': sex,
        'birthday': birthday,
        'signature': signature,
        'portrait': portrait
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> forget(
      String account, String password, String code) async {
    final response = await _dio.post(
      '/v1/api/user/forget',
      data: {'account': account, 'password': password, 'code': code},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> updatePassword(
      String oldPassword, String newPassword, String confirmPassword) async {
    final response = await _dio.post(
      '/v1/api/user/update/password',
      data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> search(String userInfo) async {
    final response = await _dio.post(
      '/v1/api/user/search',
      data: {
        'userInfo': userInfo,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> unread() async {
    final response = await _dio.get('/v1/api/user/unread');
    return response.data;
  }

  Future<dynamic> getNetworkImage(imageUrl) async {
    final response = await _dio.get<List<int>>(
      imageUrl,
      options: Options(responseType: ResponseType.bytes),
    );
    final List<int> list = List<int>.from(response.data!);
    return base64Encode(list);
  }
}
