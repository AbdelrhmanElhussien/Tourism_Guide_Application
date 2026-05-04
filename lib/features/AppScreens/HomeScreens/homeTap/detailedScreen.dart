import 'package:flutter/material.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/homeTap/widget/TopCircularButton.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Basic responsiveness using MediaQuery
    final double screenWidth = MediaQuery.of(context).size.width;
    final double paddingSide = screenWidth * 0.05;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children:[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header Image
                Stack(
                  children: [
                    // 1. Background Image
                    Container(
                      height: 350,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1503177119275-0aa32b3a9368'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Optional: Add a subtle dark gradient at the bottom so white text is readable
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.4),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: 20,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1D3557),
                          elevation: 4,
                        ),
                        child: const Icon(Icons.arrow_back, size: 20),
                      ),
                    ),

                    // 3. Action Buttons (Top Right)
                    Positioned(
                      top: 50,
                      right: 20,
                      child: Row(
                        children: [
                          Topcircularbutton(icon: Icons.share,),
                          const SizedBox(width: 10),
                          Topcircularbutton(icon:Icons.favorite_border),
                        ],
                      ),
                    ),

                    // 4. Text Overlay (Bottom Left)
                    Positioned(
                      bottom: 30,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Pyramids of Giza",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: const [
                              Icon(Icons.location_on_outlined, color: Colors.white, size: 18),
                              SizedBox(width: 4),
                              Text(
                                "Giza, Egypt",
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingSide, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Rating Row
                      Row(
                        children: const [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          SizedBox(width: 4),
                          Text(
                            "4.9",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            " (12543 reviews)",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 3. Info Cards Row
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildInfoItem(Icons.access_time, "Hours", "8:00 AM - 5:00 PM", Colors.orange.shade50, Colors.orange),
                            _buildInfoItem(Icons.attach_money, "Price", "200 EGP", Colors.yellow.shade50, Colors.orangeAccent),
                            _buildInfoItem(Icons.location_on_outlined, "Distance", "15 km from Cairo", Colors.teal.shade50, Colors.teal),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      // 4. About Section
                      const Text(
                        "About",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1D3557)),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "The Pyramids of Giza are among the most iconic monuments in the world. Built over 4,500 years ago, these ancient structures continue to captivate visitors with their engineering marvels and historical significance.",
                        style: TextStyle(fontSize: 15, color: Colors.blueGrey, height: 1.5),
                      ),
                      const SizedBox(height: 25),

                      // 5. Map Placeholder
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.shade100),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            const Icon(Icons.location_on, size: 50, color: Colors.blueGrey),
                            const SizedBox(height: 40),
                            Container(
                              padding: const EdgeInsets.all(12),
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text("View on Map", style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text("Giza, Egypt", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      // 6. Nearby Places Section
                      const Text(
                        "Nearby Places",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1D3557)),
                      ),
                      const SizedBox(height: 15),

                      // Horizontal List of Nearby Places
                      SizedBox(
                        height: 220,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildNearbyCard("Great Sphinx", "Giza, Egypt", "4.8", "9876", "https://images.unsplash.com/photo-1503177119275-0aa32b3a9368"),
                            _buildNearbyCard("Egyptian Museum", "Cairo, Egypt", "4.7", "5432", "https://images.unsplash.com/photo-1572252009286-268acec5ca0a"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

          ]

        ),
      ),
    );
  }

  // Helper function for info items (keeps code clean without new classes)
  Widget _buildInfoItem(IconData icon, String label, String sub, Color bgColor, Color iconColor) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: bgColor,
          child: Icon(icon, color: iconColor),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        SizedBox(
          width: 80,
          child: Text(
            sub,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1D3557)),
          ),
        ),
      ],
    );
  }

  // Helper function for nearby place cards
  Widget _buildNearbyCard(String title, String loc, String rating, String reviews, String imgUrl) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(imgUrl, height: 120, width: 200, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12, color: Colors.grey),
                    Text(loc, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    Text(" $rating", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("($reviews)", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}