import 'package:bite_tracker_mobile/feature/authentication/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Bite Tracker',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white, 
        ),
        home: const LoginPage(),
      ),
    );
  }
}
