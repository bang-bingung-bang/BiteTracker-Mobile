// lib/feature/edit_bites/screens/pages/product_detail.dart

import 'package:flutter/material.dart';
import 'package:bite_tracker_mobile/feature/edit_bites/screens/pages/product_form.dart';
import 'package:bite_tracker_mobile/feature/edit_bites/models/editbites_data.dart';
import 'package:bite_tracker_mobile/feature/edit_bites/models/product.dart';
import 'package:bite_tracker_mobile/feature/authentication/models/user_models.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  final EditBitesData editBitesData;
  final bool isAdmin;

  const ProductDetailScreen({
    Key? key,
    required this.productId,
    required this.editBitesData,
    required this.isAdmin,
  }) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Product> futureProduct;
  bool isDescriptionExpanded = true;
  bool isLocationExpanded = true;

  @override
  void initState() {
    super.initState();
    futureProduct = widget.editBitesData.getProductDetail(widget.productId);
  }

  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                try {
                  await widget.editBitesData.deleteProduct(widget.productId);
                  if (mounted) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Product deleted successfully')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B4B3E),
        foregroundColor: Colors.white,
        title: const Text('Product Detail'),
        actions: [
          if (logInUser?.role == true) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductFormScreen(
                      editBitesData: widget.editBitesData,
                      isEditing: true,
                      productId: widget.productId,
                    ),
                  ),
                ).then((_) {
                  setState(() {
                    futureProduct = widget.editBitesData
                        .getProductDetail(widget.productId);
                  });
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteConfirmationDialog(),
            ),
          ],
        ],
      ),
      body: FutureBuilder<Product>(
        future: futureProduct,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final product = snapshot.data!;
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Breadcrumb
                    Wrap(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Home',
                              style: TextStyle(color: Colors.black87)),
                        ),
                        const Text(' / '),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('All Products',
                              style: TextStyle(color: Colors.black87)),
                        ),
                        const Text(' / '),
                        Text(product.fields.name,
                            style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Product Content Grid
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Column - Image
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey[200]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Image.network(
                                  product.fields.image,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),

                            // Right Column - Product Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.fields.name,
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Rp ${product.fields.price}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Additional Information
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildInfoItem('Calories',
                                          '${product.fields.calories} kcal'),
                                      _buildInfoItem('Calorie Tag',
                                          product.fields.calorieTag),
                                      _buildInfoItem(
                                          'Sugar Tag', product.fields.sugarTag),
                                      _buildInfoItem(
                                          'Vegan Tag', product.fields.veganTag),
                                    ],
                                  ),
                                  const SizedBox(height: 24),

                                  // Add to Wishlist Button
                                  if (!widget.isAdmin)
                                    ElevatedButton(
                                      onPressed: () {
                                        // Add to wishlist logic
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF6B4B3E),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        minimumSize:
                                            const Size(double.infinity, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text('Add to Wishlist'),
                                    ),
                                  const SizedBox(height: 24),

                                  // Description Section
                                  _buildExpandableSection(
                                    title: 'PRODUCT DESCRIPTION',
                                    content: product.fields.description,
                                    isExpanded: isDescriptionExpanded,
                                    onToggle: () => setState(() =>
                                        isDescriptionExpanded =
                                            !isDescriptionExpanded),
                                  ),

                                  // Location Section
                                  _buildExpandableSection(
                                    title: 'STORE LOCATION',
                                    content: product.fields.getStoreDisplay(),
                                    isExpanded: isLocationExpanded,
                                    onToggle: () => setState(() =>
                                        isLocationExpanded = !isLocationExpanded),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required String content,
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  isExpanded ? '−' : '+',
                  style: const TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              content,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
      ],
    );
  }
}