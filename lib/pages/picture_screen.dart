import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'preview_picture_screen.dart';

class PictureScreen extends StatefulWidget {
  final CameraDescription camera;
  
  const PictureScreen({
    super.key,
    required this.camera,
  });

  @override
  State<PictureScreen> createState() => _PictureScreenState();
}

class _PictureScreenState extends State<PictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    
    _initializeControllerFuture = _controller.initialize();
    
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;

      final image = await _controller.takePicture();

      if (!mounted) return;

      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PreviewPictureScreen(
            imagePath: image.path,
          ),
        ),
      );

      if (result != null && mounted) {
        Navigator.of(context).pop(result);
      }

    } catch (e) {
      print("Error foto: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error foto')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tomar Foto')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}