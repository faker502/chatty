import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:linyu_mobile/utils/getx_config/ControllerBinding.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart'
    show Get, GetMaterialApp, Inst, SmartManagement, Transition;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  SharedPreferences prefs = await Get.putAsync<SharedPreferences>(
      () async => await SharedPreferences.getInstance(),
      permanent: true);
  String? token = prefs.getString('x-token');
  String? sex = prefs.getString('sex');
  runApp(MyApp(initialRoute: token != null ? '/?sex=$sex' : '/login'));
}

class MyApp extends StatelessWidget {
  final String? initialRoute;
  final Widget? initialPage;

  const MyApp({super.key, this.initialPage, this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      smartManagement: SmartManagement.keepFactory,
      title: '林语',
      //国际化
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'CH'),
        Locale('en', 'US'),
      ],
      locale: const Locale('zh'),
      //全局绑定Controller
      initialBinding: ControllerBinding(),
      enableLog: true,
      //路由配置
      getPages: pageRoute,
      //路由从右侧向左滑入（对GetX有效）
      defaultTransition: Transition.rightToLeft,
      initialRoute: initialRoute,
      //路由监听
      routingCallback: routingCallback,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4C9BFF),
          surface: const Color(0xFFFFFFFF),
          onSurface: const Color(0xFF1F1F1F),
          primary: const Color(0xFF4C9BFF),
          onPrimary: Colors.white,
        ),
        splashColor: const Color(0x80EAEAEA),
        highlightColor: const Color(0x80EAEAEA),
        useMaterial3: true,
      ),
      // home: initialPage,
    );
  }
}
