import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import 'state.dart';
import 'dart:async';

class WelcomeController extends GetxController {
  final state = WelcomeState();
  final _authService = AuthService.to;
  
  // 倒计时秒数
  final countdown = 3.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        _timer?.cancel();
        _checkAuthStatus();
      }
    });
  }

  void skipCountdown() {
    _timer?.cancel();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    print('Checking auth status...');
    state.isLoading = true;
    
    try {
      // 检查是否有token
      final token = _authService.token;
      print('Token: $token');
      
      if (token != null) {
        print('User is logged in, navigating to home...');
        await Get.offAllNamed('/home');
      } else {
        print('User is not logged in, navigating to login...');
        await Get.offAllNamed('/login');
      }
    } catch (e) {
      print('Error in _checkAuthStatus: $e');
      await Get.offAllNamed('/login');
    } finally {
      state.isLoading = false;
    }
  }

  // 处理页面切换
  void handlePageChanged(int index) {
    state.currentPage = index;
  }

  // 处理开始按钮点击
  void handleStart() async {
    state.isLoading = true;
    try {
      await Future.delayed(const Duration(seconds: 1)); // 模拟加载
      Get.offNamed('/login');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      state.isLoading = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    print('WelcomeController onClose');
    // 清理资源
    super.onClose();
  }
}