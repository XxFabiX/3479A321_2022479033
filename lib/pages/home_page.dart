import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; 
import 'package:camera/camera.dart';

import '../main.dart';
import '../provider/app_data.dart';
import 'list_content.dart';
import 'about_page.dart';
import 'preferences_page.dart';
import 'actividad_page.dart';
import 'picture_screen.dart';
import 'dart:io';
import 'gallery_page.dart';


  class MyHomePage extends StatefulWidget {
    
    final String title;
    final CameraDescription camera; //parametro camara
    
    const MyHomePage({
      super.key, 
      required this.title,
      required this.camera, //constructor
    });

    @override
    State<MyHomePage> createState() => _MyHomePageState();
  }

class _MyHomePageState extends State<MyHomePage> {

final List<String> imageUrls = [
  'https://picsum.photos/id/10/250/250',
  'https://picsum.photos/id/13/250/250',
  'https://picsum.photos/id/19/250/250',
  'https://picsum.photos/id/21/250/250',
  'https://picsum.photos/id/25/250/250',
  'https://picsum.photos/id/26/250/250',
  'https://picsum.photos/id/28/250/250',
  'https://picsum.photos/id/29/250/250',
  'https://picsum.photos/id/27/250/250',
  'https://picsum.photos/id/18/250/250',
  'https://picsum.photos/id/15/250/250',
];

  String _currentImageUrl = 'https://picsum.photos/id/10/250/250'; 
  bool _isImageLoading = false;
  String _imageError = '';
  int _currentImageIndex = 0;
  String? _cameraImagePath;
  List<String> _cameraImages = []; //lista imagenes

  @override
  void initState() {
    super.initState();
    _loadPreferences();
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

Future<void> _getNewImage() async {
  setState(() {
    _isImageLoading = true;
    _imageError = '';
  });

  try {
    final newIndex = Provider.of<AppData>(context, listen: false).counter % imageUrls.length;

    if (newIndex == _currentImageIndex) {
      _currentImageIndex = (newIndex + 1) % imageUrls.length;
    } else {
      _currentImageIndex = newIndex;
    }

    setState(() => _currentImageUrl = imageUrls[_currentImageIndex]);
  } catch (e) {
    setState(() => _imageError = 'Error: ${e.toString()}');
  } finally {
    setState(() => _isImageLoading = false);
  }
}

  Widget _buildImage() {
    if (_cameraImagePath != null) {
      return Image.file(
        File(_cameraImagePath!),
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      );
    }
    return _buildNetworkImage(); //metodo existente para las imagenes de internet
  }


  //wideget mostrar imagenes
  Widget _buildNetworkImage() {
    if (_imageError.isNotEmpty) {
      return Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 50),
          Text(_imageError, style: const TextStyle(color: Colors.red)),
        ],
      );
    }

    return Image.network(
      _currentImageUrl,
      width: double.infinity,
      height: 250,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
        return const Column(
          children: [
            Icon(Icons.broken_image, color: Colors.red, size: 50),
            Text('Error al cargar imagen', style: TextStyle(color: Colors.red)),
          ],
        );
      },
    );
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

  void _restoreInternetImages() {
  setState(() {
    _cameraImagePath = null;
  });
  }


//metodo para anvegar por camara
void _navigateToCamera() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PictureScreen(camera: widget.camera),
    ),
  );

  if (result != null && mounted) {
    setState(() {
      _cameraImagePath = result as String;
      _cameraImages.add(_cameraImagePath!); // guardar en lista
    });
  }
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
      body: SingleChildScrollView(
        child: Center(
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
                        //wideget de imagen desde internet
                        //_buildNetworkImage(),
                        _buildImage(),
                        if (_cameraImagePath != null)
                        ElevatedButton.icon(
                          onPressed: _restoreInternetImages,
                          icon: const Icon(Icons.cloud),
                          label: const Text("Imagenes internet"),
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
                        //buton cambiar iamgen
                        ElevatedButton(
                          onPressed: _isImageLoading ? null : _getNewImage,
                          child: _isImageLoading
                              ? const CircularProgressIndicator()
                              : const Text('Cambiar Imagen'),
                        ),
                        ElevatedButton(onPressed: _navigateToCamera, child: const Text("tomar foto"))
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _navigateToList,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GalleryPage(imagePaths: _cameraImages),
                  ),
                );
              },
              child: const Text("Ver Galería"),
            ),
            ],
          ),
        ),
      )
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
                MaterialPageRoute(builder: (context) => MyHomePage(title: 'Home', camera:widget.camera,)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.event_note, color: Colors.deepPurple),
            title: const Text('Actividades', style: TextStyle(fontWeight: FontWeight.bold)),
            tileColor: Colors.grey[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ActividadPage()),
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
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PreferencesPage()),
              ).then((_) {
                _loadPreferences();
                MyApp.logger.d("HomePage: Preferencias actualizadas al volver");
              });
            },
          ),
        ],
      ),
    );
  }

}