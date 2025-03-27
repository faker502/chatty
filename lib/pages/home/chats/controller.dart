import 'package:get/get.dart';
import 'state.dart';

class ChatsController extends GetxController {
  final state = ChatsState();

  @override
  void onInit() {
    super.onInit();
    _loadChats();
  }

  Future<void> _loadChats() async {
    state.isLoading = true;
    try {
      // TODO: 从API加载聊天列表
      // 模拟数据
      await Future.delayed(const Duration(seconds: 1));
      state.chats = [
        {
          'id': '1',
          'name': 'John Doe',
          'lastMessage': 'Hello!',
          'time': '10:30 AM',
          'unreadCount': 2,
        },
        {
          'id': '2',
          'name': 'Jane Smith',
          'lastMessage': 'How are you?',
          'time': '9:15 AM',
          'unreadCount': 0,
        },
      ];
    } finally {
      state.isLoading = false;
    }
  }

  void handleChatTap(Map<String, dynamic> chat) {
    // TODO: 导航到聊天详情页面
    Get.snackbar(
      'Chat',
      'Opening chat with ${chat['name']}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
} 