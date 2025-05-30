import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/app_data.dart';
import '../main.dart'; // Para acceder a MyApp.logger

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  bool _isResetEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    MyApp.logger.d("PreferencesPage: initState() - Cargando preferencias");
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedValue = prefs.getBool('isResetEnabled') ?? true;
      setState(() => _isResetEnabled = savedValue);
      Provider.of<AppData>(context, listen: false).toggleReset(savedValue);
      MyApp.logger.i("PreferencesPage: Preferencia cargada - isResetEnabled: $savedValue");
    } catch (e) {
      MyApp.logger.e("PreferencesPage: Error al cargar preferencias", error: e);
    }
  }

  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isResetEnabled', _isResetEnabled);
      Provider.of<AppData>(context, listen: false).toggleReset(_isResetEnabled);
      MyApp.logger.i("PreferencesPage: Preferencia guardada - isResetEnabled: $_isResetEnabled");
    } catch (e) {
      MyApp.logger.e("PreferencesPage: Error al guardar preferencias", error: e);
    }
  }

  @override
  void dispose() {
    _savePreferences(); 
    MyApp.logger.d("PreferencesPage: dispose() - Guardando preferencias finales");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preferencias')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Permitir reinicio del contador'),
              value: _isResetEnabled,
              onChanged: (value) {
                setState(() => _isResetEnabled = value);
                _savePreferences(); //Guarda inmediatamente al cambiar
              },
            ),
          ],
        ),
      ),
    );
  }
}