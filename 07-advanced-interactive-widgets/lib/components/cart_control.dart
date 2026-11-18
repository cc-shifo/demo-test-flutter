import 'package:flutter/material.dart';

class CartControl extends StatefulWidget {
  final void Function(int) addToCart;

  const CartControl({
    required this.addToCart,
    super.key,
  });

  @override
  State<CartControl> createState() => _CartControlState();
}

class _CartControlState extends State<CartControl> {
  int _cartNumber = 1;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMinusButton(),
        _buildCartNumberContainer(colorScheme),
        _buildPlusButton(),
        const Spacer(),
        // 添加按键似乎可以从这个子树里移到bottomSheet对话框的树里面
        // 方式1：
        // 若移动到bottomSheet里面，就需要将数据number的动态变化事件通知到外面去。
        // 方式2：
        // 而放在当前这个子树里面，就必须用回调addToCart一次性将数据在最终的时候传递出去。
        // 似乎2方式从时机上来讲，更合理——最终只是处理一次。
        _buildAddCartButton(),
      ],
    );
  }

  Widget _buildMinusButton() {
    return IconButton(
      icon: const Icon(Icons.remove),
      onPressed: () {
        setState(() {
          if (_cartNumber > 1) {
            _cartNumber--;
          }
        });
      },
      tooltip: 'Decrease Cart Count',
    );
  }

  Widget _buildCartNumberContainer(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: colorScheme.onPrimary,
      child: Text(_cartNumber.toString()),
    );
  }

  Widget _buildPlusButton() {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        setState(() {
          _cartNumber++;
        });
      },
      tooltip: 'Increase Cart Count',
    );
  }

  Widget _buildAddCartButton() {
    return FilledButton(
      onPressed: () {
        widget.addToCart(_cartNumber);
      },
      child: const Text('Add to Cart'),
    );
  }
}
