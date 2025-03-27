import 'package:get/get.dart';

class ChatsState {
  final _chats = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> get chats => _chats;
  set chats(List<Map<String, dynamic>> value) => _chats.value = value;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;
} 