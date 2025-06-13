import 'dart:io';
import 'package:flutter/material.dart';

class GalleryPage extends StatelessWidget {
  final List<String> imagePaths;

  const GalleryPage({super.key, required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Galería de imágenes")),
      body: imagePaths.isEmpty
          ? const Center(child: Text("No hay imágenes disponibles"))
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: imagePaths.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, //imagenes por fila
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return Image.file(
                  File(imagePaths[index]),
                  fit: BoxFit.cover,
                );
              },
            ),
    );
  }
}
