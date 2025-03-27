import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

class ContactsView extends GetView<ContactsController> {
  const ContactsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: controller.handleSearchChanged,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredContacts.isEmpty) {
                return const Center(child: Text('No contacts found'));
              }

              return ListView.builder(
                itemCount: controller.filteredContacts.length,
                itemBuilder: (context, index) {
                  final contact = controller.filteredContacts[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(contact['name'][0]),
                    ),
                    title: Text(contact['name']),
                    subtitle: Text(contact['status']),
                    trailing: IconButton(
                      icon: const Icon(Icons.message),
                      onPressed: () {
                        // TODO: 实现发送消息功能
                        Get.snackbar(
                          'Message',
                          'Sending message to ${contact['name']}',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),
                    onTap: () => controller.handleContactTap(contact),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: 实现添加联系人功能
          Get.snackbar(
            'Add Contact',
            'Adding new contact...',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }
} 