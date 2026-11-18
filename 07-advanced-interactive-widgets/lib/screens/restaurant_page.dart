import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../components/item_details.dart';
import '../components/restaurant_item.dart';
import '../models/cart_manager.dart';
import '../models/order_manager.dart';
import '../models/restaurant.dart';
import 'checkout_page.dart';

class RestaurantPage extends StatefulWidget {
  final Restaurant restaurant;
  final CartManager cartManager;
  final OrderManager ordersManager;

  const RestaurantPage({
    super.key,
    required this.restaurant,
    required this.cartManager,
    required this.ordersManager,
  });

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  static const double largeScreenPercentage = 0.9;
  static const double maxWidth = 1000;
  static const desktopThreshold = 700;
  static const double drawerWidth = 375.0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final constrainedWidth = _calculateConstrainedWidth(screenWidth);

    return Scaffold(
      key: scaffoldKey,
      endDrawer: _buildEndDrawer(),
      floatingActionButton: _buildFloatingActionButton(),
      body: Center(
        child: SizedBox(
          width: constrainedWidth,
          child: _buildCustomScrollView(),
        ),
      ),
    );
  }

  double _calculateConstrainedWidth(double screenWidth) {
    return (screenWidth > desktopThreshold
        ? screenWidth * largeScreenPercentage
        : screenWidth)
        .clamp(0.0, maxWidth);
  }

  int calculateColumnCount(double screenWidth) {
    const desktopThreshold = 700;
    return screenWidth > desktopThreshold ? 2 : 1;
  }

  CustomScrollView _buildCustomScrollView() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        _buildInfoSection(),
        _buildGridViewSection('Menu'),
      ],
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 300.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 64.0),
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 30.0),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(16.0),
                    image: DecorationImage(
                      image: AssetImage(widget.restaurant.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 0.0,
                  left: 16.0,
                  child: CircleAvatar(
                    radius: 30,
                    child: Icon(
                      Icons.store,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildInfoSection() {
    final textTheme = Theme.of(context).textTheme;
    final restaurant = widget.restaurant;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              restaurant.name,
              style: textTheme.headlineLarge,
            ),
            Text(
              restaurant.address,
              style: textTheme.bodySmall,
            ),
            Text(
              restaurant.getRatingAndDistance(),
              style: textTheme.bodySmall,
            ),
            Text(
              restaurant.attributes,
              style: textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(int index) {
    final item = widget.restaurant.items[index];
    return InkWell(
      onTap: () => _showBottomSheet(item),
      child: RestaurantItem(item: item),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  GridView _buildGridView(int columns) {
    return GridView.builder(
      padding: const EdgeInsets.all(0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 3.5,
        crossAxisCount: columns,
      ),
      itemBuilder: (context, index) => _buildGridItem(index),
      itemCount: widget.restaurant.items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  SliverToBoxAdapter _buildGridViewSection(String title) {
    final columns = calculateColumnCount(MediaQuery.of(context).size.width);
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(title),
            _buildGridView(columns),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(Item item) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      constraints: const BoxConstraints(maxWidth: 480),
      builder: (context) => ItemDetails(
        item: item,
        cartManager: widget.cartManager,
        // TODO 改成部分更新。这里调用了RestaurantState的setState函数，全面更新这个UI
        // TODO 需要改成仅仅更新购物车按键，购物车列表（右侧抽屉）
        // 改成ValueNotifier<int>和ValueListenableBuilder
        // 点击加入购物车时，调用回调(即这里的didUpdate)，在回调里修改ValueNotifier的值
        // 其他Widget，比如购物车按键和购物车列表（右侧抽屉），通过在他们的build函数
        // 里面返回ValueListenableBuilder，让它包裹着原先的Widget，同时传入
        // 与ValueListenableBuilder对应的ValueNotifier对象的引用
        // 原理，当ValueNotifier值改变时，触发通知，导致ValueListenableBuilder
        quantityUpdated: () {
          setState(() {});
        },
      ),
      // builder: (context) => Container(
      //   color: Colors.red,
      //   height: 400 ,
      // )
    );
  }

  Widget _buildEndDrawer() {
    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        child: CheckoutPage(
          cartManager: widget.cartManager,

          // TODO 改成部分更新。这里调用了RestaurantState的setState函数，全面更新这个UI
          // TODO 需要改成仅仅更新购物车按键，购物车列表（右侧抽屉）
          // 改成ValueNotifier<int>和ValueListenableBuilder
          // 点击加入购物车时，调用回调(即这里的didUpdate)，在回调里修改ValueNotifier的值
          // 其他Widget，比如购物车按键和购物车列表（右侧抽屉），通过在他们的build函数
          // 里面返回ValueListenableBuilder，让它包裹着原先的Widget，同时传入
          // 与ValueListenableBuilder对应的ValueNotifier对象的引用
          // 原理，当ValueNotifier值改变时，触发通知，导致ValueListenableBuilder
          didUpdate: () {
            setState(() {});
          },
          onSubmit: (order) {
            widget.ordersManager.addOrder(order);
            // Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.popUntil(context, (route) {
              if (kDebugMode) {
                debugPrint('Navigator: ${route.isFirst}');
              }
              return route.isFirst;
            });
          },
        ),
      ),
    );
  }

  void openDrawer() {
    scaffoldKey.currentState!.openEndDrawer();
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: openDrawer,
      tooltip: 'Cart',
      icon: const Icon(Icons.shopping_cart),
      label: Text('${widget.cartManager.items.length} Items in cart'),
    );
  }

}
