import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';
import 'chats/view.dart';
import 'contacts/view.dart';
import 'profile/view.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.handleLogout,
          ),
        ],
      ),
      body: Obx(() {
        switch (controller.state.currentIndex) {
          case 0:
            return const ChatsView();
          case 1:
            return const ContactsView();
          case 2:
            return const ProfileView();
          default:
            return const Center(child: Text('Unknown'));
        }
      }),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.state.currentIndex,
        onTap: controller.handleBottomNavigationChanged,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      )),
    );
  }
} 