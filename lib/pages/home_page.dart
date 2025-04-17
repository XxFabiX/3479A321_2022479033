import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../main.dart'; // acceso a MyApp.logger

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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