import 'package:bite_tracker_mobile/feature/authentication/pages/login.dart';
import 'package:bite_tracker_mobile/feature/main/pages/menu.dart';
import 'package:bite_tracker_mobile/feature/sharebites/screens/sharebites_screen.dart';
import 'package:flutter/material.dart';
import "package:bite_tracker_mobile/feature/mybites/screens/menu.dart";
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
      child: const MaterialApp(
        title: 'Bite Tracker',
        home: LoginPage(),
      ),
    );
  }
}