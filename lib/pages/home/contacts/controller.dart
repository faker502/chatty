import 'package:get/get.dart';
import 'state.dart';

class ContactsController extends GetxController {
  final state = ContactsState();

  @override
  void onInit() {
    super.onInit();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    state.isLoading = true;
    try {
      // TODO: 从API加载联系人列表
      // 模拟数据
      await Future.delayed(const Duration(seconds: 1));
      state.contacts = [
        {
          'id': '1',
          'name': 'John Doe',
          'status': 'Online',
          'avatar': null,
        },
        {
          'id': '2',
          'name': 'Jane Smith',
          'status': 'Offline',
          'avatar': null,
        },
        {
          'id': '3',
          'name': 'Mike Johnson',
          'status': 'Away',
          'avatar': null,
        },
      ];
    } finally {
      state.isLoading = false;
    }
  }

  void handleSearchChanged(String query) {
    state.searchQuery = query;
  }

  void handleContactTap(Map<String, dynamic> contact) {
    // TODO: 导航到联系人详情页面
    Get.snackbar(
      'Contact',
      'Opening contact ${contact['name']}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  List<Map<String, dynamic>> get filteredContacts {
    if (state.searchQuery.isEmpty) {
      return state.contacts;
    }
    return state.contacts
        .where((contact) =>
            contact['name'].toString().toLowerCase().contains(state.searchQuery.toLowerCase()))
        .toList();
  }
} 