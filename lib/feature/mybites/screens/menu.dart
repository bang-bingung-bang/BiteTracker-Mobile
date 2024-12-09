import 'package:bite_tracker_mobile/feature/mybites/models/mybites_data.dart';
import 'package:bite_tracker_mobile/feature/mybites/screens/product_wishlist.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyBites',
      theme: ThemeData(
        colorScheme: ColorScheme(
          primary: Colors.brown,
          secondary: Colors.brown.shade800,
          surface: Colors.white,
          background: Colors.yellow[50]!,
          error: Colors.red,
          onPrimary: Colors.black,
          onSecondary: Colors.black,
          onSurface: Colors.black,
          onBackground: Colors.black,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<ItemHomepage> items = [
    ItemHomepage("Let's go back to main page!", Icons.add_home_work_rounded),
    ItemHomepage("Wanna see product list?", Icons.shopping_cart),
  ];

  // Ini adalah list untuk menyimpan wishlist
  final List<MyBitesData> wishlist = [];

  void updateWishlist(List<MyBitesData> newWishlist) {
    setState(() {
      wishlist.clear();
      wishlist.addAll(newWishlist);
    });

    print("Updated wishlist: $wishlist");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MyBites!',
          style: GoogleFonts.lobster(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 30,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16.0),
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Welcome To MyBites!!!',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: items.map((ItemHomepage item) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ItemCard(
                          item: item,
                          wishlist: wishlist,
                          updateWishlist: updateWishlist,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16.0),
                  // Menampilkan data wishlist di sini
                  Column(
                    children: wishlist.map((MyBitesData item) {
                      return ListTile(
                        title: Text(item.fields.name),  // Nama produk
                        subtitle: Text(item.fields.description),  // Deskripsi produk
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemHomepage {
  final String name;
  final IconData icon;
  ItemHomepage(this.name, this.icon);
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;
  final List<MyBitesData> wishlist;
  final Function(List<MyBitesData>) updateWishlist;

  const ItemCard({
    super.key,
    required this.item,
    required this.wishlist,
    required this.updateWishlist,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () async {
          if (item.name == "Wanna see product list?") {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductsWishlist(
                  wishlist: wishlist,
                ),
              ),
            );
            if (result != null && result.isNotEmpty) { // Pastikan result tidak kosong
              updateWishlist(result);
            } else {
              print("Wishlist is still empty or no update received.");
            }
          } else {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text("Kamu telah menekan tombol ${item.name}!")),
              );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}