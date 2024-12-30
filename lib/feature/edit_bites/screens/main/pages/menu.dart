//lib/feature/edit_bites/screens/main/pages/menu.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:bite_tracker_mobile/feature/authentication/models/user_models.dart';
import 'package:bite_tracker_mobile/feature/edit_bites/screens/pages/product_detail.dart';
import 'package:bite_tracker_mobile/feature/edit_bites/screens/pages/product_form.dart';
import 'package:bite_tracker_mobile/feature/edit_bites/models/editbites_data.dart';
import 'package:bite_tracker_mobile/feature/edit_bites/models/product.dart';
import 'package:bite_tracker_mobile/feature/main/pages/footer.dart';

class EditBitesMenu extends StatefulWidget {
  const EditBitesMenu({Key? key}) : super(key: key);

  @override
  State<EditBitesMenu> createState() => _EditBitesMenuState();
}

class _EditBitesMenuState extends State<EditBitesMenu> {
  late Future<List<Product>> futureProducts;
  String? filterParam;
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 4;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    final editBitesData = EditBitesData(request: request);
    futureProducts = editBitesData.getProducts();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final editBitesData = EditBitesData(request: request);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5D4037),
        foregroundColor: Colors.white,
        title: const Text(
          'Products',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: Colors.grey[50],
        child: Column(
          children: [
            // Title and Product Count
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    filterParam ?? 'All Products',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FutureBuilder<List<Product>>(
                    future: futureProducts,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '${snapshot.data!.length} products',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),

            // Search Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by product name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        prefixIcon: const Icon(Icons.search),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                  ),
                ],
              ),
            ),// Main Content with Sidebar and Grid
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sidebar Filters
                  Container(
                    width: 256,
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Browse by',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(height: 32),
                        _buildFilterOption('All Products', null),
                        _buildFilterOption('High Calories', 'High Calories'),
                        _buildFilterOption('High Sugar', 'High Sugar'),
                        _buildFilterOption('Low Calorie', 'Low Calorie'),
                        _buildFilterOption('Low Sugar', 'Low Sugar'),
                        _buildFilterOption('Non-Vegan', 'Non-Vegan'),
                        _buildFilterOption('Vegan', 'Vegan'),
                      ],
                    ),
                  ),

                  // Products Grid Section
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Admin Add Button
                          if (logInUser?.role == true)
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductFormScreen(
                                        editBitesData: editBitesData,
                                        isEditing: false,
                                      ),
                                    ),
                                  ).then((_) => setState(() {
                                        futureProducts = editBitesData.getProducts();
                                      }));
                                },
                                icon: const Icon(Icons.add),
                                label: const Text(
                                  'Add Product',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),// Products Grid with FutureBuilder
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
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 0.75,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                    ),
                                    itemCount: products.length,
                                    itemBuilder: (context, index) {
                                      final product = products[index];
                                      return Card(
                                        clipBehavior: Clip.antiAlias,
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),child: InkWell(
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
                                            ).then((_) => setState(() {
                                                  futureProducts = editBitesData.getProducts();
                                                }));
                                          },
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Product Tag
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF5D4037),
                                                    borderRadius: BorderRadius.circular(16),
                                                  ),
                                                  child: Text(
                                                    _getProductTag(product),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              // Product Image and Admin Actions
                                              Expanded(
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(16),
                                                      child: Image.network(
                                                        product.fields.image,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                    if (logInUser?.role == true)
                                                      Material(
                                                        color: Colors.transparent,
                                                        child: InkWell(
                                                          onTap: () {},
                                                          hoverColor: Colors.black.withOpacity(0.3),
                                                          child: Container(
                                                            color: Colors.transparent,
                                                            child: Center(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  IconButton(
                                                                    icon: const Icon(Icons.edit),
                                                                    color: Colors.white,
                                                                    onPressed: () {
                                                                      Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) => ProductFormScreen(
                                                                            editBitesData: editBitesData,
                                                                            isEditing: true,
                                                                            productId: product.pk,
                                                                          ),
                                                                        ),
                                                                      ).then((_) => setState(() {
                                                                            futureProducts = editBitesData.getProducts();
                                                                          }));
                                                                    },
                                                                  ),
                                                                  IconButton(
                                                                    icon: const Icon(Icons.delete),
                                                                    color: Colors.white,
                                                                    onPressed: () async {
                                                                      final confirmed = await showDialog<bool>(
                                                                        context: context,
                                                                        builder: (context) => AlertDialog(
                                                                          title: const Text('Confirm Delete'),
                                                                          content: const Text('Are you sure you want to delete this product?'),
                                                                          actions: [
                                                                            TextButton(
                                                                              child: const Text('Cancel'),
                                                                              onPressed: () => Navigator.pop(context, false),
                                                                            ),
                                                                            TextButton(
                                                                              child: const Text('Delete'),
                                                                              onPressed: () => Navigator.pop(context, true),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );

                                                                      if (confirmed == true) {
                                                                        try {
                                                                          await editBitesData.deleteProduct(product.pk);
                                                                          setState(() {
                                                                            futureProducts = editBitesData.getProducts();
                                                                          });
                                                                        } catch (e) {
                                                                          if (mounted) {
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              SnackBar(content: Text('Error deleting product: $e')),
                                                                            );
                                                                          }
                                                                        }
                                                                      }
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),// Product Info
                                              Container(
                                                padding: const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    top: BorderSide(color: Colors.grey[200]!),
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      product.fields.name,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      'Rp ${product.fields.price}',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
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
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FooterNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  String _getProductTag(Product product) {
    if (product.fields.calorieTag == "HIGH") return "High Calorie";
    if (product.fields.calorieTag == "LOW") return "Low Calorie";
    if (product.fields.sugarTag == "HIGH") return "High Sugar";
    if (product.fields.veganTag == "VEGAN") return "Vegan";
    return "";
  }

  Widget _buildFilterOption(String label, String? value) {
    final isSelected = filterParam == value;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          setState(() {
            filterParam = value;
          });
        },
        child: Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}