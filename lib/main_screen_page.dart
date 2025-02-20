import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'http/impl/http_service_impl.dart';

class MainScreenPage extends StatefulWidget {
  const MainScreenPage({super.key});

  @override
  State<MainScreenPage> createState() => _MainScreenPageState();
}

class _MainScreenPageState extends State<MainScreenPage> {
  final HttpServiceImpl http = HttpServiceImpl(baseUrl: 'http://teste.com');

  File? image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      image = File(pickedFile!.path);
    });
  }

  Future<void> _sendImage() async {
    http.post('aa');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Detector'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: image == null ? const Text('Selecione uma imagem') : Image.file(image!),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _sendImage,
            child: const Text('Enviar imagem'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _pickImage,
            child: const Text('Selecionar imagem'),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
