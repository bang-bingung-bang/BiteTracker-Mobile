import 'package:bite_tracker_mobile/feature/tracker_bites/models/trackerbites_models.dart';
import 'package:bite_tracker_mobile/feature/tracker_bites/pages/tracker_bites_form.dart';
import 'package:bite_tracker_mobile/feature/tracker_bites/pages/tracker_bites_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bite_tracker_mobile/core/assets.dart';
import 'package:google_fonts/google_fonts.dart';

class TrackerBitesPages extends StatefulWidget {
  const TrackerBitesPages({super.key});

  @override
  State<TrackerBitesPages> createState() => _TrackerBitesPagesState();
}

class _TrackerBitesPagesState extends State<TrackerBitesPages> {
  
  DateTime _selectedDate = DateTime.now();


  void _navigateToFormPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BiteTrackerFormPage()),
    ).then((_) {
      // Refresh data when returning from the form page
      setState(() {});
    });
  }

  void _navigateToListPage(BuildContext context, String time) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TrackerBitesListPages(date: _selectedDate, time: time)),
    ).then((_) {
      // Refresh data when returning from the list page
      setState(() {});
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

Future<InfoData> _fetchData(CookieRequest request) async {
  String formattedDate = "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";
    
  final response = await request.get('http://127.0.0.1:8000/data-info-by-date/$formattedDate/');
  if (kDebugMode) {
    print(response);
  }
  var data = response;
  return InfoData.fromJson(data);  
  
}

  void _previousDate() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _nextDate() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
  }



  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 233, 225, 225),
      body: Stack(
        children: [
          SvgPicture.asset(
            Assets.svg.trackerbites,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 50,
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: FutureBuilder<InfoData>(
              future: _fetchData(request),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
          
                final data = snapshot.data ?? InfoData(
                  totalBites: 0,
                  totalCalories: 0,
                  mealCounts: Meal(breakfast: 0, lunch: 0, dinner: 0, snack: 0),
                  mealPercentages: Meal(breakfast: 0, lunch: 0, dinner: 0, snack: 0),
                );
          
                return Column(
                  children: [
                    Text(
                      'Tracker Bites',
                      style: GoogleFonts.lobster(
                        textStyle: const TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      constraints: const BoxConstraints(
                        minHeight: 0,
                        maxHeight: double.infinity,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_left),
                                onPressed: _previousDate,
                              ),
                              GestureDetector(
                                onTap: () => _selectDate(context),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.calendar_today),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                onPressed: _nextDate,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Eaten',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      data.totalBites.toString(),
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Bites',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  // TODO: Ganti Jadi Custom Circular Progress Indicator
                                  child: CircularProgressIndicator(
                                    value: data.totalCalories > 2500 ? 1 : data.totalCalories / 2500,
                                    strokeWidth: 10,
                                    strokeCap: StrokeCap.round,
                                    backgroundColor: Colors.grey,
                                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFB99867)),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Remaining',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      data.totalCalories > 2500 ? '0' : (2500 - data.totalCalories).toString(),
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'cal',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [ 
                              Row(
                                children: [
                                  const Icon(
                                    Icons.set_meal_sharp,
                                    color: Colors.blue,
                                    size: 50,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'Breakfast',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 50,
                                        child: LinearProgressIndicator(
                                          value: data.mealCounts.breakfast >= 1 ? 1 : 0,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          backgroundColor: Colors.grey,
                                          color: data.mealCounts.breakfast == 1 ? const Color(0xFFB99867) : Colors.red,
                                          minHeight: 5,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: data.mealCounts.breakfast >= 1 ? Colors.transparent : const Color(0xFFB99867),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    if (data.mealCounts.breakfast >= 1) {
                                      _navigateToListPage(context, 'Breakfast');
                                    } else {
                                      _navigateToFormPage(context);
                                    }
                                  },
                                  icon: Icon(
                                    data.mealCounts.breakfast >= 1 ? Icons.chevron_right : Icons.add,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                            child: Divider(
                              color: Color.fromARGB(255, 200, 212, 217),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [ 
                              Row(
                                children: [
                                  const Icon(
                                    Icons.set_meal_sharp,
                                    color: Colors.blue,
                                    size: 50,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'Lunch',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 50,
                                        child: LinearProgressIndicator(
                                          value: data.mealCounts.lunch >= 1 ? 1 : 0,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          backgroundColor: Colors.grey,
                                          color: data.mealCounts.lunch == 1 ? const Color(0xFFB99867) : Colors.red,
                                          minHeight: 5,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: data.mealCounts.lunch >= 1 ? Colors.transparent : const Color(0xFFB99867),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    if (data.mealCounts.lunch >= 1) {
                                      _navigateToListPage(context, 'Lunch');
                                    } else {
                                      _navigateToFormPage(context);
                                    }
                                  },
                                  icon: Icon(
                                    data.mealCounts.lunch >= 1 ? Icons.chevron_right : Icons.add,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                            child: Divider(
                              color: Color.fromARGB(255, 200, 212, 217),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [ 
                              Row(
                                children: [
                                  const Icon(
                                    Icons.set_meal_sharp,
                                    color: Colors.blue,
                                    size: 50,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'Dinner',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 50,
                                        child: LinearProgressIndicator(
                                          value: data.mealCounts.dinner >= 1 ? 1 : 0,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          backgroundColor: Colors.grey,
                                          color: data.mealCounts.dinner == 1 ? const Color(0xFFB99867) : Colors.red,
                                          minHeight: 5,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: data.mealCounts.dinner >= 1 ? Colors.transparent : const Color(0xFFB99867),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    if (data.mealCounts.dinner >= 1) {
                                      _navigateToListPage(context, 'Dinner');
                                    } else {
                                      _navigateToFormPage(context);
                                    }
                                  },
                                  icon: Icon(
                                    data.mealCounts.dinner >= 1 ? Icons.chevron_right : Icons.add,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                            child: Divider(
                              color: Color.fromARGB(255, 200, 212, 217),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [ 
                              Row(
                                children: [
                                  const Icon(
                                    Icons.set_meal_sharp,
                                    color: Colors.blue,
                                    size: 50,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'Snacks',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 50,
                                        child: LinearProgressIndicator(
                                          value: data.mealCounts.snack >= 1 ? 1 : 0,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          backgroundColor: Colors.grey,
                                          color: data.mealCounts.snack == 1 ? const Color(0xFFB99867) : Colors.red,
                                          minHeight: 5,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: data.mealCounts.snack >= 1 ? Colors.transparent : const Color(0xFFB99867),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    if (data.mealCounts.snack >= 1) {
                                      _navigateToListPage(context, 'Snack');
                                    } else {
                                      _navigateToFormPage(context);
                                    }
                                  },
                                  icon: Icon(
                                    data.mealCounts.snack >= 1 ? Icons.chevron_right : Icons.add,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}