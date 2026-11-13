import 'package:flutter/material.dart';

import 'constants.dart';
import 'home.dart';

void main() {
  runApp(const Yummy());
}

class Yummy extends StatefulWidget {
  // TODO: Setup default theme

  // 2
  const Yummy({super.key});

  @override
  State<Yummy> createState() => _YummyState();
}
//
// class _YummyState extends State<Yummy> {
//   // TODO: Add changeTheme above here
//   @override
//   Widget build(BuildContext context) {
//     const appTitle = 'Yummy';
//
//     // TODO: Setup default theme
//     ThemeMode themeMode = ThemeMode.light; // Manual theme toggle
//     ColorSelection colorSelected = ColorSelection.pink;
//
//     //3
//     return MaterialApp(
//       title: appTitle,
//       //debugShowCheckedModeBanner: false,
//       // Uncomment to remove Debug banner
//
//       // TODO: Add theme
//       themeMode: themeMode,
//       theme: ThemeData(
//         colorSchemeSeed: colorSelected.color,
//         useMaterial3: true,
//         brightness: Brightness.light,
//       ),
//       darkTheme: ThemeData(
//         colorSchemeSeed: colorSelected.color,
//         useMaterial3: true,
//         brightness: Brightness.dark,
//       ),
//       // TODO: Replace Scaffold with Home widget
//       // 4
//       home: Scaffold(
//         appBar: AppBar(
//           // TODO: Add action buttons
//           elevation: 4.0,
//           title: const Text(appTitle, style: TextStyle(fontSize: 24.0)),
//         ),
//         body: const Center(
//           child: Text('You Hungry?!', style: TextStyle(fontSize: 30.0)),
//         ),
//       ),
//     );
//   }
// }

class _YummyState extends State<Yummy> {
  ThemeMode themeMode = ThemeMode.light;
  ColorSelection colorSelected = ColorSelection.pink;

  void changeThemeMode(bool useLightMode) {
    setState(() {
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
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
      // Uncomment to remove Debug banner
      debugShowCheckedModeBanner: false,
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
        appTitle: appTitle, //todo: stef delete this?

        changeTheme: changeThemeMode,
        changeColor: changeColor,
        colorSelected: colorSelected,
      ),
    );
  }
}
