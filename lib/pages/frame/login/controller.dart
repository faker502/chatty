import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import 'state.dart';

class LoginController extends GetxController {
  final state = LoginState();
  final _authService = AuthService.to;

  // 处理用户名输入
  void handleUsernameChanged(String value) {
    state.username = value;
  }

  // 处理密码输入
  void handlePasswordChanged(String value) {
    state.password = value;
  }

  // 切换密码显示状态
  void togglePasswordVisibility() {
    state.obscurePassword = !state.obscurePassword;
  }

  // 处理登录
  void handleLogin() async {
    if (!state.isValid) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    state.isLoading = true;
    try {
      final success = await _authService.login(state.username, state.password);
      if (success) {
        // 导航到主页
        Get.offAllNamed('/home');
      }
    } finally {
      state.isLoading = false;
    }
  }

  @override
  void onClose() {
    // 清理资源
    super.onClose();
  }
} 