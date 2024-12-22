import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bite_tracker_mobile/feature/mybites/models/mybites_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProductsWishlist extends StatefulWidget {
  final List<MyBitesData> wishlist;

  const ProductsWishlist({Key? key, required this.wishlist}) : super(key: key);

  @override
  State<ProductsWishlist> createState() => _ProductsWishlistState();
}

class _ProductsWishlistState extends State<ProductsWishlist> {
  late Future<List<MyBitesData>> _myBitesData;

  @override
  void initState() {
    super.initState();
    _myBitesData = fetchMyBitesData();
  }

  Future<List<MyBitesData>> fetchMyBitesData() async {
  final url = Uri.parse('https://faiz-akram-bitetrackers.pbp.cs.ui.ac.id/mybites/json/');

  final response = await http.get(url);
  try {

    if (response.statusCode == 200) {
      return myBitesDataFromJson(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  } on http.ClientException catch (e) {
    throw Exception('Connection error: $e');
  } catch (e) {
    throw Exception('Unexpected error: $e');
  }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products List',
          style: GoogleFonts.lobster(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.brown.shade700,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown.shade50, Colors.brown.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<MyBitesData>>(
          future: _myBitesData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final data = snapshot.data!;
              return LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    padding: const EdgeInsets.all(16),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      String calorieTag = item.fields.calorieTag == Tag.HIGH ? "High" : "Low";
                      String veganTag = item.fields.veganTag == VeganTag.VEGAN ? "Vegan" : "Non Vegan";
                      String sugarTag = item.fields.sugarTag == Tag.HIGH ? "High" : "Low";
                      String store = {
                        Store.AL_HIKAM_MART: "Al Hikam Mart",
                        Store.BELANDA_MART: "Belanda Mart",
                        Store.QITA_MART: "Qita Mart",
                        Store.SNACK_JAYA_MARKET: "Snack Jaya Market",
                        Store.TUTUL_V_MARKET: "Tutul V Market",
                      }[item.fields.store] ?? "Unknown Store";

                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.brown.shade100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Stack(
                                  children: [
                                    Image.network(
                                      item.fields.image,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Colors.brown.withOpacity(0.3), Colors.transparent],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.fields.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.brown.shade800,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Rp. ${item.fields.price}\nStore: $store\nCalories: ${item.fields.calories}\nCalories Tag: $calorieTag\nSugar Tag: $sugarTag\nVegan Tag: $veganTag",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.brown,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.fields.description,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState (() async {
                                    final product_id = item.pk;
                                    final response = await request.postJson(
                                      "https://faiz-akram-bitetrackers.pbp.cs.ui.ac.id/mybites/flutter/add/$product_id/",
                                      jsonEncode(product_id)
                                    );
                                    if (context.mounted) {
                                      if (response['status'] == 'success') {
                                        ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                            content: Text("MyBites berhasil disimpan!"),
                                          ));
                                        Navigator.pop(context);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                            content:
                                              Text("Terdapat kesalahan, silakan coba lagi."),
                                          ));
                                      }
                                    }
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${item.fields.name} added to MyBites!'),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.favorite),
                                label: const Text("Add to MyBites"),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return const Center(child: Text('No data found.'));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, widget.wishlist);
        },
        backgroundColor: Colors.brown.shade700,
        child: const Icon(Icons.check),
      ),
    );
  }
}