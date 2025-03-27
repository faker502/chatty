import 'package:get/get.dart';

class ContactsState {
  final _contacts = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> get contacts => _contacts;
  set contacts(List<Map<String, dynamic>> value) => _contacts.value = value;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  final _searchQuery = ''.obs;
  String get searchQuery => _searchQuery.value;
  set searchQuery(String value) => _searchQuery.value = value;
} 