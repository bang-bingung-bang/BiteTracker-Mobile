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

  final List<MyBitesData> wishlist = [];

  void updateWishlist(List<MyBitesData> newWishlist) {
    setState(() {
      wishlist.clear();
      wishlist.addAll(newWishlist);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MyBites',
          style: GoogleFonts.lobster(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.brown.shade800,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown.shade100, Colors.brown.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Welcome to MyBites!',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Discover and track your favorite snacks.',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.brown.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: items.map((item) {
                    return GestureDetector(
                      onTap: () async {
                        if (item.name == "Wanna see product list?") {
                          final newWishlist = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductsWishlist(
                                wishlist: List.from(wishlist),
                              ),
                            ),
                          );
                          if (newWishlist != null &&
                              newWishlist is List<MyBitesData>) {
                            updateWishlist(newWishlist);
                          }
                        } else {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                  content: Text("Anda menekan ${item.name}!")),
                            );
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.brown.shade200,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.brown.shade100,
                              offset: Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              item.icon,
                              size: 40,
                              color: Colors.brown.shade900,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              item.name,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.brown.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.brown.shade50,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.shade100,
                      offset: const Offset(0, -2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Bites!',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: wishlist.isNotEmpty
                            ? ListView.builder(
                                itemCount: wishlist.length,
                                itemBuilder: (context, index) {
                                  final item = wishlist[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: ListTile(
                                      leading: Image.network(
                                        item.fields.image,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error,
                                            stackTrace) {
                                          return Icon(Icons.broken_image,
                                              size: 50);
                                        },
                                      ),
                                      title: Text(
                                        item.fields.name,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        item.fields.description,
                                        style: GoogleFonts.poppins(
                                            fontSize: 14),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                  'Your Bites is empty!',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.brown.shade600,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
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
            final newWishlist = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductsWishlist(
                  wishlist: List.from(wishlist),
                ),
              ),
            );

            if (newWishlist != null && newWishlist is List<MyBitesData>) {
              updateWishlist(newWishlist);
            }
          } else {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text("Anda menekan tombol ${item.name}!")),
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