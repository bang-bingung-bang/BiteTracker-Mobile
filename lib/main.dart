import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bite_tracker_mobile/feature/artibites/screens/edit_artikel_page.dart';
import 'package:bite_tracker_mobile/feature/artibites/screens/add_artikel_page.dart';
import 'package:bite_tracker_mobile/feature/artibites/screens/artikel_list_page.dart';
import 'package:bite_tracker_mobile/feature/artibites/models/artikel.dart';

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
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.deepPurple,
          ).copyWith(secondary: Colors.deepPurple[400]),
        ),
        initialRoute: '/artikelList',
        routes: {
          '/artikelList': (context) => const ArtikelListPage(),
          '/addArtikel': (context) => const AddArtikelPage(),
          '/editArtikel': (context) => EditArtikelPage(
                artikel: ModalRoute.of(context)!.settings.arguments as Artikel,
              ),
        },
      ),
    );
  }
}
