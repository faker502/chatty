import 'package:get/get.dart';

class LoginState {
  // 表单状态
  final _username = ''.obs;
  final _password = ''.obs;
  final _isLoading = false.obs;
  final _obscurePassword = true.obs;

  // Getters
  get username => _username.value;
  get password => _password.value;
  get isLoading => _isLoading.value;
  get obscurePassword => _obscurePassword.value;

  // Setters
  set username(value) => _username.value = value;
  set password(value) => _password.value = value;
  set isLoading(value) => _isLoading.value = value;
  set obscurePassword(value) => _obscurePassword.value = value;

  // 表单验证
  bool get isValid => username.isNotEmpty && password.isNotEmpty;
} 