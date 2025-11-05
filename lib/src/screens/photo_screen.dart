
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({super.key});

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  File? _image;
  double _progress = 0;
  List<String> found = [];
  List<String> missing = [];
  bool _busy = false;

  Future<void> _pick() async {
    final picker = ImagePicker();
    final x = await picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (x == null) return;
    setState(() {
      _image = File(x.path);
      _progress = 0.1;
      found = []; missing = []; _busy = true;
    });
    await Future.delayed(const Duration(milliseconds: 300)); setState(()=>_progress = 0.35);
    await Future.delayed(const Duration(milliseconds: 300)); setState(()=>_progress = 0.6);
    final res = await TabachkiApi.recognizeBrandsWithVision(await _image!.readAsBytes());
    setState(() {
      _progress = 1.0;
      found = (res['found'] as List).cast<String>();
      missing = (res['missing'] as List).cast<String>();
      _busy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Фото витрины')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _busy ? null : _pick,
        icon: const Icon(Icons.photo_camera),
        label: const Text('Сделать фото'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(_image!, height: 220, fit: BoxFit.cover),
            ),
          if (_busy || (_progress > 0 && _progress < 1.0)) ...[
            const SizedBox(height: 16),
            LinearProgressIndicator(value: _progress < 1.0 ? _progress : null),
            const SizedBox(height: 8),
            Text(_progress < 1.0 ? 'Обработка... ${(100*_progress).round()}%' : 'Финализация...'),
          ],
          const SizedBox(height: 16),
          if (found.isNotEmpty) ...[
            Text('✅ Найдено:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Wrap(spacing: 8, children: found.map((e) => Chip(label: Text(e))).toList()),
          ],
          if (missing.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text('🚫 Отсутствует:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Wrap(spacing: 8, children: missing.map((e) => Chip(label: Text(e))).toList()),
          ],
          if (_image == null && found.isEmpty && missing.isEmpty)
            const Text('Сфотографируйте витрину — приложение определит, каких сигарет не хватает.'),
          if (found.isEmpty && missing.isNotEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('Подключи Vision API в config.dart, чтобы распознавание работало автоматически.'),
            ),
        ],
      ),
    );
  }
}
