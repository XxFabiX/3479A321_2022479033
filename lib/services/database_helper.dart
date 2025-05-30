import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../entity/actividad.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'actividad_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE actividades (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha TEXT NOT NULL,
        nombre TEXT NOT NULL
      )
    ''');
  }

  Future<void> initializeDatabase() async {
    await database;
  }

  //insertar actividad
  Future<int> insertActivity(Actividad actividad) async {
    final db = await database;
    return await db.insert(
      'actividades',
      actividad.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //obtener actividades
  Future<List<Actividad>> getAllActivities() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('actividades');
    return List.generate(maps.length, (i) => Actividad.fromMap(maps[i]));
  }

  //actualizar actividad
  Future<int> updateActivity(Actividad actividad) async {
    final db = await database;
    return await db.update(
      'actividades',
      actividad.toMap(),
      where: 'id = ?',
      whereArgs: [actividad.id],
    );
  }

  //elimanar actividad
  Future<int> deleteActivity(int id) async {
    final db = await database;
    return await db.delete(
      'actividades',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


}


