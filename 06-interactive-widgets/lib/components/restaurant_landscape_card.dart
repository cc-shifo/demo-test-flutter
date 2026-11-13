import 'package:flutter/material.dart';

import '../models/restaurant.dart';
import '../screens/restaurant_page.dart';

class RestaurantLandscapeCard extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantLandscapeCard({super.key, required this.restaurant});

  @override
  State<RestaurantLandscapeCard> createState() =>
      _RestaurantLandscapeCardState();
}

class _RestaurantLandscapeCardState extends State<RestaurantLandscapeCard> {
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return Card(
      // 方法一，直接换成手势，监听点击行为
      // child: GestureDetector(
      // 方法二，直接改用InkWell，满足点击行为，同时有点击水文效果
      clipBehavior: Clip.antiAlias, // ✅ 关键：让Card裁剪子元素，水波纹不会溢出
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RestaurantPage(restaurant: widget.restaurant),
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8.0),
              ),
              child: AspectRatio(
                aspectRatio: 2,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // 配合方法一
                    // Image.asset(widget.restaurant.imageUrl, fit: BoxFit.cover),
                    // 方法二，配合IntWell点击的水文效果
                    // ✅ 使用 Ink.image，图片上面可以正常显示水波纹
                    Ink.image(
                      image: AssetImage(widget.restaurant.imageUrl),
                      fit: BoxFit.cover,
                      child: const SizedBox(),
                    ),
                    Positioned(
                      top: 4.0,
                      right: 4.0,
                      child: IconButton(
                        icon: Icon(
                          _isFavorited
                              ? Icons
                                    .favorite //
                              : Icons.favorite_border,
                        ),
                        iconSize: 30.0,
                        color: Colors.red[400],
                        onPressed: () {
                          setState(() {
                            _isFavorited = !_isFavorited;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text(widget.restaurant.name, style: textTheme.titleSmall),
              subtitle: Text(
                widget.restaurant.attributes,
                maxLines: 1,
                style: textTheme.bodySmall,
              ),
              // onTap: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) =>
              //           RestaurantPage(restaurant: widget.restaurant),
              //     ),
              //   );
              // },
            ),
          ],
        ),
      ),
    );
  }
}
