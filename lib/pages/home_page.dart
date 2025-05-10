import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../main.dart'; // acceso a MyApp.logger
import 'list_content.dart';
import 'about_page.dart';

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
      MyApp.logger.d("Contador incrementado: $_counter");
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
      MyApp.logger.d("Contador decrementado: $_counter");
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
      MyApp.logger.d("Contador reiniciado a 0");
    });
  }

  
  void _navigateToList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ListContent()),
    );
    MyApp.logger.i("Navegando a ListContent");
  }

  @override
  Widget build(BuildContext context) {
    MyApp.logger.d("MyHomePage construido");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: Card(
                margin: const EdgeInsets.all(16),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        'Flutter es un framework ¡No olvidar!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                      SvgPicture.asset(
                        'assets/icon/escudo.svg',
                        height: 50,
                        width: 50,
                      ),
                      const SizedBox(height: 10),
                      const Text('Contador actual:'),
                      Text(
                        '$_counter',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: _decrementCounter,
                            icon: const Icon(Icons.remove),
                          ),
                          IconButton(
                            onPressed: _resetCounter,
                            icon: const Icon(Icons.refresh),
                          ),
                          IconButton(
                            onPressed: _incrementCounter,
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //siguiente
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToList,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Ir a Lista de Contenido'),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }

}