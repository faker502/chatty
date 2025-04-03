import 'package:custom_pop_up_menu_fork/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linyu_mobile/components/app_bar_title/index.dart';
import 'package:linyu_mobile/components/custom_button/index.dart';
import 'package:linyu_mobile/components/custom_icon_button/index.dart';
import 'package:linyu_mobile/components/custom_label_value_button/index.dart';
import 'package:linyu_mobile/components/custom_least_button/index.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/components/custom_shadow_text/index.dart';
import 'package:linyu_mobile/components/custom_update_portrait/index.dart';
import 'package:linyu_mobile/pages/contacts/chat_group_information/logic.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class ChatGroupInformationPage extends CustomWidget<ChatGroupInformationLogic> {
  ChatGroupInformationPage({super.key});

  Widget _selectedUserItem(dynamic member) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomPortrait(
            url: member['portrait'],
            size: 40,
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 40,
            child: Center(
              child: Text(
                member['name'],
                style: const TextStyle(
                    fontSize: 12, overflow: TextOverflow.ellipsis),
              ),
            ),
          )
        ],
      );

  @override
  Widget buildWidget(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFF9FBFF),
        appBar: AppBar(
          centerTitle: true,
          title: const AppBarTitle('群资料'),
          backgroundColor: const Color(0xFFF9FBFF),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [theme.minorColor, const Color(0xFFFFFFFF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 100,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 5,
                                ),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: CustomUpdatePortrait(
                                  isEdit: controller.isOwner,
                                  onTap: () => controller.selectPortrait(),
                                  url:
                                      controller.chatGroupDetails['portrait'] ??
                                          '',
                                  size: 70,
                                  radius: 35),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomShadowText(
                                      text:
                                          controller.chatGroupDetails['name']),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 1),
                      QuickPopUpMenu(
                        showArrow: true,
                        useGridView: false,
                        // useGridView: true,
                        darkMode: true,
                        pressType: PressType.longPress,
                        menuItems: [
                          PopMenuItemModel(
                            title: '复制',
                            icon: Icons.content_copy,
                            callback: (data) {
                              Clipboard.setData(ClipboardData(
                                  text: controller
                                      .chatGroupDetails['chatGroupNumber']));
                            },
                          ),
                        ],
                        dataObj: CustomLabelValueButton(
                            onTap: () {},
                            width: 60,
                            label: '群号',
                            value:
                                controller.chatGroupDetails['chatGroupNumber']),
                        child: CustomLabelValueButton(
                            onTap: () {},
                            width: 60,
                            label: '群号',
                            value:
                                controller.chatGroupDetails['chatGroupNumber']),
                      ),
                      const SizedBox(height: 1),
                      CustomLabelValueButton(
                          onTap: controller.setGroupName,
                          width: 60,
                          label: '群名称',
                          value: controller.chatGroupDetails['name']),
                      const SizedBox(height: 1),
                      CustomLabelValueButton(
                          onTap: controller.setGroupRemark,
                          width: 60,
                          label: '群备注',
                          hint: '未设置备注',
                          value: controller.chatGroupDetails['groupRemark']),
                      const SizedBox(height: 1),
                      CustomLabelValueButton(
                          onTap: controller.setGroupNickname,
                          width: 60,
                          label: '群昵称',
                          hint: '未设置昵称',
                          value: controller.chatGroupDetails['groupName']),
                      const SizedBox(height: 1),
                      CustomLabelValueButton(
                        onTap: controller.chatGroupNotice,
                        width: 60,
                        label: '群公告',
                        hint: '暂无群公告~',
                        maxLines: 10,
                        value: controller.chatGroupDetails['notice'] != null
                            ? controller.chatGroupDetails['notice']
                                ['noticeContent']
                            : '',
                      ),
                      const SizedBox(height: 1),
                      CustomLabelValueButton(
                        onTap: controller.chatGroupMember,
                        width: 140,
                        compact: false,
                        label:
                            '查看所有成员(${controller.chatGroupDetails['memberNum']})',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              children: [
                                SizedBox(
                                  width: controller.groupMemberWidth,
                                  height: 62,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: controller.chatGroupMembers
                                        .map((member) => Container(
                                              margin: const EdgeInsets.only(
                                                  right: 5),
                                              child: GestureDetector(
                                                  onTap: () => controller
                                                      .onGroupMemberPress(
                                                          member),
                                                  child: _selectedUserItem(
                                                      member)),
                                            ))
                                        .toList(),
                                  ),
                                ),
                                CustomIconButton(
                                  onTap: controller.chatGroupMember,
                                  icon: Icons.add,
                                  text: '邀请成员',
                                ),
                                CustomIconButton(
                                  onTap: controller.chatGroupMember,
                                  icon: Icons.remove,
                                  text: '移除成员',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      CustomButton(
                        text: '发送消息',
                        width: MediaQuery.of(context).size.width,
                        type: 'gradient',
                        onTap: controller.onToSendGroupMsg,
                      ),
                      const SizedBox(height: 10),
                      if (controller.isOwner)
                        CustomLeastButton(
                          onTap: () => controller.onDissolveGroup(context),
                          text: '解散群聊',
                          textColor: const Color(0xFFFF4C4C),
                        ),
                      if (!controller.isOwner)
                        CustomLeastButton(
                          onTap: () => controller.onQuitGroup(context),
                          text: '退出群聊',
                          textColor: const Color(0xFFFF4C4C),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
