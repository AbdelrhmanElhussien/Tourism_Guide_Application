import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/features/map/provider/map_provider.dart';
import 'package:tourist_app/features/map/screens/place_details_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MapTap extends StatelessWidget {
  const MapTap({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<Themeprovider>(context);
    bool isDark = themeProvider.apptheme == ThemeMode.dark;

    return Consumer<MapProvider>(
      builder: (context, mapProvider, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          mapProvider.setMapStyle(isDark);
        });

        return Scaffold(
          body: Stack(
            children: [
              // 1. The Map
              GoogleMap(
                initialCameraPosition: mapProvider.cameraPosition,
                mapType: MapType.normal,
                markers: mapProvider.markers,
                polylines: mapProvider.polylines,
                onMapCreated: (controller) {
                  mapProvider.onMapCreated(controller, isDark);
                },
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
              ),

              // 2. Search Bar
              Positioned(
                top: 50,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF101E2E) : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: mapProvider.searchController,
                    onChanged: (value) => mapProvider.searchPlaces(value),
                    style: TextStyle(color: isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Search for destinations...',
                      hintStyle: TextStyle(color: isDark ? Colors.white60 : Colors.grey),
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: isDark ? Colors.white60 : Colors.grey),
                      suffixIcon: mapProvider.searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: isDark ? Colors.white70 : Colors.grey),
                              onPressed: () {
                                mapProvider.searchController.clear();
                                mapProvider.searchPlaces('');
                              },
                            )
                          : null,
                    ),
                  ),
                ),
              ),

              // 3. Category Filters (hidden when search suggestions are active)
              if (mapProvider.searchPredictions.isEmpty)
                Positioned(
                  top: 110,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: mapProvider.categories.length,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemBuilder: (context, index) {
                        String category = mapProvider.categories[index];
                        bool isSelected =
                            mapProvider.selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            showCheckmark: false,
                            onSelected: (selected) {
                              mapProvider.filterByCategory(category);
                            },
                            backgroundColor: isDark ? const Color(0xFF101E2E) : AppColors.whiteColor,
                            selectedColor: AppColors.primaryColor,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide.none,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              if (mapProvider.selectedPlace != null)
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: _buildPlaceDetailsCard(context, mapProvider, isDark),
                ),

              // 5. Search Autocomplete Overlay
              if (mapProvider.searchPredictions.isNotEmpty)
                Positioned(
                  top: 110,
                  left: 20,
                  right: 20,
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(15),
                    color: isDark ? AppColors.bottomNavigationColor : Colors.white,
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 280),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.bottomNavigationColor : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: mapProvider.searchPredictions.length,
                        itemBuilder: (context, index) {
                          final prediction =
                              mapProvider.searchPredictions[index];
                          return ListTile(
                            leading: Icon(
                              Icons.location_on,
                              color: isDark ? AppColors.blueColor : AppColors.primaryColor,
                            ),
                            title: Text(
                              prediction.mainText,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              prediction.secondaryText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.grey,
                              ),
                            ),
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              mapProvider.selectPrediction(prediction);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          floatingActionButton: mapProvider.searchPredictions.isNotEmpty
              ? null
              : Padding(
                  padding: const EdgeInsets.only(top: 170),
                  child: FloatingActionButton(
                    onPressed: () {
                      mapProvider.getUserLocation();
                    },
                    backgroundColor: isDark ? AppColors.bottomNavigationColor : AppColors.whiteColor,
                    foregroundColor: isDark ? Colors.white : AppColors.primaryColor,
                    child: const Icon(Icons.location_searching_outlined),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildPlaceDetailsCard(BuildContext context, MapProvider mapProvider, bool isDark) {
    final place = mapProvider.selectedPlace!;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bottomNavigationColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail Image with Hero Animation
              Hero(
                tag: place.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    place.image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: isDark ? const Color(0xFF101E2E) : Colors.grey[300],
                      child: Icon(Icons.image_not_supported, color: isDark ? Colors.white30 : Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                place.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                place.category,
                                style: TextStyle(color: isDark ? Colors.white60 : Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            mapProvider.clearSelectedPlace();
                          },
                          icon: Icon(Icons.close, color: isDark ? Colors.white70 : Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 5),
                        Text(
                          place.rating.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Icon(
                          Icons.location_on,
                          color: isDark ? Colors.white30 : Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            place.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
                          ),
                        ),
                      ],
                    ),

                    // Travel distance and duration info from Directions API
                    if (mapProvider.routeDistance != null &&
                        mapProvider.routeDuration != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.directions_car,
                            color: isDark ? AppColors.yellowColor : AppColors.primaryColor,
                            size: 18,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            mapProvider.routeDistance!,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Icon(
                            Icons.access_time,
                            color: isDark ? Colors.white30 : Colors.grey,
                            size: 18,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            mapProvider.routeDuration!,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaceDetailsScreen(place: place),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AppColors.yellowColor : AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'View Details',
                    style: TextStyle(color: isDark ? AppColors.primaryColor : Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final String googleMapsUrl =
                        'https://www.google.com/maps/search/?api=1&query=${place.location.latitude},${place.location.longitude}';
                    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
                      await launchUrl(
                        Uri.parse(googleMapsUrl),
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Could not open Google Maps'),
                        ),
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Open in Maps',
                    style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
