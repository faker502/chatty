import 'dart:convert';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/msg_api.dart';
import 'package:linyu_mobile/utils/String.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class FileMessage extends StatelessThemeWidget {
  final _msgApi = MsgApi();
  final dynamic value;
  final bool isRight;

  FileMessage({
    super.key,
    required this.value,
    required this.isRight,
  });

  Future<String> onGetFile() async {
    try {
      final fromForwardMsgId = value['fromForwardMsgId'];
      final res = await _msgApi.getMedia(fromForwardMsgId ?? value['id']);
      if (res['code'] == 0) return res['data'];
    } catch (e) {
      // 处理错误，您可以记录日志或执行其他操作
      if (kDebugMode) print('获取图片时出错: $e');
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    dynamic content = jsonDecode(value['msgContent']['content']);
    return SizedBox(
      height: 85,
      child: FutureBuilder<String>(
        future: onGetFile(),
        builder: (context, snapshot) => snapshot.hasData
            ? GestureDetector(
                onTap: () async =>
                    await Get.toNamed('file_details', arguments: {
                  'fileUrl': snapshot.data,
                  'fileName': content['name'],
                  'fileType': content['type'],
                  'fileSize': content['size'],
                }),
                child: Container(
                  height: 85,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isRight ? theme.primaryColor : Colors.white,
                    borderRadius: isRight
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )
                        : const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(Get.context!).size.width * 0.6,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              maxLines: 2,
                              content['name'],
                              style: TextStyle(
                                  color: isRight ? Colors.white : null,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              StringUtil.formatSize(content['size']),
                              style: TextStyle(
                                  color: isRight ? Colors.white : null,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            isRight
                                ? 'assets/images/file-white.png'
                                : 'assets/images/file-${theme.themeMode.value}.png',
                            width: 50,
                          ),
                          Transform.translate(
                            offset: const Offset(-2, 2),
                            child: Text(
                              content['type'].toUpperCase(),
                              style: TextStyle(
                                  color: isRight
                                      ? theme.primaryColor
                                      : Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                width: MediaQuery.of(Get.context!).size.width * 0.6,
                color: isRight ? theme.primaryColor : Colors.white,
                height: 85,
                alignment: Alignment.center,
                child: const SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(
                    color: Color(0xffffffff),
                    strokeWidth: 2,
                  ),
                ),
              ),
      ),
    );
  }
}
