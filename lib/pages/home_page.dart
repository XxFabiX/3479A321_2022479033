import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../main.dart'; // acceso a MyApp.logger
import '../provider/app_data.dart'; 
import 'list_content.dart';
import 'about_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() {
    print("crear estado"); 
    return _MyHomePageState(); 
  }
}

class _MyHomePageState extends State<MyHomePage> {

  _MyHomePageState() {
    MyApp.logger.d("Constructor llamado, mounted: $mounted");
  }

  @override
  void initState() {
    super.initState();
    MyApp.logger.d("initState() llamado, mounted: $mounted");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyApp.logger.d("didChangeDependencies() llamado, mounted: $mounted");
  }

  @override
  void setState(VoidCallback fn) {
    MyApp.logger.d("setState() llamado (antes), mounted: $mounted");
    super.setState(fn);
    MyApp.logger.d("setState() llamado (despues), mounted: $mounted");
  }

  @override
  void didUpdateWidget(MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    MyApp.logger.d("didUpdateWidget() llamado, mounted: $mounted");
  }

  @override
  void deactivate() {
    MyApp.logger.d("deactivate() llamado, mounted: $mounted");
    super.deactivate();
  }

  @override
  void dispose() {
    MyApp.logger.d("dispose() llamado, mounted: $mounted");
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    MyApp.logger.d("reassemble() llamado, mounted: $mounted");
  }

  void _incrementCounter() {
    Provider.of<AppData>(context, listen: false).incrementCounter();
    MyApp.logger.d("Contador incrementado");
  }

  void _decrementCounter() {
    Provider.of<AppData>(context, listen: false).decrementCounter();
    MyApp.logger.d("Contador decrementado");
  }

  void _resetCounter() {
    Provider.of<AppData>(context, listen: false).resetCounter();
    MyApp.logger.d("Contador reiniciado");
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
    MyApp.logger.d("build() llamado, mounted: $mounted");
    

    final appData = Provider.of<AppData>(context);

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
                      Text(
                        'Usuario: ${appData.userName}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
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

                      //mostrar contador desde provider
                      Text(
                        '${appData.counter}',
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
                            onPressed: appData.allowReset ? _resetCounter : null,
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