import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_colors.dart';
import 'package:tourist_app/core/utils/app_routes.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/homeTap/widget/TopCircularButton.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    bool isSelected = false;
    // Basic responsiveness using MediaQuery
    final double screenWidth = MediaQuery.of(context).size.width;
    final double paddingSide = screenWidth * 0.05;
    var themeProvider = Provider.of<Themeprovider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
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
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1503177119275-0aa32b3a9368',
                          ),
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
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.HomeRouteName,
                          );
                        },
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
                          Topcircularbutton(
                            icon: isSelected == false
                                ? Icons.share
                                : Icons.share,
                            isSelected: false,
                            fun: () {
                              setState(() {
                                isSelected != true;
                                print('scs');
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          Topcircularbutton(
                            icon: isSelected == false
                                ? Icons.favorite_border_outlined
                                : Icons.favorite,
                            isSelected: false,
                            fun: () {
                              setState(() {
                                isSelected != true;
                                print('scs');
                              });
                            },
                          ),
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
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Giza, Egypt",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: paddingSide,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Rating Row
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            "4.9",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: themeProvider.apptheme == ThemeMode.dark
                                  ? AppColors.begiColor
                                  : AppColors.blackColor,
                            ),
                          ),
                          Text(
                            " (12543 reviews)",
                            style: TextStyle(
                              color: themeProvider.apptheme == ThemeMode.dark
                                  ? AppColors.blueColor
                                  : AppColors.blackColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 3. Info Cards Row
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: themeProvider.apptheme == ThemeMode.dark
                                ? AppColors.blueColor
                                : AppColors.whiteColor,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildInfoItem(
                              Icons.access_time,
                              "Hours",
                              "8:00 AM - 5:00 PM",
                              Colors.orange.shade50,
                              Colors.orange,
                              themeProvider.apptheme == ThemeMode.dark
                                  ? AppColors.begiColor
                                  : AppColors.primaryColor,
                              themeProvider.apptheme == ThemeMode.dark
                                  ? AppColors.blueColor
                                  : Colors.blueGrey,
                            ),
                            _buildInfoItem(
                              Icons.attach_money,
                              "Price",
                              "200 EGP",
                              Colors.yellow.shade50,
                              Colors.orangeAccent,
                              themeProvider.apptheme == ThemeMode.dark
                                  ? AppColors.begiColor
                                  : AppColors.primaryColor,
                              themeProvider.apptheme == ThemeMode.dark
                                  ? AppColors.blueColor
                                  : Colors.blueGrey,
                            ),
                            _buildInfoItem(
                              Icons.location_on_outlined,
                              "Distance",
                              "15 km from Cairo",
                              Colors.teal.shade50,
                              Colors.teal,
                              themeProvider.apptheme == ThemeMode.dark
                                  ? AppColors.begiColor
                                  : AppColors.primaryColor,
                              themeProvider.apptheme == ThemeMode.dark
                                  ? AppColors.blueColor
                                  : Colors.blueGrey,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      // 4. About Section
                      Text(
                        "About",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.apptheme == ThemeMode.dark
                              ? AppColors.begiColor
                              : AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "The Pyramids of Giza are among the most iconic monuments in the world. Built over 4,500 years ago, these ancient structures continue to captivate visitors with their engineering marvels and historical significance.",
                        style: TextStyle(
                          fontSize: 15,
                          color: themeProvider.apptheme == ThemeMode.dark
                              ? AppColors.blueColor
                              : Colors.blueGrey,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 25),

                      // 5. Map Placeholder
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: themeProvider.apptheme == ThemeMode.dark
                              ? AppColors.lightyellowColor
                              : Colors.orange.withOpacity(0.005),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: themeProvider.apptheme == ThemeMode.dark
                                ? AppColors.blueColor
                                : AppColors.whiteColor,
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            const Icon(
                              Icons.location_on,
                              size: 50,
                              color: Colors.blueGrey,
                            ),
                            const SizedBox(height: 40),
                            Container(
                              padding: const EdgeInsets.all(12),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: themeProvider.apptheme == ThemeMode.dark
                                    ? AppColors.primaryColor
                                    : Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(15),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "View on Map",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          themeProvider.apptheme ==
                                              ThemeMode.dark
                                          ? AppColors.begiColor
                                          : Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "Giza, Egypt",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      // 6. Nearby Places Section
                      Text(
                        "Nearby Places",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.apptheme == ThemeMode.dark
                              ? AppColors.begiColor
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Horizontal List of Nearby Places
                      SizedBox(
                        height: 220,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildNearbyCard(
                              "Great Sphinx",
                              "Giza, Egypt",
                              "4.8",
                              "9876",
                              "https://images.unsplash.com/photo-1503177119275-0aa32b3a9368",

                              themeProvider.apptheme == ThemeMode.dark
                                  ? AppColors.begiColor
                                  : AppColors.primaryColor,
                              themeProvider.apptheme == ThemeMode.dark
                                  ? AppColors.blueColor
                                  : Colors.blueGrey,
                            ),
                            _buildNearbyCard(
                              "Egyptian Museum",
                              "Cairo, Egypt",
                              "4.7",
                              "5432",
                              "https://images.unsplash.com/photo-1572252009286-268acec5ca0a",

                              themeProvider.apptheme == ThemeMode.dark
                                  ? AppColors.begiColor
                                  : AppColors.primaryColor,
                              themeProvider.apptheme == ThemeMode.dark
                                  ? AppColors.blueColor
                                  : Colors.blueGrey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper function for info items (keeps code clean without new classes)
  Widget _buildInfoItem(
    IconData icon,
    String label,
    String sub,
    Color bgColor,
    Color iconColor,
    Color textColorPrimary,
    Color textColorSec,
  ) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: bgColor,
          child: Icon(icon, color: iconColor),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: textColorPrimary)),
        const SizedBox(height: 4),
        SizedBox(
          width: 80,
          child: Text(
            sub,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: textColorSec,
            ),
          ),
        ),
      ],
    );
  }

  // Helper function for nearby place cards
  Widget _buildNearbyCard(
    String title,
    String loc,
    String rating,
    String reviews,
    String imgUrl,
    Color textColorPrimary,
    Color textColorSec,
  ) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: textColorSec),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              imgUrl,
              height: 120,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textColorPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12, color: Colors.grey),
                    Text(
                      loc,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    Text(
                      " $rating",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: textColorSec,
                      ),
                    ),
                    Text(
                      "($reviews)",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
