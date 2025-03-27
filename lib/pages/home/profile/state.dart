import 'package:get/get.dart';
import '../../../models/user.dart';

class ProfileState {
  final _user = Rxn<User>();
  User? get user => _user.value;
  set user(User? value) => _user.value = value;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  final _isEditing = false.obs;
  bool get isEditing => _isEditing.value;
  set isEditing(bool value) => _isEditing.value = value;
} 