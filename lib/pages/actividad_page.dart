import 'package:flutter/material.dart';
import '../entity/actividad.dart';
import '../services/database_helper.dart';

class ActividadPage extends StatefulWidget {
  const ActividadPage({super.key});

  @override
  State<ActividadPage> createState() => _ActividadPageState();
}

class _ActividadPageState extends State<ActividadPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Actividad> _actividades = [];

  @override
  void initState() {
    super.initState();
    _cargarActividades();
  }

  Future<void> _cargarActividades() async {
    final actividades = await _dbHelper.getAllActivities();
    setState(() {
      _actividades = actividades;
    });
  }

  Future<void> _eliminarActividad(int id) async {
    await _dbHelper.deleteActivity(id);
    _cargarActividades();
  }

  Future<void> _editarActividad(Actividad actividad) async {
    final nombreController = TextEditingController(text: actividad.nombre);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Actividad'),
        content: TextField(
          controller: nombreController,
          decoration: const InputDecoration(labelText: 'Nombre de la actividad'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final nuevoNombre = nombreController.text.trim();
              if (nuevoNombre.isNotEmpty) {
                final actividadEditada = Actividad(
                  id: actividad.id,
                  nombre: nuevoNombre,
                  fecha: actividad.fecha,
                );
                await _dbHelper.updateActivity(actividadEditada);
                _cargarActividades();
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actividades registradas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarActividades,
          ),
        ],
      ),
      body: _actividades.isEmpty
          ? const Center(child: Text('No hay actividades registradas'))
          : ListView.builder(
              itemCount: _actividades.length,
              itemBuilder: (context, index) {
                final actividad = _actividades[index];
                return Dismissible(
                  key: Key(actividad.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirmar'),
                        content: const Text('¿Eliminar esta actividad?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Eliminar'),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) => _eliminarActividad(actividad.id!),
                  child: Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: const Icon(Icons.event_note, color: Colors.deepPurple),
                      title: Text(actividad.nombre),
                      subtitle: Text('Fecha: ${actividad.fecha}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editarActividad(actividad),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final nombreController = TextEditingController();

          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Nueva Actividad'),
              content: TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre de la actividad'),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final nombre = nombreController.text.trim();
                    if (nombre.isNotEmpty) {
                      final nuevaActividad = Actividad(
                        fecha: DateTime.now().toIso8601String(),
                        nombre: nombre,
                      );
                      await _dbHelper.insertActivity(nuevaActividad);
                      _cargarActividades();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}