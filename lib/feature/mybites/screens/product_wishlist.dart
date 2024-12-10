import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:bite_tracker_mobile/feature/mybites/models/mybites_data.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final String response = await rootBundle.loadString('assets/data/mybites_data.json');
    return myBitesDataFromJson(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products List',
          style: GoogleFonts.lobster(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: FutureBuilder<List<MyBitesData>>(
        future: _myBitesData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              padding: const EdgeInsets.all(16),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                              if (item.fields.calorieTag == "low-cal")
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "Low-Cal",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.fields.name,
                              style: GoogleFonts.deliusSwashCaps(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Rp. ${item.fields.price}\nStore : ${item.fields.store}\nCalories : ${item.fields.calories}\nCalories Tag : ${item.fields.calorieTag}\nSugar Tag : ${item.fields.sugarTag}\nVegan Tag : ${item.fields.veganTag}\n\n",
                              style: GoogleFonts.arvo(
                                fontSize: 14,
                                color: Colors.brown,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.fields.description,
                              style: GoogleFonts.arvo(
                                fontSize: 20,
                                color: Colors.grey[700],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              if (!widget.wishlist.contains(item)) {
                                widget.wishlist.add(item);
                              }
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${item.fields.name} added to MyBites!'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.favorite),
                          label: const Text("Add to MyBites!"),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No data found.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, widget.wishlist);
        },
        backgroundColor: Colors.brown,
        child: const Icon(Icons.check),
      ),
    );
  }
}