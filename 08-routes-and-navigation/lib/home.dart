import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'constants.dart';
import '../components/components.dart';
import '../models/models.dart';
import '../screens/screens.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.auth,
    required this.cartManager,
    required this.ordersManager,
    required this.changeTheme,
    required this.changeColor,
    required this.colorSelected,
    required this.tab,
  });

  final YummyAuth auth;
  final int tab;
  final CartManager cartManager;
  final OrderManager ordersManager;
  final ColorSelection colorSelected;
  final void Function(bool useLightMode) changeTheme;
  final void Function(int value) changeColor;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // 方法1
  // 点击tab，调用setState方式更改页面
  // int tab = 0;
  List<NavigationDestination> appBarDestinations = const [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      label: 'Explore',
      selectedIcon: Icon(Icons.home),
    ),
    NavigationDestination(
      icon: Icon(Icons.list_outlined),
      label: 'Orders',
      selectedIcon: Icon(Icons.list),
    ),
    NavigationDestination(
      icon: Icon(Icons.person_2_outlined),
      label: 'Account',
      selectedIcon: Icon(Icons.person),
    )
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      ExplorePage(
        cartManager: widget.cartManager,
        orderManager: widget.ordersManager,
      ),
      MyOrdersPage(orderManager: widget.ordersManager),
      AccountPage(
          onLogOut: (logout) async {
            print("this is onLogOut, go '/login'");
            widget.auth.signOut().then((value) => context.go('/login'));
          },
          user: User(
              firstName: 'Stef',
              lastName: 'P',
              role: 'Flutteristas',
              profileImageUrl: 'assets/profile_pics/person_stef.jpeg',
              points: 100,
              darkMode: true))
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          ThemeButton(
            changeThemeMode: widget.changeTheme,
          ),
          ColorButton(
            changeColor: widget.changeColor,
            colorSelected: widget.colorSelected,
          ),
        ],
      ),
      body: IndexedStack(index: widget.tab, children: pages),
      bottomNavigationBar: NavigationBar(
        // 方法1：当前_HomeState定义的值
        // selectedIndex: tab,
        // 方法2：Home这个widget的成员变量
        selectedIndex: widget.tab,
        onDestinationSelected: (index) {
          // 方法1：使用当前_HomeState定义的值
          // 似乎比go_router方式要好，最起码没有重新new Home，只是rebuild了
          // setState(() {
          //   tab = index;
          // });

          // 方法2：使用Home这个widget的成员变量
          // 去全局路由里面找/0, /1, /2，结果只有/:tab能匹配，于是重构home，并且传入tab值。
          context.go('/$index');
        },
        destinations: appBarDestinations,
      ),
    );
  }
}
