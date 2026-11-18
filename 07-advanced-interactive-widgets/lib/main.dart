import 'package:flutter/material.dart';

import 'constants.dart';
import 'home.dart';
import 'models/cart_manager.dart';
import 'models/order_manager.dart';

import 'dart:async';

void main() {
  // runApp(const Yummy());
  runZonedGuarded((){
    runApp(const Yummy());
  }, (error, stack)  {
    debugPrint("${DateTime.now()}\n$error\n$stack\n");
  });

  // runZonedGuarded(
  //   () {
  //     WidgetsFlutterBinding.ensureInitialized();
  //     runApp(const Yummy());
  //   },
  //   // 🟡 第二个参数：zone内【未被捕获的异常】都会进到这里
  //   (Object error, StackTrace stackTrace) {
  //     debugPrint('runZonedGuarded捕获到未捕获异常：');
  //     debugPrint('error: $error');
  //     debugPrint('stack: $stackTrace');
  //     // 你可以在这里：写入本地日志文件、上报
  //   },
  //   // 可选参数：捕获Flutter框架自身的错误（widget渲染错误）
  //   zoneSpecification: ZoneSpecification(
  //     print: (self, parent, zone, message) {
  //       parent.print(zone, "[ZONE LOG] $message");
  //     },
  //   ),
  // );
}

class Yummy extends StatefulWidget {
  const Yummy({super.key});

  @override
  State<Yummy> createState() => _YummyState();
}

class _YummyState extends State<Yummy> {
  ThemeMode themeMode = ThemeMode.light;
  ColorSelection colorSelected = ColorSelection.pink;

  /// Manage user's shopping cart for the items they order.
  final CartManager _cartManager = CartManager();

  /// Manage user's orders submitted
  final OrderManager _orderManager = OrderManager();

  void changeThemeMode(bool useLightMode) {
    setState(() {
      themeMode = useLightMode
          ? ThemeMode
                .light //
          : ThemeMode.dark;
    });
  }

  void changeColor(int value) {
    setState(() {
      colorSelected = ColorSelection.values[value];
    });
  }

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Yummy';

    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      // Uncomment to remove Debug banner
      themeMode: themeMode,
      theme: ThemeData(
        colorSchemeSeed: colorSelected.color,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: colorSelected.color,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: Home(
        appTitle: appTitle,
        cartManager: _cartManager,
        ordersManager: _orderManager,
        changeTheme: changeThemeMode,
        changeColor: changeColor,
        colorSelected: colorSelected,
      ),
    );
  }
}
