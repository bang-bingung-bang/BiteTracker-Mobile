import 'package:bite_tracker_mobile/feature/authentication/pages/login.dart';
import 'package:bite_tracker_mobile/feature/tracker_bites/pages/tracker_bites.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.deepPurple,
            ).copyWith(secondary: Colors.deepPurple[400]),      ),
        home: const TrackerBitesPages(),
      ),
    );
  }
}