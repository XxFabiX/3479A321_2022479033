import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../main.dart'; // acceso a MyApp.logger

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
          children: <Widget>[
            SvgPicture.asset(
              'assets/icon/escudo.svg',
              semanticsLabel: 'Dart Logo',
              height: 50,
              width: 50,
            ),
            const Text('Has pulsado el boton muchas veces'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),


      persistentFooterButtons: [
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

    );

  }

}