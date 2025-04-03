import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/msg_api.dart';
import 'package:linyu_mobile/components/custom_audio/index.dart';
import 'package:linyu_mobile/utils/getx_config/GlobalThemeConfig.dart';

class VoiceMessage extends StatefulWidget {
  final dynamic value;
  final bool isRight;

  const VoiceMessage({
    super.key,
    required this.value,
    this.isRight = false,
  });

  @override
  State<VoiceMessage> createState() => _ChatContentVoiceState();
}

class _ChatContentVoiceState extends State<VoiceMessage> {
  final _msgApi = MsgApi();
  String audioUrl = '';
  int audioTime = 0;
  String text = '';
  bool loading = true;
  final GlobalThemeConfig _theme = GetInstance().find<GlobalThemeConfig>();

  @override
  void initState() {
    super.initState();
    _parseValue();
  }

  void _parseValue() {
    final content = jsonDecode(widget.value['msgContent']['content']);
    if (content != null)
      setState(() {
        audioTime = content['time'] ?? 0;
        text = content['text'] ?? '';
        loading = false;
      });
    else
      setState(() => loading = true);
  }

  Future<String> onGetVoice() async {
    try {
      final fromForwardMsgId = widget.value['fromForwardMsgId'];
      dynamic res;
      // 是否为转发消息，则尝试使用 fromForwardMsgId 获取媒体
      if (fromForwardMsgId != null)
        res = await _msgApi.getMedia(fromForwardMsgId);

      // 如果没有获取到结果，则尝试使用 id 获取媒体
      if (res == null || res['code'] != 0)
        res = await _msgApi.getMedia(widget.value['id']);

      // 检查获取的结果
      if (res['code'] == 0) return res['data'] ?? '';
    } catch (e) {
      if (kDebugMode) print('Error fetching voice: $e');
    }
    return '';
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) _parseValue();
  }

  @override
  Widget build(BuildContext context) {
    final alignment =
        widget.isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          if (audioTime > 0)
            FutureBuilder<String>(
              future: onGetVoice(),
              builder: (context, snapshot) => snapshot.hasData
                  ? CustomAudio(
                      isRight: widget.isRight,
                      audioUrl: snapshot.data ?? '',
                      time: audioTime,
                      type: widget.isRight ? '' : 'minor',
                      onLoadedMetadata: () {},
                    )
                  : Container(
                      width: 120,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color:
                            widget.isRight ? _theme.primaryColor : Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          color: Color(0xffffffff),
                          strokeWidth: 2,
                        ),
                      ),
                    ),
            ),
          if (loading && text.isEmpty)
            const Text(
              "加载中...",
              style: TextStyle(color: Colors.grey),
            ),
          if (text.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 0.5),
              decoration: BoxDecoration(
                color: widget.isRight ? _theme.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(maxWidth: 240),
              child: Text(
                text,
                style: TextStyle(
                  color: widget.isRight ? Colors.white : null,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
