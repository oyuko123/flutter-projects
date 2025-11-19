import 'package:flutter/material.dart';
import 'package:flutter_e_commerce/e_commerce_screen_before.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          elevation: 10,
          titleTextStyle: TextStyle(fontFamily: 'LeckerliOne', fontSize: 24),
        ),
      ),
      home: ECommerceScreen(),
    );
  }
}
