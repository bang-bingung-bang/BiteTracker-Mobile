import 'package:bite_tracker_mobile/core/assets.dart';
import 'package:bite_tracker_mobile/feature/main/pages/footer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BiteTracker',
          style: GoogleFonts.lobster(
            textStyle: const TextStyle(
              fontSize: 40.0, 
              fontWeight: FontWeight.bold,
              color: Colors.white, 
            ),
          ),
        ),
        backgroundColor: const Color(0xFF533A2E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                image: DecorationImage(
                  image: AssetImage(Assets.images.background),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                  Center( // Memastikan semua isi berada di tengah
                    child: Text(
                      'Track Your Bites,\nTailor Your Eats!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // About Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What is Bite Tracker?',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Track your meals, discover new recipes, and achieve your nutrition goals with our easy-to-use platform.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'How to use Bite Tracker?',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Simply create an account, log your meals, and let Bite Tracker help you maintain a balanced diet.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // Categories Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Text(
                    'Find Your Perfect Bites!',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  _buildCategoryGrid(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FooterNavigationBar(
        selectedIndex: _selectedIndex, 
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final List<Map<String, String>> categories = [
      {
        'title': 'Vegan',
        'image': 'https://static.wixstatic.com/media/bd7c83_c8c12d945dcc44298adf849d657e3418~mv2.jpg',
        'description': 'Produk makanan berbasis tumbuhan, bebas dari bahan hewani.',
      },
      {
        'title': 'Non-Vegan',
        'image': 'https://static.wixstatic.com/media/bd7c83_14d1ef4229964f86bfe9d466665a307d~mv2.jpg',
        'description': 'Produk makanan yang mengandung bahan-bahan hewani.',
      },
      {
        'title': 'High Calorie',
        'image': 'https://static.wixstatic.com/media/bd7c83_81326449af1c45dcb119da80d9cb56a7~mv2.jpg',
        'description': 'Makanan dengan kandungan kalori tinggi, cocok untuk meningkatkan energi.',
      },
      {
        'title': 'Low Calorie',
        'image': 'https://static.wixstatic.com/media/bd7c83_1f6ca149b79a45ee8c2766e122898cee~mv2.jpg',
        'description': 'Pilihan rendah kalori untuk menjaga asupan energi harian.',
      },
      {
        'title': 'High Sugar',
        'image': 'https://static.wixstatic.com/media/bd7c83_cedae553bea34977a59aa85c216860ee~mv2.jpg',
        'description': 'Makanan dengan kandungan gula tinggi untuk menambah rasa manis.',
      },
      {
        'title': 'Low Sugar',
        'image': 'https://static.wixstatic.com/media/bd7c83_3de75328881143468a28620e83e89785~mv2.jpg',
        'description': 'Pilihan rendah gula untuk mengurangi asupan manis dalam diet.',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Card(
          color: Colors.white, // Set the background color to white
          elevation: 4, // Add shadow to the card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Ensure content is aligned
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  child: Image.network(
                    category['image'] ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0), // Adjusted padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align elements to the start
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFCCBFB0),
                          minimumSize: const Size(double.infinity, 36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          category['title'] ?? '',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16, // Larger font size for the title
                          ),
                        ),
                      ),
                      const SizedBox(height: 8), // Add space between button and description
                      Text(
                        category['description'] ?? '',
                        style: GoogleFonts.poppins(
                          fontSize: 12, // Increased font size for the description
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center, // Center the description text
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}