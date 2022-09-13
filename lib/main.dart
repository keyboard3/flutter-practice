import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (context) => CartModel(),
        child: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
class Item {
  Item(String name,int age,String breed) {
    this.name = name;
    this.age = age;
    this.breed = breed;
  }
  String name="";
  int age = 0;
  String breed = "";
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
       json['name'],
       json['age'],
       json['breed'],
    );
  }
}
class CartModel extends ChangeNotifier {
  CartModel() {
    loadCats();
  }

  Future<void> loadCats() async{
    final response = await http.get(Uri.parse('http://keyboard3.com/next-nest/api/cats'));

    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body);
      for (var value in list) {
        add(Item.fromJson(value));
      }
    } else {
      throw Exception('Failed to load album');
    }
  }
  /// Internal, private state of the cart.
  final List<Item> _items = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  /// The current total price of all items (assuming all items cost $42).
  int get totalPrice => _items.length * 42;

  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(Item item) {
    _items.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child:Consumer<CartModel>(
          builder: (context, carts, child) {
             return Column(
               children: carts.items.map((cart) => Column(
                 children: <Widget>[
                   Text(
                     '名字: ${cart.name}',
                     style: Theme.of(context).textTheme.headline4,
                   ),
                   Text(
                     '年龄: ${cart.age}',
                     style: Theme.of(context).textTheme.headline5,
                   ),
                   Text(
                     '品种: ${cart.breed}',
                     style: Theme.of(context).textTheme.headline5,
                   ),
                 ],
               )).toList(),
             );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
