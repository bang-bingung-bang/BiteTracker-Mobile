import 'dart:convert';

import 'package:bite_tracker_mobile/feature/sharebites/screens/sharebites_screen.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CreateShareBitesScreen extends StatefulWidget {
  const CreateShareBitesScreen({super.key});

  @override
  State<CreateShareBitesScreen> createState() => _CreateShareBitesScreenState();
}

class _CreateShareBitesScreenState extends State<CreateShareBitesScreen> {
  final _formKey = GlobalKey<FormState>();
  
  String _title = "";
  String _content = "";
  String _image = "";
  String _calorieContent = 'low';
  String _sugarContent = 'low';
  String _dietType = 'vegan';

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Post',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _title = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Title cannot be empty!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _content = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Description cannot be empty!';
                  }
                  return null;
                },
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _image = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Image URL cannot be empty!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Calorie Content',
                  border: OutlineInputBorder(),
                ),
                value: _calorieContent,
                items: const [
                  DropdownMenuItem(value: 'low', child: Text('Low Calorie')),
                  DropdownMenuItem(value: 'high', child: Text('High Calorie')),
                ],
                onChanged: (String? value) {
                  setState(() {
                    _calorieContent = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Sugar Content',
                  border: OutlineInputBorder(),
                ),
                value: _sugarContent,
                items: const [
                  DropdownMenuItem(value: 'low', child: Text('Low Sugar')),
                  DropdownMenuItem(value: 'high', child: Text('High Sugar')),
                ],
                onChanged: (String? value) {
                  setState(() {
                    _sugarContent = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Diet Type',
                  border: OutlineInputBorder(),
                ),
                value: _dietType,
                items: const [
                  DropdownMenuItem(value: 'vegan', child: Text('Vegan')),
                  DropdownMenuItem(value: 'non-vegan', child: Text('Non-Vegan')),
                ],
                onChanged: (String? value) {
                  setState(() {
                    _dietType = value!;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF533A2E),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final response = await request.postJson(
                        "https://faiz-akram-bitetrackers.pbp.cs.ui.ac.id/sharebites/create-flutter/",
                        jsonEncode(<String, dynamic>{
                          'user_id': 2,
                          'title': _title,
                          'content': _content,
                          'image': _image,
                          'calorie_content': _calorieContent,
                          'sugar_content': _sugarContent,
                          'diet_type': _dietType,
                        }),
                      );

                      if (context.mounted) {
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Uploaded Successfully"),
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ShareBitesScreen()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(response['message'] ??
                                  "Terdapat kesalahan, silakan coba lagi."),
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
                child: const Text(
                  'Create Post',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}