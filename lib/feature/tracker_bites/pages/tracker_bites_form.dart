import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
// TODO: Impor drawer yang sudah dibuat sebelumnya

class BiteTrackerFormPage extends StatefulWidget {
  const BiteTrackerFormPage({super.key});

  @override
  State<BiteTrackerFormPage> createState() => _BiteTrackerFormPageState();
}

class _BiteTrackerFormPageState extends State<BiteTrackerFormPage> {
  String _foodName = "";
  int _calorie = 0;
  String _time = "";
  DateTime? _selectedDate;

  final _formKey = GlobalKey<FormState>();
  final List<String> _timeOptions = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Center(
          child: Text(
            'Track Your Bites!',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: const Color(0xFFB99867),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color.fromARGB(59, 158, 158, 158),
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bites Name',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                            ),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Bites Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              ),
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                _foodName = value!;
                              });
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter bites name';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Calories',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                            ),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Calories',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              ),
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                _calorie = int.tryParse(value!) ?? 0;
                              });
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter calories';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                            ),
                          ),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              hintText: 'Select a time',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              ),
                            ),
                            value: _time.isEmpty ? null : _time,
                            items: _timeOptions.map((String option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option, style: GoogleFonts.poppins()),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _time = newValue!;
                              });
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a time';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                            ),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Select a date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              ),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            readOnly: true,
                            controller: TextEditingController(
                              text: _selectedDate != null 
                                  ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                                  : '',
                            ),
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2025),
                              );
                              if (picked != null && picked != _selectedDate) {
                                setState(() {
                                  _selectedDate = picked;
                                });
                              }
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a date';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFB99867),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      String formattedDate = "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
                                  // Kirim ke Django dan tunggu respons
                      final response = await request.postJson(
                        "http://127.0.0.1:8000/add_bites_flutter/",
                        jsonEncode(<String, String>{
                          "bite_name": _foodName,
                          "bite_calories": _calorie.toString(),
                          "bite_time": _time,
                          "bite_date": formattedDate,
                        }),
                      );
                      if (context.mounted) {
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                              content: Text("Bites baru berhasil disimpan!"),
                            ));
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                              content:
                                Text("Terdapat kesalahan, silakan coba lagi."),
                            ));
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB99867),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

