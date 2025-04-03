import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/components/app_bar_title/index.dart';
import 'package:linyu_mobile/components/custom_badge/index.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/components/custom_search_box/index.dart';
import 'package:linyu_mobile/pages/chat_list/logic.dart';
import 'package:linyu_mobile/utils/String.dart';
import 'package:linyu_mobile/utils/date.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';
import 'package:linyu_mobile/utils/linyu_msg.dart';

class ChatListPage extends CustomWidget<ChatListLogic> {
  ChatListPage({super.key});

  Widget _buildChatItem(dynamic chat, String id) {
    return Slidable(
      key: ValueKey(id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            padding: const EdgeInsets.all(0),
            onPressed: (context) => controller.onTopStatus(id, chat['isTop']),
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            icon: chat['isTop'] ? Icons.push_pin_outlined : Icons.push_pin,
            label: chat['isTop'] ? '取消置顶' : '置顶',
            // flex: chat.isTop ? 3 : 2,
          ),
          SlidableAction(
            padding: const EdgeInsets.all(0),
            onPressed: (context) => controller.onDeleteChatList(id),
            backgroundColor: const Color(0xFFFF4C4C),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: '删除',
            // flex: 2,
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: InkWell(
          onTap: () => controller.onTapToChat(chat),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[100]!,
                  width: 1,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  CustomPortrait(url: chat['portrait'] ?? ''),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  StringUtil.isNotNullOrEmpty(chat['remark'])
                                      ? chat['remark']
                                      : chat['name'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                if (chat['type'] == 'group')
                                  const CustomBadge(text: '群'),
                              ],
                            ),
                            Text(
                              DateUtil.formatTime(chat['updateTime']),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                chat['name'] == null && chat['type'] == 'group'
                                    ? '该群已解散'
                                    : LinyuMsgUtil.getMsgContent(
                                        chat['lastMsgContent']),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (chat['unreadNum'] > 0)
                              Container(
                                width: 16,
                                height: 16,
                                padding: const EdgeInsets.all(0),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFF4C4C),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    chat['unreadNum'] < 99
                                        ? chat['unreadNum'].toString()
                                        : '99',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PopupMenuEntry<int> _buildPopupDivider() {
    return PopupMenuItem<int>(
      enabled: false,
      height: 1,
      child: Container(
        height: 1,
        padding: const EdgeInsets.all(0),
        color: Colors.grey[200],
      ),
    );
  }

  Widget _buildSearchItem(dynamic chatObject, String id,
      {bool isGroup = false}) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: InkWell(
        onTap: () => !isGroup
            ? controller.onTapSearchFriend(chatObject)
            : controller.onTapSearchGroup(chatObject),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[200]!,
                width: 0.5,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                CustomPortrait(url: chatObject['portrait']),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            chatObject['name'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (chatObject[!isGroup ? 'remark' : 'groupRemark'] !=
                                  null &&
                              chatObject[!isGroup ? 'remark' : 'groupRemark']
                                      ?.toString()
                                      .trim() !=
                                  '')
                            Text(
                              '(${chatObject[!isGroup ? 'remark' : 'groupRemark']})',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          const SizedBox(width: 5),
                          if (isGroup) const CustomBadge(text: '群'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  init(BuildContext context) => controller.onGetChatList();

  @override
  Widget buildWidget(BuildContext context) => GestureDetector(
        onTap: () => controller.focusNode.unfocus(),
        child: Scaffold(
          backgroundColor: const Color(0xFFF9FBFF),
          appBar: AppBar(
            // leading: Container(
            //   margin: const EdgeInsets.only(left: 13.2, top: 10.8),
            //   child: CustomPortrait(
            //     url: globalData.currentAvatarUrl ?? '',
            //     size: 40,
            //     radius: 20,
            //     onTap: () => Scaffold.of(context).openDrawer(),
            //   ),
            // ),
            centerTitle: true,
            title: const AppBarTitle('聊天列表'),
            backgroundColor: const Color(0xFFF9FBFF),
            actions: [
              PopupMenuButton(
                icon: const Icon(Icons.add, size: 32),
                offset: const Offset(0, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                color: const Color(0xFFFFFFFF),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                  PopupMenuItem(
                    value: 1,
                    height: 40,
                    onTap: () => Get.toNamed('/qr_code_scan'),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(IconData(0xe61e, fontFamily: 'IconFont'),
                            size: 20),
                        SizedBox(width: 12),
                        Text('扫一扫', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  _buildPopupDivider(),
                  PopupMenuItem(
                    value: 1,
                    height: 40,
                    onTap: () => Get.toNamed('/add_friend'),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_add, size: 20),
                        SizedBox(width: 12),
                        Text('添加好友', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  _buildPopupDivider(),
                  PopupMenuItem(
                    value: 2,
                    height: 40,
                    onTap: () => Get.toNamed('/create_chat_group'),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.group_add, size: 20),
                        SizedBox(width: 12),
                        Text('创建群聊', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            child: Column(
              children: [
                CustomSearchBox(
                  focusNode: controller.focusNode,
                  textEditingController: controller.searchBoxController,
                  isCentered: false,
                  onChanged: (value) => controller.onSearch(value),
                ),
                if (controller.groupSearchList.isNotEmpty ||
                    controller.friendSearchList.isNotEmpty ||
                    controller.otherList.isNotEmpty ||
                    controller.topList.isNotEmpty)
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        controller.onGetChatList();
                        return Future.delayed(
                            const Duration(milliseconds: 700));
                      },
                      color: theme.primaryColor,
                      child: ListView(
                        children: [
                          if ((controller.friendSearchList.isNotEmpty ||
                                  controller.groupSearchList.isNotEmpty) &&
                              controller.searchBoxController.text
                                  .trim()
                                  .isNotEmpty) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "搜索结果",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                            ...controller.friendSearchList.map((friend) =>
                                _buildSearchItem(friend, friend['friendId'])),
                            ...controller.groupSearchList.map((group) =>
                                _buildSearchItem(group, group['id'],
                                    isGroup: true)),
                          ],
                          if (controller.topList.isNotEmpty) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "置顶",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                            ...controller.topList.map(
                                (chat) => _buildChatItem(chat, chat['id'])),
                          ],
                          if (controller.otherList.isNotEmpty) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "全部",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                            ...controller.otherList.map(
                                (chat) => _buildChatItem(chat, chat['id'])),
                          ],
                        ],
                      ),
                    ),
                  ),
                if (controller.friendSearchList.isEmpty &&
                    controller.otherList.isEmpty &&
                    controller.topList.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/empty-bg.png',
                            width: 100,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '暂无聊天记录~',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}
