import 'package:get/get.dart';
import 'controller.dart';
import '../../../services/auth_service.dart';

class WelcomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AuthService());
    Get.put(WelcomeController());
  }
} 