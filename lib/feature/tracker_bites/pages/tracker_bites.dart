import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class TrackerBitesPages extends StatefulWidget {
  const TrackerBitesPages({super.key});

  @override
  State<TrackerBitesPages> createState() => _TrackerBitesPagesState();
}

class _TrackerBitesPagesState extends State<TrackerBitesPages> {
  
  @override
  Widget build(BuildContext context) {
    // final request = context.watch<CookieRequest>();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Tracker Bites',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                fontFamily: '.SF Pro Text',
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              constraints: const BoxConstraints(
                minHeight: 0,
                maxHeight: double.infinity,
              ),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 250, 246, 246),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              child: const Column(
                children: [
                  Text(
                    'Dec 9, 2024',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: '.SF Pro Text',
                    ),
                  ),
                  SizedBox(
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
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: '.SF Pro Text',
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '1',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                fontFamily: '.SF Pro Text',
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Bites',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: '.SF Pro Text',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 100,
                          width: 100,
                          // TODO: Ganti Jadi Custom Circular Progress Indicator
                          child: CircularProgressIndicator(
                            value: 0.5,
                            strokeWidth: 10,
                            strokeCap: StrokeCap.round,
                            backgroundColor: Color.fromARGB(255, 181, 222, 255),
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          children: [
                            Text(
                              'Remaining',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: '.SF Pro Text',
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '500',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                fontFamily: '.SF Pro Text',
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'cal',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: '.SF Pro Text',
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
                color: const Color.fromARGB(255, 250, 246, 246),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [ 
                      const Row(
                        children: [
                          Icon(
                            Icons.set_meal_sharp,
                            color: Colors.blue,
                            size: 50,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Breakfast',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: '.SF Pro Text',
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: 50,
                                child: LinearProgressIndicator(
                                  value: 0.5,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  backgroundColor: Colors.grey,
                                  color: Colors.blue,
                                  minHeight: 5,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.add),
                        ),
                      ),
                      
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}