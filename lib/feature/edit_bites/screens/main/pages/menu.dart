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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<Product>> futureProducts;
  String? filterParam;
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 4;
  List<Product> filteredProducts = [];

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

  List<Product> _applyFilters(List<Product> products) {
    var filtered = products;

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((product) =>
          product.fields.name
              .toLowerCase()
              .contains(_searchController.text.toLowerCase())).toList();
    }

    // Apply category filter
    if (filterParam != null) {
      filtered = filtered.where((product) {
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

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final editBitesData = EditBitesData(request: request);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF5D4037),
        foregroundColor: Colors.white,
        title: const Text(
          'Products',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            ),
        ],
      ),
      endDrawer: isMobile ? _buildFilterDrawer() : null,
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
                        filteredProducts = _applyFilters(snapshot.data!);
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '${filteredProducts.length} products',
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
            ),

            // Main Content with Sidebar and Grid
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter sidebar untuk desktop
                  if (!isMobile)
                    Container(
                      width: 256,
                      height: double.infinity,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: _buildFilterContent(),
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
                            ),

                          // Products Grid
                          Expanded(
                            child: FutureBuilder<List<Product>>(
                              future: futureProducts,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  filteredProducts = _applyFilters(snapshot.data!);
                                  
                                  return GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: _calculateCrossAxisCount(screenWidth),
                                      childAspectRatio: 0.75,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                    ),
                                    itemCount: filteredProducts.length,
                                    itemBuilder: (context, index) {
                                      final product = filteredProducts[index];
                                      return _buildProductCard(product, editBitesData, context);
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

  // Helper Methods for Filters
  Widget _buildFilterContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
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
    );
  }

  Widget _buildFilterDrawer() {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16).copyWith(top: 48),
              color: const Color(0xFF5D4037),
              child: const Row(
                children: [
                  Text(
                    'Filters',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildFilterContent(),
            ),
            // Tombol Apply di mobile
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5D4037),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label, String? value) {
    final isSelected = filterParam == value;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          setState(() {
            filterParam = value;
            // Jika dalam mode mobile, tutup drawer setelah memilih filter
            if (isMobile) {
              Navigator.pop(context);
            }
          });
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF5D4037).withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF5D4037) : Colors.black,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  int _calculateCrossAxisCount(double screenWidth) {
    if (screenWidth > 1200) return 4;
    if (screenWidth > 900) return 3;
    if (screenWidth > 600) return 2;
    return 1;
  }

  Widget _buildProductCard(Product product, EditBitesData editBitesData, BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
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
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.error_outline, size: 48, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  if (logInUser?.role == true)
                    _buildAdminActions(product, editBitesData, context),
                ],
              ),
            ),

            // Product Info
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
  }

  Widget _buildAdminActions(Product product, EditBitesData editBitesData, BuildContext context) {
    return Material(
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
                  onPressed: () => _showDeleteConfirmation(product, editBitesData, context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(Product product, EditBitesData editBitesData, BuildContext context) async {
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
  }

  String _getProductTag(Product product) {
    if (product.fields.calorieTag == "HIGH") return "High Calorie";
    if (product.fields.calorieTag == "LOW") return "Low Calorie";
    if (product.fields.sugarTag == "HIGH") return "High Sugar";
    if (product.fields.veganTag == "VEGAN") return "Vegan";
    return "";
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}