import 'package:bite_tracker_mobile/feature/sharebites/screens/sharebites_screen.dart';
import 'package:bite_tracker_mobile/feature/tracker_bites/pages/tracker_bites.dart';
import 'package:bite_tracker_mobile/feature/authentication/models/user_models.dart';
import 'package:flutter/material.dart';
import 'package:bite_tracker_mobile/feature/main/pages/menu.dart';

// TODO: Import package Form yang dibutuhkan

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              children: [
                Text(
                  'Geda Gedi',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                Text(
                  "Ayo Penuhi Kebutuhan Sehari-hari Mu Disini!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: const Text('Tracker Bites'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const TrackerBitesPages(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_a_photo_outlined),
            title: const Text('ShareBites'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShareBitesScreen(),
                ),
              );
            },
          ),
          // example of role based widget
          // if (logInUser?.role == false)
          //   ListTile(
          //     leading: const Icon(Icons.people),
          //     title: const Text('Users'),
          //     onTap: () {
          //       Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => const TrackerBitesPages(),
          //         ),
          //       );
          //     },
          //   ),
        ],
      ),
    );
  }
}