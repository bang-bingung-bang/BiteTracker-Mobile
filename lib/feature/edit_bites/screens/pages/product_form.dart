////lib\feature\edit_bites\screens\pages\product_detail.dart

import 'package:flutter/material.dart';
import 'package:bite_tracker_mobile/feature/authentication/models/user_models.dart';
import 'package:bite_tracker_mobile/feature/edit_bites/models/editbites_data.dart';
import 'package:bite_tracker_mobile/feature/edit_bites/models/product.dart';

class ProductFormScreen extends StatefulWidget {
  final EditBitesData editBitesData;
  final bool isEditing;
  final int? productId;

  const ProductFormScreen({
    Key? key,
    required this.editBitesData,
    required this.isEditing,
    this.productId,
  }) : super(key: key);

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _caloriesController;
  late TextEditingController _imageController;
  
  String _selectedStore = 'QITA_MART';
  String _selectedCalorieTag = 'LOW';
  String _selectedVeganTag = 'NON_VEGAN';
  String _selectedSugarTag = 'LOW';

  @override
  void initState() {
    super.initState();

    if (logInUser?.role != true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unauthorized: Admin access required')),
        );
        Navigator.pop(context);
      });
      return;
    }

    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _descriptionController = TextEditingController();
    _caloriesController = TextEditingController();
    _imageController = TextEditingController();

    if (widget.isEditing && widget.productId != null) {
      _loadProductData();
    }
  }

  Future<void> _loadProductData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final product = await widget.editBitesData.getProductDetail(widget.productId!);
      
      _nameController.text = product.fields.name;
      _priceController.text = product.fields.price.toString();
      _descriptionController.text = product.fields.description;
      _caloriesController.text = product.fields.calories.toString();
      _imageController.text = product.fields.image;
      
      setState(() {
        _selectedStore = product.fields.store;
        _selectedCalorieTag = product.fields.calorieTag;
        _selectedVeganTag = product.fields.veganTag;
        _selectedSugarTag = product.fields.sugarTag;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading product: $e')),
        );
        Navigator.pop(context);
      }
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final now = DateTime.now();
        final product = Product(
          model: "editbites.product",
          pk: widget.isEditing ? widget.productId! : 0,
          fields: Fields(
            store: _selectedStore,
            name: _nameController.text,
            price: int.parse(_priceController.text),
            description: _descriptionController.text,
            calories: int.parse(_caloriesController.text),
            calorieTag: _selectedCalorieTag,
            veganTag: _selectedVeganTag,
            sugarTag: _selectedSugarTag,
            image: _imageController.text,
            createdAt: now,
            updatedAt: now,
          ),
        );

        String message;
        if (widget.isEditing) {
          message = await widget.editBitesData.updateProduct(widget.productId!, product);
        } else {
          message = await widget.editBitesData.createProduct(product);
        }

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _caloriesController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && widget.isEditing) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Product' : 'Add Product'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Store',
                  border: OutlineInputBorder(),
                ),
                value: _selectedStore,
                items: [
                  DropdownMenuItem(value: 'QITA_MART', child: Text('QITA MART')),
                  DropdownMenuItem(value: 'TUTUL_V_MARKET', child: Text('TUTUL V MARKET')),
                  DropdownMenuItem(value: 'AL_HIKAM_MART', child: Text('AL HIKAM MART')),
                  DropdownMenuItem(value: 'SNACK_JAYA_MARKET', child: Text('SNACK JAYA MARKET')),
                  DropdownMenuItem(value: 'BELANDA_MART', child: Text('BELANDA MART')),
                ],
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _selectedStore = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _caloriesController,
                decoration: const InputDecoration(
                  labelText: 'Calories',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter calories';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter image URL';
                  }
                  if (!Uri.tryParse(value)!.isAbsolute) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Calorie Level',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedCalorieTag,
                      items: const [
                        DropdownMenuItem(value: 'HIGH', child: Text('HIGH')),
                        DropdownMenuItem(value: 'LOW', child: Text('LOW')),
                      ],
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() {
                            _selectedCalorieTag = value;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Sugar Level',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedSugarTag,
                      items: const [
                        DropdownMenuItem(value: 'HIGH', child: Text('HIGH')),
                        DropdownMenuItem(value: 'LOW', child: Text('LOW')),
                      ],
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() {
                            _selectedSugarTag = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Vegan Status',
                  border: OutlineInputBorder(),
                ),
                value: _selectedVeganTag,
                items: const [
                  DropdownMenuItem(value: 'VEGAN', child: Text('VEGAN')),
                  DropdownMenuItem(value: 'NON_VEGAN', child: Text('NON VEGAN')),
                ],
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _selectedVeganTag = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(widget.isEditing ? 'Update Product' : 'Create Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}