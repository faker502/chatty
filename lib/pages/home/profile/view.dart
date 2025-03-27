import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = controller.state.user;
        if (user == null) {
          return const Center(child: Text('No user data'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                child: Text(
                  user.nickname[0].toUpperCase(),
                  style: const TextStyle(fontSize: 32),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user.nickname,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user.abstract.isEmpty ? 'No description' : user.abstract,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              if (controller.state.isEditing)
                _buildEditForm(user)
              else
                _buildProfileInfo(user),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileInfo(dynamic user) {
    return Column(
      children: [
        _buildInfoCard(
          title: 'Account Settings',
          children: [
            _buildInfoTile(
              icon: Icons.edit,
              title: 'Edit Profile',
              onTap: controller.toggleEditMode,
            ),
            _buildInfoTile(
              icon: Icons.lock,
              title: 'Change Password',
              onTap: () {
                // TODO: 实现修改密码功能
                Get.snackbar(
                  'Change Password',
                  'Password change feature coming soon',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            _buildInfoTile(
              icon: Icons.notifications,
              title: 'Notifications',
              onTap: () {
                // TODO: 实现通知设置功能
                Get.snackbar(
                  'Notifications',
                  'Notification settings coming soon',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          title: 'App Settings',
          children: [
            _buildInfoTile(
              icon: Icons.language,
              title: 'Language',
              onTap: () {
                // TODO: 实现语言设置功能
                Get.snackbar(
                  'Language',
                  'Language settings coming soon',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            _buildInfoTile(
              icon: Icons.dark_mode,
              title: 'Theme',
              onTap: () {
                // TODO: 实现主题设置功能
                Get.snackbar(
                  'Theme',
                  'Theme settings coming soon',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            _buildInfoTile(
              icon: Icons.storage,
              title: 'Storage',
              onTap: () {
                // TODO: 实现存储管理功能
                Get.snackbar(
                  'Storage',
                  'Storage management coming soon',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEditForm(dynamic user) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(),
          ),
          controller: TextEditingController(text: user.nickname),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
          controller: TextEditingController(text: user.abstract),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: controller.toggleEditMode,
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.updateProfile({
                  'nickname': user.nickname,
                  'abstract': user.abstract,
                });
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
} 