class Actividad {
  final int? id;
  final String fecha;
  final String nombre;

  Actividad({
    this.id,
    required this.fecha,
    required this.nombre,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fecha': fecha,
      'nombre': nombre,
    };
  }

  factory Actividad.fromMap(Map<String, dynamic> map) {
    return Actividad(
      id: map['id'],
      fecha: map['fecha'],
      nombre: map['nombre'],
    );
  }
  
}
