import 'dart:math';
import 'package:flutter/material.dart';

class Fruit {
  final String name;
  final String image;

  Fruit(this.name, this.image);
}

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
        primarySwatch: Colors.blue,
      ),
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
  List<Fruit> fruits = [];
  Color _currentColor = Colors.blue;

  String imagePath(String fruitName) {
    return 'images/$fruitName.png';
  }

  Color randomColor() {
    return _currentColor == Colors.blue ? Colors.lightBlue : Colors.blue;
  }

  Fruit randomFruit() {
    final List<Fruit> fruitsPossibles = [
      Fruit('Pomme', 'pomme'),
      Fruit('Poire', 'poire'),
      Fruit('Ananas', 'ananas')
    ];
    return fruitsPossibles[Random().nextInt(fruitsPossibles.length)];
  }

  void _ajouterFruit() {
    setState(() {
      final newFruit = randomFruit();
      if (fruits.length < 12) {
        fruits.add(newFruit);
        _currentColor = randomColor();
      }
    });
  }

  void _supprimerFruit(int index) {
    setState(() {
      fruits.removeAt(index);
    });
    Navigator.of(context).pop(); 
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Supprimer ${fruits[index].name}?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(imagePath(fruits[index].image)),
              const SizedBox(height: 10),
              const Text('Voulez-vous vraiment supprimer ce fruit ?'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => _supprimerFruit(index),
              child: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste de fruits'),
      ),
      body: ListView.builder(
        itemCount: fruits.length,
        itemBuilder: (BuildContext context, int index) {
          final fruit = fruits[index];
          return GestureDetector(
            onTap: () => _showDeleteDialog(context, index),
            child: ListTile(
              leading: Image.asset(imagePath(fruit.image)),
              title: Text(
                fruit.name,
                style: TextStyle(
                  color: index.isEven ? const Color.fromARGB(255, 84, 87, 255) : Colors.black,
                ),
              ),
              tileColor: index.isEven ? _currentColor : const Color.fromARGB(255, 84, 87, 255),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _ajouterFruit,
        child: const Icon(Icons.add),
      ),
    );
  }
}
