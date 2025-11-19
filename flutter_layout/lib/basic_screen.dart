import 'package:flutter/material.dart';
import 'package:flutter_layout/text_layout.dart';

class BasicScreen extends StatelessWidget {
  const BasicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Welcome to Flutter'),
        actions: const [
          Padding(padding: EdgeInsets.all(10),
          child: Icon(Icons.edit),
          )]
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextLayout(),
    
          Semantics(
            image: true,
            label: 'A beautiful beach',
            child: Image.asset('assets/beach.png'),
          ),
          
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.lightBlue,
          child: ListView(
             children: [
             ListTile(
            title: Text('1'),
             ),
              ListTile(
              title: Text('2'),
             ),
             ListTile(
              title: Text('3')
             )
            ]
          )

        ),
      ),
    );
  }
}
