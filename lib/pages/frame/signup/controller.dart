import 'package:get/get.dart';
import 'state.dart';

class SignupController extends GetxController {
  final state = SignupState();

  // 处理用户名输入
  void handleUsernameChanged(String value) {
    state.username = value;
  }

  // 处理密码输入
  void handlePasswordChanged(String value) {
    state.password = value;
  }

  // 处理确认密码输入
  void handleConfirmPasswordChanged(String value) {
    state.confirmPassword = value;
  }

  // 处理邮箱输入
  void handleEmailChanged(String value) {
    state.email = value;
  }

  // 切换密码显示状态
  void togglePasswordVisibility() {
    state.obscurePassword = !state.obscurePassword;
  }

  // 切换确认密码显示状态
  void toggleConfirmPasswordVisibility() {
    state.obscureConfirmPassword = !state.obscureConfirmPassword;
  }

  // 处理注册
  void handleSignup() async {
    if (!state.isValid) {
      if (state.password != state.confirmPassword) {
        Get.snackbar(
          'Error',
          'Passwords do not match',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Please fill in all fields',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return;
    }

    state.isLoading = true;
    try {
      await Future.delayed(const Duration(seconds: 2)); // 模拟注册请求
      // TODO: 实现实际的注册逻辑
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Registration failed',
        snackPosition: SnackPosition.BOTTOM,
      );
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