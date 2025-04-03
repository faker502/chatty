import 'dart:async';
import 'dart:convert';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:linyu_mobile/utils/linyu_msg.dart';
import 'package:linyu_mobile/utils/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketUtil extends GetxController {
  static WebSocketUtil? _instance;
  WebSocketChannel? _channel;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  bool _lockReconnect = false;
  bool isConnected = false;
  String? _token;
  final int _reconnectCountMax = 200;
  int _reconnectCount = 0;

  // 事件总线，用于消息分发
  static final eventController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get eventStream => eventController.stream;

  factory WebSocketUtil() {
    _instance ??= WebSocketUtil._internal();
    return _instance!;
  }

  WebSocketUtil._internal();

  Future<void> connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-token');
    if (token == null) return;
    if (isConnected || _channel != null) return;
    isConnected = true;

    try {
      print('WebSocket connecting...');
      String wsIp = 'ws://249ansm92588.vicp.fun';

      _channel = WebSocketChannel.connect(
        Uri.parse('$wsIp/ws?x-token=$token'),
      );

      _channel!.stream.listen(
        _handleMessage,
        onDone: _handleClose,
        onError: _handleError,
        cancelOnError: true,
      );

      _clearTimer();
      _startHeartbeat();
    } catch (e) {
      _handleClose();
    }
  }

  void _handleMessage(dynamic message) {
    if (message == null) {
      _handleClose();
      return;
    }

    Map<String, dynamic> wsContent;
    try {
      wsContent = jsonDecode(message);
    } catch (e) {
      _handleClose();
      return;
    }

    if (wsContent.containsKey('type')) {
      if (wsContent['data'] != null && wsContent['data']['code'] == -1) {
        _handleClose();
      } else {
        switch (wsContent['type']) {
          case 'msg':
            sendNotification(wsContent['content']);
            eventController.add(
                {'type': 'on-receive-msg', 'content': wsContent['content']});
            break;
          case 'notify':
            eventController.add(
                {'type': 'on-receive-notify', 'content': wsContent['content']});
            break;
          case 'video':
            eventController.add(
                {'type': 'on-receive-video', 'content': wsContent['content']});
            break;
        }
      }
    } else {
      _handleClose();
    }
  }

  void send(String message) {
    if (_channel != null) {
      _channel!.sink.add(message);
    }
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(
      const Duration(milliseconds: 9900),
      (_) => send('heart'),
    );
  }

  void _handleClose() {
    _clearHeartbeat();
    if (_channel != null) {
      _channel!.sink.close();
      _channel = null;
    }
    isConnected = false;
    _reconnect();
  }

  void _handleError(dynamic error) {
    _handleClose();
  }

  void _reconnect() {
    if (_lockReconnect) return;
    _lockReconnect = true;

    _reconnectTimer?.cancel();

    if (_reconnectCount >= _reconnectCountMax) {
      _reconnectCount = 0;
      return;
    }

    _reconnectTimer = Timer(
      const Duration(seconds: 5),
      () {
        connect();
        _reconnectCount++;
        _lockReconnect = false;
      },
    );
  }

  void _clearHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  void _clearTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  void sendNotification(dynamic msg) {
    dynamic msgContent = msg['msgContent'];
    String contentStr = LinyuMsgUtil.getMsgContent(msgContent);
    NotificationUtil.showNotification(
      id: 0,
      title: msgContent['formUserName'],
      body: '${msgContent['formUserName']}: $contentStr',
    );
  }

  void disconnect() {
    _clearHeartbeat();
    _channel?.sink.close();
    _channel = null;
    isConnected = false;
  }

  @override
  void onReady() {
    connect();
    super.onReady();
  }

  @override
  void dispose() {
    _clearHeartbeat();
    _clearTimer();
    _channel?.sink.close();
    eventController.close();
    _instance = null;
    super.dispose();
  }
}
