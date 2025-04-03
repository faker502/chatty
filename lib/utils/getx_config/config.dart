import 'package:flutter/cupertino.dart'
    show
        BuildContext,
        Key,
        StatelessElement,
        StatelessWidget,
        Widget,
        debugPrint;
import 'package:flutter/foundation.dart' show Key, debugPrint, kDebugMode;
import 'package:get/get.dart'
    show
        Get,
        GetBuilder,
        GetBuilderState,
        GetInstance,
        GetNavigation,
        GetPage,
        GetView,
        GetxController,
        Obx;
import 'package:linyu_mobile/utils/getx_config/route.dart';

import 'package:linyu_mobile/utils/web_socket.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'GlobalData.dart';
import 'GlobalThemeConfig.dart';

//路由配置
List<GetPage> get pageRoute => AppRoutes.routeConfig[1];
Map get widgetMap => AppRoutes.routeConfig[0];

//路由监听
void routingCallback(router) {
  debugPrint("enter>>>>>>>>>>>>>>>>${router.current}");
}

/// 通过内置GetBuilder来构建，配合GetView使用
/// 与业务逻辑绑定，通过GetX实现状态管理，这样页面只负责渲染，业务逻辑全部在控制器中实现
abstract class CustomWidget<T extends GetxController> extends StatelessWidget {
  /// 构造函数
  CustomWidget({
    this.key,
  }) : super(key: key);

  /// 当传入key的时候，若更新widget需使用controller.update([key],)
  @override
  final Key? key;

  /// 传入的参数
  final dynamic arguments = Get.arguments;

  /// 控制器的tag
  final String? tag = null;

  /// 获取控制器
  T get controller => GetInstance().find<T>(tag: tag);

  GlobalThemeConfig get theme =>
      GetInstance().find<GlobalThemeConfig>(tag: tag);

  GlobalData get globalData => GetInstance().find<GlobalData>(tag: tag);

  /// 初始化
  void init(BuildContext context) => print("init>$runtimeType");

  /// 依赖发生变化
  void didChangeDependencies(BuildContext context) =>
      print("change>$runtimeType");

  /// 更新Widget
  void didUpdateWidget(
    GetBuilder oldWidget,
    GetBuilderState<T> state,
  ) =>
      print("update>$runtimeType");

  /// 构建widget
  Widget buildWidget(BuildContext context);

  /// 关闭
  void close(BuildContext context) => print("close>$runtimeType");

  /// 创建上下文
  @override
  StatelessElement createElement() => StatelessElement(this);

  /// 构建
  @override
  Widget build(BuildContext context) => GetBuilder<T>(
        id: this.key,
        assignId: true,
        initState: (GetBuilderState<T> state) => this.init(context),
        didChangeDependencies: (GetBuilderState<T> state) =>
            this.didChangeDependencies(context),
        didUpdateWidget: this.didUpdateWidget,
        builder: (controller) {
          return this.buildWidget(context);
        },
        dispose: (GetBuilderState<T> state) => this.close(context),
      );
}

abstract class Logic<V extends Widget> extends GetxController {
  /// 当前与controller绑定的view
  /// 当不传入泛型时，view为null 不能在controller的onInit中使用view
  /// 若需要在onInit中使用view，则需要传入泛型
  /// like: class HomeLogic extends Logic<HomeView>{}
  V? view = widgetMap[V];

  //路由参数
  dynamic get arguments => Get.arguments;

  //主题配置
  GlobalThemeConfig get theme =>
      GetInstance().find<GlobalThemeConfig>(tag: null);

  //全局数据
  GlobalData get globalData => GetInstance().find<GlobalData>(tag: null);

  //websocket管理
  WebSocketUtil get wsManager => GetInstance().find<WebSocketUtil>(tag: null);

  //数据存储（本地存储）
  SharedPreferences get sharedPreferences =>
      GetInstance().find<SharedPreferences>(tag: null);
}

abstract class CustomView<T extends Logic> extends StatelessWidget {
  /// 构造函数
  /// 当传入key的时候，若更新widget需使用controller.update([key],)
  CustomView({
    super.key,
    this.tag,
  });

  /// 传入的参数
  final dynamic arguments = Get.arguments;

  /// 控制器的tag
  final String? tag;

  /// 获取控制器
  T get controller => GetInstance().find<T>(tag: tag);

  GlobalThemeConfig get theme =>
      GetInstance().find<GlobalThemeConfig>(tag: tag);

  GlobalData get globalData => GetInstance().find<GlobalData>(tag: tag);

  /// 初始化
  void init(BuildContext context) {
    if (kDebugMode) print("init>$runtimeType");
    if (!controller.initialized || controller.view != null)
      return; // 提前返回，减少不必要的计算
    controller.view = this;
  }

  /// 依赖发生变化
  void didChangeDependencies(BuildContext context) {
    if (kDebugMode) print("change>$runtimeType");
  }

  /// 更新Widget
  void didUpdateWidget(
    GetBuilder oldWidget,
    GetBuilderState<T> state,
  ) {
    if (kDebugMode) print("update>$runtimeType");
  }

  /// 构建widget
  Widget buildView(BuildContext context);

  /// 关闭
  void close(BuildContext context) {
    if (kDebugMode) print("close>$runtimeType");
  }

  /// 创建上下文
  @override
  StatelessElement createElement() => StatelessElement(this);

  /// 构建
  @override
  Widget build(BuildContext context) => GetBuilder<T>(
        id: key,
        assignId: true,
        // 开启控制器随着view的生命周期一起销毁
        key: Key("${context.widget.hashCode}_builder"),
        initState: (GetBuilderState<T> state) => this.init(context),
        didChangeDependencies: (GetBuilderState<T> state) =>
            this.didChangeDependencies(context),
        didUpdateWidget: this.didUpdateWidget,
        builder: (_) => this.buildView(context),
        dispose: (GetBuilderState<T> state) => this.close(context),
      );
}

abstract class StatelessThemeWidget extends StatelessWidget {
  const StatelessThemeWidget({super.key});

  GlobalThemeConfig get theme => GetInstance().find<GlobalThemeConfig>();

  GlobalData get globalData => GetInstance().find<GlobalData>();
}

/// 继承自GetView
/// 适用于局部
abstract class CustomWidgetObx<T extends GetxController> extends GetView<T> {
  const CustomWidgetObx({required Key key}) : super(key: key);

  dynamic get arguments => Get.arguments;

  Widget buildWidget(BuildContext context);

  @override
  Widget build(BuildContext context) => Obx(() => buildWidget(context));
}
