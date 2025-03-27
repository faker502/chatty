import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import 'state.dart';

class ProfileController extends GetxController {
  final state = ProfileState();
  final _authService = AuthService.to;

  @override
  void onInit() {
    super.onInit();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    state.isLoading = true;
    try {
      // 使用 AuthService 中的用户信息
      state.user = _authService.currentUser;
    } finally {
      state.isLoading = false;
    }
  }

  void toggleEditMode() {
    state.isEditing = !state.isEditing;
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    state.isLoading = true;
    try {
      // TODO: 调用API更新用户资料
      await Future.delayed(const Duration(seconds: 1));
      state.isEditing = false;
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      state.isLoading = false;
    }
  }
} 