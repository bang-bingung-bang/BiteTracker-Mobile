import 'package:flutter/material.dart';
import 'package:bite_tracker_mobile/feature/artibites/models/artikel.dart';

class AddArtikelPage extends StatefulWidget {
  const AddArtikelPage({super.key});

  @override
  _AddArtikelPageState createState() => _AddArtikelPageState();
}

class _AddArtikelPageState extends State<AddArtikelPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  String? _previewImageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Artikel')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul Artikel'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Konten Artikel'),
                maxLines: 5,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'URL Gambar'),
                onChanged: (value) {
                  setState(() {
                    if (Uri.tryParse(value)?.hasAbsolutePath ?? false) {
                      _previewImageUrl = value;
                    } else {
                      _previewImageUrl = null;
                    }
                  });
                },
              ),
              const SizedBox(height: 10),
              if (_previewImageUrl != null && _previewImageUrl!.isNotEmpty)
                Image.network(
                  _previewImageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'Gagal memuat gambar. Periksa URL Anda.',
                      style: TextStyle(color: Colors.red),
                    );
                  },
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Tambah Artikel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    // Validasi input
    if (_titleController.text.isEmpty) {
      _showSnackBar('Judul artikel tidak boleh kosong!');
      return;
    }
    if (_contentController.text.isEmpty) {
      _showSnackBar('Konten artikel tidak boleh kosong!');
      return;
    }
    if (_imageUrlController.text.isEmpty) {
      _showSnackBar('URL gambar tidak boleh kosong!');
      return;
    }

    final artikelBaru = Artikel(
      id: DateTime.now().toString(),
      title: _titleController.text,
      content: _contentController.text,
      imageUrl: _imageUrlController.text,
      createdAt: DateTime.now().toIso8601String(),
    );

    // Kirim artikel baru kembali ke halaman sebelumnya
    Navigator.pop(context, artikelBaru);

    // Reset form
    _titleController.clear();
    _contentController.clear();
    _imageUrlController.clear();
    setState(() {
      _previewImageUrl = null;
    });

    // Tampilkan notifikasi sukses
    _showSnackBar('Artikel berhasil ditambahkan!');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
