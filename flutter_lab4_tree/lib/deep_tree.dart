import 'package:flutter/material.dart';

class DeepTree extends StatelessWidget {
  const DeepTree({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [FlutterLogo(), Text('Flutter is amazing.')],
            ),
            Expanded(child: Container(color: Colors.purple)),
            Text('Its all widgets!'),
            Text('Let\'s find out how deep the rabbit hole goes.'),
          ],
        ),
      ),
    );
  }
}
