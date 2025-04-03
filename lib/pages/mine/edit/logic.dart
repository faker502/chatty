import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/date_type.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:linyu_mobile/api/user_api.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';
import 'package:linyu_mobile/pages/chat_list/logic.dart';
import 'package:linyu_mobile/pages/contacts/logic.dart';
import 'package:linyu_mobile/pages/mine/logic.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' show MultipartFile, FormData;

import 'index.dart';

//个人资料编辑页面逻辑
class EditMineLogic extends Logic<EditMinePage> {
  //上个页面控制器
  final MineLogic _mineLogic = getx.Get.find<MineLogic>();

  final ChatListLogic _chatListLogic = getx.Get.find<ChatListLogic>();

  final ContactsLogic _contactsLogic = getx.Get.find<ContactsLogic>();

  //用户API
  final _useApi = UserApi();

  //用户名输入框控制器
  final TextEditingController nameController = new TextEditingController();

  //签名输入框控制器
  final TextEditingController signatureController = new TextEditingController();

  //签名输入框控制器
  final TextEditingController birthdayController = new TextEditingController();

  //当前用户信息
  late dynamic currentUserInfo = {};

  //是否处于编辑状态
  bool _isEdit = false;

  bool get isEdit => _isEdit;

  set isEdit(bool value) {
    _isEdit = value;
    update([const Key("edit_mine")]);
  }

  //用户名输入长度
  int _nameTextLength = 0;

  int get nameTextLength => _nameTextLength;

  set nameTextLength(int value) {
    _nameTextLength = value;
    update([const Key("login")]);
  }

  //性别
  late String _sex;

  String get sex => _sex;

  set sex(String value) {
    _sex = value;
    update([const Key("edit_mine")]);
  }

  //男性颜色被选中时的颜色
  Color _maleColorActive = const Color(0xFFe0e0e0);

  Color get maleColorActive => _maleColorActive;

  set maleColorActive(Color value) {
    _maleColorActive = value;
    update([const Key("edit_mine")]);
  }

  //男性文字颜色被选中时的颜色
  Color _maleTextColorActive = const Color(0xFF727275);

  Color get maleTextColorActive => _maleTextColorActive;

  set maleTextColorActive(Color value) {
    _maleTextColorActive = value;
    update([const Key("edit_mine")]);
  }

  //女性颜色被选中时的颜色
  Color _femaleColorActive = const Color(0xFFe0e0e0);

  Color get femaleColorActive => _femaleColorActive;

  set femaleColorActive(Color value) {
    _femaleColorActive = value;
    update([const Key("edit_mine")]);
  }

  //女性文字颜色被选中时的颜色
  Color _femaleTextColorActive = const Color(0xFF727275);

  Color get femaleTextColorActive => _femaleTextColorActive;

  set femaleTextColorActive(Color value) {
    _femaleTextColorActive = value;
    update([const Key("edit_mine")]);
  }

  //生日
  late DateTime _birthday;

  DateTime get birthday => _birthday;

  set birthday(DateTime value) {
    _birthday = value;
    update([const Key("edit_mine")]);
  }

  //个性签名输入长度
  int _signatureTextLength = 0;

  int get signatureTextLength => _signatureTextLength;

  set signatureTextLength(int value) {
    _signatureTextLength = value;
    update([const Key("edit_mine")]);
  }

  //上传头像
  Future<void> _uploadPicture(File picture) async {
    Map<String, dynamic> map = {};
    final file = await MultipartFile.fromFile(picture.path,
        filename: picture.path.split('/').last);
    map['type'] = 'image/jpeg';
    map['name'] = picture.path.split('/').last;
    map['size'] = picture.lengthSync();
    map["file"] = file;
    FormData formData = FormData.fromMap(map);
    final result = await _useApi.upload(formData);
    if (result['code'] == 0) {
      CustomFlutterToast.showSuccessToast('头像修改成功');
      currentUserInfo['portrait'] = result['data'];
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('portrait', currentUserInfo['portrait']);
      globalData.currentAvatarUrl = currentUserInfo['portrait'];
      update([const Key("edit_mine")]);
    } else {
      CustomFlutterToast.showErrorToast(result['msg']);
    }
  }

  //点击头像按钮弹出底部选择框
  void selectPortrait() {
    if (!isEdit) return;
    Get.toNamed('/image_viewer_update', arguments: {
      'imageUrl': currentUserInfo['portrait'],
      'onConfirm': _uploadPicture
    });
  }

  //设置性别值
  void _setSexValue(String value) {
    sex = value;
    theme.changeThemeMode(sex == "女" ? "pink" : "blue");
    if (value == "男") {
      maleColorActive = const Color(0xFF4C9BFF);
      maleTextColorActive = Colors.white;
      femaleColorActive = const Color(0xFFe0e0e0);
      femaleTextColorActive = const Color(0xFF727275);
    } else {
      maleColorActive = const Color(0xFFe0e0e0);
      maleTextColorActive = const Color(0xFF727275);
      femaleColorActive = const Color(0xFFffa0cf);
      femaleTextColorActive = Colors.white;
    }
  }

