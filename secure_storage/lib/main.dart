import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final pwdController = TextEditingController();
  String myPass = '';
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final myKey = 'myPass';

  @override
  void initState() {
    super.initState();
  }
  
  @override
  void dispose() {
    pwdController.dispose();
    super.dispose();
  }

  Future writeToSecureStorage() async {
    await storage.write(key: myKey, value: pwdController.text);
  }
  
  Future<String> readFromSecureStorage() async {
    final value = await storage.read(key: myKey);
    return value ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Path Provider')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(controller: pwdController),
              ElevatedButton(
                child: const Text('Save Value'),
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await writeToSecureStorage();
                  if (!mounted) return;
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Value saved to secure storage')),
                  );
                },
              ),
              ElevatedButton(
                child: Text('Read Value'),
                onPressed: () {
                  readFromSecureStorage().then((value) {
                    setState(() {
                      myPass = value;
                    });
                  });
                },
              ),
              Text(myPass),
            ],
          ),
        ),
      ),
    );
  }
}
