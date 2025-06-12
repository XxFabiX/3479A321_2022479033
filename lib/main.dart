import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home_page.dart';
import 'provider/app_data.dart';
import 'services/database_helper.dart';
import 'pages/picture_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    //obtener camaras disponibles
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    //inicializa base de datos
    await DatabaseHelper().initializeDatabase();

    final prefs = await SharedPreferences.getInstance();
    final isResetEnabled = prefs.getBool('isResetEnabled') ?? true;

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AppData()..toggleReset(isResetEnabled),
          ),
        ],
        child: MyApp(camera: firstCamera),
      ),
    );
  } catch (e) {
    Logger().e("Error al inicializar la aplicación", error: e);
    runApp(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error al iniciar la cámara. Reinicie la aplicación.'),
          ),
        ),
      ),
    );
  }
}


class MyApp extends StatelessWidget {

  final CameraDescription camera;
  
  const MyApp({
    super.key,
    required this.camera,
  });

  static final Logger logger = Logger();


  @override
  Widget build(BuildContext context) {
    logger.i("Aplicación iniciada correctamente");
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplicación con Cámara',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple,
          titleTextStyle: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'App con Camara',
        camera: camera,
      ),
    );
  }

}