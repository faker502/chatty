import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../network/api_client.dart';
import '../network/api_response.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();
  
  final _apiClient = ApiClient();
  final _currentUser = Rxn<User>();
  final _token = RxnString();
  final _initialized = false.obs;
  
  User? get currentUser => _currentUser.value;
  String? get token => _token.value;
  bool get isLoggedIn => _token.value != null && _currentUser.value != null;
  bool get initialized => _initialized.value;

  @override
  void onInit() {
    super.onInit();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');
    if (savedToken != null) {
      _token.value = savedToken;
      await _fetchUserInfo();
    }
    _initialized.value = true;
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    _token.value = token;
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _token.value = null;
  }

  Future<bool> login(String username, String password) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/auth/login',
        data: {
          'userName': username,
          'password': password,
        },
      );

      if (response.code == 0 && response.data != null) {
        final token = response.data!['token'] as String;
        await _saveToken(token);
        await _fetchUserInfo();
        return true;
      } else {
        Get.snackbar(
          'Error',
          response.msg,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Login failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  Future<bool> signup(String username, String email, String password) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/auth/signup',
        data: {
          'userName': username,
          'email': email,
          'password': password,
        },
      );

      if (response.code == 0) {
        return true;
      } else {
        Get.snackbar(
          'Error',
          response.msg,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Signup failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  Future<void> _fetchUserInfo() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>('/api/user/user_info');
      if (response.code == 0 && response.data != null) {
        print('${response.data}');
        _currentUser.value = User.fromJson(response.data!);
      }
    } catch (e) {
      print('Failed to fetch user info: ${e.toString()}');
      Get.snackbar(
        'Error',
        'Failed to fetch user info',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> logout() async {
    await _clearToken();
    _currentUser.value = null;
    Get.offAllNamed('/login');
  }
} 