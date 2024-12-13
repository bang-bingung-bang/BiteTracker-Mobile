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
                  String calorieTag = "";
                  String veganTag = "";
                  String sugarTag = "";
                  String store = "";
                  if (item.fields.veganTag == VeganTag.VEGAN){
                    veganTag = "Vegan";
                  } else {
                    veganTag = "Non Vegan";
                  }

                  if (item.fields.calorieTag == Tag.HIGH){
                    calorieTag = "High";
                  } else {
                    calorieTag = "Low";
                  }

                  if (item.fields.sugarTag == Tag.HIGH){
                    sugarTag = "High";
                  } else {
                    sugarTag = "Low";
                  }

                  if (item.fields.store == Store.AL_HIKAM_MART){
                    store = "Al Hikam Mart";
                  } else if (item.fields.store == Store.BELANDA_MART){
                    store = "Belanda Mart";
                  } else if (item.fields.store == Store.QITA_MART){
                    store = "Qita Mart";
                  } else if (item.fields.store == Store.SNACK_JAYA_MARKET){
                    store = "Store Jaya Market";
                  } else if (item.fields.store == Store.TUTUL_V_MARKET){
                    store = "Tutul V Market";
                  }
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
                        Padding(
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
                                "Rp. ${item.fields.price}\nStore : ${store}\nCalories : ${item.fields.calories}\nCalories Tag : ${calorieTag}\nSugar Tag : ${sugarTag}\nVegan Tag : ${veganTag}\n\n",
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
                                  content: Text('${item.fields.name} added to wishlist!'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown.shade700,
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
