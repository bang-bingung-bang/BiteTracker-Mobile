//lib\feature\edit_bites\screens\main\pages\menu.dart

import 'package:bite_tracker_mobile/feature/main/pages/footer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:bite_tracker_mobile/feature/authentication/models/user_models.dart';
import 'package:bite_tracker_mobile/feature/edit_bites/screens/pages/product_detail.dart';
import 'package:bite_tracker_mobile/feature/edit_bites/screens/pages/product_form.dart';
import 'package:bite_tracker_mobile/feature/edit_bites/models/editbites_data.dart';
import 'package:bite_tracker_mobile/feature/edit_bites/models/product.dart';

class EditBitesMenu extends StatefulWidget {
  const EditBitesMenu({Key? key}) : super(key: key);

  @override
  _EditBitesMenuState createState() => _EditBitesMenuState();
}

class _EditBitesMenuState extends State<EditBitesMenu> {
  late Future<List<Product>> futureProducts;
  String? filterParam;
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 4; // Index for Products/EditBites

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    final editBitesData = EditBitesData(request: request);
    futureProducts = editBitesData.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final editBitesData = EditBitesData(request: request);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          if (logInUser?.role == true)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductFormScreen(
                      editBitesData: editBitesData,
                      isEditing: false,
                    ),
                  ),
                ).then((_) {
                  setState(() {
                    futureProducts = editBitesData.getProducts();
                  });
                });
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search by product name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _buildFilterChip('High Calories'),
                _buildFilterChip('High Sugar'),
                _buildFilterChip('Low Calorie'),
                _buildFilterChip('Low Sugar'),
                _buildFilterChip('Non-Vegan'),
                _buildFilterChip('Vegan'),
              ],
            ),
          ),

          // Product List
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var products = snapshot.data!;

                  // Apply search filter
                  if (_searchController.text.isNotEmpty) {
                    products = products.where((product) =>
                        product.fields.name
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase())).toList();
                  }

                  // Apply category filter
                  if (filterParam != null) {
                    products = products.where((product) {
                      switch (filterParam) {
                        case 'High Calories':
                          return product.fields.calorieTag == "HIGH";
                        case 'High Sugar':
                          return product.fields.sugarTag == "HIGH";
                        case 'Low Calorie':
                          return product.fields.calorieTag == "LOW";
                        case 'Low Sugar':
                          return product.fields.sugarTag == "LOW";
                        case 'Non-Vegan':
                          return product.fields.veganTag == "NON_VEGAN";
                        case 'Vegan':
                          return product.fields.veganTag == "VEGAN";
                        default:
                          return true;
                      }
                    }).toList();
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(
                                  productId: product.pk,
                                  editBitesData: editBitesData,
                                  isAdmin: logInUser?.role ?? false,
                                ),
                              ),
                            ).then((_) {
                              setState(() {
                                futureProducts = editBitesData.getProducts();
                              });
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Image
                              Expanded(
                                child: Image.network(
                                  product.fields.image,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.fields.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rp ${product.fields.price}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: product.fields.calorieTag == "HIGH"
                                                ? Colors.red[100]
                                                : Colors.green[100],
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            product.fields.calorieTag,
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: FooterNavigationBar(
        selectedIndex: _selectedIndex, 
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: filterParam == label,
        onSelected: (bool selected) {
          setState(() {
            filterParam = selected ? label : null;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}