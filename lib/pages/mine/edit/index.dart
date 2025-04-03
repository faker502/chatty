import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linyu_mobile/components/custom_button/index.dart';
import 'package:linyu_mobile/components/custom_text_field/index.dart';
import 'package:linyu_mobile/components/custom_update_portrait/index.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

import 'logic.dart';

class EditMinePage extends CustomView<EditMineLogic> {
  EditMinePage({super.key});

  @override
  Widget buildView(BuildContext context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.minorColor, const Color(0xFFFFFFFF)],
            // 渐变颜色
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                CustomUpdatePortrait(
                    isEdit: controller.isEdit,
                    onTap: () => controller.selectPortrait(),
                    url: controller.currentUserInfo['portrait'] ??
                        'http://192.168.101.4:9000/linyu/default-portrait.jpg',
                    size: 80,
                    radius: 50),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => controller.setSex('男'),
                        child: Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: controller.maleColorActive,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.male,
                                size: 20,
                                color: controller.maleTextColorActive,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '男生',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: controller.maleTextColorActive,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      GestureDetector(
                        onTap: () => controller.setSex('女'),
                        child: Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: controller.femaleColorActive,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.female,
                                size: 20,
                                color: controller.femaleTextColorActive,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '女生',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: controller.femaleTextColorActive,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: const Color(0xFFF2F2F2),
                      width: 1.0,
                    ),
                  ),
                  child: Column(children: [
                    CustomTextField(
                      labelText: "昵称",
                      controller: controller.nameController,
                      inputLimit: 30,
                      onChanged: controller.onNameTextChanged,
                      readOnly: !controller.isEdit,
                      suffix: Text('${controller.nameTextLength}/30'),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      labelText: "生日",
                      controller: controller.birthdayController,
                      readOnly: true,
                      showCursor: false,
                      suffixIcon: IconButton(
                        onPressed: () => controller.selectDate(context),
                        icon: Icon(Icons.calendar_today,
                            size: 20, color: theme.primaryColor),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      labelText: "签名",
                      controller: controller.signatureController,
                      inputLimit: 100,
                      onChanged: controller.onSignatureTextChanged,
                      readOnly: !controller.isEdit,
                      maxLines: 4,
                      suffix: Text('${controller.signatureTextLength}/100'),
                    ),
                  ]),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: !controller.isEdit ? "编辑资料" : "保存",
                  onTap: controller.onPressed,
                  width: MediaQuery.of(context).size.width,
                  type: 'gradient',
                ),
              ],
            ),
          ),
        ),
      );
}
