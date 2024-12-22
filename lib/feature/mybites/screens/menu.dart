import 'package:bite_tracker_mobile/feature/mybites/models/mybites_data.dart';
import 'package:bite_tracker_mobile/feature/mybites/screens/product_wishlist.dart';
import 'package:bite_tracker_mobile/feature/main/pages/menu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:bite_tracker_mobile/feature/main/pages/footer.dart';

void main() {
  runApp(const MyBitesApp());
}

class MyBitesApp extends StatelessWidget {
  const MyBitesApp({super.key});

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
  List<MyBitesData> wishlist = [];

  int _selectedIndex = 4;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void updateWishlist(List<MyBitesData> newWishlist) {
    setState(() {
      wishlist.clear();
      wishlist.addAll(newWishlist);
    });
  }

  Future<void> saveWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistJson =
        wishlist.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('wishlist', wishlistJson);
  }

  @override
  void initState() {
    super.initState();
    loadWishlist(context.read<CookieRequest>());
  }

  void addToWishlist(MyBitesData product) async {
    try {
      final request = context.read<CookieRequest>();
      final response = await request.post(
        'http://127.0.0.1:8000/mybites/flutter/add/',
        {
          'product_id': product.pk.toString(),
        },
      );

      if (response['status'] == true) {
        setState(() {
          wishlist.add(product);
        });

        saveWishlist();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product added to wishlist successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Failed to add product to wishlist'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> loadWishlist(CookieRequest request) async {
      if (!request.loggedIn) return;

      try {
        final response = await request.get('http://127.0.0.1:8000/mybites/flutter/view/');
        if (response['wishlist'] != null) {
          final List<MyBitesData> fetchedWishlist = 
              (response['wishlist'] as List).map((json) => MyBitesData.fromJson(json)).toList();
          
          if (mounted) {
            setState(() {
              wishlist = fetchedWishlist;
            });
          }
          
          saveWishlist();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load wishlist: $e')),
          );
        }
      }
  }

  Future<void> removeFromWishlist(MyBitesData product) async {
    try {
      final request = context.read<CookieRequest>();
      final product_id = product.pk;

      final response = await request.post(
        'http://127.0.0.1:8000/mybites/flutter/remove/$product_id/',
        {}
      );

      if (response['status'] == true) {
        setState(() {
          wishlist.remove(product);
        });

        saveWishlist();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product removed from wishlist successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Failed to remove product from wishlist'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> _addProductToWishlist(MyBitesData product) async {
    try {
      await Future.delayed(Duration(seconds: 1));
      return true;
    } catch (e) {
      return false;
    }
  }

  List<MyBitesData> parseWishlist(String responseBody) {
    final List<dynamic> parsed = jsonDecode(responseBody);
    return parsed.map((json) => MyBitesData.fromJson(json)).toList();
  }

  Future<List<MyBitesData>> loadWishlistFuture(CookieRequest request) async {
    if (!request.loggedIn) {
      throw Exception('User not logged in');
    }

    try {
      final response = await request.get('http://127.0.0.1:8000/mybites/flutter/view/');
      if (response['wishlist'] != null) {
        final List<MyBitesData> wishlist =
            (response['wishlist'] as List).map((json) => MyBitesData.fromJson(json)).toList();
        return wishlist;
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch wishlist: $e');
    }
  }

  final List<ItemHomepage> items = [
    ItemHomepage("Let's go back to main page!", Icons.add_home_work_rounded),
    ItemHomepage("Wanna see product list?", Icons.shopping_cart),
  ];

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    if (!request.loggedIn) {
      return Scaffold(
        body: Center(
          child: Text(
            'Please log in to access MyBites',
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: isLandscape ? 8 : 16,
                ),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
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
                          ).then((_) {
                            setState(() {
                              loadWishlist(context.read<CookieRequest>());
                            });
                          });
                          if (newWishlist != null &&
                              newWishlist is List<MyBitesData>) {
                            updateWishlist(newWishlist);
                          }
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
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
                              offset: const Offset(0, 3),
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
                            Expanded(
                              child: Text(
                                item.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.brown.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Container(
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
                      SizedBox(
                        height: mediaQuery.size.height * 0.4,
                        child: wishlist.isEmpty
                            ? Center(
                                child: Text(
                                  'Your Bites is empty',
                                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.brown),
                                ),
                              )
                            : ListView.builder(
                                itemCount: wishlist.length,
                                itemBuilder: (context, index) {
                                  final item = wishlist[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: ListTile(
                                      leading: Image.network(
                                        item.fields.image,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                      title: Text(item.fields.name),
                                      trailing: IconButton(
                                        icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                                        onPressed: () async {
                                          await removeFromWishlist(item);

                                          setState(() {
                                            wishlist.removeAt(index);
                                          });
                                          saveWishlist();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Product removed from wishlist')),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: FooterNavigationBar(
        selectedIndex: _selectedIndex, 
        onItemTapped: _onItemTapped,
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