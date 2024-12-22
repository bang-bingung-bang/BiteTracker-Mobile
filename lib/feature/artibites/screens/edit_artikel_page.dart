import 'package:flutter/material.dart';
import 'package:bite_tracker_mobile/feature/artibites/models/artikel.dart';

class EditArtikelPage extends StatefulWidget {
  final Artikel artikel;

  const EditArtikelPage({super.key, required this.artikel});

  @override
  _EditArtikelPageState createState() => _EditArtikelPageState();
}

class _EditArtikelPageState extends State<EditArtikelPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.artikel.title);
    _contentController = TextEditingController(text: widget.artikel.content);
    _imageController = TextEditingController(text: widget.artikel.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Artikel')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Judul Artikel'),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Konten Artikel'),
            ),
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(labelText: 'Link Gambar'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    // Validasi input
    if (_titleController.text.isNotEmpty &&
        _contentController.text.isNotEmpty &&
        _imageController.text.isNotEmpty) {
      final artikelDiedit = Artikel(
        id: widget.artikel.id, // Menggunakan id artikel lama
        title: _titleController.text,
        content: _contentController.text,
        imageUrl: _imageController.text,
        createdAt:
            widget.artikel.createdAt, // Tetap mempertahankan createdAt yang ada
      );

      // Kembalikan artikel yang sudah diedit
      Navigator.pop(context, artikelDiedit);
    } else {
      // Menampilkan pesan jika ada kolom yang kosong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom harus diisi!')),
      );
    }
  }
}
