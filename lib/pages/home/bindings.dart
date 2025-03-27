import 'package:get/get.dart';
import 'controller.dart';
import 'chats/controller.dart';
import 'contacts/controller.dart';
import 'profile/controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ChatsController>(() => ChatsController());
    Get.lazyPut<ContactsController>(() => ContactsController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
} 