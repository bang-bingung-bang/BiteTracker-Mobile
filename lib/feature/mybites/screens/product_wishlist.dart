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
        title: const Text('Products List'),
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
                crossAxisCount: 3,
                childAspectRatio: 0.7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                          child: Image.network(
                            item.fields.image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          item.fields.name,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (!widget.wishlist.contains(item)) {
                              widget.wishlist.add(item);
                            }
                          });
                        },
                        child: const Text("Add to MyBites!"),
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
          Navigator.pop(context, widget.wishlist);  // Return updated wishlist
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}