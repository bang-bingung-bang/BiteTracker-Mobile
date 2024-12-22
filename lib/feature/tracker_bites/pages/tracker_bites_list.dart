import 'dart:convert';

import 'package:bite_tracker_mobile/core/assets.dart';
import 'package:bite_tracker_mobile/feature/tracker_bites/models/trackerbites_models.dart';
import 'package:bite_tracker_mobile/feature/tracker_bites/pages/tracker_bites_edit.dart';
import 'package:bite_tracker_mobile/feature/tracker_bites/pages/tracker_bites_form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class TrackerBitesListPages extends StatefulWidget {
  const TrackerBitesListPages(
    {super.key, 
    required this.date,
    required this.time});
  
  final DateTime date;
  final String time;

  @override
  State<TrackerBitesListPages> createState() => _TrackerBitesListPagesState();
}

class _TrackerBitesListPagesState extends State<TrackerBitesListPages> {
    late Future<List<BiteTrackerModel>> _futureBites;

    @override
  void initState() {
    super.initState();
    _futureBites = _fetchBites(context.read<CookieRequest>());
  }

  void _navigateToFormPage(BuildContext context, CookieRequest request) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BiteTrackerFormPage()),
    ).then((_) {
      // Refresh data when returning from the form page
      setState(() {
        _futureBites = _fetchBites(request); // Refresh the list after deletion
      });
    });
  }

  void _navigateToEditPage(BuildContext context, CookieRequest request, BiteTrackerModel bite) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BiteTrackerEditPage(bite: bite),
      ),
    ).then((_) {
      // Refresh data when returning from the form page
      setState(() {
        _futureBites = _fetchBites(request); // Refresh the list after deletion
      });
    });
  }

  Future<List<BiteTrackerModel>> _fetchBites(CookieRequest request) async {
    String formattedDate = "${widget.date.year}-${widget.date.month.toString().padLeft(2, '0')}-${widget.date.day.toString().padLeft(2, '0')}";

    final response = await request.get('http://127.0.0.1:8000/show-json-by-date/$formattedDate/');
    var data = response;

    if (kDebugMode) {
      print(response);
    }

    List<BiteTrackerModel> bites = [];

    for (var d in data) {
      BiteTrackerModel bite = BiteTrackerModel.fromJson(d);
      if (bite.fields.biteTime == widget.time) {
        bites.add(bite);
      }
    }

    return bites;
  }

  Future<void> _deleteBite(CookieRequest request, String pk) async {
    final response = await request.postJson(
      'http://127.0.0.1:8000/delete-bite-flutter/$pk/',
      jsonEncode(<String, String>{'pk': pk}),
    );

    if (kDebugMode) {
      print(response);
    }
    if (response['success'] == true) {
      setState(() {
        _futureBites = _fetchBites(request); // Refresh the list after deletion
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.read<CookieRequest>();

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.images.background),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(132, 151, 143, 143)
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: Text(
                  widget.time,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color.fromARGB(255, 221, 221, 221)),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: const Color(0xFFB99867),
                  boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFB99867).withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                ),
                child: FutureBuilder<List<BiteTrackerModel>>(
                  future: _futureBites, // _fetchBites(request),
                  builder: (context, snapshot) {
                    if (kDebugMode) {
                      print(snapshot.connectionState);
                    }
                    if (snapshot.data == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.warning,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                                Text(
                                  'No bites found',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        final bites = snapshot.data!;
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: bites.length,
                          separatorBuilder: (_, index) => const Divider(),
                          itemBuilder: (_, index) {
                            final bite = bites[index];
                            return Card(
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      bite.fields.biteName,
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${bite.fields.biteCalories} calories',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (String value) {
                                    if (value == 'edit') {
                                      _navigateToEditPage(context, request, bite);
                                    } else if (value == 'delete') {
                                      _deleteBite(request, bite.pk);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem<String>(
                                        value: 'edit',
                                        child: Text(
                                          'Edit',
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Text(
                                          'Delete',
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ];
                                  },
                                  icon: const Icon(Icons.chevron_right),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    }
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF533A2E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ElevatedButton(
                  onPressed: () => _navigateToFormPage(context, request),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB99867),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Add New Bite',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}