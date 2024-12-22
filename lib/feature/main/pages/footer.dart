import 'package:bite_tracker_mobile/feature/authentication/pages/login.dart';
import 'package:bite_tracker_mobile/feature/mybites/screens/menu.dart';
import 'package:bite_tracker_mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bite_tracker_mobile/feature/edit_bites/screens/main/pages/menu.dart';
import 'package:bite_tracker_mobile/feature/sharebites/screens/sharebites_screen.dart';
import 'package:bite_tracker_mobile/feature/tracker_bites/pages/tracker_bites.dart';
import 'package:bite_tracker_mobile/feature/main/pages/menu.dart';
import 'package:bite_tracker_mobile/feature/main/pages/footer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class FooterNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const FooterNavigationBar({
    super.key, 
    required this.selectedIndex, 
    required this.onItemTapped
  });

  void _navigateToPage(BuildContext context, int index) async {
    switch (index) {
      case 0: // Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
        break;
        
      case 1: // MyBites
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MyApp(),
          ),
        );
        break;
        
      case 2: // TrackerBites
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const TrackerBitesPages(),
          ),
        );
        break;
        
      case 3: // ShareBites
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ShareBitesScreen(),
          ),
        );
        break;
        
      case 4: // Product
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const EditBitesMenu(),
          ),
        );
        break;
      
      // Uncomment if you want to add ArtiBites back
      // case 5: // ArtiBites
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => const ProductBitesScreen(),
      //     ),
      //   );
      //   break;

      case 6: // Logout
        final request = context.read<CookieRequest>();
        final response = await request.logout(
          'https://faiz-akram-bitetracker.pbp.cs.ui.ac.id/auth/logout/',
        );
        final message = response['message'];
        if (context.mounted) {
          if (response['status']) {
              String uname = response["username"];
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("$message Sampai jumpa, $uname."),
              ));
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
              );
          } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(message),
                  ),
              );
          }
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, 0, Icons.home, 'Home'),
              _buildNavItem(context, 4, Icons.food_bank, 'Products'),
              _buildNavItem(context, 1, Icons.fastfood_outlined, 'MyBites'),
              _buildNavItem(context, 2, Icons.restaurant_menu, 'TrackerBites'),
              _buildNavItem(context, 3, Icons.add_a_photo_outlined, 'ShareBites'),
              _buildNavItem(context, 5, Icons.newspaper, 'ArtiBites'),
              _buildNavItem(context, 6, Icons.person, 'Logout'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
    final isSelected = selectedIndex == index;
    return InkWell(
      onTap: () {
        onItemTapped(index);
        _navigateToPage(context, index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF533A2E) : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: isSelected ? const Color(0xFF533A2E) : Colors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}