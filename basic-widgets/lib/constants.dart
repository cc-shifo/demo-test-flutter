import 'package:flutter/material.dart';

enum ColorSelection {
  deepPurple('Deep Purple', Colors.deepPurple),
  purple('Purple', Colors.purple),
  indigo('Indigo', Colors.indigo),
  blue('Blue', Colors.blue),
  teal('Teal', Colors.teal),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  orange('Orange', Colors.orange),
  deepOrange('Deep Orange', Colors.deepOrange),
  pink('Pink', Colors.pink);

  // 常量构造函数：
  // 用于创建常量对象，变量是final/const，创建对象时，对象必须赋值给被const修饰变量
  const ColorSelection(this.label, this.color);
  final String label;
  final Color color;
}