  //设置性别
  void setSex(String value) {
    if (isEdit) _setSexValue(value);
    return;
  }

  //用户账号输入长度
  void onNameTextChanged(String value) {
    nameTextLength = value.length;
    if (nameTextLength >= 30) nameTextLength = 30;
  }

  //个性签名输入长度
  void onSignatureTextChanged(String value) {
    signatureTextLength = value.length;
    if (signatureTextLength >= 100) signatureTextLength = 100;
  }

  //选择生日
  Future<void> selectDate(BuildContext context) async {
    if (isEdit) {
      final iniDate = PDuration.parse(birthday);
      Pickers.showDatePicker(
        context,
        maxDate: PDuration.parse(DateTime.now()),
        minDate: PDuration.parse(DateTime(1900, 1, 1)),
        pickerStyle: PickerStyle(
          commitButton: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 12, right: 22),
            child: Text('确定',
                style: TextStyle(color: theme.primaryColor, fontSize: 16.0)),
          ),
          headDecoration: BoxDecoration(
            color:
                sex == "女" ? const Color(0xFFfcebff) : const Color(0xFFe6f2ff),
          ),
          backgroundColor:
              sex == "女" ? const Color(0xFFfcebff) : const Color(0xFFe6f2ff),
        ),
        selectDate: iniDate,
        onChanged: (res) {
          birthday = DateTime(
            res.getSingle(DateType.Year),
            res.getSingle(DateType.Month),
            res.getSingle(DateType.Day),
          );
          birthdayController.text = DateFormat('yyyy-MM-dd').format(birthday);
        },
        onConfirm: (res) {
          birthday = DateTime(
            res.getSingle(DateType.Year),
            res.getSingle(DateType.Month),
            res.getSingle(DateType.Day),
          );
          birthdayController.text =
              DateFormat('yyyy-MM-dd').format(birthday); // 格式化日期
        },
      );
    }
  }

  //点击保存按钮进行网络请求
  void onPressed() async {
    if (!isEdit) {
      isEdit = true;
      return;
    } else {
      String name = nameController.text;
      String signature = signatureController.text;
      String birthday = this.birthday.toString();
      String portrait = currentUserInfo['portrait'];
      final updateResult = await _useApi.update(
          name: name,
          sex: sex,
          birthday: birthday,
          signature: signature,
          portrait: portrait);
      if (updateResult['code'] == 0) {
        CustomFlutterToast.showSuccessToast('资料修改成功~');
        sharedPreferences.setString('username', name);
        sharedPreferences.setString('portrait', portrait);
        sharedPreferences.setString('sex', sex);
        sharedPreferences.setString('birthday', birthday);
        sharedPreferences.setString('signature', signature);
        isEdit = false;
        return;
      } else {
        CustomFlutterToast.showErrorToast(updateResult['msg']);
      }
      return;
    }
  }

  void _whenClose() async {
    try {
      theme.changeThemeMode(
          sharedPreferences.getString('sex') == "女" ? "pink" : "blue");
    } catch (e) {
      if (kDebugMode) print('error when close EditMinePage:$e');
    } finally {
      nameController.dispose();
      signatureController.dispose();
      birthdayController.dispose();
      //以及返回上一页时更新页面
      if (_mineLogic.initialized) _mineLogic.init();
      if (_chatListLogic.initialized) _chatListLogic.onGetChatList();
      if (_contactsLogic.initialized) _contactsLogic.init();
    }
  }

  //初始化
  @override
  void onInit() async {
    super.onInit();
    final userInfo = await _useApi.info();
    currentUserInfo['name'] =
        sharedPreferences.getString('username') ?? userInfo['data']['name'];
    currentUserInfo['portrait'] =
        sharedPreferences.getString('portrait') ?? userInfo['data']['portrait'];
    nameController.text = currentUserInfo['name'];
    nameTextLength = nameController.text.length;
    sex = sharedPreferences.getString('sex') ?? userInfo['data']['sex'];
    _setSexValue(sex);
    currentUserInfo['sex'] = sex;
    birthday = DateTime.parse(userInfo['data']['birthday']).toLocal();
    birthdayController.text =
        DateFormat('yyyy-MM-dd').format(birthday); // 格式化日期
    currentUserInfo['birthday'] = birthday;
    signatureController.text = sharedPreferences.getString('signature') ??
        userInfo['data']['signature'];
    signatureTextLength = signatureController.text.length;
  }

  //当页面返回时，销毁控制器
  @override
  void onClose() {
    _whenClose();
    super.onClose();
  }
}
