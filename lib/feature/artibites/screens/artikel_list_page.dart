import 'package:bite_tracker_mobile/feature/artibites/screens/detail_artikel_page.dart';
import 'package:flutter/material.dart';
import 'package:bite_tracker_mobile/feature/artibites/models/artikel.dart';
import 'package:bite_tracker_mobile/feature/artibites/screens/add_artikel_page.dart';
import 'package:bite_tracker_mobile/feature/artibites/screens/edit_artikel_page.dart'; // Tambahkan Edit Artikel

class ArtikelListPage extends StatefulWidget {
  const ArtikelListPage({super.key});

  @override
  _ArtikelListPageState createState() => _ArtikelListPageState();
}

class _ArtikelListPageState extends State<ArtikelListPage> {
  final List<Artikel> _artikels = []; // Daftar artikel kosong

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Artikel')),
      body: _artikels.isEmpty
          ? const Center(child: Text('Belum ada artikel!'))
          : ListView.separated(
              itemCount: _artikels.length,
              separatorBuilder: (context, index) =>
                  const Divider(), // Pemisah antar artikel
              itemBuilder: (context, index) {
                final artikel = _artikels[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: artikel.imageUrl.isNotEmpty
                        ? Image.network(
                            artikel.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported);
                            },
                          )
                        : const Icon(Icons.image),
                    title: Text(artikel.title),
                    subtitle: Text(
                      artikel.content.length > 50
                          ? '${artikel.content.substring(0, 50)}...'
                          : artikel.content,
                    ),
                    trailing: Text(
                      artikel.createdAt.split('T').first,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    onTap: () {
                      // Navigasi ke halaman detail artikel
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ArticleDetailPage(artikel: artikel),
                        ),
                      );
                    },
                    onLongPress: () {
                      // Menampilkan dialog untuk edit atau hapus artikel
                      _showEditDeleteDialog(artikel);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigasi ke halaman Add Artikel
          final artikelBaru = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddArtikelPage()),
          );
          if (artikelBaru != null && artikelBaru is Artikel) {
            setState(() {
              _artikels.add(artikelBaru); // Menambahkan artikel baru
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Dialog untuk mengedit atau menghapus artikel
  void _showEditDeleteDialog(Artikel artikel) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Apa yang ingin Anda lakukan?'),
        actions: [
          TextButton(
            onPressed: () {
              // Navigasi ke halaman edit artikel
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditArtikelPage(artikel: artikel),
                ),
              ).then((updatedArtikel) {
                if (updatedArtikel != null) {
                  setState(() {
                    final index = _artikels.indexOf(artikel);
                    if (index != -1) {
                      _artikels[index] = updatedArtikel; // Update artikel
                    }
                  });
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Edit'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _artikels.remove(artikel); // Hapus artikel
              });
              Navigator.pop(context);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
