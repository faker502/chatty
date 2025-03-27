import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

class ChatsView extends GetView<ChatsController> {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.state.chats.isEmpty) {
          return const Center(child: Text('No chats yet'));
        }

        return ListView.builder(
          itemCount: controller.state.chats.length,
          itemBuilder: (context, index) {
            final chat = controller.state.chats[index];
            return ListTile(
              leading: CircleAvatar(
                child: Text(chat['name'][0]),
              ),
              title: Text(chat['name']),
              subtitle: Text(
                chat['lastMessage'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    chat['time'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  if (chat['unreadCount'] > 0)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        chat['unreadCount'].toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              onTap: () => controller.handleChatTap(chat),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: 实现新建聊天功能
          Get.snackbar(
            'New Chat',
            'Creating new chat...',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 