import 'package:get/get.dart';

class WelcomeState {
  // 页面状态
  final _currentPage = 0.obs;
  final _isLoading = false.obs;

  // Getters
  int get currentPage => _currentPage.value;
  get isLoading => _isLoading.value;

  // Setters
  set currentPage(int value) => _currentPage.value = value;
  set isLoading(value) => _isLoading.value = value;

  // 欢迎页数据
  final List<Map<String, String>> pages = [
    {
      'title': 'Welcome to IM Flutter',
      'description': 'Connect with friends and family in real-time',
      'image': 'assets/images/demo.png',
    },
    {
      'title': 'Secure Communication',
      'description': 'Your messages are encrypted and secure',
      'image': 'assets/images/demo.png',
    },
    {
      'title': 'Start Chatting',
      'description': 'Begin your journey with IM Flutter',
      'image': 'assets/images/demo.png',
    },
  ];
} 