import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart'; // acceso a MyApp.logger
import '../provider/app_data.dart';
import 'list_content.dart';
import 'about_page.dart';
import 'preferences_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    _loadPreferences(); // Carga las preferencias al iniciar
    MyApp.logger.d("HomePage: initState() - Cargando preferencias");
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isResetEnabled = prefs.getBool('isResetEnabled') ?? true;
      Provider.of<AppData>(context, listen: false).toggleReset(isResetEnabled);
      MyApp.logger.i("HomePage: Preferencia cargada - isResetEnabled: $isResetEnabled");
    } catch (e) {
      MyApp.logger.e("HomePage: Error al cargar preferencias", error: e);
    }
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
      drawer: _buildDrawer(context),
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

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.shade300,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: const Text(
              'Menú Principal',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.deepPurple),
            title: const Text('Home', style: TextStyle(fontWeight: FontWeight.bold)),
            tileColor: Colors.grey[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage(title: 'Home')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.list, color: Colors.deepPurple),
            title: const Text('Lista de Elementos', style: TextStyle(fontWeight: FontWeight.bold)),
            tileColor: Colors.grey[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ListContent()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.deepPurple),
            title: const Text('About', style: TextStyle(fontWeight: FontWeight.bold)),
            tileColor: Colors.grey[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.deepPurple),
            title: const Text('Preferencias', style: TextStyle(fontWeight: FontWeight.bold)),
            tileColor: Colors.grey[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onTap: () {
              Navigator.pop(context); //cierra darwer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PreferencesPage()),
              ).then((_) {
                _loadPreferences(); //recarga preferencias al volver
                MyApp.logger.d("HomePage: Preferencias actualizadas al volver");
              });
            },
          ),
        ],
      ),
    );
  }

}