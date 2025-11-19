import 'package:flutter/material.dart';
import 'package:hero_animation/list_screen.dart';
import 'package:hero_animation/fade_transition.dart';
import 'package:hero_animation/animated_list.dart';
import 'package:hero_animation/dismissible.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animations Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home:
          //ListScreen(),
          //const FadeTransitionScreen(),
          //const AnimatedListScreen(),
          const DismissibleScreen(),
    );
  }
}
