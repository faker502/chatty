import 'package:get/get.dart';

class SignupState {
  // 表单状态
  final _username = ''.obs;
  final _password = ''.obs;
  final _confirmPassword = ''.obs;
  final _email = ''.obs;
  final _isLoading = false.obs;
  final _obscurePassword = true.obs;
  final _obscureConfirmPassword = true.obs;

  // Getters
  get username => _username.value;
  get password => _password.value;
  get confirmPassword => _confirmPassword.value;
  get email => _email.value;
  get isLoading => _isLoading.value;
  get obscurePassword => _obscurePassword.value;
  get obscureConfirmPassword => _obscureConfirmPassword.value;

  // Setters
  set username(value) => _username.value = value;
  set password(value) => _password.value = value;
  set confirmPassword(value) => _confirmPassword.value = value;
  set email(value) => _email.value = value;
  set isLoading(value) => _isLoading.value = value;
  set obscurePassword(value) => _obscurePassword.value = value;
  set obscureConfirmPassword(value) => _obscureConfirmPassword.value = value;

  // 表单验证
  bool get isValid => 
    username.isNotEmpty && 
    password.isNotEmpty && 
    confirmPassword.isNotEmpty && 
    email.isNotEmpty &&
    password == confirmPassword;
} 