import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Añadido
import 'pages/home_page.dart';
import 'provider/app_data.dart';
import 'services/database_helper.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final Logger logger = Logger();


  @override
  Widget build(BuildContext context) {
    logger.i("Logger is working");
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
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
      home: const MyHomePage(title: 'PRIMER INTENTO FLUTTER'),
    );
  }

}