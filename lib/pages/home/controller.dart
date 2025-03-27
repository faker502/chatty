import 'package:get/get.dart';
import '../../services/auth_service.dart';
import 'state.dart';

class HomeController extends GetxController {
  final state = HomeState();
  final _authService = AuthService.to;

  // 处理底部导航栏切换
  void handleBottomNavigationChanged(int index) {
    state.currentIndex = index;
  }

  // 处理退出登录
  void handleLogout() async {
    state.isLoading = true;
    try {
      await _authService.logout();
    } finally {
      state.isLoading = false;
    }
  }
} 