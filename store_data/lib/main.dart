import 'package:flutter/material.dart';
import 'dart:convert';
import './pizza.dart';
import './httphelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pizza_details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter JSON Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
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
  String pizzaString = '';
  List<Pizza> myPizzas = [];

  int appCounter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JSON')),
      body:
      
          //readjsonfile function duudaj pizza list awah
          //Container(),


          // Pizza list-iig http-r awah
          FutureBuilder(
            future: callPizzas(),
            builder: (BuildContext context, AsyncSnapshot<List<Pizza>> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              return ListView.builder(
                itemCount: (snapshot.data == null) ? 0 : snapshot.data!.length,
                itemBuilder: (BuildContext context, int position) {
                  return Dismissible(
                    key: Key(snapshot.data![position].id.toString()),
                    onDismissed: (direction) {
                      HttpHelper helper = HttpHelper();
                      helper.deletePizza(snapshot.data![position].id);
                    },
                    child: ListTile(
                      title: Text(snapshot.data![position].pizzaName),
                      subtitle: Text(
                        snapshot.data![position].description +
                            ' - € ' +
                            snapshot.data![position].price.toString(),
                      ),
                      // pizza deer tovshihod pizza detail delgets ruu shiljih
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PizzaDetailScreen(
                              pizza: snapshot.data![position],
                              isNew: false,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PizzaDetailScreen(
                pizza: Pizza(
                  id: 0,
                  pizzaName: '',
                  description: '',
                  price: 0.0,
                  imageUrl: '',
                ),
                isNew: true,
              ),
            ),
          );
        },
      ),

      //App neesen toog haruulna

      //Center(
      //  child: Column(
      //    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //    children: [
      //      Text('You have opened the app $appCounter times.'),
      //      ElevatedButton(
      //        onPressed: () {
      //          deletePreference();
      //        },
      //        child: Text('Reset counter'),
      //      ),
      //    ],
      //  ),
      //),

      //pizza list haruulah

      //ListView.builder(
      //  itemCount: myPizzas.length,
      //  itemBuilder: (context, index) {
      //    return ListTile(
      //      title: Text(myPizzas[index].pizzaName),
      //      subtitle: Text(myPizzas[index].description),
      //    );
      //  },
      //),
    );
  }

  //json file-aas pizza list unshih function
  Future<List<Pizza>> readJsonFile() async {
    String myString = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/pizzalist.json');
    List pizzaMapList = jsonDecode(myString);
    List<Pizza> myPizzas = [];
    for (var pizza in pizzaMapList) {
      Pizza myPizza = Pizza.fromJson(pizza);
      myPizzas.add(myPizza);
    }

    //json string haruulah

    //setState(() {
    //  pizzaString = myString;
    //});

    // pizza objectiin listiig string bolgon huvirgasnaa haruulah
    //String json = convertToJSON(myPizzas);
    //print(json);
    return myPizzas;
  }

  @override
  void initState() {
    super.initState();
    //readJsonFile();
    readAndWritePreference();
    readJsonFile().then((value) {
      setState(() {
        myPizzas = value;
      });
    });
  }

  // App neesen toog unshij nemj hadgalah function
  Future readAndWritePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    appCounter = prefs.getInt('appCounter') ?? 0;
    appCounter++;
    await prefs.setInt('appCounter', appCounter);
    setState(() {
      appCounter = appCounter;
    });
  }

  // App neesen toog ustgah function
  Future deletePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      appCounter = 0;
    });
  }

  // HttpHelper class-iin getPizzaList function duudaj pizza list awah function
  Future<List<Pizza>> callPizzas() async {
    HttpHelper helper = HttpHelper();
    List<Pizza> pizzas = await helper.getPizzaList();
    return pizzas;
  }
}
